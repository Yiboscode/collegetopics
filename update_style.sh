#!/bin/bash
set -e
echo "🎨 更新前端样式..."

# 备份
cp vue/src/assets/css/front.css vue/src/assets/css/front.css.backup 2>/dev/null || true

# 更新样式（将宽度从70%改为90%）
sed -i 's/width: 70%;/width: 90%;\n    max-width: 1400px;/' vue/src/assets/css/front.css

echo "✅ 样式文件已更新"

# 重新构建前端
echo "🏗️  重新构建前端..."
docker-compose build --no-cache frontend

# 重启前端
echo "🔄 重启前端服务..."
docker restart entrepreneurship_frontend
sleep 5

echo ""
echo "✅ 更新完成！"
echo "请清除浏览器缓存后刷新页面查看效果"
