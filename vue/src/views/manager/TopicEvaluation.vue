<template>
  <div>
    <!-- 搜索区域 -->
    <div class="card" style="margin-bottom: 5px">
      <el-row :gutter="20">
        <el-col :span="5">
          <el-input v-model="data.topicTitle" clearable placeholder="请输入选题名称" style="width: 100%"></el-input>
        </el-col>
        <el-col :span="5">
          <el-input v-model="data.evaluatorName" clearable placeholder="请输入评价人姓名" style="width: 100%"></el-input>
        </el-col>
        <el-col :span="5">
          <el-select v-model="data.status" clearable placeholder="请选择状态" style="width: 100%">
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="待审核" value="待审核"></el-option>
            <el-option label="已审核" value="已审核"></el-option>
          </el-select>
        </el-col>
        <el-col :span="5">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-col>
        <el-col :span="4">
          <div>
            <el-button type="primary" @click="load">
              <el-icon><Search /></el-icon>
              查询
            </el-button>
            <el-button @click="reset">
              <el-icon><Refresh /></el-icon>
              重置
            </el-button>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 操作区域 -->
    <div class="card" style="margin-bottom: 5px">
      <div style="margin-bottom: 10px">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          新增评价
        </el-button>
        <el-button type="info" @click="handleExport">
          <el-icon><Download /></el-icon>
          导出
        </el-button>
        <el-button type="danger" @click="delBatch" :disabled="!ids.length">
          <el-icon><Delete /></el-icon>
          批量删除
        </el-button>
      </div>

      <!-- 统计卡片 -->
      <el-row :gutter="20" style="margin-bottom: 20px">
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.total }}</div>
            <div class="stat-label">评价总数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.averageScore }}</div>
            <div class="stat-label">平均分</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.todayCount }}</div>
            <div class="stat-label">今日评价</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.weekCount }}</div>
            <div class="stat-label">本周评价</div>
          </div>
        </el-col>
      </el-row>

      <!-- 表格区域 -->
      <el-table :data="tableData" @selection-change="handleSelectionChange" row-key="id">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="topicTitle" label="选题名称" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="studentName" label="学生姓名" width="120"></el-table-column>
        <el-table-column prop="evaluatorName" label="评价人" width="120"></el-table-column>
        <el-table-column label="评分详情" width="200" align="center">
          <template #default="scope">
            <div class="score-details">
              <el-tag size="small" class="score-tag">创新: {{ scope.row.innovationScore }}/5</el-tag>
              <el-tag size="small" class="score-tag">可行: {{ scope.row.feasibilityScore }}/5</el-tag>
              <el-tag size="small" class="score-tag">意义: {{ scope.row.significanceScore }}/5</el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="totalScore" label="总分" width="80" align="center">
          <template #default="scope">
            <el-tag :type="getScoreType(scope.row.totalScore)" size="large">
              {{ scope.row.totalScore }}/15
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="evaluationTime" label="评价时间" width="180"></el-table-column>
        <el-table-column label="操作" width="280" align="center" fixed="right">
          <template #default="scope">
            <el-button type="primary" @click="handleView(scope.row)" size="small">查看</el-button>
            <el-button type="success" @click="handleEdit(scope.row)" size="small">编辑</el-button>
            <el-button type="warning" @click="handleViewTopic(scope.row.topicId)" size="small">选题详情</el-button>
            <el-button type="danger" @click="del(scope.row.id)" size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页区域 -->
      <div style="margin-top: 20px; text-align: center">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[5, 10, 15, 20]"
          :small="false"
          :disabled="false"
          :background="true"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑评价' : '新增评价'" width="60%" :before-close="handleClose">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="选择选题" prop="topicId" v-if="!form.id">
          <el-select v-model="form.topicId" placeholder="请选择选题" style="width: 100%" filterable>
            <el-option
              v-for="topic in topics"
              :key="topic.id"
              :label="topic.title"
              :value="topic.id"
            >
              <span style="float: left">{{ topic.title }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">{{ topic.studentName }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="创新性评分" prop="innovationScore">
              <el-rate
                v-model="form.innovationScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可行性评分" prop="feasibilityScore">
              <el-rate
                v-model="form.feasibilityScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="意义性评分" prop="significanceScore">
              <el-rate
                v-model="form.significanceScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="评价建议" prop="suggestions">
          <el-input
            v-model="form.suggestions"
            type="textarea"
            :rows="4"
            placeholder="请输入评价建议..."
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="待审核" value="待审核"></el-option>
            <el-option label="已审核" value="已审核"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="save">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog v-model="viewVisible" title="评价详情" width="70%">
      <div v-if="currentEvaluation">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="选题名称" :span="2">{{ currentEvaluation.topicTitle }}</el-descriptions-item>
          <el-descriptions-item label="学生姓名">{{ currentEvaluation.studentName }}</el-descriptions-item>
          <el-descriptions-item label="评价人">{{ currentEvaluation.evaluatorName }}</el-descriptions-item>
          <el-descriptions-item label="评价时间" :span="2">{{ currentEvaluation.evaluationTime }}</el-descriptions-item>
          <el-descriptions-item label="创新性评分">
            <el-rate v-model="currentEvaluation.innovationScore" disabled show-score score-template="{value}分" />
          </el-descriptions-item>
          <el-descriptions-item label="可行性评分">
            <el-rate v-model="currentEvaluation.feasibilityScore" disabled show-score score-template="{value}分" />
          </el-descriptions-item>
          <el-descriptions-item label="意义性评分">
            <el-rate v-model="currentEvaluation.significanceScore" disabled show-score score-template="{value}分" />
          </el-descriptions-item>
          <el-descriptions-item label="总分">
            <el-tag :type="getScoreType(currentEvaluation.totalScore)" size="large">
              {{ currentEvaluation.totalScore }}/15
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="状态" :span="2">
            <el-tag :type="getStatusType(currentEvaluation.status)">{{ currentEvaluation.status }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="评价建议" :span="2" v-if="currentEvaluation.suggestions">
            <p style="white-space: pre-wrap; line-height: 1.6; margin: 0;">{{ currentEvaluation.suggestions }}</p>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="viewVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, Plus, Download, Delete } from '@element-plus/icons-vue'
import request from '@/utils/request'

const router = useRouter()

// 响应式数据
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const data = reactive({
  topicTitle: '',
  evaluatorName: '',
  status: ''
})
const dateRange = ref(null)
const form = ref({})
const dialogVisible = ref(false)
const viewVisible = ref(false)
const currentEvaluation = ref(null)
const ids = ref([])
const topics = ref([])
const formRef = ref(null)

const stats = reactive({
  total: 0,
  averageScore: 0,
  todayCount: 0,
  weekCount: 0
})

const rules = {
  topicId: [
    { required: true, message: '请选择选题', trigger: 'change' }
  ],
  innovationScore: [
    { required: true, message: '请选择创新性评分', trigger: 'change' }
  ],
  feasibilityScore: [
    { required: true, message: '请选择可行性评分', trigger: 'change' }
  ],
  significanceScore: [
    { required: true, message: '请选择意义性评分', trigger: 'change' }
  ]
}

// 加载数据
const load = () => {
  const params = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    ...data
  }
  
  if (dateRange.value && dateRange.value.length === 2) {
    params.startDate = dateRange.value[0]
    params.endDate = dateRange.value[1]
  }

  request.get('/topicEvaluation/selectPage', { params }).then(res => {
    if (res.code === '200') {
      // 兼容PageInfo结构和普通list结构
      if (res.data.list) {
        tableData.value = res.data.list
        total.value = res.data.total
      } else if (res.data.records) {
        tableData.value = res.data.records
        total.value = res.data.total
      } else {
        tableData.value = res.data || []
        total.value = tableData.value.length
      }
      calculateStats()
    }
  })
}

// 加载选题列表
const loadTopics = () => {
  request.get('/topic/selectAll').then(res => {
    if (res.code === '200') {
      topics.value = res.data || []
    }
  })
}

// 计算统计数据
const calculateStats = () => {
  stats.total = tableData.value.length
  if (tableData.value.length > 0) {
    const totalScore = tableData.value.reduce((sum, item) => sum + parseFloat(item.totalScore || 0), 0)
    stats.averageScore = (totalScore / tableData.value.length).toFixed(1)
  }
  
  const today = new Date().toDateString()
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
  
  stats.todayCount = tableData.value.filter(item => 
    new Date(item.evaluationTime).toDateString() === today
  ).length
  
  stats.weekCount = tableData.value.filter(item => 
    new Date(item.evaluationTime) >= weekAgo
  ).length
}

// 重置搜索
const reset = () => {
  data.topicTitle = ''
  data.evaluatorName = ''
  data.status = ''
  dateRange.value = null
  load()
}

// 新增
const handleAdd = () => {
  form.value = {
    status: '已完成'
  }
  dialogVisible.value = true
}

// 为特定选题新增评价（检查是否已评价）
const handleAddForTopic = (topicId) => {
  // 先检查当前用户是否已经评价过这个选题
  request.get(`/topicEvaluation/myEvaluation/${topicId}`).then(res => {
    if (res.code === '200' && res.data) {
      // 已经评价过，跳转到编辑模式
      ElMessage.warning('您已经对此选题进行过评价，将为您打开编辑模式')
      form.value = JSON.parse(JSON.stringify(res.data))
      dialogVisible.value = true
    } else {
      // 没有评价过，可以新增
      form.value = {
        topicId: parseInt(topicId),
        status: '已完成'
      }
      dialogVisible.value = true
    }
  }).catch(() => {
    // 出错时也允许新增
    form.value = {
      topicId: parseInt(topicId),
      status: '已完成'
    }
    dialogVisible.value = true
  })
}

// 编辑
const handleEdit = (row) => {
  form.value = JSON.parse(JSON.stringify(row))
  dialogVisible.value = true
}

// 查看详情
const handleView = (row) => {
  currentEvaluation.value = row
  viewVisible.value = true
}

// 查看选题详情
const handleViewTopic = (topicId) => {
  router.push(`/manager/topic?id=${topicId}`)
}

// 导出
const handleExport = () => {
  window.open('/api/topicEvaluation/export')
}

// 保存
const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      const request_method = form.value.id ? request.put : request.post
      const url = form.value.id ? '/topicEvaluation/update' : '/topicEvaluation/add'
      request_method(url, form.value).then(res => {
        if (res.code === '200') {
          ElMessage.success('操作成功')
          load()
          dialogVisible.value = false
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}

// 删除
const del = (id) => {
  ElMessageBox.confirm('您确认删除吗？', '确认删除', { type: 'warning' }).then(() => {
    request.delete('/topicEvaluation/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(() => {})
}

// 批量删除
const delBatch = () => {
  if (!ids.value.length) {
    ElMessage.warning('请选择数据')
    return
  }
  ElMessageBox.confirm('您确认批量删除这些数据吗？', '确认删除', { type: 'warning' }).then(() => {
    request.delete('/topicEvaluation/del/batch', { data: ids.value }).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(() => {})
}

// 选择变化
const handleSelectionChange = (selection) => {
  ids.value = selection.map(v => v.id)
}

// 分页变化
const handleSizeChange = (size) => {
  pageSize.value = size
  load()
}

const handleCurrentChange = (num) => {
  pageNum.value = num
  load()
}

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false
}

// 获取状态类型
const getStatusType = (status) => {
  const types = {
    '已完成': 'success',
    '待审核': 'warning',
    '已审核': 'info'
  }
  return types[status] || 'info'
}

// 获取分数类型
const getScoreType = (score) => {
  if (score >= 12) return 'success'
  if (score >= 9) return 'warning'
  return 'danger'
}

// 检查URL参数
const checkUrlParams = () => {
  const topicId = router.currentRoute.value.query.topicId
  if (topicId) {
    handleAddForTopic(topicId)
  }
}

// 为特定选题新增评价方法已经在上面重新定义

// 组件挂载
onMounted(() => {
  load()
  loadTopics()
  checkUrlParams()
})
</script>

<style scoped>
.card {
  background: white;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.9;
}

.score-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.score-tag {
  font-size: 12px;
}
</style> 