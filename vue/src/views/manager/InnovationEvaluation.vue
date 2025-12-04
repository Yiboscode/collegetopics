<template>
  <div class="innovation-evaluation-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <el-icon class="title-icon"><TrendCharts /></el-icon>
          创新能力评价管理
        </h2>
        <p class="page-description">对学生创新能力进行多维度评价，支持雷达图可视化分析</p>
      </div>
    </div>

    <!-- 操作区域 -->
    <div class="action-section">
      <el-card class="action-card" shadow="hover">
        <div class="search-area">
          <div class="search-input-group">
            <el-input 
              v-model="data.studentName" 
              prefix-icon="Search" 
              placeholder="请输入学生姓名进行搜索..." 
              clearable
              class="search-input"
            />
            <el-button type="primary" @click="load" class="search-btn">
              <el-icon><Search /></el-icon>
              查询
            </el-button>
            <el-button @click="reset" class="reset-btn">
              <el-icon><RefreshRight /></el-icon>
              重置
            </el-button>
          </div>
        </div>
        
        <el-divider />
        
        <div class="operation-area">
          <div class="btn-group">
            <el-button type="primary" @click="handleAdd" class="primary-btn">
              <el-icon><Plus /></el-icon>
              新增评价
            </el-button>
            <el-button type="danger" @click="delBatch" class="danger-btn" :disabled="!data.ids.length">
              <el-icon><Delete /></el-icon>
              批量删除
            </el-button>
          </div>
          <div class="stats-info">
            <el-tag type="info" size="large">共 {{ data.total }} 条评价记录</el-tag>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 表格区域 -->
    <div class="table-section">
      <el-card shadow="hover" class="table-card">
        <template #header>
          <div class="table-header">
            <span class="table-title">
              <el-icon><List /></el-icon>
              评价记录列表
            </span>
          </div>
        </template>
        
        <el-table 
          :data="data.tableData" 
          @selection-change="handleSelectionChange"
          stripe
          class="evaluation-table"
          :header-cell-style="{ background: '#f8f9fa', color: '#495057', fontWeight: 'bold' }"
        >
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column prop="id" label="ID" width="80" align="center" />
          <el-table-column prop="studentName" label="学生姓名" width="120" align="center">
            <template v-slot="scope">
              <div class="student-info">
                <el-avatar :size="30" class="student-avatar">
                  {{ scope.row.studentName?.charAt(0) }}
                </el-avatar>
                <span class="student-name">{{ scope.row.studentName }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="evaluatorName" label="评价教师" width="120" align="center">
            <template v-slot="scope">
              <el-tag type="info" size="small">{{ scope.row.evaluatorName }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="totalScore" label="总分" width="120" align="center">
            <template v-slot="scope">
              <div class="score-display">
                <el-tag :type="getScoreType(scope.row.totalScore)" size="large" class="score-tag">
                  {{ scope.row.totalScore }} 分
                </el-tag>
                <el-progress 
                  :percentage="Math.round((scope.row.totalScore / 60) * 100)" 
                  :color="getProgressColor(scope.row.totalScore)"
                  :stroke-width="4"
                  class="score-progress"
                />
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="evaluationTime" label="评价时间" width="180" align="center">
            <template v-slot="scope">
              <div class="time-info">
                <el-icon class="time-icon"><Clock /></el-icon>
                <span>{{ scope.row.evaluationTime }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200" fixed="right" align="center">
            <template v-slot="scope">
              <div class="action-buttons">
                <el-tooltip content="查看雷达图" placement="top">
                  <el-button type="success" circle @click="showRadarChart(scope.row)" class="action-btn radar-btn">
                    <el-icon><TrendCharts /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="编辑评价" placement="top">
                  <el-button type="primary" circle @click="handleEdit(scope.row)" class="action-btn edit-btn">
                    <el-icon><Edit /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="删除评价" placement="top">
                  <el-button type="danger" circle @click="del(scope.row.id)" class="action-btn delete-btn">
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </el-tooltip>
              </div>
            </template>
          </el-table-column>
        </el-table>
        
        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="data.total">
          <el-pagination
            @current-change="load"
            background
            layout="total, prev, pager, next, jumper"
            :page-size="data.pageSize"
            v-model:current-page="data.pageNum"
            :total="data.total"
            class="custom-pagination"
          />
        </div>
      </el-card>
    </div>

    <!-- 创新能力评价表单对话框 -->
    <el-dialog 
      v-model="data.formVisible" 
      width="800px" 
      destroy-on-close
      class="evaluation-dialog"
      align-center
    >
      <template #header>
        <div class="dialog-header">
          <el-icon class="dialog-icon"><DocumentAdd /></el-icon>
          <span class="dialog-title">{{ data.form.id ? '编辑' : '新增' }}创新能力评价</span>
        </div>
      </template>
      
      <div class="dialog-content">
        <el-form ref="form" :model="data.form" label-width="120px" class="evaluation-form">
          <div class="student-select-section">
            <el-form-item prop="studentId" label="选择学生" required>
              <el-select v-model="data.form.studentId" placeholder="请选择要评价的学生" style="width: 100%" size="large">
                <el-option v-for="student in students" :key="student.id" :label="student.name" :value="student.id">
                  <div class="student-option">
                    <el-avatar :size="24">{{ student.name?.charAt(0) }}</el-avatar>
                    <span class="student-option-name">{{ student.name }}</span>
                  </div>
                </el-option>
              </el-select>
            </el-form-item>
          </div>
          
          <el-divider class="section-divider">
            <el-icon><Star /></el-icon>
            <span class="divider-text">能力评价指标（每项1-5分）</span>
          </el-divider>
          
          <div class="rating-section">
        
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="knowledgeSeeking" label="求知欲" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.knowledgeSeeking" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.knowledgeSeeking || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="processingAbility" label="信息处理能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.processingAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.processingAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
        
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="understandingAbility" label="理解能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.understandingAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.understandingAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="selfLearningAbility" label="自学能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.selfLearningAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.selfLearningAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
            
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="innovationDesire" label="创新欲望" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.innovationDesire" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.innovationDesire || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="innovationInterest" label="创新兴趣" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.innovationInterest" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.innovationInterest || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
            
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="innovationMotivation" label="创新动机" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.innovationMotivation" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.innovationMotivation || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="innovationSpirit" label="创新精神" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.innovationSpirit" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.innovationSpirit || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
            
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="cooperationAbility" label="合作能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.cooperationAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.cooperationAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="handsOnAbility" label="动手能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.handsOnAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.handsOnAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
            
            <el-row :gutter="20" class="rating-row">
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="expressionAbility" label="表达能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.expressionAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.expressionAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="rating-item">
                  <el-form-item prop="researchAbility" label="研究能力" class="rating-form-item">
                    <div class="rating-content">
                      <el-rate v-model="data.form.researchAbility" :max="5" size="large" :colors="['#99A9BF', '#F7BA2A', '#FF9900']"></el-rate>
                      <span class="score-text">{{ data.form.researchAbility || 0 }} 分</span>
                    </div>
                  </el-form-item>
                </div>
              </el-col>
            </el-row>
          </div>
        
          <el-divider class="section-divider">
            <el-icon><ChatLineRound /></el-icon>
            <span class="divider-text">评价说明</span>
          </el-divider>
          
          <div class="comments-section">
            <el-form-item prop="comments" label="评价说明" class="comments-form-item">
              <el-input 
                v-model="data.form.comments" 
                type="textarea" 
                :rows="4" 
                placeholder="请输入对该学生创新能力的详细评价说明..." 
                class="comments-textarea"
              />
            </el-form-item>
          </div>
          
          <div class="total-score-section">
            <el-form-item label="总分" class="total-score-item">
              <div class="total-score-display">
                <el-tag type="success" size="large" class="total-score-tag">
                  <el-icon><Trophy /></el-icon>
                  {{ calculateTotalScore() }} 分
                </el-tag>
                <el-progress 
                  :percentage="Math.round((calculateTotalScore() / 60) * 100)" 
                  :color="getProgressColor(calculateTotalScore())"
                  :stroke-width="8"
                  class="total-score-progress"
                />
              </div>
            </el-form-item>
          </div>
        </el-form>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="data.formVisible = false" size="large" class="cancel-btn">
            <el-icon><Close /></el-icon>
            取 消
          </el-button>
          <el-button type="primary" @click="save" size="large" class="confirm-btn">
            <el-icon><Check /></el-icon>
            确 定
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 雷达图对话框 -->
    <el-dialog 
      v-model="data.radarVisible" 
      width="90%" 
      destroy-on-close 
      @opened="initRadarChart"
      class="radar-dialog"
      align-center
    >
      <template #header>
        <div class="dialog-header">
          <el-icon class="dialog-icon"><TrendCharts /></el-icon>
          <span class="dialog-title">{{ data.currentStudent }}的创新能力雷达图分析</span>
        </div>
      </template>
      
      <div class="radar-content">
        <div class="radar-chart-container">
          <div class="chart-wrapper">
            <div ref="radarChartRef" class="radar-chart"></div>
          </div>
        </div>
        
        <div class="radar-statistics">
          <el-card shadow="hover" class="statistics-card">
            <template #header>
              <div class="statistics-header">
                <el-icon class="statistics-icon"><DataAnalysis /></el-icon>
                <span class="statistics-title">能力分析统计</span>
              </div>
            </template>
            
            <div v-if="data.statistics.count > 0" class="statistics-content">
              <div class="stat-item">
                <div class="stat-label">
                  <el-icon><User /></el-icon>
                  学生姓名
                </div>
                <div class="stat-value">{{ data.currentStudent }}</div>
              </div>
              
              <div class="stat-item">
                <div class="stat-label">
                  <el-icon><Calendar /></el-icon>
                  评价次数
                </div>
                <div class="stat-value">
                  <el-tag type="info">{{ data.statistics.count }} 次</el-tag>
                </div>
              </div>
              
              <div class="stat-item">
                <div class="stat-label">
                  <el-icon><Clock /></el-icon>
                  最新评价时间
                </div>
                <div class="stat-value">{{ data.statistics.latestEvaluation?.evaluationTime }}</div>
              </div>
              
              <div class="stat-item">
                <div class="stat-label">
                  <el-icon><Trophy /></el-icon>
                  最新总分
                </div>
                <div class="stat-value">
                  <el-tag :type="getScoreType(data.statistics.latestEvaluation?.totalScore)" size="large">
                    {{ data.statistics.latestEvaluation?.totalScore }} 分
                  </el-tag>
                </div>
              </div>
              
              <el-divider class="divider">
                <el-icon><Star /></el-icon>
                各项能力平均分
              </el-divider>
              
              <div class="abilities-list">
                <div v-for="(score, ability) in data.statistics.averageScores" :key="ability" class="ability-item">
                  <div class="ability-name">{{ ability }}</div>
                  <div class="ability-score">
                    <el-tag :type="getScoreType(score)" size="small">{{ score }} 分</el-tag>
                    <el-progress 
                      :percentage="(score / 5) * 100" 
                      :color="getProgressColor(score)"
                      :stroke-width="6"
                      class="ability-progress"
                    />
                  </div>
                </div>
              </div>
            </div>
            
            <div v-else class="empty-state">
              <el-empty description="暂无评价数据" image-size="80" />
            </div>
          </el-card>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>

import {reactive, onMounted, nextTick, ref} from "vue";
import request from "@/utils/request.js";
import {ElMessage, ElMessageBox} from "element-plus";
import {Delete, Edit, View} from "@element-plus/icons-vue";
import * as echarts from 'echarts';

const radarChartRef = ref(null)

const data = reactive({
  formVisible: false,
  radarVisible: false,
  form: {},
  tableData: [],
  pageNum: 1,
  pageSize: 10,
  total: 0,
  studentName: null,
  ids: [],
  statistics: {},
  currentStudent: ''
})

const students = reactive([])
let radarChartInstance = null

const load = () => {
  request.get('/innovationEvaluation/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      studentName: data.studentName
    }
  }).then(res => {
    if (res.code === '200') {
      data.tableData = res.data?.list || []
      data.total = res.data?.total
    }
  })
}

const loadStudents = () => {
  request.get('/user/selectAll').then(res => {
    if (res.code === '200') {
      students.splice(0, students.length, ...res.data)
    }
  })
}

const handleAdd = () => {
  data.form = {
    knowledgeSeeking: 0,
    processingAbility: 0,
    understandingAbility: 0,
    selfLearningAbility: 0,
    innovationDesire: 0,
    innovationInterest: 0,
    innovationMotivation: 0,
    innovationSpirit: 0,
    cooperationAbility: 0,
    handsOnAbility: 0,
    expressionAbility: 0,
    researchAbility: 0
  }
  data.formVisible = true
}

const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row))
  data.formVisible = true
}

const calculateTotalScore = () => {
  const scores = [
    data.form.knowledgeSeeking || 0,
    data.form.processingAbility || 0,
    data.form.understandingAbility || 0,
    data.form.selfLearningAbility || 0,
    data.form.innovationDesire || 0,
    data.form.innovationInterest || 0,
    data.form.innovationMotivation || 0,
    data.form.innovationSpirit || 0,
    data.form.cooperationAbility || 0,
    data.form.handsOnAbility || 0,
    data.form.expressionAbility || 0,
    data.form.researchAbility || 0
  ]
  return scores.reduce((sum, score) => sum + score, 0)
}

const add = async () => {
  // 检查是否已经评价过该学生
  try {
    const checkRes = await request.get(`/innovationEvaluation/checkEvaluated/${data.form.studentId}`)
    if (checkRes.code === '200' && checkRes.data) {
      ElMessage.warning('您已经评价过该学生，请勿重复评价')
      return
    }
  } catch (error) {
    console.error('检查评价状态失败:', error)
  }
  
  data.form.totalScore = calculateTotalScore()
  request.post('/innovationEvaluation/add', data.form).then(res => {
    if (res.code === '200') {
      ElMessage.success('操作成功')
      data.formVisible = false
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

const update = () => {
  data.form.totalScore = calculateTotalScore()
  request.put('/innovationEvaluation/update', data.form).then(res => {
    if (res.code === '200') {
      ElMessage.success('操作成功')
      data.formVisible = false
      load()
    }
  })
}

const save = () => {
  data.form.id ? update() : add()
}

const del = (id) => {
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗？', '删除确认', { type: 'warning' }).then(res => {
    request.delete('/innovationEvaluation/delete/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success("删除成功")
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => {
    console.error(err)
  })
}

const delBatch = () => {
  if (!data.ids.length) {
    ElMessage.warning("请选择数据")
    return
  }
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗？', '删除确认', { type: 'warning' }).then(res => {
    request.delete("/innovationEvaluation/delete/batch", {data: data.ids}).then(res => {
      if (res.code === '200') {
        ElMessage.success('操作成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => {
    console.error(err)
  })
}

const handleSelectionChange = (rows) => {
  data.ids = rows.map(v => v.id)
}

const getScoreType = (score) => {
  if (score >= 50) return 'success'
  if (score >= 40) return 'warning'
  return 'danger'
}

const getProgressColor = (score) => {
  if (score >= 50) return '#67c23a'
  if (score >= 40) return '#e6a23c'
  return '#f56c6c'
}

const reset = () => {
  data.studentName = null
  load()
}

const showRadarChart = async (row) => {
  data.currentStudent = row.studentName
  data.radarVisible = true
  
  // 获取学生的创新能力统计数据
  try {
    const res = await request.get(`/innovationEvaluation/student/${row.studentId}/statistics`)
    if (res.code === '200') {
      data.statistics = res.data
    } else {
      ElMessage.error('获取学生统计数据失败')
    }
  } catch (error) {
    console.error('获取学生统计数据失败:', error)
    ElMessage.error('获取学生统计数据失败')
  }
}

const initRadarChart = () => {
  nextTick(() => {
    if (radarChartInstance) {
      radarChartInstance.dispose()
      radarChartInstance = null
    }
    
    if (radarChartRef.value && data.statistics.averageScores) {
      radarChartInstance = echarts.init(radarChartRef.value)
      
      const averageScores = data.statistics.averageScores || {}
      
      const radarData = [
        averageScores['求知能力'] || 0,
        averageScores['处理能力'] || 0,  
        averageScores['理解能力'] || 0,
        averageScores['自学能力'] || 0,
        averageScores['创新欲望'] || 0,
        averageScores['创新兴趣'] || 0,
        averageScores['创新动力'] || 0,
        averageScores['创新精神'] || 0,
        averageScores['合作能力'] || 0,
        averageScores['动手能力'] || 0,
        averageScores['表达能力'] || 0,
        averageScores['研究能力'] || 0
      ]
      
      const option = {
        title: {
          text: `${data.currentStudent}的创新能力雷达图`,
          left: 'center',
          textStyle: {
            fontSize: 16,
            fontWeight: 'bold'
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: function(params) {
            return `${params.name}: ${params.value}`
          }
        },
        radar: {
          indicator: [
            { name: '求知能力', max: 5 },
            { name: '处理能力', max: 5 },
            { name: '理解能力', max: 5 },
            { name: '自学能力', max: 5 },
            { name: '创新欲望', max: 5 },
            { name: '创新兴趣', max: 5 },
            { name: '创新动力', max: 5 },
            { name: '创新精神', max: 5 },
            { name: '合作能力', max: 5 },
            { name: '动手能力', max: 5 },
            { name: '表达能力', max: 5 },
            { name: '研究能力', max: 5 }
          ],
          radius: 120,
          center: ['50%', '55%'],
          splitNumber: 5,
          axisName: {
            fontSize: 12,
            color: '#333'
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(128, 128, 128, 0.2)'
            }
          },
          splitArea: {
            show: false
          }
        },
        series: [{
          name: '创新能力',
          type: 'radar',
          data: [{
            value: radarData,
            name: '平均得分',
            symbol: 'circle',
            symbolSize: 6,
            itemStyle: {
              color: '#409EFF'
            },
            lineStyle: {
              color: '#409EFF',
              width: 2
            },
            areaStyle: {
              color: 'rgba(64, 158, 255, 0.3)'
            }
          }]
        }]
      }
      
      radarChartInstance.setOption(option)
      
      // 监听窗口大小变化
      window.addEventListener('resize', () => {
        if (radarChartInstance) {
          radarChartInstance.resize()
        }
      })
    }
  })
}

onMounted(() => {
  load()
  loadStudents()
})
</script>

<style scoped>
/* 整体容器样式 */
.innovation-evaluation-container {
  padding: 20px;
  min-height: calc(100vh - 120px);
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

/* 页面标题区域 */
.page-header {
  margin-bottom: 30px;
  text-align: center;
}

.header-content {
  background: white;
  padding: 30px;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.18);
}

.page-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin: 0 0 10px 0;
  color: #2c3e50;
  font-size: 28px;
  font-weight: 700;
}

.title-icon {
  font-size: 32px;
  color: #409eff;
}

.page-description {
  color: #666;
  font-size: 16px;
  margin: 0;
  line-height: 1.6;
}

/* 操作区域样式 */
.action-section {
  margin-bottom: 24px;
}

.action-card {
  border-radius: 16px;
  overflow: hidden;
  border: none;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
}

.search-area {
  margin-bottom: 0;
}

.search-input-group {
  display: flex;
  align-items: center;
  gap: 15px;
  flex-wrap: wrap;
}

.search-input {
  flex: 1;
  min-width: 280px;
}

.search-input :deep(.el-input__inner) {
  border-radius: 25px;
  border: 2px solid #e4e7ed;
  transition: all 0.3s ease;
}

.search-input :deep(.el-input__inner:focus) {
  border-color: #409eff;
  box-shadow: 0 0 10px rgba(64, 158, 255, 0.2);
}

.search-btn {
  border-radius: 25px;
  padding: 10px 20px;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
  transition: all 0.3s ease;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(64, 158, 255, 0.4);
}

.reset-btn {
  border-radius: 25px;
  padding: 10px 20px;
  border: 2px solid #ddd;
  transition: all 0.3s ease;
}

.reset-btn:hover {
  border-color: #409eff;
  color: #409eff;
}

.operation-area {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 15px;
}

.btn-group {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.primary-btn, .danger-btn {
  border-radius: 25px;
  padding: 12px 24px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.primary-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.primary-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
}

.danger-btn {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(245, 87, 108, 0.4);
}

.danger-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(245, 87, 108, 0.6);
}

.stats-info {
  color: #666;
  font-size: 14px;
}

/* 表格区域样式 */
.table-section {
  margin-bottom: 24px;
}

.table-card {
  border-radius: 16px;
  overflow: hidden;
  border: none;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
}

.table-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
}

.table-title {
  display: flex;
  align-items: center;
  gap: 8px;
}

.evaluation-table {
  margin-bottom: 20px;
}

.student-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.student-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: bold;
}

.student-name {
  font-weight: 500;
  color: #2c3e50;
}

.score-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.score-tag {
  font-weight: 600;
  padding: 8px 12px;
}

.score-progress {
  width: 80px;
}

.time-info {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
}

.time-icon {
  color: #409eff;
}

.action-buttons {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.action-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.radar-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.4);
}

.edit-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.delete-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.4);
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.custom-pagination {
  background: transparent;
}

/* 对话框样式 */
.evaluation-dialog :deep(.el-dialog),
.radar-dialog :deep(.el-dialog) {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.dialog-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
}

.dialog-icon {
  font-size: 24px;
  color: #409eff;
}

.dialog-title {
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
}

.dialog-content {
  padding: 20px;
  background: #f8f9fa;
  border-radius: 12px;
  margin: 20px 0;
}

/* 表单样式 */
.evaluation-form {
  background: white;
  padding: 24px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.student-select-section {
  margin-bottom: 24px;
  padding: 20px;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  border-radius: 12px;
  color: white;
}

.student-select-section :deep(.el-form-item__label) {
  color: white !important;
  font-weight: 600;
}

.student-option {
  display: flex;
  align-items: center;
  gap: 10px;
}

.student-option-name {
  font-weight: 500;
}

.section-divider {
  margin: 30px 0 20px 0;
}

.divider-text {
  font-weight: 600;
  color: #409eff;
  margin-left: 8px;
}

.rating-section {
  background: white;
  padding: 24px;
  border-radius: 12px;
  border: 2px solid #f0f0f0;
}

.rating-row {
  margin-bottom: 20px;
}

.rating-item {
  background: #f8f9fa;
  padding: 16px;
  border-radius: 10px;
  border: 1px solid #e9ecef;
  transition: all 0.3s ease;
}

.rating-item:hover {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.1);
}

.rating-form-item :deep(.el-form-item__label) {
  font-weight: 600;
  color: #2c3e50;
}

.rating-content {
  display: flex;
  align-items: center;
  gap: 12px;
  justify-content: space-between;
}

.score-text {
  font-weight: 600;
  color: #409eff;
  font-size: 14px;
  min-width: 40px;
}

.comments-section {
  background: white;
  padding: 20px;
  border-radius: 12px;
  border: 2px solid #f0f0f0;
}

.comments-textarea :deep(.el-textarea__inner) {
  border-radius: 8px;
  border: 2px solid #e4e7ed;
  transition: all 0.3s ease;
}

.comments-textarea :deep(.el-textarea__inner:focus) {
  border-color: #409eff;
  box-shadow: 0 0 10px rgba(64, 158, 255, 0.2);
}

.total-score-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
  border-radius: 12px;
  color: white;
  margin-top: 20px;
}

.total-score-section :deep(.el-form-item__label) {
  color: white !important;
  font-weight: 600;
  font-size: 16px;
}

.total-score-display {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.total-score-tag {
  font-size: 16px;
  padding: 12px 20px;
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.3);
  color: white;
}

.total-score-progress {
  width: 100%;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 20px;
  padding-top: 20px;
}

.cancel-btn, .confirm-btn {
  border-radius: 25px;
  padding: 12px 30px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.cancel-btn {
  border: 2px solid #ddd;
}

.cancel-btn:hover {
  border-color: #409eff;
  color: #409eff;
}

.confirm-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.confirm-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
}

/* 雷达图对话框样式 */
.radar-content {
  display: flex;
  gap: 24px;
  min-height: 600px;
}

.radar-chart-container {
  flex: 1;
  background: white;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.chart-wrapper {
  height: 100%;
  position: relative;
}

.radar-chart {
  width: 100%;
  height: 560px;
}

.radar-statistics {
  width: 320px;
  flex-shrink: 0;
}

.statistics-card {
  border-radius: 16px;
  overflow: hidden;
  border: none;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
  height: 100%;
}

.statistics-header {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #2c3e50;
}

.statistics-icon {
  color: #409eff;
  font-size: 18px;
}

.statistics-title {
  font-weight: 600;
  font-size: 16px;
}

.statistics-content {
  padding: 0;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.stat-item:last-child {
  border-bottom: none;
}

.stat-label {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-weight: 500;
}

.stat-value {
  font-weight: 600;
  color: #2c3e50;
}

.divider {
  margin: 20px 0 16px 0;
  color: #409eff;
}

.abilities-list {
  max-height: 300px;
  overflow-y: auto;
}

.ability-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.ability-item:last-child {
  border-bottom: none;
}

.ability-name {
  font-weight: 500;
  color: #2c3e50;
  min-width: 80px;
}

.ability-score {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 6px;
  flex: 1;
}

.ability-progress {
  width: 100px;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .radar-content {
    flex-direction: column;
  }
  
  .radar-statistics {
    width: 100%;
  }
  
  .operation-area {
    flex-direction: column;
    align-items: stretch;
  }
  
  .btn-group {
    justify-content: center;
  }
}

@media (max-width: 768px) {
  .innovation-evaluation-container {
    padding: 15px;
  }
  
  .search-input-group {
    flex-direction: column;
  }
  
  .search-input {
    min-width: 100%;
  }
  
  .action-buttons {
    flex-wrap: wrap;
  }
  
  .page-title {
    font-size: 24px;
  }
  
  .header-content {
    padding: 20px;
  }
}

/* 滚动条美化 */
.abilities-list::-webkit-scrollbar {
  width: 6px;
}

.abilities-list::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.abilities-list::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.abilities-list::-webkit-scrollbar-thumb:hover {
  background: #a1a1a1;
}

/* 动画效果 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.innovation-evaluation-container > * {
  animation: fadeInUp 0.6s ease forwards;
}

.innovation-evaluation-container > *:nth-child(2) {
  animation-delay: 0.1s;
}

.innovation-evaluation-container > *:nth-child(3) {
  animation-delay: 0.2s;
}
</style> 