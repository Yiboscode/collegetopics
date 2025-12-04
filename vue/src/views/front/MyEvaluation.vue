<template>
  <div class="my-evaluation">
    <!-- 页面标题 -->
    <div class="header-section">
      <h2 class="page-title">我的评价记录</h2>
      <p class="page-subtitle">查看我提交的所有评价信息</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.totalEvaluations }}</div>
            <div class="stat-label">评价总数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.averageScore }}</div>
            <div class="stat-label">平均评分</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.thisWeekEvaluations }}</div>
            <div class="stat-label">本周评价</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ stats.thisMonthEvaluations }}</div>
            <div class="stat-label">本月评价</div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 筛选卡片 -->
    <el-card class="filter-card">
      <el-row :gutter="20" align="middle">
        <el-col :span="6">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            @change="handleDateChange"
          />
        </el-col>
        <el-col :span="4">
          <el-select v-model="filterForm.evaluationType" placeholder="评价类型" clearable>
            <el-option label="选题评价" value="topic" />
            <el-option label="创新能力评价" value="innovation" />
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-input
            v-model="filterForm.keyword"
            placeholder="搜索选题标题或学生姓名"
            clearable
            @keyup.enter="loadData"
          >
            <template #suffix>
              <el-icon class="el-input__icon"><Search /></el-icon>
            </template>
          </el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="loadData" :icon="Search">搜索</el-button>
          <el-button @click="resetFilter" :icon="Refresh">重置</el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 内容卡片 -->
    <el-card class="content-card">
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <!-- 选题评价 -->
        <el-tab-pane label="选题评价" name="topic">
          <div class="evaluations-container">
            <el-empty v-if="topicEvaluations.length === 0" description="暂无选题评价记录" />
            <el-timeline v-else>
              <el-timeline-item
                v-for="evaluation in topicEvaluations"
                :key="evaluation.id"
                :timestamp="evaluation.evaluationTime"
                placement="top"
              >
                <el-card class="evaluation-card">
                  <div class="evaluation-header">
                    <h4 class="topic-title">{{ evaluation.topicTitle }}</h4>
                    <el-tag 
                      :type="getStatusType(evaluation.status)" 
                      effect="light"
                    >
                      {{ evaluation.status }}
                    </el-tag>
                  </div>
                  
                  <div class="evaluation-content">
                    <el-row :gutter="20">
                      <el-col :span="12">
                        <div class="score-section">
                          <h5>评分详情</h5>
                          <div class="scores">
                            <div class="score-item">
                              <span class="score-label">创新性：</span>
                              <el-rate
                                :model-value="Number(evaluation.innovationScore) || 0"
                                disabled
                                show-score
                                text-color="#ff9900"
                                score-template="{value}分"
                              />
                            </div>
                            <div class="score-item">
                              <span class="score-label">可行性：</span>
                              <el-rate
                                :model-value="Number(evaluation.feasibilityScore) || 0"
                                disabled
                                show-score
                                text-color="#ff9900"
                                score-template="{value}分"
                              />
                            </div>
                            <div class="score-item">
                              <span class="score-label">意义性：</span>
                              <el-rate
                                :model-value="Number(evaluation.significanceScore) || 0"
                                disabled
                                show-score
                                text-color="#ff9900"
                                score-template="{value}分"
                              />
                            </div>
                          </div>
                          <div class="total-score">
                            总分：<span class="score-value">{{ evaluation.totalScore }}/15</span>
                          </div>
                        </div>
                      </el-col>
                      <el-col :span="12">
                        <div class="info-section">
                          <h5>基本信息</h5>
                          <div class="info-item">
                            <span class="info-label">学生：</span>
                            <span>{{ evaluation.studentName }}</span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">评价人：</span>
                            <span>{{ evaluation.evaluatorName }}</span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">评价时间：</span>
                            <span>{{ evaluation.evaluationTime }}</span>
                          </div>
                        </div>
                      </el-col>
                    </el-row>
                    
                    <div class="comments-section" v-if="evaluation.suggestions">
                      <h5>评价意见</h5>
                      <p class="comments-text">{{ evaluation.suggestions }}</p>
                    </div>
                  </div>

                  <div class="evaluation-actions">
                    <el-button size="small" @click="viewTopicDetail(evaluation.topicId)">
                      查看选题
                    </el-button>
                    <el-button
                      size="small"
                      type="primary"
                      @click="editEvaluation(evaluation)"
                      v-if="canEdit(evaluation)"
                    >
                      修改评价
                    </el-button>
                  </div>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </div>
        </el-tab-pane>

        <!-- 创新能力评价 -->
        <el-tab-pane label="创新能力评价" name="innovation">
          <div class="evaluations-container">
            <el-empty v-if="innovationEvaluations.length === 0" description="暂无创新能力评价记录" />
            <el-timeline v-else>
              <el-timeline-item
                v-for="evaluation in innovationEvaluations"
                :key="evaluation.id"
                :timestamp="evaluation.evaluationTime"
                placement="top"
              >
                <el-card class="evaluation-card">
                  <div class="evaluation-header">
                    <h4 class="topic-title">{{ evaluation.studentName }} - 创新能力评价</h4>
                    <div class="total-score">
                      总分：<span class="score-value">{{ evaluation.totalScore }}/60</span>
                    </div>
                  </div>
                  
                  <div class="evaluation-content">
                    <div class="innovation-scores">
                      <el-row :gutter="15">
                        <el-col :span="6" v-for="(score, index) in getInnovationScores(evaluation)" :key="index">
                          <div class="innovation-score-item">
                            <div class="score-name">{{ score.name }}</div>
                            <div class="score-value">{{ score.value }}/5</div>
                          </div>
                        </el-col>
                      </el-row>
                    </div>
                    
                    <div class="comments-section" v-if="evaluation.comments">
                      <h5>评价意见</h5>
                      <p class="comments-text">{{ evaluation.comments }}</p>
                    </div>
                  </div>

                  <div class="evaluation-actions">
                    <el-button
                      size="small"
                      type="primary"
                      @click="editInnovationEvaluation(evaluation)"
                    >
                      修改评价
                    </el-button>
                  </div>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </div>
        </el-tab-pane>
      </el-tabs>

      <!-- 分页 -->
      <div class="pagination-section" v-if="total > 0">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :small="false"
          :disabled="false"
          :background="true"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { Search, Refresh } from '@element-plus/icons-vue'
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const router = useRouter()

const activeTab = ref('topic')
const dateRange = ref(null)
const filterForm = reactive({
  evaluationType: '',
  keyword: ''
})
const topicEvaluations = ref([])
const innovationEvaluations = ref([])
const stats = reactive({
  totalEvaluations: 0,
  averageScore: 0,
  thisWeekEvaluations: 0,
  thisMonthEvaluations: 0
})
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

onMounted(() => {
  loadData()
  loadStats()
})

const loadData = () => {
  if (activeTab.value === 'topic') {
    loadTopicEvaluations()
  } else {
    loadInnovationEvaluations()
  }
}

const loadTopicEvaluations = () => {
  const params = {
    pageNum: pageNum.value,
    pageSize: pageSize.value
  }
  
  if (dateRange.value && dateRange.value.length === 2) {
    params.startDate = dateRange.value[0]
    params.endDate = dateRange.value[1]
  }
  
  if (filterForm.keyword) {
    params.keyword = filterForm.keyword
  }

  request.get('/topicEvaluation/my', { params }).then(res => {
    if (res.code === '200') {
      const data = res.data || {}
      topicEvaluations.value = data.records || data.list || []
      total.value = data.total || topicEvaluations.value.length
      
      // 更新统计信息
      if (topicEvaluations.value.length > 0) {
        stats.totalEvaluations = topicEvaluations.value.length
        const totalScore = topicEvaluations.value.reduce((sum, item) => sum + (Number(item.totalScore) || 0), 0)
        stats.averageScore = topicEvaluations.value.length > 0 ? (totalScore / topicEvaluations.value.length).toFixed(1) : 0
      }
    } else {
      ElMessage.error(res.msg || '加载选题评价失败')
      topicEvaluations.value = []
      total.value = 0
    }
  }).catch(err => {
    console.error('加载选题评价失败:', err)
    ElMessage.error('加载选题评价失败')
    topicEvaluations.value = []
    total.value = 0
  })
}

const loadInnovationEvaluations = () => {
  const params = {
    pageNum: pageNum.value,
    pageSize: pageSize.value
  }
  
  if (dateRange.value && dateRange.value.length === 2) {
    params.startDate = dateRange.value[0]
    params.endDate = dateRange.value[1]
  }
  
  if (filterForm.keyword) {
    params.keyword = filterForm.keyword
  }

  request.get('/innovationEvaluation/my', { params }).then(res => {
    if (res.code === '200') {
      const data = res.data || {}
      innovationEvaluations.value = data.records || data.list || []
      total.value = data.total || innovationEvaluations.value.length
      
      // 更新统计信息
      if (innovationEvaluations.value.length > 0) {
        stats.totalEvaluations = innovationEvaluations.value.length
        const totalScore = innovationEvaluations.value.reduce((sum, item) => sum + (Number(item.totalScore) || 0), 0)
        stats.averageScore = innovationEvaluations.value.length > 0 ? (totalScore / innovationEvaluations.value.length).toFixed(1) : 0
      }
    } else {
      ElMessage.error(res.msg || '加载创新能力评价失败')
      innovationEvaluations.value = []
      total.value = 0
    }
  }).catch(err => {
    console.error('加载创新能力评价失败:', err)
    ElMessage.error('加载创新能力评价失败')
    innovationEvaluations.value = []
    total.value = 0
  })
}

const loadStats = () => {
  // 统计信息会在数据加载后更新
  stats.totalEvaluations = 0
  stats.averageScore = 0
  stats.thisWeekEvaluations = 0
  stats.thisMonthEvaluations = 0
}

const handleTabChange = (tabName) => {
  activeTab.value = tabName
  pageNum.value = 1
  loadData()
}

const handleDateChange = () => {
  pageNum.value = 1
  loadData()
}

const handleSizeChange = (val) => {
  pageSize.value = val
  loadData()
}

const handleCurrentChange = (val) => {
  pageNum.value = val
  loadData()
}

const resetFilter = () => {
  dateRange.value = null
  filterForm.evaluationType = ''
  filterForm.keyword = ''
  pageNum.value = 1
  loadData()
}

const getStatusType = (status) => {
  const types = {
    '已提交': 'success',
    '评价中': 'warning',
    '已完成': 'success',
    '草稿': 'info'
  }
  return types[status] || 'info'
}

const getInnovationScores = (evaluation) => {
  if (!evaluation) return []
  
  return [
    { name: '求知欲', value: Number(evaluation.knowledgeSeeking) || 0 },
    { name: '加工能力', value: Number(evaluation.processingAbility) || 0 },
    { name: '理解能力', value: Number(evaluation.understandingAbility) || 0 },
    { name: '自学能力', value: Number(evaluation.selfLearningAbility) || 0 },
    { name: '创新欲望', value: Number(evaluation.innovationDesire) || 0 },
    { name: '创新兴趣', value: Number(evaluation.innovationInterest) || 0 },
    { name: '创新动机', value: Number(evaluation.innovationMotivation) || 0 },
    { name: '创新精神', value: Number(evaluation.innovationSpirit) || 0 },
    { name: '合作能力', value: Number(evaluation.cooperationAbility) || 0 },
    { name: '动手能力', value: Number(evaluation.handsOnAbility) || 0 },
    { name: '表达能力', value: Number(evaluation.expressionAbility) || 0 },
    { name: '研究能力', value: Number(evaluation.researchAbility) || 0 }
  ]
}

const canEdit = (evaluation) => {
  // 可以根据业务逻辑判断是否可以编辑
  if (!evaluation.evaluationTime) return false
  
  const evaluationTime = new Date(evaluation.evaluationTime)
  const now = new Date()
  const diffHours = (now - evaluationTime) / (1000 * 60 * 60)
  return diffHours < 24 // 24小时内可以修改
}

const viewTopicDetail = (topicId) => {
  if (topicId) {
    router.push(`/front/topicDetail/${topicId}`)
  }
}

const editEvaluation = (evaluation) => {
  // 编辑评价功能
  ElMessage.info('编辑功能开发中...')
}

const editInnovationEvaluation = (evaluation) => {
  // 编辑创新能力评价功能
  ElMessage.info('编辑功能开发中...')
}
</script>

<style scoped>
.my-evaluation {
  padding: 20px;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.header-section {
  margin-bottom: 30px;
}

.page-title {
  margin: 0 0 8px 0;
  color: #1f2937;
  font-size: 28px;
  font-weight: 600;
}

.page-subtitle {
  margin: 0;
  color: #6b7280;
  font-size: 14px;
}

.stats-section {
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  padding: 25px;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-number {
  font-size: 28px;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 8px;
}

.stat-label {
  color: #6b7280;
  font-size: 14px;
}

.filter-card {
  margin-bottom: 20px;
}

.content-card {
  min-height: 400px;
}

.evaluations-container {
  margin-top: 20px;
}

.evaluation-card {
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.evaluation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e5e7eb;
}

.topic-title {
  margin: 0;
  color: #1f2937;
  font-size: 18px;
  font-weight: 600;
}

.evaluation-content {
  margin-bottom: 20px;
}

.score-section h5,
.info-section h5,
.comments-section h5 {
  margin: 0 0 15px 0;
  color: #374151;
  font-size: 16px;
  font-weight: 600;
}

.scores {
  margin-bottom: 15px;
}

.score-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.score-label {
  width: 80px;
  color: #6b7280;
  font-size: 14px;
}

.total-score {
  text-align: center;
  padding: 15px;
  background-color: #f3f4f6;
  border-radius: 8px;
  font-weight: 600;
  color: #374151;
}

.score-value {
  color: #ef4444;
  font-size: 18px;
}

.info-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.info-label {
  width: 80px;
  color: #6b7280;
  font-size: 14px;
}

.comments-section {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #e5e7eb;
}

.comments-text {
  color: #6b7280;
  line-height: 1.6;
  margin: 0;
  background-color: #f9fafb;
  padding: 15px;
  border-radius: 8px;
}

.innovation-scores {
  margin-bottom: 20px;
}

.innovation-score-item {
  text-align: center;
  padding: 15px;
  background-color: #f9fafb;
  border-radius: 8px;
  margin-bottom: 10px;
}

.score-name {
  color: #6b7280;
  font-size: 12px;
  margin-bottom: 5px;
}

.innovation-score-item .score-value {
  color: #3b82f6;
  font-weight: 600;
  font-size: 16px;
}

.evaluation-actions {
  text-align: right;
  padding-top: 15px;
  border-top: 1px solid #e5e7eb;
}

.pagination-section {
  margin-top: 30px;
  text-align: center;
}
</style> 