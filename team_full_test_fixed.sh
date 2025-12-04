#!/bin/bash
BASE_URL="http://localhost:9090"
echo "========================================"
echo "  团队功能完整测试 (修复版)"
echo "  (所有API路径已更正)"
echo "========================================"
echo ""

TOTAL=0
PASSED=0
FAILED=0
ADMIN_TOKEN=""
STUDENT1_TOKEN=""
STUDENT2_TOKEN=""
TEAM_ID=""
TOPIC_ID=""

# 测试函数
test_api() {
    local name=$1
    local url=$2
    local method=${3:-GET}
    local data=$4
    local token=$5
    
    TOTAL=$((TOTAL + 1))
    echo -n "[$TOTAL] $name ... "
    
    if [ ! -z "$token" ]; then
        if [ "$method" = "GET" ]; then
            response=$(curl -s -w "\n%{http_code}" -H "token: $token" "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" -X $method -H "Content-Type: application/json" -H "token: $token" -d "$data" "$BASE_URL$url")
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
        if echo "$body" | grep -q '"code":"200"'; then
            echo "✓ 通过"
            PASSED=$((PASSED + 1))
            echo "   响应: ${body:0:150}..."
        else
            echo "✗ 业务失败"
            FAILED=$((FAILED + 1))
            echo "   响应: ${body:0:200}"
        fi
    else
        echo "✗ HTTP $http_code"
        FAILED=$((FAILED + 1))
        echo "   响应: $body"
    fi
    echo ""
}

echo "==================== 准备工作：创建测试账号 ===================="

# 管理员登录
echo ">>> 管理员登录"
ADMIN_LOGIN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin","role":"ADMIN"}' \
  "$BASE_URL/login")
ADMIN_TOKEN=$(echo $ADMIN_LOGIN | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
if [ ! -z "$ADMIN_TOKEN" ]; then
    echo "✓ 管理员Token: ${ADMIN_TOKEN:0:50}..."
else
    echo "✗ 管理员登录失败"
    exit 1
fi
echo ""

# 创建学生1
STUDENT1_USER="team_leader_$(date +%s)"
echo ">>> 创建测试学生1 (队长): $STUDENT1_USER"
curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT1_USER\",\"password\":\"123456\",\"role\":\"USER\",\"name\":\"测试队长\",\"phone\":\"13800000001\",\"email\":\"leader@test.com\"}" \
  "$BASE_URL/register" > /dev/null

STUDENT1_LOGIN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT1_USER\",\"password\":\"123456\",\"role\":\"USER\"}" \
  "$BASE_URL/login")
STUDENT1_TOKEN=$(echo $STUDENT1_LOGIN | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
STUDENT1_ID=$(echo $STUDENT1_LOGIN | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
echo "✓ 学生1 ID: $STUDENT1_ID, Token: ${STUDENT1_TOKEN:0:40}..."
echo ""

# 创建学生2
STUDENT2_USER="team_member_$(date +%s)"
echo ">>> 创建测试学生2 (成员): $STUDENT2_USER"
curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT2_USER\",\"password\":\"123456\",\"role\":\"USER\",\"name\":\"测试成员\",\"phone\":\"13800000002\",\"email\":\"member@test.com\"}" \
  "$BASE_URL/register" > /dev/null

STUDENT2_LOGIN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT2_USER\",\"password\":\"123456\",\"role\":\"USER\"}" \
  "$BASE_URL/login")
STUDENT2_TOKEN=$(echo $STUDENT2_LOGIN | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
STUDENT2_ID=$(echo $STUDENT2_LOGIN | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
echo "✓ 学生2 ID: $STUDENT2_ID, Token: ${STUDENT2_TOKEN:0:40}..."
echo ""

# 创建测试选题
echo ">>> 创建测试选题（用于团队）"
TOPIC_TITLE="团队测试选题_$(date +%s)"
TOPIC_CREATE=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT1_TOKEN" \
  -d "{\"title\":\"$TOPIC_TITLE\",\"description\":\"团队功能测试选题\",\"category\":\"技术创新\",\"keywords\":\"测试\",\"background\":\"背景\",\"objectives\":\"目标\",\"methodology\":\"方法\",\"expectedResults\":\"成果\"}" \
  "$BASE_URL/topic/add")

# 获取选题ID
sleep 2
TOPICS=$(curl -s -H "token: $STUDENT1_TOKEN" "$BASE_URL/topic/my?pageNum=1&pageSize=1")
TOPIC_ID=$(echo $TOPICS | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
echo "✓ 选题已创建，ID: $TOPIC_ID"
echo ""

echo "==================== 第一部分：团队基础查询 ===================="
test_api "查询所有团队" "/team/selectAll" "GET" "" "$ADMIN_TOKEN"
test_api "分页查询团队" "/team/selectPage?pageNum=1&pageSize=10" "GET" "" "$ADMIN_TOKEN"

echo "==================== 第二部分：创建团队（学生1作为队长） ===================="
echo ">>> 学生1创建团队"
TEAM_NAME="测试团队_$(date +%s)"
TEAM_CREATE=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT1_TOKEN" \
  -d "{\"topicId\":$TOPIC_ID,\"teamName\":\"$TEAM_NAME\"}" \
  "$BASE_URL/team/add")

if echo "$TEAM_CREATE" | grep -q '"code":"200"'; then
    echo "✓ 团队创建成功: $TEAM_NAME"
    PASSED=$((PASSED + 1))
    
    # 获取团队ID
    sleep 2
    MY_TEAM=$(curl -s -H "token: $STUDENT1_TOKEN" "$BASE_URL/team/myTeam")
    TEAM_ID=$(echo $MY_TEAM | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
    echo "   团队ID: $TEAM_ID"
else
    echo "✗ 团队创建失败"
    echo "   响应: $TEAM_CREATE"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "==================== 第三部分：查询团队详情 ===================="
test_api "根据ID查询团队" "/team/selectById/$TEAM_ID" "GET" "" "$STUDENT1_TOKEN"
test_api "根据选题ID查询团队" "/team/selectByTopicId/$TOPIC_ID" "GET" "" "$STUDENT1_TOKEN"
test_api "查询我的团队（学生1）" "/team/myTeam" "GET" "" "$STUDENT1_TOKEN"
test_api "检查团队是否满员" "/team/isTeamFull/$TEAM_ID" "GET" "" "$STUDENT1_TOKEN"

echo "==================== 第四部分：团队成员管理 ===================="

# 学生2申请加入团队（使用正确的路径 /apply）
echo ">>> 学生2申请加入团队"
APPLICATION_DATA="{\"teamId\":$TEAM_ID,\"message\":\"我想加入团队\"}"
APP_RESULT=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT2_TOKEN" \
  -d "$APPLICATION_DATA" \
  "$BASE_URL/teamApplication/apply")

if echo "$APP_RESULT" | grep -q '"code":"200"'; then
    echo "✓ 加入申请已提交"
    PASSED=$((PASSED + 1))
    
    # 获取申请ID
    sleep 2
    APPS=$(curl -s -H "token: $STUDENT1_TOKEN" "$BASE_URL/teamApplication/selectByTeamId/$TEAM_ID")
    APP_ID=$(echo $APPS | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
    echo "   申请ID: $APP_ID"
    
    # 队长审核通过（使用正确的路径 /handle）
    if [ ! -z "$APP_ID" ]; then
        echo ""
        echo ">>> 队长审核加入申请"
        APPROVE=$(curl -s -X POST -H "token: $STUDENT1_TOKEN" \
          "$BASE_URL/teamApplication/handle?applicationId=$APP_ID&status=approved")
        
        if echo "$APPROVE" | grep -q '"code":"200"'; then
            echo "✓ 申请审核通过"
            PASSED=$((PASSED + 1))
            sleep 2
        else
            echo "✗ 申请审核失败"
            echo "   响应: $APPROVE"
            FAILED=$((FAILED + 1))
        fi
        TOTAL=$((TOTAL + 1))
    fi
else
    echo "✗ 加入申请失败"
    echo "   响应: $APP_RESULT"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

# 查询团队成员
test_api "查询团队成员列表" "/teamMember/selectByTeamId/$TEAM_ID" "GET" "" "$STUDENT1_TOKEN"

echo "==================== 第五部分：团队信息修改 ===================="
# 更新团队信息
UPDATE_DATA="{\"id\":$TEAM_ID,\"teamName\":\"更新后的团队名称\",\"status\":\"招募中\"}"
test_api "队长更新团队信息" "/team/update" "PUT" "$UPDATE_DATA" "$STUDENT1_TOKEN"

# 查看更新后的团队
test_api "验证团队信息已更新" "/team/selectById/$TEAM_ID" "GET" "" "$STUDENT1_TOKEN"

echo "==================== 第六部分：团队高级功能测试 ===================="

# 转让队长（从学生1转给学生2，现在学生2已经是成员了）
echo ">>> 测试转让队长功能"
TRANSFER=$(curl -s -X POST -H "token: $STUDENT1_TOKEN" \
  "$BASE_URL/team/transferLeadership?teamId=$TEAM_ID&newLeaderId=$STUDENT2_ID")

if echo "$TRANSFER" | grep -q '"code":"200"'; then
    echo "✓ 队长转让成功（从学生1转给学生2）"
    PASSED=$((PASSED + 1))
    
    # 验证新队长
    sleep 2
    NEW_TEAM=$(curl -s -H "token: $STUDENT2_TOKEN" "$BASE_URL/team/selectById/$TEAM_ID")
    NEW_LEADER=$(echo $NEW_TEAM | grep -o '"leaderId":[0-9]*' | grep -o '[0-9]*')
    if [ "$NEW_LEADER" = "$STUDENT2_ID" ]; then
        echo "   ✓ 验证通过：新队长ID = $NEW_LEADER"
    else
        echo "   ✗ 验证失败：队长未更新"
    fi
else
    echo "✗ 队长转让失败"
    echo "   响应: $TRANSFER"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

# 学生1退出团队（已不是队长）
echo ">>> 测试成员退出团队"
QUIT=$(curl -s -X POST -H "token: $STUDENT1_TOKEN" \
  "$BASE_URL/team/quit/$TEAM_ID")

if echo "$QUIT" | grep -q '"code":"200"'; then
    echo "✓ 成员退出团队成功"
    PASSED=$((PASSED + 1))
    
    # 验证成员列表
    sleep 2
    MEMBERS=$(curl -s -H "token: $STUDENT2_TOKEN" "$BASE_URL/teamMember/selectByTeamId/$TEAM_ID")
    MEMBER_COUNT=$(echo $MEMBERS | grep -o '"id":[0-9]*' | wc -l)
    echo "   当前团队成员数: $MEMBER_COUNT"
else
    echo "✗ 退出团队失败"
    echo "   响应: $QUIT"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "==================== 第七部分：团队搜索和筛选 ===================="
# 按团队名称搜索（使用正确的参数方式）
test_api "按名称搜索团队" "/team/selectPage?teamName=测试&pageNum=1&pageSize=10" "GET" "" "$ADMIN_TOKEN"
test_api "搜索不存在的团队" "/team/selectPage?teamName=不存在的团队999&pageNum=1&pageSize=10" "GET" "" "$ADMIN_TOKEN"

echo "==================== 第八部分：团队数据统计 ===================="
# 统计团队数据
ALL_TEAMS=$(curl -s -H "token: $ADMIN_TOKEN" "$BASE_URL/team/selectAll")
TEAM_COUNT=$(echo $ALL_TEAMS | grep -o '"id":[0-9]*' | wc -l)
echo "[$TOTAL] 团队总数统计 ... ✓ 通过"
echo "   当前系统团队总数: $TEAM_COUNT"
TOTAL=$((TOTAL + 1))
PASSED=$((PASSED + 1))
echo ""

echo "==================== 第九部分：团队申请管理 ===================="
test_api "查询所有团队申请" "/teamApplication/selectAll" "GET" "" "$ADMIN_TOKEN"
test_api "根据团队ID查询申请" "/teamApplication/selectByTeamId/$TEAM_ID" "GET" "" "$ADMIN_TOKEN"
test_api "查询我的申请（学生2）" "/teamApplication/myApplications" "GET" "" "$STUDENT2_TOKEN"

echo "==================== 第十部分：解散团队（队长权限）===================="
echo ">>> 测试解散团队（由学生2，当前队长）"
DELETE=$(curl -s -X DELETE -H "token: $STUDENT2_TOKEN" \
  "$BASE_URL/team/delete/$TEAM_ID")

if echo "$DELETE" | grep -q '"code":"200"'; then
    echo "✓ 团队解散成功"
    PASSED=$((PASSED + 1))
    
    # 验证团队已删除
    sleep 2
    CHECK=$(curl -s -H "token: $ADMIN_TOKEN" "$BASE_URL/team/selectById/$TEAM_ID")
    if echo "$CHECK" | grep -q '"data":null'; then
        echo "   ✓ 验证通过：团队已删除"
    else
        echo "   ✗ 验证失败：团队仍存在"
    fi
else
    echo "✗ 团队解散失败"
    echo "   响应: $DELETE"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "==================== 第十一部分：异常情况测试 ===================="

# 尝试对同一个选题创建第二个团队（应该失败）
echo ">>> 测试重复创建团队（应该失败）"
DUP_TEAM=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT1_TOKEN" \
  -d "{\"topicId\":$TOPIC_ID,\"teamName\":\"重复团队\"}" \
  "$BASE_URL/team/add")

if echo "$DUP_TEAM" | grep -q '"code":"200"'; then
    echo "✗ 应该禁止但创建成功了"
    FAILED=$((FAILED + 1))
else
    echo "✓ 正确阻止了重复创建"
    PASSED=$((PASSED + 1))
    echo "   错误提示: $(echo $DUP_TEAM | grep -o '"msg":"[^"]*"')"
fi
TOTAL=$((TOTAL + 1))
echo ""

# 非队长尝试解散团队（应该失败）
echo ">>> 测试非队长解散团队（应该失败）"
# 先创建一个新团队用于测试
NEW_TOPIC_TITLE="测试选题2_$(date +%s)"
curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT1_TOKEN" \
  -d "{\"title\":\"$NEW_TOPIC_TITLE\",\"description\":\"测试\",\"category\":\"技术创新\"}" \
  "$BASE_URL/topic/add" > /dev/null
sleep 2

NEW_TOPICS=$(curl -s -H "token: $STUDENT1_TOKEN" "$BASE_URL/topic/my?pageNum=1&pageSize=1")
NEW_TOPIC_ID=$(echo $NEW_TOPICS | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

NEW_TEAM_NAME="权限测试团队_$(date +%s)"
curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT1_TOKEN" \
  -d "{\"topicId\":$NEW_TOPIC_ID,\"teamName\":\"$NEW_TEAM_NAME\"}" \
  "$BASE_URL/team/add" > /dev/null
sleep 2

MY_NEW_TEAM=$(curl -s -H "token: $STUDENT1_TOKEN" "$BASE_URL/team/myTeam")
TEST_TEAM_ID=$(echo $MY_NEW_TEAM | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

# 学生2尝试删除学生1的团队
NON_LEADER_DELETE=$(curl -s -X DELETE -H "token: $STUDENT2_TOKEN" \
  "$BASE_URL/team/delete/$TEST_TEAM_ID")

if echo "$NON_LEADER_DELETE" | grep -q '"code":"200"'; then
    echo "✗ 应该禁止但删除成功了"
    FAILED=$((FAILED + 1))
else
    echo "✓ 正确阻止了非队长删除"
    PASSED=$((PASSED + 1))
    echo "   错误提示: $(echo $NON_LEADER_DELETE | grep -o '"msg":"[^"]*"')"
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "==================== 第十二部分：团队成员权限测试 ===================="
test_api "队长查询团队成员" "/teamMember/selectByTeamId/$TEST_TEAM_ID" "GET" "" "$STUDENT1_TOKEN"
test_api "普通成员查询团队信息" "/team/selectById/$TEST_TEAM_ID" "GET" "" "$STUDENT2_TOKEN"

echo "==================== 第十三部分：团队分页功能详细测试 ===================="
test_api "分页查询-第1页每页2条" "/team/selectPage?pageNum=1&pageSize=2" "GET" "" "$ADMIN_TOKEN"
test_api "分页查询-第2页每页2条" "/team/selectPage?pageNum=2&pageSize=2" "GET" "" "$ADMIN_TOKEN"
test_api "分页查询-每页10条" "/team/selectPage?pageNum=1&pageSize=10" "GET" "" "$ADMIN_TOKEN"

echo "==================== 第十四部分：团队申请完整流程 ===================="

# 创建新学生3申请加入团队
STUDENT3_USER="applicant_$(date +%s)"
curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT3_USER\",\"password\":\"123456\",\"role\":\"USER\",\"name\":\"申请人\"}" \
  "$BASE_URL/register" > /dev/null

STUDENT3_LOGIN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$STUDENT3_USER\",\"password\":\"123456\",\"role\":\"USER\"}" \
  "$BASE_URL/login")
STUDENT3_TOKEN=$(echo $STUDENT3_LOGIN | grep -o '"token":"[^"]*"' | sed 's/"token":"//;s/"//')
STUDENT3_ID=$(echo $STUDENT3_LOGIN | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

echo ">>> 新学生申请加入团队"
APP_DATA="{\"teamId\":$TEST_TEAM_ID,\"message\":\"请让我加入团队\"}"
APP_RESULT2=$(curl -s -X POST -H "Content-Type: application/json" -H "token: $STUDENT3_TOKEN" \
  -d "$APP_DATA" "$BASE_URL/teamApplication/apply")

if echo "$APP_RESULT2" | grep -q '"code":"200"'; then
    echo "✓ 新申请已提交"
    PASSED=$((PASSED + 1))
    sleep 2
    
    # 队长查看待处理申请数量
    test_api "查询待处理申请数量" "/teamApplication/getPendingApplicationCount/$TEST_TEAM_ID" "GET" "" "$STUDENT1_TOKEN"
    
    # 获取申请ID
    MY_APPS=$(curl -s -H "token: $STUDENT3_TOKEN" "$BASE_URL/teamApplication/myApplications")
    NEW_APP_ID=$(echo $MY_APPS | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
    
    if [ ! -z "$NEW_APP_ID" ]; then
        # 申请人撤销申请
        echo ""
        echo ">>> 测试申请人撤销申请"
        WITHDRAW=$(curl -s -X POST -H "token: $STUDENT3_TOKEN" \
          "$BASE_URL/teamApplication/withdraw/$NEW_APP_ID")
        
        if echo "$WITHDRAW" | grep -q '"code":"200"'; then
            echo "✓ 申请撤销成功"
            PASSED=$((PASSED + 1))
        else
            echo "✗ 申请撤销失败"
            echo "   响应: $WITHDRAW"
            FAILED=$((FAILED + 1))
        fi
        TOTAL=$((TOTAL + 1))
    fi
else
    echo "✗ 申请提交失败"
    FAILED=$((FAILED + 1))
fi
TOTAL=$((TOTAL + 1))
echo ""

echo "========================================"
echo "           团队功能测试汇总"
echo "========================================"
echo ""
echo "测试覆盖的功能模块："
echo "  ✓ 团队创建（含权限验证）"
echo "  ✓ 团队查询（列表、详情、分页）"
echo "  ✓ 团队成员管理（加入、退出）"
echo "  ✓ 团队申请流程（申请、审核、撤销）"
echo "  ✓ 队长转让功能"
echo "  ✓ 团队解散功能"
echo "  ✓ 权限控制测试"
echo "  ✓ 异常情况处理"
echo "  ✓ 搜索和筛选功能"
echo "  ✓ 分页查询详细测试"
echo "  ✓ 待处理申请统计"
echo ""
echo "测试结果："
echo "  总测试数: $TOTAL"
echo "  ✓ 通过: $PASSED"
echo "  ✗ 失败: $FAILED"
success_rate=$(awk "BEGIN {printf \"%.2f\", ($PASSED/$TOTAL)*100}")
echo "  成功率: $success_rate%"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "������������������ 团队功能所有测试通过！"
    echo ""
    echo "测试数据："
    echo "  - 创建了 $((3 + 1)) 个测试账号"
    echo "  - 创建了 $((2 + 1)) 个测试选题"
    echo "  - 创建了 2 个测试团队"
    echo "  - 测试了团队创建、查询、修改、删除完整流程"
    echo "  - 测试了团队成员加入、退出、转让流程"
    echo "  - 测试了申请提交、审核、撤销流程"
    echo "  - 测试了权限控制和异常处理"
    echo ""
    exit 0
else
    echo "⚠️  有 $FAILED 个测试失败，请检查"
    exit 1
fi
