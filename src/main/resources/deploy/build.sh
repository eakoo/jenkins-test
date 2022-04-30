#!/usr/bin/env bash

# 镜像名
IMAGE_NAME=jenkins-test

# 删除旧镜像
sudo docker rmi $IMAGE_NAME

# 生成新镜像
sudo docker build -t $IMAGE_NAME .