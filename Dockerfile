FROM maven:3.6.3-openjdk-14-slim AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY src /workspace/src
RUN mvn -B package --file pom.xml -DskipTests

RUN mkdir /opt/tomcat/

RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.64/bin/apache-tomcat-9.0.64.tar.gz 
ADD /workspace/apache-tomcat-9.0.64.tar.gz /opt/tomcat/

FROM openjdk:14-slim
COPY --from=build /workspace/target/my-app.war /opt/tomcat/webapps/

EXPOSE 8080 

ENTRYPOINT ["/opt/tomcat/bin/catalina.sh","run"]
