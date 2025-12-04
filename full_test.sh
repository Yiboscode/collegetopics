#!/bin/bash
BASE_URL="http://localhost:9090"
echo "========================================"
echo "  创新创业系统 - 完整功能测试"
echo "========================================"
echo ""

TOTAL=0
PASSED=0
FAILED=0
TOKEN=""

# 测试函数
test_api() {
    local name=$1
    local url=$2
    local method=${3:-GET}
    local data=$4
    local use_token=${5:-false}
    
    TOTAL=$((TOTAL + 1))
    echo -n "测试 $TOTAL: $name ... "
    
    if [ "$use_token" = "true" ] && [ ! -z "$TOKEN" ]; then
        if [ "$method" = "GET" ]; then
            response=$(curl -s -w "\n%{http_code}" -H "token: $TOKEN" "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" -X $method -H "Content-Type: application/json" -H "token: $TOKEN" -d "$data" "$BASE_URL$url")
        fi
    else
        if [ "$method" = "GET" ]; then
            response=$(curl -s -w "\n%{http_code}" "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" -X $method -H "Content-Type: application/json" -d "$data" "$BASE_URL$url")
        fi
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo "✓ (HTTP $http_code)"
        PASSED=$((PASSED + 1))
        echo "   响应: ${body:0:100}..."
    else
        echo "✗ (HTTP $http_code)"
        FAILED=$((FAILED + 1))
    fi
}

echo "==================== 第一部分：基础接口 ===================="
test_api "健康检查" "/"
test_api "统计数据" "/count"
echo ""

echo "==================== 第二部分：用户认证 ===================="
# 管理员登录
echo ">>> 测试管理员登录"
login_response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin","role":"ADMIN"}' "$BASE_URL/login")
TOKEN=$(echo $login_response | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
if [ ! -z "$TOKEN" ]; then
    echo "✓ 管理员登录成功，Token: ${TOKEN:0:50}..."
    PASSED=$((PASSED + 1))
else
    echo "✗ 管理员登录失败"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

# 注册新用户
echo ">>> 测试用户注册"
RAND_USER="test_$(date +%s)"
test_api "学生注册" "/register" "POST" "{\"username\":\"$RAND_USER\",\"password\":\"123456\",\"role\":\"USER\",\"name\":\"测试学生\",\"phone\":\"13800138000\",\"email\":\"test@test.com\"}"

# 学生登录
echo ">>> 测试学生登录"
student_login=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"username\":\"$RAND_USER\",\"password\":\"123456\",\"role\":\"USER\"}" "$BASE_URL/login")
STUDENT_TOKEN=$(echo $student_login | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
if [ ! -z "$STUDENT_TOKEN" ]; then
    echo "✓ 学生登录成功"
    PASSED=$((PASSED + 1))
else
    echo "✗ 学生登录失败"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "==================== 第三部分：用户管理（管理员权限） ===================="
test_api "查询所有学生" "/user/selectAll" "GET" "" true
test_api "分页查询学生" "/user/selectPage?pageNum=1&pageSize=10" "GET" "" true
test_api "查询单个学生" "/user/selectById/1" "GET" "" true
echo ""

echo "==================== 第四部分：轮播图管理 ===================="
test_api "查询所有轮播图" "/carousel/selectAll" "GET" "" true
test_api "分页查询轮播图" "/carousel/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第五部分：分类管理 ===================="
test_api "查询所有分类" "/classify/selectAll" "GET" "" true
test_api "分页查询分类" "/classify/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第六部分：项目管理 ===================="
test_api "查询所有项目" "/project/selectAll" "GET" "" true
test_api "分页查询项目" "/project/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第七部分：选题管理（核心功能） ===================="
# 使用学生token提交选题
echo ">>> 使用学生账号提交选题"
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 学生提交选题 ... "
topic_data="{\"title\":\"测试选题_$(date +%s)\",\"description\":\"这是一个测试选题\",\"category\":\"科技创新\",\"keywords\":\"测试,创新\",\"background\":\"项目背景\",\"objectives\":\"项目目标\",\"methodology\":\"研究方法\",\"expectedResults\":\"预期成果\"}"
topic_response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -H "token: $STUDENT_TOKEN" -d "$topic_data" "$BASE_URL/topic/add")
topic_code=$(echo "$topic_response" | tail -n1)
if [ "$topic_code" = "200" ]; then
    echo "✓ (HTTP $topic_code)"
    PASSED=$((PASSED + 1))
else
    echo "✗ (HTTP $topic_code)"
    FAILED=$((FAILED + 1))
fi

test_api "查询所有选题" "/topic/selectAll" "GET" "" true
test_api "分页查询选题" "/topic/selectPage?pageNum=1&pageSize=10" "GET" "" true
test_api "学生查询我的选题" "/topic/my?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第八部分：团队管理 ===================="
test_api "查询所有团队" "/team/selectAll" "GET" "" true
test_api "分页查询团队" "/team/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第九部分：任务管理 ===================="
test_api "查询所有任务" "/task/selectAll" "GET" "" true
test_api "分页查询任务" "/task/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十部分：问答管理 ===================="
test_api "查询所有问答" "/qa/selectAll" "GET" "" true
test_api "分页查询问答" "/qa/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十一部分：竞赛管理 ===================="
test_api "查询所有竞赛" "/competition/selectAll" "GET" "" true
test_api "分页查询竞赛" "/competition/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十二部分：竞赛报名 ===================="
test_api "查询所有报名" "/enroll/selectAll" "GET" "" true
test_api "分页查询报名" "/enroll/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十三部分：通知管理 ===================="
test_api "查询所有通知" "/notice/selectAll" "GET" "" true
test_api "分页查询通知" "/notice/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十四部分：优秀选题 ===================="
test_api "查询优秀选题" "/excellentTopic/selectAll" "GET" "" true
echo ""

echo "==================== 第十五部分：教师管理 ===================="
test_api "查询所有教师" "/teacher/selectAll" "GET" "" true
test_api "分页查询教师" "/teacher/selectPage?pageNum=1&pageSize=10" "GET" "" true
echo ""

echo "==================== 第十六部分：教师认证 ===================="
test_api "查询认证申请" "/certify/selectAll" "GET" "" true
echo ""

echo "==================== 第十七部分：收藏功能 ===================="
test_api "查询收藏" "/collect/selectAll" "GET" "" true
echo ""

echo "==================== 第十八部分：任务提交 ===================="
test_api "查询任务提交" "/submit/selectAll" "GET" "" true
echo ""

echo "==================== 第十九部分：宣传推广 ===================="
test_api "查询推广内容" "/promote/selectAll" "GET" "" true
echo ""

echo "==================== 第二十部分：评价管理 ===================="
test_api "查询评价" "/evaluate/selectAll" "GET" "" true
test_api "查询选题评价" "/topicEvaluation/selectAll" "GET" "" true
test_api "查询创新评价" "/innovationEvaluation/selectAll" "GET" "" true
echo ""

echo "==================== 第二十一部分：文件操作 ===================="
# 测试文件上传
echo ">>> 测试文件上传"
TOTAL=$((TOTAL + 1))
echo -n "测试 $TOTAL: 文件上传功能 ... "
# 创建一个测试文件
echo "这是一个测试文件" > /tmp/test_upload.txt
upload_response=$(curl -s -w "\n%{http_code}" -F "file=@/tmp/test_upload.txt" "$BASE_URL/files/upload")
upload_code=$(echo "$upload_response" | tail -n1)
upload_body=$(echo "$upload_response" | head -n-1)
if [ "$upload_code" = "200" ]; then
    echo "✓ (HTTP $upload_code)"
    PASSED=$((PASSED + 1))
    file_url=$(echo "$upload_body" | grep -o '"data":"[^"]*"' | sed 's/"data":"//;s/"//')
    echo "   上传成功，文件URL: $file_url"
    
    # 测试文件下载
    if [ ! -z "$file_url" ]; then
        filename=$(basename "$file_url")
        TOTAL=$((TOTAL + 1))
        echo -n "测试 $TOTAL: 文件下载功能 ... "
        download_response=$(curl -s -w "\n%{http_code}" -o /tmp/downloaded_file.txt "$BASE_URL/files/download/$filename")
        download_code=$(echo "$download_response" | tail -n1)
        if [ "$download_code" = "200" ]; then
            echo "✓ (HTTP $download_code)"
            PASSED=$((PASSED + 1))
            echo "   文件下载成功"
        else
            echo "✗ (HTTP $download_code)"
            FAILED=$((FAILED + 1))
        fi
    fi
else
    echo "✗ (HTTP $upload_code)"
    FAILED=$((FAILED + 1))
fi

# 清理测试文件
rm -f /tmp/test_upload.txt /tmp/downloaded_file.txt
echo ""

echo "==================== 第二十二部分：数据统计 ===================="
test_api "Echarts数据" "/echarts/bar" "GET" "" true
test_api "Echarts折线图" "/echarts/line" "GET" "" true
test_api "Echarts饼图" "/echarts/pie" "GET" "" true
echo ""

echo "========================================"
echo "           测试结果汇总"
echo "========================================"
echo "总测试数: $TOTAL"
echo "✓ 通过: $PASSED"
echo "✗ 失败: $FAILED"
success_rate=$(awk "BEGIN {printf \"%.2f\", ($PASSED/$TOTAL)*100}")
echo "成功率: $success_rate%"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "������ 所有测试通过！系统运行完美！"
    exit 0
else
    echo "⚠️  有 $FAILED 个测试失败，需要检查"
    exit 1
fi
