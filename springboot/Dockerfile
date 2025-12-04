FROM openjdk:21-jdk-slim

WORKDIR /app

# 安装 curl（用于健康检查）
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY target/springboot-0.0.1-SNAPSHOT.jar app.jar

RUN mkdir -p /app/logs /app/files

EXPOSE 9090

ENTRYPOINT ["java", "-Xms512m", "-Xmx2g", "-jar", "app.jar"]
