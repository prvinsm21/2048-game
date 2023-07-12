FROM adoptopenjdk/openjdk11:alpine-jre

ARG artifact=target/2048-game-site.jar

WORKDIR /opt/app 

COPY ${artifact} app.jar

ENTRYPOINT ["java","-jar","app.jar"]

