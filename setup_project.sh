#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=========================================="
echo "创新创业选题系统 Docker 部署脚本"
echo "==========================================${NC}"

# 检查文件是否存在
echo -e "${YELLOW}[1/12] 检查必要文件...${NC}"
cd /home/ubuntu/collegetopics

if [ ! -d "springboot" ]; then
    echo -e "${RED}错误: springboot文件夹不存在！${NC}"
    exit 1
fi

if [ ! -d "vue" ]; then
    echo -e "${RED}错误: vue文件夹不存在！${NC}"
    exit 1
fi

if [ ! -f "entrepreneurship_system.sql" ]; then
    echo -e "${RED}错误: entrepreneurship_system.sql文件不存在！${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 文件检查通过${NC}"

# 创建目录结构
echo -e "${YELLOW}[2/12] 创建目录结构...${NC}"
mkdir -p mysql/data mysql/init nginx/conf logs files
chmod 777 logs files mysql/data

# 修改后端配置
echo -e "${YELLOW}[3/12] 配置后端application.yml...${NC}"
cat > springboot/src/main/resources/application.yml <<'EOF'
server:
  port: 9090

spring:
  servlet:
    multipart:
      max-file-size: 100MB
      max-request-size: 100MB
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: root123456
    url: jdbc:mysql://mysql:3306/entrepreneurship_system?useUnicode=true&characterEncoding=utf-8&allowMultiQueries=true&useSSL=false&serverTimezone=GMT%2b8&allowPublicKeyRetrieval=true
    hikari:
      minimum-idle: 10
      maximum-pool-size: 30
      connection-timeout: 30000

mybatis:
  configuration:
    log-impl: org.apache.ibatis.logging.slf4j.Slf4jImpl
    map-underscore-to-camel-case: true
  mapper-locations: classpath:mapper/*.xml

fileBaseUrl: https://collegetopics.cn

logging:
  level:
    root: INFO
    com.example: INFO
  file:
    name: /app/logs/application.log
EOF

# 创建后端Dockerfile
echo -e "${YELLOW}[4/12] 创建后端Dockerfile...${NC}"
cat > springboot/Dockerfile <<'EOF'
FROM openjdk:21-jdk-slim

WORKDIR /app

COPY target/springboot-0.0.1-SNAPSHOT.jar app.jar

RUN mkdir -p /app/logs /app/files

EXPOSE 9090

ENTRYPOINT ["java", "-Xms512m", "-Xmx2g", "-jar", "app.jar"]
EOF

# 创建前端配置
echo -e "${YELLOW}[5/12] 创建前端配置...${NC}"
cat > vue/.env.production <<'EOF'
VITE_BASE_URL=https://collegetopics.cn
EOF

# 创建前端nginx配置
cat > vue/nginx.conf <<'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://backend:9090/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /files/ {
        proxy_pass http://backend:9090/files/;
        client_max_body_size 100M;
        proxy_set_header Host $host;
    }
}
EOF

# 创建前端Dockerfile
echo -e "${YELLOW}[6/12] 创建前端Dockerfile...${NC}"
cat > vue/Dockerfile <<'EOF'
FROM node:18 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm config set registry https://registry.npmmirror.com
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# 创建docker-compose.yml
echo -e "${YELLOW}[7/12] 创建docker-compose.yml...${NC}"
cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: entrepreneurship_mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root123456
      MYSQL_DATABASE: entrepreneurship_system
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/data:/var/lib/mysql
      - ./entrepreneurship_system.sql:/docker-entrypoint-initdb.d/init.sql:ro
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot123456"]
      interval: 10s
      timeout: 5s
      retries: 10

  backend:
    build:
      context: ./springboot
      dockerfile: Dockerfile
    container_name: entrepreneurship_backend
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./logs:/app/logs
      - ./files:/app/files
    environment:
      TZ: Asia/Shanghai
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9090/ || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  frontend:
    build:
      context: ./vue
      dockerfile: Dockerfile
    container_name: entrepreneurship_frontend
    restart: always
    ports:
      - "8080:80"
    depends_on:
      backend:
        condition: service_healthy
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOF

# 安装Maven
echo -e "${YELLOW}[8/12] 检查Maven...${NC}"
if ! command -v mvn &> /dev/null; then
    echo "安装Maven..."
    sudo apt install -y maven
fi

# 打包后端
echo -e "${YELLOW}[9/12] 打包后端项目（需要几分钟）...${NC}"
cd springboot
mvn clean package -DskipTests -q
if [ ! -f "target/springboot-0.0.1-SNAPSHOT.jar" ]; then
    echo -e "${RED}错误: 后端打包失败！${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 后端打包成功${NC}"
cd ..

# 配置防火墙
echo -e "${YELLOW}[10/12] 配置防火墙...${NC}"
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp
echo -e "${GREEN}✓ 防火墙配置完成${NC}"

# 启动Docker服务
echo -e "${YELLOW}[11/12] 启动Docker容器（首次启动需要10-15分钟）...${NC}"
echo "正在拉取镜像并构建容器，请耐心等待..."
docker compose up -d --build

# 等待服务启动
echo -e "${YELLOW}[12/12] 等待服务启动...${NC}"
sleep 30

echo ""
echo -e "${GREEN}=========================================="
echo "������ 部署完成！"
echo "==========================================${NC}"
echo ""
echo -e "${YELLOW}访问地址：${NC}"
echo "  HTTP:  http://collegetopics.cn:8080"
echo "  前端:  http://$(curl -s ifconfig.me):8080"
echo ""
echo -e "${YELLOW}查看服务状态：${NC}"
echo "  docker compose ps"
echo ""
echo -e "${YELLOW}查看日志：${NC}"
echo "  docker compose logs -f backend    # 后端日志"
echo "  docker compose logs -f frontend   # 前端日志"
echo "  docker compose logs -f mysql      # 数据库日志"
echo ""
echo -e "${YELLOW}默认登录账号：${NC}"
echo "  管理员: admin / admin"
echo "  教师: zzz / 123"
echo "  学生: aaa / 123"
echo ""
echo -e "${YELLOW}接下来需要配置HTTPS（SSL证书）${NC}"
echo "  详见部署文档"
echo "==========================================="
