# 下载maven与java的镜像
FROM hub.c.163.com/wuxukun/maven-aliyun:3-jdk-8

# 指定当前操作目录
WORKDIR /home/jenkins/workspace/jenkins-test

#指定对外端口号
EXPOSE 8081

COPY ./jenkins-test-1.0.0.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]