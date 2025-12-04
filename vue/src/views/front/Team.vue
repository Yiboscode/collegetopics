<template>
  <div class="team-container">
    <!-- 头部标题 -->
    <div class="header">
      <h2>团队管理</h2>
      <p>发现优秀团队，组建你的创业伙伴</p>
    </div>

    <!-- 功能卡片区域 -->
    <div class="function-cards">
      <!-- 我的团队卡片 -->
      <el-card class="team-card my-team-card" v-if="myTeam">
        <template #header>
          <div class="card-header">
            <span>我的团队</span>
            <el-button type="primary" size="small" @click="showTeamDetail(myTeam)">查看详情</el-button>
          </div>
        </template>
        <div class="team-info">
          <div class="team-name">{{ myTeam.teamName }}</div>
          <div class="team-topic">选题：{{ myTeam.topicTitle }}</div>
          <div class="team-stats">
            <span>队长：{{ myTeam.leaderName }}</span>
            <span>成员：{{ myTeam.memberCount || 0 }}/7</span>
          </div>
        </div>
      </el-card>

      <!-- 创建团队卡片 -->
      <el-card class="team-card create-team-card" v-else>
        <template #header>
          <div class="card-header">
            <span>创建团队</span>
          </div>
        </template>
        <div class="create-team-content">
          <p>还没有团队？立即创建属于你的团队吧！</p>
          <el-button type="primary" @click="showCreateDialog = true">创建团队</el-button>
        </div>
      </el-card>

      <!-- 我的申请卡片 -->
      <el-card class="team-card">
        <template #header>
          <div class="card-header">
            <span>我的申请</span>
            <el-button type="link" @click="loadMyApplications">刷新</el-button>
          </div>
        </template>
        <div class="application-list">
          <div v-if="myApplications.length === 0" class="empty-state">
            暂无申请记录
          </div>
          <div v-else>
            <div v-for="app in myApplications.slice(0, 3)" :key="app.id" class="application-item">
              <div class="app-info">
                <span class="team-name">{{ app.teamName }}</span>
                <el-tag :type="getStatusType(app.status)">{{ getStatusText(app.status) }}</el-tag>
              </div>
              <div class="app-time">{{ app.applyTime }}</div>
            </div>
            <el-button v-if="myApplications.length > 3" type="link" @click="showAllApplications">查看全部</el-button>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 团队列表 -->
    <div class="team-list-section">
      <div class="section-header">
        <h3>发现团队</h3>
        <div class="search-bar">
          <el-input 
            v-model="searchForm.teamName" 
            placeholder="搜索团队名称"
            @keyup.enter="loadTeamList"
            style="width: 300px;">
            <template #append>
              <el-button @click="loadTeamList" icon="Search"></el-button>
            </template>
          </el-input>
        </div>
      </div>

      <div class="team-grid">
        <el-card 
          v-for="team in teamList" 
          :key="team.id" 
          class="team-item-card"
          :class="{ 'full-team': team.memberCount >= 7 }"
          @click="showTeamDetail(team)">
          <div class="team-header">
            <h4>{{ team.teamName }}</h4>
            <el-tag v-if="team.memberCount >= 7" type="info">已满员</el-tag>
            <el-tag v-else type="success">招募中</el-tag>
          </div>
          <div class="team-topic">{{ team.topicTitle }}</div>
          <div class="team-footer">
            <div class="team-leader">队长：{{ team.leaderName }}</div>
            <div class="team-count">{{ team.memberCount || 0 }}/7人</div>
          </div>
          <div v-if="!myTeam && team.memberCount < 7" class="apply-btn">
            <el-button 
              type="primary" 
              size="small" 
              @click.stop="showApplyDialogMethod(team)">
              申请加入
            </el-button>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 创建团队对话框 -->
    <el-dialog v-model="showCreateDialog" title="创建团队" width="600px">
      <el-form :model="createForm" :rules="createRules" ref="createFormRef" label-width="80px">
        <el-form-item label="选题" prop="topicId">
          <el-select v-model="createForm.topicId" placeholder="请选择选题" style="width: 100%">
            <el-option 
              v-for="topic in myTopics" 
              :key="topic.id" 
              :label="topic.title" 
              :value="topic.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="团队名称" prop="teamName">
          <el-input v-model="createForm.teamName" placeholder="请输入团队名称"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="createTeam">创建</el-button>
      </template>
    </el-dialog>

    <!-- 申请加入对话框 -->
    <el-dialog v-model="showApplyFormDialog" title="申请加入团队" width="500px">
      <div class="apply-team-info">
        <h4>{{ selectedTeam?.teamName }}</h4>
        <p>选题：{{ selectedTeam?.topicTitle }}</p>
        <p>队长：{{ selectedTeam?.leaderName }}</p>
      </div>
      <el-form :model="applyForm" ref="applyFormRef" label-width="80px">
        <el-form-item label="申请留言" prop="message">
          <el-input 
            v-model="applyForm.message" 
            type="textarea" 
            :rows="4"
            placeholder="请简单介绍一下自己，说明为什么要加入这个团队...">
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showApplyFormDialog = false">取消</el-button>
        <el-button type="primary" @click="submitApplication">提交申请</el-button>
      </template>
    </el-dialog>

    <!-- 团队详情对话框 -->
    <el-dialog v-model="showDetailDialog" title="团队详情" width="700px">
      <div v-if="selectedTeam" class="team-detail">
        <div class="detail-header">
          <h3>{{ selectedTeam.teamName }}</h3>
          <el-tag :type="selectedTeam.memberCount >= 7 ? 'info' : 'success'">
            {{ selectedTeam.memberCount >= 7 ? '已满员' : '招募中' }}
          </el-tag>
        </div>
        <div class="detail-content">
          <div class="detail-item">
            <label>选题：</label>
            <span>{{ selectedTeam.topicTitle }}</span>
          </div>
          <div class="detail-item">
            <label>队长：</label>
            <span>{{ selectedTeam.leaderName }}</span>
          </div>
          <div class="detail-item">
            <label>成员数量：</label>
            <span>{{ selectedTeam.memberCount || 0 }}/7人</span>
          </div>
          <div class="detail-item">
            <label>创建时间：</label>
            <span>{{ selectedTeam.createTime }}</span>
          </div>
        </div>

        <!-- 团队成员列表 -->
        <div class="members-section">
          <h4>团队成员</h4>
          <div class="members-list">
            <div v-for="member in teamMembers" :key="member.id" class="member-item">
              <el-avatar :src="member.avatar" :size="40">
                {{ member.studentName?.charAt(0) }}
              </el-avatar>
              <div class="member-info">
                <div class="member-name">{{ member.studentName }}</div>
                <div class="member-role">{{ member.role }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="detail-actions" v-if="isMyTeam(selectedTeam)">
          <el-button v-if="isTeamLeader(selectedTeam)" type="primary" @click="manageApplications">
            管理申请 <el-badge :value="pendingCount" v-if="pendingCount > 0" />
          </el-button>
          <el-button v-if="!isTeamLeader(selectedTeam)" type="danger" @click="quitTeam">退出团队</el-button>
        </div>
      </div>
    </el-dialog>

    <!-- 申请管理对话框 -->
    <el-dialog v-model="showApplicationsDialog" title="申请管理" width="800px">
      <div class="applications-list">
        <div v-if="teamApplications.length === 0" class="empty-state">
          暂无待处理申请
        </div>
        <div v-else>
          <div v-for="app in teamApplications" :key="app.id" class="application-card">
            <div class="applicant-info">
              <el-avatar :src="app.avatar" :size="50">{{ app.applicantName?.charAt(0) }}</el-avatar>
              <div class="applicant-details">
                <h4>{{ app.applicantName }}</h4>
                <p class="apply-time">申请时间：{{ app.applyTime }}</p>
                <p class="apply-message">{{ app.message || '该用户没有留言' }}</p>
              </div>
            </div>
            <div class="application-actions" v-if="app.status === 'pending'">
              <el-button type="success" @click="handleApplication(app.id, 'approved')">同意</el-button>
              <el-button type="danger" @click="showRejectDialogMethod(app)">拒绝</el-button>
            </div>
            <div v-else class="application-status">
              <el-tag :type="getStatusType(app.status)">{{ getStatusText(app.status) }}</el-tag>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 拒绝申请对话框 -->
    <el-dialog v-model="showRejectFormDialog" title="拒绝申请" width="400px">
      <el-form :model="rejectForm" ref="rejectFormRef">
        <el-form-item label="拒绝原因">
          <el-input v-model="rejectForm.reason" type="textarea" :rows="3" placeholder="请输入拒绝原因..."></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showRejectFormDialog = false">取消</el-button>
        <el-button type="danger" @click="rejectApplication">确认拒绝</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/utils/request'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'Team',
  data() {
    return {
      // 我的团队
      myTeam: null,
      // 团队列表
      teamList: [],
      // 我的申请列表
      myApplications: [],
      // 搜索表单
      searchForm: {
        teamName: ''
      },
      // 创建团队对话框
      showCreateDialog: false,
      createForm: {
        topicId: '',
        teamName: ''
      },
      createRules: {
        topicId: [{ required: true, message: '请选择选题', trigger: 'change' }],
        teamName: [{ required: true, message: '请输入团队名称', trigger: 'blur' }]
      },
      // 申请加入对话框
      showApplyFormDialog: false,
      applyForm: {
        teamId: '',
        message: ''
      },
      // 团队详情对话框
      showDetailDialog: false,
      selectedTeam: null,
      teamMembers: [],
      // 申请管理对话框
      showApplicationsDialog: false,
      teamApplications: [],
      pendingCount: 0,
      // 拒绝申请对话框
      showRejectFormDialog: false,
      rejectForm: {
        applicationId: '',
        reason: ''
      },
      // 我的选题列表（用于创建团队）
      myTopics: []
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    // 加载数据
    async loadData() {
      await this.loadMyTeam()
      await this.loadTeamList()
      await this.loadMyApplications()
      if (this.myTeam) {
        await this.loadPendingApplicationCount()
      }
    },
    // 加载我的团队
    async loadMyTeam() {
      try {
        const res = await request.get('/team/myTeam')
        this.myTeam = res.data
      } catch (error) {
        console.error('加载我的团队失败:', error)
      }
    },
    // 加载团队列表
    async loadTeamList() {
      try {
        const res = await request.get('/team/selectAll', {
          params: { teamName: this.searchForm.teamName }
        })
        this.teamList = res.data || []
      } catch (error) {
        console.error('加载团队列表失败:', error)
      }
    },
    // 加载我的申请
    async loadMyApplications() {
      try {
        const res = await request.get('/teamApplication/myApplications')
        this.myApplications = res.data || []
      } catch (error) {
        console.error('加载我的申请失败:', error)
      }
    },
    // 加载我的选题（用于创建团队）
    async loadMyTopics() {
      try {
        // 获取当前用户的选题
        const res = await request.get('/topic/selectAll')
        // 过滤出当前用户的选题且没有团队的
        const currentUser = JSON.parse(localStorage.getItem('xm-user') || '{}')
        this.myTopics = res.data?.filter(topic => 
          topic.studentId === currentUser.id && topic.status === '审核通过'
        ) || []
      } catch (error) {
        console.error('加载我的选题失败:', error)
      }
    },
    // 创建团队
    async createTeam() {
      this.$refs.createFormRef.validate(async (valid) => {
        if (valid) {
          try {
            await request.post('/team/add', this.createForm)
            ElMessage.success('创建团队成功！')
            this.showCreateDialog = false
            this.createForm = { topicId: '', teamName: '' }
            await this.loadData()
          } catch (error) {
            ElMessage.error(error.message || '创建团队失败')
          }
        }
      })
    },
    // 显示申请对话框
    showApplyDialogMethod(team) {
      this.selectedTeam = team
      this.applyForm = { teamId: team.id, message: '' }
      this.showApplyFormDialog = true
    },
    // 提交申请
    async submitApplication() {
      try {
        await request.post('/teamApplication/apply', this.applyForm)
        ElMessage.success('申请提交成功！')
        this.showApplyFormDialog = false
        this.applyForm = { teamId: '', message: '' }
        await this.loadMyApplications()
      } catch (error) {
        ElMessage.error(error.message || '申请失败')
      }
    },
    // 显示团队详情
    async showTeamDetail(team) {
      this.selectedTeam = team
      await this.loadTeamMembers(team.id)
      this.showDetailDialog = true
    },
    // 加载团队成员
    async loadTeamMembers(teamId) {
      try {
        const res = await request.get(`/teamMember/selectByTeamId/${teamId}`)
        this.teamMembers = res.data || []
      } catch (error) {
        console.error('加载团队成员失败:', error)
      }
    },
    // 管理申请
    async manageApplications() {
      await this.loadTeamApplications()
      this.showApplicationsDialog = true
    },
    // 加载团队申请
    async loadTeamApplications() {
      try {
        const res = await request.get(`/teamApplication/selectByTeamId/${this.selectedTeam.id}`)
        this.teamApplications = res.data || []
      } catch (error) {
        console.error('加载团队申请失败:', error)
      }
    },
    // 加载待处理申请数量
    async loadPendingApplicationCount() {
      try {
        const res = await request.get(`/teamApplication/getPendingApplicationCount/${this.myTeam.id}`)
        this.pendingCount = res.data || 0
      } catch (error) {
        console.error('加载待处理申请数量失败:', error)
      }
    },
    // 处理申请
    async handleApplication(applicationId, status) {
      try {
        await request.post('/teamApplication/handle', null, {
          params: { applicationId, status }
        })
        ElMessage.success(status === 'approved' ? '已同意申请' : '已拒绝申请')
        await this.loadTeamApplications()
        await this.loadTeamMembers(this.selectedTeam.id)
        await this.loadPendingApplicationCount()
      } catch (error) {
        ElMessage.error(error.message || '操作失败')
      }
    },
    // 显示拒绝对话框
    showRejectDialogMethod(application) {
      this.rejectForm.applicationId = application.id
      this.rejectForm.reason = ''
      this.showRejectFormDialog = true
    },
    // 拒绝申请
    async rejectApplication() {
      try {
        await request.post('/teamApplication/handle', null, {
          params: { 
            applicationId: this.rejectForm.applicationId, 
            status: 'rejected',
            rejectReason: this.rejectForm.reason
          }
        })
        ElMessage.success('已拒绝申请')
        this.showRejectFormDialog = false
        await this.loadTeamApplications()
        await this.loadPendingApplicationCount()
      } catch (error) {
        ElMessage.error(error.message || '操作失败')
      }
    },
    // 退出团队
    async quitTeam() {
      try {
        await ElMessageBox.confirm('确定要退出团队吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        await request.post(`/team/quit/${this.selectedTeam.id}`)
        ElMessage.success('已退出团队')
        this.showDetailDialog = false
        await this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.error(error.message || '退出团队失败')
        }
      }
    },
    // 工具方法
    isMyTeam(team) {
      return this.myTeam && this.myTeam.id === team.id
    },
    isTeamLeader(team) {
      const currentUser = JSON.parse(localStorage.getItem('xm-user') || '{}')
      return this.myTeam && this.myTeam.leaderId === currentUser.id
    },
    getStatusType(status) {
      const typeMap = {
        'pending': 'warning',
        'approved': 'success',
        'rejected': 'danger'
      }
      return typeMap[status] || 'info'
    },
    getStatusText(status) {
      const textMap = {
        'pending': '待审核',
        'approved': '已同意',
        'rejected': '已拒绝'
      }
      return textMap[status] || status
    },
    // 显示全部申请
    showAllApplications() {
      // 这里可以跳转到一个单独的申请历史页面
      ElMessage.info('功能开发中...')
    }
  },
  watch: {
    showCreateDialog(newVal) {
      if (newVal) {
        this.loadMyTopics()
      }
    }
  }
}
</script>

<style scoped>
.team-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.header h2 {
  color: #2c3e50;
  margin-bottom: 10px;
}

.header p {
  color: #7f8c8d;
  font-size: 16px;
}

/* 功能卡片区域 */
.function-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.team-card {
  border-radius: 12px;
  transition: all 0.3s ease;
}

.team-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
}

.my-team-card {
  border-left: 4px solid #409eff;
}

.create-team-card {
  border-left: 4px solid #67c23a;
}

.team-info .team-name {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 8px;
  color: #2c3e50;
}

.team-info .team-topic {
  color: #606266;
  margin-bottom: 10px;
}

.team-stats {
  display: flex;
  justify-content: space-between;
  color: #909399;
  font-size: 14px;
}

.create-team-content {
  text-align: center;
  padding: 20px;
}

.create-team-content p {
  margin-bottom: 20px;
  color: #606266;
}

.application-list .empty-state {
  text-align: center;
  color: #909399;
  padding: 20px;
}

.application-item {
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.application-item:last-child {
  border-bottom: none;
}

.app-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.app-time {
  font-size: 12px;
  color: #909399;
}

/* 团队列表 */
.team-list-section {
  margin-top: 40px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h3 {
  color: #2c3e50;
  margin: 0;
}

.team-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.team-item-card {
  cursor: pointer;
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
}

.team-item-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.1);
}

.team-item-card.full-team {
  opacity: 0.7;
}

.team-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.team-header h4 {
  margin: 0;
  color: #2c3e50;
}

.team-topic {
  color: #606266;
  margin-bottom: 15px;
  font-size: 14px;
}

.team-footer {
  display: flex;
  justify-content: space-between;
  color: #909399;
  font-size: 14px;
  margin-bottom: 10px;
}

.apply-btn {
  text-align: center;
  margin-top: 10px;
}

/* 对话框样式 */
.apply-team-info {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.apply-team-info h4 {
  margin: 0 0 10px 0;
  color: #2c3e50;
}

.apply-team-info p {
  margin: 5px 0;
  color: #606266;
}

.team-detail .detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.team-detail .detail-header h3 {
  margin: 0;
  color: #2c3e50;
}

.detail-content {
  margin-bottom: 30px;
}

.detail-item {
  display: flex;
  margin-bottom: 10px;
}

.detail-item label {
  width: 100px;
  font-weight: bold;
  color: #606266;
}

.members-section h4 {
  color: #2c3e50;
  margin-bottom: 15px;
}

.members-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.member-item {
  display: flex;
  align-items: center;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 8px;
}

.member-info {
  margin-left: 10px;
}

.member-name {
  font-weight: bold;
  color: #2c3e50;
}

.member-role {
  font-size: 12px;
  color: #909399;
}

.detail-actions {
  margin-top: 20px;
  text-align: center;
}

/* 申请管理 */
.applications-list .empty-state {
  text-align: center;
  color: #909399;
  padding: 40px;
}

.application-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  margin-bottom: 15px;
}

.applicant-info {
  display: flex;
  align-items: center;
  flex: 1;
}

.applicant-details {
  margin-left: 15px;
}

.applicant-details h4 {
  margin: 0 0 5px 0;
  color: #2c3e50;
}

.apply-time {
  margin: 0;
  font-size: 12px;
  color: #909399;
}

.apply-message {
  margin: 5px 0 0 0;
  color: #606266;
}

.application-actions {
  display: flex;
  gap: 10px;
}

.application-status {
  display: flex;
  align-items: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .function-cards {
    grid-template-columns: 1fr;
  }
  
  .team-grid {
    grid-template-columns: 1fr;
  }
  
  .section-header {
    flex-direction: column;
    gap: 15px;
  }
  
  .search-bar {
    width: 100%;
  }
  
  .search-bar .el-input {
    width: 100% !important;
  }
  
  .application-card {
    flex-direction: column;
    gap: 15px;
  }
}
</style> 