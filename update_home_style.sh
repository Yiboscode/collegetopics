#!/bin/bash
set -e

echo "🎨 更新优秀选题卡片样式..."
echo ""

cd /home/ubuntu/collegetopics

# 1. 重新编译Vue项目
echo "🏗️  重新编译Vue项目..."
cd vue
npm run build
echo "✅ 编译完成"
echo ""

cd ..

# 2. 停止并删除旧容器
echo "🐳 重新构建Docker..."
sudo docker stop entrepreneurship_frontend
sudo docker rm entrepreneurship_frontend

# 3. 重新构建镜像
sudo docker build -t collegetopics-frontend ./vue

# 4. 启动新容器
sudo docker run -d \
  --name entrepreneurship_frontend \
  --network collegetopics_app-network \
  -p 8080:80 \
  --restart always \
  collegetopics-frontend

echo ""
echo "⏳ 等待服务启动..."
sleep 5

sudo docker ps | grep entrepreneurship_frontend

echo ""
echo "================================================"
echo "✅ 样式更新完成！"
echo "================================================"
echo ""
echo "📋 修改内容："
echo "  • 卡片标题字体：16px → 14px"
echo "  • 分类标签字体：13px（更小）"
echo "  • 行高优化，文字不会被截断"
echo ""
echo "🧪 测试方法："
echo "  1. 清除浏览器缓存（Ctrl+Shift+Delete）"
echo "  2. 强制刷新（Ctrl+F5）"
echo "  3. 查看优秀选题的标题是否完整显示"
echo ""
