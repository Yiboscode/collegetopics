#!/bin/bash
set -e

echo "🔧 最终修复：更新卡片标题样式..."

cd vue/src/views/front

# 1. 检查当前文件内容
echo "📋 检查当前文件..."
if grep -q "card-title-text" Home.vue; then
    echo "✅ 文件已包含 card-title-text"
else
    echo "⚠️  文件还没有更新，正在修改..."
    
    # 备份
    cp Home.vue Home.vue.backup_$(date +%Y%m%d_%H%M%S)
    
    # 替换 HTML 中的类名（卡片标题）
    sed -i 's|<span class="title-text">{{ item.title }}</span>|<span class="card-title-text">{{ item.title }}</span>|g' Home.vue
    
    # 查找并替换 CSS 中卡片标题的样式定义
    # 注意：需要找到卡片相关的 .title-text，不是大标题的 .title-text
    # 在 .separator 之后的 .title-text 就是卡片标题的样式
    
    # 使用 perl 进行多行替换（更可靠）
    perl -i -pe 's/\.separator \{\s*color: #ddd;\s*flex-shrink: 0;\s*\}\s*\.title-text \{/.separator {\n  color: #ddd;\n  flex-shrink: 0;\n  font-size: 13px;\n}\n\n.card-title-text {/g' Home.vue
    
    echo "✅ 文件修改完成"
fi

# 2. 验证修改
echo ""
echo "🔍 验证修改结果..."
grep -n "card-title-text" Home.vue | head -5

cd ../../../..

# 3. 重新编译
echo ""
echo "🏗️  重新编译Vue项目..."
cd vue
sudo rm -rf dist
npm run build

# 4. 验证编译结果
echo ""
echo "🔍 检查编译后的文件..."
if grep -q "card-title-text" dist/assets/*.css 2>/dev/null; then
    echo "✅ 编译成功，CSS包含 card-title-text"
else
    echo "⚠️  警告：编译后的CSS中未找到 card-title-text"
fi

cd ..

# 5. 重新部署
echo ""
echo "🐳 重新部署Docker容器..."
sudo docker stop entrepreneurship_frontend
sudo docker rm entrepreneurship_frontend
sudo docker build --no-cache -t collegetopics-frontend ./vue
sudo docker run -d --name entrepreneurship_frontend --network collegetopics_app-network -p 8080:80 --restart always collegetopics-frontend

sleep 5

echo ""
echo "================================================"
echo "✅ 部署完成！"
echo "================================================"
echo ""
echo "🧪 测试步骤（非常重要！）："
echo "  1. 完全关闭浏览器（不是关标签页）"
echo "  2. 打开浏览器设置，清除所有浏览数据"
echo "  3. 重新打开浏览器"
echo "  4. 访问 https://collegetopics.cn/front/home"
echo "  5. 按 Ctrl+F5 多次刷新"
echo "  6. 按 F12，在Elements中查找 card-title-text"
echo ""
echo "📊 验证方法："
echo "  • 卡片标题应该显示完整，不会被截断"
echo "  • 开发者工具中应该看到 .card-title-text 类"
echo "  • 字体大小应该是 14px"
echo ""

sudo docker ps | grep entrepreneurship_frontend
