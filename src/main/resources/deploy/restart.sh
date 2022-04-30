#!/usr/bin/env bash

# 应用名称
APP_NAME=jenkins-test

# 应用端口
APP_PORT=8081

# 容器状态
CONTAINER_STATUS=$(sudo docker ps -a | grep $APP_NAME -i -c)
if [ "$CONTAINER_STATUS" == 0 ];
  then
    sudo docker run -d -p $APP_PORT:$APP_PORT --name $APP_NAME $APP_NAME
  else
    sudo docker stop $APP_NAME
    sudo docker rm $APP_NAME
    sudo docker run -d -p $APP_PORT:$APP_PORT --name $APP_NAME $APP_NAME
fi

# 删除 NONE 镜像
IMAGE_IDS=$(sudo docker images | grep"<none>" | awk '{print $3}')
echo 'remove images start ..'
echo IMAGE_IDS
if [ -n "$IMAGE_IDS" ] ;then
    sudo docker rmi "$IMAGE_IDS"
fi