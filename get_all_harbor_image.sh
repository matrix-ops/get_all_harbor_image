#!/bin/bash
#此脚本兼容harbor 1.9.2，其他版本未作兼容性测试
#Author zhangweilong

USER="admin"
#harbor的管理员账号名称
PASS="Harbor12345"
#harbor的管理员账号密码
harborURL="https://192.168.200.134"
#harbor使用的协议和地址端口

function getImage {
    harborToken=$(curl -k -s  -u ${USER}:${PASS} ${harborURL}/service/token?account=${USER}\&service=harbor-registry\&scope=registry:catalog:*|grep "token" |awk -F '"' '{print $4}')
    imageList=$(curl -k -s -H "authorization: bearer $harborToken " ${harborURL}/v2/_catalog|awk -F '[' '{print $2}'|awk -F ']' '{print $1}'|sed 's/"//g')
    allImage=$(echo $imageList | sed 's/,/\n/g')
    echo -e "${allImage}"
}
for imageName in $(getImage);do
        tagToken=$(curl -iksL -X GET -u $USER:$PASS $harborURL/service/token?account=${USER}\&service=harbor-registry\&scope=repository:${imageName}:pull|grep "token" |awk -F '"' '{print $4}')
        tagList=$(curl -ksL -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $tagToken" ${harborURL}/v2/${imageName}/tags/list | awk -F '[' '{print $2}'| awk -F ']' '{print $1}' | sed 's/"//g')
        allImageTag=$( echo $tagList | sed 's/,/\n/g')
        for imageTag in $allImageTag;do
                echo $imageName:$imageTag
        done
done
