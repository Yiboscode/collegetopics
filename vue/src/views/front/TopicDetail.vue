<template>
  <div class="topic-detail" v-if="topic">
    <!-- 返回按钮 -->
    <div class="back-section">
      <el-button @click="goBack" :icon="ArrowLeft" type="primary" plain>
        返回选题列表
      </el-button>
    </div>

    <!-- 选题信息卡片 -->
    <el-card class="topic-card">
      <template #header>
        <div class="card-header">
          <h2 class="topic-title">{{ topic.title }}</h2>
          <div class="topic-status">
            <el-tag :type="getStatusType(topic.status)" size="large">
              {{ topic.status }}
            </el-tag>
          </div>
        </div>
      </template>

      <el-row :gutter="30">
        <el-col :span="16">
          <!-- 基本信息 -->
          <el-descriptions :column="2" border class="topic-info">
            <el-descriptions-item label="选题分类">
              <el-tag type="primary">{{ topic.category }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="提交时间">
              {{ topic.submitTime }}
            </el-descriptions-item>
            <el-descriptions-item label="学生ID">
              {{ topic.studentId }}
            </el-descriptions-item>
            <el-descriptions-item label="更新时间">
              {{ topic.updateTime }}
            </el-descriptions-item>
            <el-descriptions-item label="关键词">
              {{ topic.keywords }}
            </el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="getStatusType(topic.status)">{{ topic.status }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="选题描述" :span="2">
              <p class="description-text">{{ topic.description }}</p>
            </el-descriptions-item>
            <el-descriptions-item label="项目背景" :span="2">
              <p class="description-text">{{ topic.background }}</p>
            </el-descriptions-item>
            <el-descriptions-item label="项目目标" :span="2">
              <p class="description-text">{{ topic.objectives }}</p>
            </el-descriptions-item>
            <el-descriptions-item label="研究方法" :span="2">
              <p class="description-text">{{ topic.methodology }}</p>
            </el-descriptions-item>
            <el-descriptions-item label="预期成果" :span="2">
              <p class="description-text">{{ topic.expectedResults }}</p>
            </el-descriptions-item>
          </el-descriptions>
        </el-col>

        <el-col :span="8">
          <!-- 评价信息 -->
          <div class="evaluation-section">
            <h3>评价信息</h3>
            <div class="score-display" v-if="averageScore > 0">
              <div class="score-circle">
                <div class="score-number">{{ averageScore }}</div>
                <div class="score-label">平均分</div>
              </div>
            </div>
            
            <!-- 评价列表 -->
            <div class="evaluations-list" v-if="evaluations.length > 0">
              <el-timeline>
                <el-timeline-item
                  v-for="evaluation in evaluations"
                  :key="evaluation.id"
                  :timestamp="evaluation.evaluationTime"
                  placement="top"
                >
                  <el-card>
                    <div class="evaluation-item">
                      <div class="evaluator-info">
                        <strong>评价教师：{{ evaluation.evaluatorName || '教师' + evaluation.evaluatorId }}</strong>
                      </div>
                      <div class="scores">
                        <el-row :gutter="10">
                          <el-col :span="8">
                            <div class="score-item">
                              <span class="score-label">创新性</span>
                              <span class="score-value">{{ evaluation.innovationScore }}/5</span>
                            </div>
                          </el-col>
                          <el-col :span="8">
                            <div class="score-item">
                              <span class="score-label">可行性</span>
                              <span class="score-value">{{ evaluation.feasibilityScore }}/5</span>
                            </div>
                          </el-col>
                          <el-col :span="8">
                            <div class="score-item">
                              <span class="score-label">意义性</span>
                              <span class="score-value">{{ evaluation.significanceScore }}/5</span>
                            </div>
                          </el-col>
                        </el-row>
                      </div>
                      <div class="total-score">
                        总分：{{ evaluation.totalScore }}/15
                      </div>
                      <div class="comments" v-if="evaluation.suggestions">
                        <p><strong>修改建议：</strong></p>
                        <p>{{ evaluation.suggestions }}</p>
                      </div>
                    </div>
                  </el-card>
                </el-timeline-item>
              </el-timeline>
            </div>

            <!-- 暂无评价 -->
            <el-empty v-else description="暂无评价信息" :image-size="100" />
          </div>

          <!-- 操作按钮 -->
          <div class="action-section" v-if="canEvaluate">
            <el-button type="primary" @click="showEvaluationDialog" :icon="Edit">
              提交评价
            </el-button>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 相关推荐 -->
    <el-card class="recommend-card" v-if="recommendTopics.length > 0">
      <template #header>
        <h3>相关推荐</h3>
      </template>
      <el-row :gutter="20">
        <el-col :span="8" v-for="recommendTopic in recommendTopics" :key="recommendTopic.id">
          <el-card class="recommend-item" @click="viewRecommend(recommendTopic)">
            <div class="recommend-title">{{ recommendTopic.title }}</div>
            <div class="recommend-info">
              <span>{{ recommendTopic.category }}</span>
              <span>{{ recommendTopic.status }}</span>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-card>

    <!-- 评价对话框 -->
    <el-dialog
      v-model="evaluationVisible"
      title="选题评价"
      width="60%"
      :before-close="handleEvaluationClose"
    >
      <el-form :model="evaluationForm" :rules="evaluationRules" ref="evaluationFormRef" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="创新性评分" prop="innovationScore">
              <el-rate
                v-model="evaluationForm.innovationScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可行性评分" prop="feasibilityScore">
              <el-rate
                v-model="evaluationForm.feasibilityScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="意义性评分" prop="significanceScore">
              <el-rate
                v-model="evaluationForm.significanceScore"
                :max="5"
                show-score
                score-template="{value}分"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="修改建议" prop="suggestions">
          <el-input
            v-model="evaluationForm.suggestions"
            type="textarea"
            :rows="4"
            placeholder="请输入修改建议..."
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="evaluationVisible = false">取消</el-button>
          <el-button type="primary" @click="submitEvaluation" :loading="loading">
            提交评价
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ArrowLeft, Edit } from '@element-plus/icons-vue'
import request from '@/utils/request'

export default {
  name: 'TopicDetail',
  components: {
    ArrowLeft,
    Edit
  },
  data() {
    return {
      topic: null,
      evaluations: [],
      recommendTopics: [],
      averageScore: 0,
      evaluationVisible: false,
      loading: false,
      canEvaluate: false,
      evaluationForm: {
        innovationScore: 0,
        feasibilityScore: 0,
        significanceScore: 0,
        suggestions: ''
      },
      evaluationRules: {
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
    }
  },
  created() {
    this.loadTopicDetail()
  },
  methods: {
    loadTopicDetail() {
      const topicId = this.$route.params.id
      if (!topicId) {
        this.$message.error('选题ID无效')
        this.goBack()
        return
      }

      // 加载选题详情
      request.get(`/topic/selectById/${topicId}`).then(res => {
        if (res.code === '200') {
          this.topic = res.data
          this.loadEvaluations()
          this.loadRecommendations()
          this.checkCanEvaluate()
        } else {
          this.$message.error(res.msg || '加载选题详情失败')
          this.goBack()
        }
      }).catch(() => {
        this.$message.error('加载选题详情失败')
        this.goBack()
      })
    },
    loadEvaluations() {
      request.get('/topicEvaluation/selectPage', {
        params: {
          topicId: this.topic.id,
          pageNum: 1,
          pageSize: 100
        }
      }).then(res => {
        if (res.code === '200') {
          this.evaluations = res.data.list || []
          this.calculateAverageScore()
        }
      })
    },
    loadRecommendations() {
      request.get('/topic/selectPage', {
        params: {
          category: this.topic.category,
          pageNum: 1,
          pageSize: 3
        }
      }).then(res => {
        if (res.code === '200') {
          this.recommendTopics = (res.data.list || []).filter(item => item.id !== this.topic.id)
        }
      })
    },
    checkCanEvaluate() {
      const user = JSON.parse(localStorage.getItem('xm-user') || '{}')
      if (user.role === 'TEACHER') {
        // 检查当前用户是否已经评价过此选题
        request.get(`/topicEvaluation/myEvaluation/${this.topic.id}`).then(res => {
          if (res.code === '200' && res.data) {
            // 已经评价过，不能再评价
            this.canEvaluate = false
            this.$message.info('您已经对此选题进行过评价')
          } else {
            // 没有评价过，可以评价
            this.canEvaluate = true
          }
        }).catch(() => {
          // 出错时允许评价
          this.canEvaluate = true
        })
      }
    },
    calculateAverageScore() {
      if (this.evaluations.length === 0) {
        this.averageScore = 0
        return
      }
      const total = this.evaluations.reduce((sum, item) => sum + item.totalScore, 0)
      this.averageScore = (total / this.evaluations.length).toFixed(1)
    },
    getStatusType(status) {
      const types = {
        '待评价': 'warning',
        '评价中': 'primary',
        '审核中': 'info',
        '审核通过': 'success',
        '审核不通过': 'danger'
      }
      return types[status] || 'info'
    },
    showEvaluationDialog() {
      this.evaluationVisible = true
    },
    handleEvaluationClose() {
      this.evaluationVisible = false
      this.resetEvaluationForm()
    },
    resetEvaluationForm() {
      this.evaluationForm = {
        innovationScore: 0,
        feasibilityScore: 0,
        significanceScore: 0,
        suggestions: ''
      }
      this.$refs.evaluationFormRef?.clearValidate()
    },
    submitEvaluation() {
      this.$refs.evaluationFormRef.validate((valid) => {
        if (valid) {
          this.loading = true
          const data = {
            ...this.evaluationForm,
            topicId: this.topic.id
          }
          
          request.post('/topicEvaluation/add', data).then(() => {
            this.$message.success('评价提交成功')
            this.evaluationVisible = false
            this.resetEvaluationForm()
            this.loadEvaluations()
            this.canEvaluate = false
          }).finally(() => {
            this.loading = false
          })
        }
      })
    },
    viewRecommend(topic) {
      this.$router.push(`/front/topicDetail/${topic.id}`)
    },
    goBack() {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.topic-detail {
  padding: 20px;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.back-section {
  margin-bottom: 20px;
}

.topic-card {
  margin-bottom: 20px;
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.topic-title {
  margin: 0;
  color: #1f2937;
  font-size: 24px;
  font-weight: 600;
}

.topic-status {
  margin-left: 20px;
}

.topic-info {
  margin-bottom: 20px;
}

.description-text {
  line-height: 1.8;
  color: #374151;
  margin: 0;
  white-space: pre-wrap;
}

.evaluation-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.evaluation-section h3 {
  margin: 0 0 20px 0;
  color: #1f2937;
  font-size: 18px;
}

.score-display {
  text-align: center;
  margin-bottom: 30px;
}

.score-circle {
  display: inline-block;
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.score-number {
  font-size: 24px;
  font-weight: 600;
}

.score-label {
  font-size: 12px;
  margin-top: 5px;
}

.evaluations-list {
  max-height: 400px;
  overflow-y: auto;
}

.evaluation-item {
  padding: 15px;
}

.evaluator-info {
  margin-bottom: 15px;
}

.scores {
  margin-bottom: 15px;
}

.score-item {
  text-align: center;
  padding: 10px;
  background: #f3f4f6;
  border-radius: 6px;
}

.score-item .score-label {
  display: block;
  font-size: 12px;
  color: #6b7280;
  margin-bottom: 5px;
}

.score-item .score-value {
  font-size: 16px;
  font-weight: 600;
  color: #1f2937;
}

.total-score {
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  color: #059669;
  margin-bottom: 15px;
}

.comments p {
  margin: 5px 0;
  line-height: 1.6;
}

.action-section {
  text-align: center;
}

.recommend-card {
  border-radius: 12px;
}

.recommend-card h3 {
  margin: 0;
  color: #1f2937;
  font-size: 18px;
}

.recommend-item {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
}

.recommend-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.recommend-title {
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 8px;
  font-size: 14px;
}

.recommend-info {
  font-size: 12px;
  color: #6b7280;
}

.recommend-info span {
  margin-right: 10px;
}

.dialog-footer {
  text-align: right;
}
</style> 