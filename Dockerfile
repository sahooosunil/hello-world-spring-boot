FROM openjdk:17-jdk
VOLUME /tmp
COPY target/helloworld-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
