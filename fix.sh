#!/bin/bash
set -e
echo "🚀 开始修复..."

# 备份数据库
BACKUP="backup_$(date +%Y%m%d_%H%M%S).sql"
docker exec entrepreneurship_mysql mysqldump -uroot -proot123456 entrepreneurship_system > "$BACKUP" 2>/dev/null
echo "✅ 数据库已备份: $BACKUP"

# 更新数据库URL
docker exec entrepreneurship_mysql mysql -uroot -proot123456 -e "
USE entrepreneurship_system;
UPDATE admin SET avatar = REPLACE(avatar, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE avatar LIKE 'http://localhost:9090%';
UPDATE carousel SET img = REPLACE(img, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE img LIKE 'http://localhost:9090%';
UPDATE certify SET img1 = REPLACE(img1, 'http://localhost:9090', 'https://collegetopics.cn/api'), img2 = REPLACE(img2, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE img1 LIKE 'http://localhost:9090%' OR img2 LIKE 'http://localhost:9090%';
UPDATE competition SET img = REPLACE(img, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE img LIKE 'http://localhost:9090%';
UPDATE excellent_topic SET image_url = REPLACE(image_url, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE image_url LIKE 'http://localhost:9090%';
UPDATE project SET img = REPLACE(img, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE img LIKE 'http://localhost:9090%';
UPDATE promote SET img = REPLACE(img, 'http://localhost:9090', 'https://collegetopics.cn/api'), video = REPLACE(video, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE img LIKE 'http://localhost:9090%' OR video LIKE 'http://localhost:9090%';
UPDATE submit SET detail = REPLACE(detail, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE detail LIKE 'http://localhost:9090%';
UPDATE teacher SET avatar = REPLACE(avatar, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE avatar LIKE 'http://localhost:9090%';
UPDATE topic SET image_url = REPLACE(image_url, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE image_url LIKE 'http://localhost:9090%';
UPDATE user SET avatar = REPLACE(avatar, 'http://localhost:9090', 'https://collegetopics.cn/api') WHERE avatar LIKE 'http://localhost:9090%';
" 2>/dev/null
echo "✅ 数据库URL已更新"

# 更新配置文件
if [ -f "springboot/src/main/resources/application.yml" ]; then
    sed -i 's|fileBaseUrl: https://collegetopics.cn$|fileBaseUrl: https://collegetopics.cn/api|g' springboot/src/main/resources/application.yml
    echo "✅ 配置文件已更新"
fi

# 重启服务
echo "🔄 重启服务..."
docker-compose restart backend
sleep 10
docker-compose restart frontend

echo ""
echo "✅ 修复完成！请访问 https://collegetopics.cn 测试"
echo "记得清除浏览器缓存（Ctrl+Shift+Delete）"
echo "备份文件: $BACKUP"
