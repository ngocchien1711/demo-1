FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY ./target/demo-1-0.0.1-SNAPSHOT.war /app
EXPOSE 9999
CMD ["java","-jar", "demo-1-0.0.1-SNAPSHOT.war"]