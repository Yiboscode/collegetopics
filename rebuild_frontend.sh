#!/bin/bash
set -e

echo "🎨 开始更新前端样式并重新编译..."
echo ""

# 1. 检查并更新CSS
echo "📝 Step 1: 更新CSS文件..."
cd /home/ubuntu/collegetopics

# 备份
cp vue/src/assets/css/front.css vue/src/assets/css/front.css.backup 2>/dev/null || true

# 检查是否已经是90%
if grep -q "width: 90%" vue/src/assets/css/front.css; then
    echo "✅ CSS已经是90%宽度"
else
    echo "📝 修改CSS宽度..."
    sed -i 's/width: 70%;/width: 90%;\n    max-width: 1400px;/g' vue/src/assets/css/front.css
    echo "✅ CSS已更新为90%宽度"
fi

# 验证修改
echo ""
echo "📋 当前CSS设置："
grep -A 2 "main-content {" vue/src/assets/css/front.css | grep "width"
echo ""

# 2. 重新编译Vue项目
echo "🏗️  Step 2: 重新编译Vue项目..."
cd vue

if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install
fi

echo "⚙️  编译中..."
npm run build

if [ -d "dist" ]; then
    echo "✅ 编译完成，dist目录已生成"
    ls -lh dist/ | head -5
else
    echo "❌ 编译失败，dist目录不存在"
    exit 1
fi

cd ..
echo ""

# 3. 重新构建Docker镜像
echo "🐳 Step 3: 重新构建Docker镜像..."
sudo docker stop entrepreneurship_frontend 2>/dev/null || true
sudo docker rm entrepreneurship_frontend 2>/dev/null || true
sudo docker build -t collegetopics-frontend ./vue

# 4. 启动新容器
echo "🚀 Step 4: 启动新容器..."
sudo docker run -d \
  --name entrepreneurship_frontend \
  --network collegetopics_app-network \
  -p 8080:80 \
  --restart always \
  collegetopics-frontend

sleep 5

# 5. 验证
echo ""
echo "🔍 检查容器状态..."
sudo docker ps | grep entrepreneurship_frontend

echo ""
echo "================================================"
echo "✅ 前端更新完成！"
echo "================================================"
echo ""
echo "📊 修改内容："
echo "  • 页面宽度：70% → 90%"
echo "  • 最大宽度：1400px"
echo "  • 布局更加宽敞"
echo ""
echo "🧪 测试步骤（重要！）："
echo "  1. 清除浏览器所有缓存和Cookie"
echo "  2. 完全关闭浏览器"
echo "  3. 重新打开浏览器"
echo "  4. 访问 https://collegetopics.cn/front/home"
echo "  5. 按 Ctrl+F5 强制刷新"
echo ""
echo "💡 如果还是没变化："
echo "  • 尝试无痕模式访问"
echo "  • 换一个浏览器测试"
echo "  • 用手机浏览器访问"
echo ""
