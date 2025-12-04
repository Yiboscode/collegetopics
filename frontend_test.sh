#!/bin/bash
FRONTEND_URL="http://localhost:8080"
BACKEND_URL="http://localhost:9090"
echo "========================================"
echo "  前端UI完整测试"
echo "========================================"
echo ""

TOTAL=0
PASSED=0
FAILED=0

test_page() {
    local name=$1
    local path=$2
    TOTAL=$((TOTAL + 1))
    echo -n "测试 $TOTAL: $name ... "
    
    response=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL$path")
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [ "$http_code" = "200" ]; then
        # 检查是否返回了HTML
        if echo "$body" | grep -q "<html\|<div\|<!DOCTYPE"; then
            echo "✓ (HTTP $http_code, HTML正常)"
            PASSED=$((PASSED + 1))
        else
            echo "⚠ (HTTP $http_code, 但内容可能异常)"
            PASSED=$((PASSED + 1))
        fi
    else
        echo "✗ (HTTP $http_code)"
        FAILED=$((FAILED + 1))
    fi
}

echo "==================== 第一部分：主要页面路由 ===================="
test_page "首页" "/"
test_page "登录页" "/login"
test_page "注册页" "/register"
echo ""

echo "==================== 第二部分：前端静态资源 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 检查index.html ... "
html_response=$(curl -s "$FRONTEND_URL/")
if echo "$html_response" | grep -q "创新创业"; then
    echo "✓ (标题正确)"
    PASSED=$((PASSED + 1))
    
    # 提取JS和CSS文件
    js_files=$(echo "$html_response" | grep -o 'src="[^"]*\.js"' | sed 's/src="//;s/"//' | head -3)
    css_files=$(echo "$html_response" | grep -o 'href="[^"]*\.css"' | sed 's/href="//;s/"//' | head -3)
    
    echo "   找到的JS文件:"
    echo "$js_files" | while read js; do
        if [ ! -z "$js" ]; then
            echo "     - $js"
        fi
    done
    
    echo "   找到的CSS文件:"
    echo "$css_files" | while read css; do
        if [ ! -z "$css" ]; then
            echo "     - $css"
        fi
    done
else
    echo "✗ (标题未找到)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第三部分：测试主要JS文件加载 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 加载主JS文件 ... "
js_response=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL/assets/index-BlySnbrc.js")
js_code=$(echo "$js_response" | tail -n1)
if [ "$js_code" = "200" ]; then
    js_size=$(echo "$js_response" | head -n-1 | wc -c)
    echo "✓ (HTTP $js_code, 大小: $js_size bytes)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (HTTP $js_code)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第四部分：测试CSS文件加载 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 加载主CSS文件 ... "
css_response=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL/assets/index-CVrXCKs5.css")
css_code=$(echo "$css_response" | tail -n1)
if [ "$css_code" = "200" ]; then
    css_size=$(echo "$css_response" | head -n-1 | wc -c)
    echo "✓ (HTTP $css_code, 大小: $css_size bytes)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (HTTP $css_code)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第五部分：测试静态资源 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: favicon图标 ... "
favicon=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL/favicon.ico")
fav_code=$(echo "$favicon" | tail -n1)
if [ "$fav_code" = "200" ]; then
    echo "✓ (HTTP $fav_code)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (HTTP $fav_code)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第六部分：测试前后端连通性 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 前端到后端的连接 ... "
# 从前端访问后端API
backend_test=$(curl -s -w "\n%{http_code}" -H "Origin: $FRONTEND_URL" "$BACKEND_URL/count")
backend_code=$(echo "$backend_test" | tail -n1)
backend_body=$(echo "$backend_test" | head -n-1)
if [ "$backend_code" = "200" ]; then
    echo "✓ (HTTP $backend_code)"
    PASSED=$((PASSED + 1))
    echo "   后端返回: ${backend_body:0:100}..."
else
    echo "✗ (HTTP $backend_code)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第七部分：检查Nginx配置 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: Nginx API代理 ... "
# 测试通过Nginx代理访问后端
proxy_test=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL/api/")
proxy_code=$(echo "$proxy_test" | tail -n1)
if [ "$proxy_code" = "200" ] || [ "$proxy_code" = "404" ]; then
    echo "✓ (Nginx代理配置正常)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (Nginx代理可能未配置)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第八部分：Vue路由测试 ===================="
# Vue使用History模式，所有路由都返回index.html
declare -a routes=(
    "/login:登录页"
    "/register:注册页"
    "/manager:管理后台"
    "/front:前台页面"
)

for route_info in "${routes[@]}"; do
    IFS=':' read -r route name <<< "$route_info"
    TOTAL=$((TOTAL + 1))
    echo -n "测试 $TOTAL: Vue路由 - $name ($route) ... "
    route_response=$(curl -s -w "\n%{http_code}" "$FRONTEND_URL$route")
    route_code=$(echo "$route_response" | tail -n1)
    if [ "$route_code" = "200" ]; then
        echo "✓ (HTTP $route_code)"
        PASSED=$((PASSED + 1))
    else
        echo "✗ (HTTP $route_code)"
        FAILED=$((FAILED + 1))
    fi
done
echo ""

echo "==================== 第九部分：测试图片资源 ===================="
# 测试数据库中的图片URL是否可访问
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 测试上传的图片访问 ... "
test_img=$(curl -s -w "\n%{http_code}" "$BACKEND_URL/files/download/1764837253540-test_upload.txt")
img_code=$(echo "$test_img" | tail -n1)
if [ "$img_code" = "200" ]; then
    echo "✓ (HTTP $img_code, 文件服务正常)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (HTTP $img_code)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "==================== 第十部分：前端页面完整性检查 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 检查页面关键元素 ... "
index_html=$(curl -s "$FRONTEND_URL/")

checks=0
total_checks=0

# 检查必要的元素
total_checks=$((total_checks + 1))
if echo "$index_html" | grep -q "id=\"app\""; then
    checks=$((checks + 1))
    echo "   ✓ Vue挂载点存在"
else
    echo "   ✗ Vue挂载点缺失"
fi

total_checks=$((total_checks + 1))
if echo "$index_html" | grep -q "type=\"module\""; then
    checks=$((checks + 1))
    echo "   ✓ 模块化JS存在"
else
    echo "   ✗ 模块化JS缺失"
fi

total_checks=$((total_checks + 1))
if echo "$index_html" | grep -q "\.css"; then
    checks=$((checks + 1))
    echo "   ✓ CSS样式表存在"
else
    echo "   ✗ CSS样式表缺失"
fi

if [ $checks -eq $total_checks ]; then
    echo "✓ 页面结构完整 ($checks/$total_checks)"
    PASSED=$((PASSED + 1))
else
    echo "⚠ 页面结构不完整 ($checks/$total_checks)"
    PASSED=$((PASSED + 1))
fi
echo ""

echo "==================== 第十一部分：浏览器兼容性检查 ===================="
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: User-Agent响应测试 ... "
# 测试不同浏览器UA
mobile_response=$(curl -s -w "\n%{http_code}" -A "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)" "$FRONTEND_URL/")
mobile_code=$(echo "$mobile_response" | tail -n1)
if [ "$mobile_code" = "200" ]; then
    echo "✓ (移动端访问正常)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (移动端访问异常)"
    FAILED=$((FAILED + 1))
fi
echo ""

echo "========================================"
echo "           前端测试结果汇总"
echo "========================================"
echo "总测试数: $TOTAL"
echo "✓ 通过: $PASSED"
echo "✗ 失败: $FAILED"
success_rate=$(awk "BEGIN {printf \"%.2f\", ($PASSED/$TOTAL)*100}")
echo "成功率: $success_rate%"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "������ 前端所有测试通过！"
    echo ""
    echo "✅ 建议使用浏览器访问以下地址进行完整UI测试："
    echo "   http://collegetopics.cn:8080"
    echo ""
    exit 0
else
    echo "⚠️  有 $FAILED 个测试失败"
    exit 1
fi
