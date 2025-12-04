#!/bin/bash
BASE_URL="http://localhost:9090"
echo "================================"
echo "  创新创业系统API测试"
echo "================================"
echo ""
TOTAL=0
PASSED=0
FAILED=0

test_api() {
    local name=$1
    local url=$2
    TOTAL=$((TOTAL + 1))
    echo -n "测试 $TOTAL: $name ... "
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL$url")
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo "✓ 通过 (HTTP $http_code)"
        PASSED=$((PASSED + 1))
    else
        echo "✗ 失败 (HTTP $http_code)"
        FAILED=$((FAILED + 1))
    fi
}

echo ">>> 基础接口测试"
test_api "健康检查" "/"
test_api "统计数据" "/count"

echo ""
echo ">>> 用户认证测试"
login_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin","role":"ADMIN"}' "$BASE_URL/login")
echo "登录响应: $login_response"

token=$(echo $login_response | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
if [ ! -z "$token" ]; then
    echo "Token获取成功: ${token:0:50}..."
    echo ""
    echo ">>> 受保护接口测试"
    test_api "用户列表" "/user/selectAll" 
    test_api "选题列表" "/topic/selectAll"
    test_api "项目列表" "/project/selectAll"
    test_api "团队列表" "/team/selectAll"
fi

echo ""
echo "================================"
echo "测试结果: 通过 $PASSED / 失败 $FAILED / 总数 $TOTAL"
echo "================================"
