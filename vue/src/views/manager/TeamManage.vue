<template>
  <div class="team-manage">
    <!-- 页面标题 -->
    <div class="header">
      <h2>团队管理</h2>
      <p>管理系统中的所有团队信息</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-number">{{ teamStats.totalTeams }}</div>
          <div class="stat-label">总团队数</div>
        </div>
        <div class="stat-icon">
          <el-icon size="40"><UserFilled /></el-icon>
        </div>
      </el-card>
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-number">{{ teamStats.totalMembers }}</div>
          <div class="stat-label">总成员数</div>
        </div>
        <div class="stat-icon">
          <el-icon size="40"><Avatar /></el-icon>
        </div>
      </el-card>
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-number">{{ teamStats.pendingApplications }}</div>
          <div class="stat-label">待处理申请</div>
        </div>
        <div class="stat-icon">
          <el-icon size="40"><Bell /></el-icon>
        </div>
      </el-card>
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-number">{{ teamStats.fullTeams }}</div>
          <div class="stat-label">满员团队</div>
        </div>
        <div class="stat-icon">
          <el-icon size="40"><Check /></el-icon>
        </div>
      </el-card>
    </div>

    <!-- 搜索和操作栏 -->
    <div class="toolbar">
      <div class="search-section">
        <el-input 
          v-model="searchForm.teamName" 
          placeholder="搜索团队名称"
          style="width: 300px;"
          @keyup.enter="loadTeamList">
          <template #prepend>团队名称</template>
        </el-input>
        <el-button type="primary" @click="loadTeamList" icon="Search">搜索</el-button>
        <el-button @click="resetSearch" icon="Refresh">重置</el-button>
      </div>
      <div class="action-section">
        <el-button type="success" @click="exportTeamData" icon="Download">导出数据</el-button>
        <el-button type="info" @click="refreshData" icon="Refresh">刷新</el-button>
      </div>
    </div>

    <!-- 团队列表表格 -->
    <el-table :data="teamList" style="width: 100%" v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" align="center" />
      <el-table-column prop="teamName" label="团队名称" min-width="150">
        <template #default="scope">
          <el-button type="link" @click="showTeamDetail(scope.row)">
            {{ scope.row.teamName }}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column prop="topicTitle" label="选题" min-width="200" show-overflow-tooltip />
      <el-table-column prop="leaderName" label="队长" width="120" />
      <el-table-column label="成员数量" width="100" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.memberCount >= 7 ? 'success' : 'warning'">
            {{ scope.row.memberCount || 0 }}/7
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.memberCount >= 7 ? 'info' : 'success'">
            {{ scope.row.memberCount >= 7 ? '已满员' : '招募中' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="160" />
      <el-table-column label="操作" width="200" align="center" fixed="right">
        <template #default="scope">
          <el-button type="primary" size="small" @click="showTeamDetail(scope.row)">详情</el-button>
          <el-button type="warning" size="small" @click="manageMembers(scope.row)">成员</el-button>
          <el-button type="danger" size="small" @click="deleteTeam(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 团队详情对话框 -->
    <el-dialog v-model="showDetailDialog" title="团队详情" width="800px">
      <div v-if="selectedTeam" class="team-detail">
        <div class="detail-grid">
          <div class="detail-item">
            <label>团队名称：</label>
            <span>{{ selectedTeam.teamName }}</span>
          </div>
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
            <label>状态：</label>
            <el-tag :type="selectedTeam.memberCount >= 7 ? 'info' : 'success'">
              {{ selectedTeam.memberCount >= 7 ? '已满员' : '招募中' }}
            </el-tag>
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
            <div v-for="member in teamMembers" :key="member.id" class="member-card">
              <el-avatar :src="member.avatar" :size="50">
                {{ member.studentName?.charAt(0) }}
              </el-avatar>
              <div class="member-info">
                <div class="member-name">{{ member.studentName }}</div>
                <div class="member-role">
                  <el-tag :type="member.role === '队长' ? 'warning' : 'info'" size="small">
                    {{ member.role }}
                  </el-tag>
                </div>
                <div class="member-time">加入时间：{{ member.joinTime }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 申请记录 -->
        <div class="applications-section">
          <h4>申请记录</h4>
          <el-table :data="teamApplications" size="small">
            <el-table-column prop="applicantName" label="申请人" width="100" />
            <el-table-column prop="message" label="申请留言" show-overflow-tooltip />
            <el-table-column prop="applyTime" label="申请时间" width="160" />
            <el-table-column prop="status" label="状态" width="100" align="center">
              <template #default="scope">
                <el-tag :type="getStatusType(scope.row.status)" size="small">
                  {{ getStatusText(scope.row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="handleTime" label="处理时间" width="160" />
          </el-table>
        </div>
      </div>
    </el-dialog>

    <!-- 成员管理对话框 -->
    <el-dialog v-model="showMembersDialog" title="成员管理" width="600px">
      <div v-if="selectedTeam">
        <div class="members-header">
          <h4>{{ selectedTeam.teamName }} - 成员管理</h4>
          <el-button type="primary" size="small" @click="loadTeamMembers(selectedTeam.id)">刷新</el-button>
        </div>
        
        <el-table :data="teamMembers" size="small">
          <el-table-column label="头像" width="80" align="center">
            <template #default="scope">
              <el-avatar :src="scope.row.avatar" :size="40">
                {{ scope.row.studentName?.charAt(0) }}
              </el-avatar>
            </template>
          </el-table-column>
          <el-table-column prop="studentName" label="姓名" />
          <el-table-column prop="role" label="角色" width="100" align="center">
            <template #default="scope">
              <el-tag :type="scope.row.role === '队长' ? 'warning' : 'info'" size="small">
                {{ scope.row.role }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="joinTime" label="加入时间" width="160" />
          <el-table-column label="操作" width="120" align="center">
            <template #default="scope">
              <el-button 
                v-if="scope.row.role !== '队长'" 
                type="danger" 
                size="small" 
                @click="removeMember(scope.row)">
                移除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/utils/request'
import { ElMessage, ElMessageBox } from 'element-plus'
import { UserFilled, Avatar, Bell, Check } from '@element-plus/icons-vue'

export default {
  name: 'TeamManage',
  components: {
    UserFilled,
    Avatar,
    Bell,
    Check
  },
  data() {
    return {
      loading: false,
      // 团队列表
      teamList: [],
      // 搜索表单
      searchForm: {
        teamName: ''
      },
      // 分页
      pagination: {
        page: 1,
        size: 10,
        total: 0
      },
      // 统计数据
      teamStats: {
        totalTeams: 0,
        totalMembers: 0,
        pendingApplications: 0,
        fullTeams: 0
      },
      // 对话框
      showDetailDialog: false,
      showMembersDialog: false,
      selectedTeam: null,
      teamMembers: [],
      teamApplications: []
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    // 加载数据
    async loadData() {
      await this.loadTeamList()
      await this.loadStats()
    },
    // 加载团队列表
    async loadTeamList() {
      this.loading = true
      try {
        const res = await request.get('/team/selectAll', {
          params: { teamName: this.searchForm.teamName }
        })
        this.teamList = res.data || []
        this.pagination.total = this.teamList.length
      } catch (error) {
        console.error('加载团队列表失败:', error)
        ElMessage.error('加载团队列表失败')
      } finally {
        this.loading = false
      }
    },
    // 加载统计数据
    async loadStats() {
      try {
        // 计算统计数据
        const totalTeams = this.teamList.length
        let totalMembers = 0
        let fullTeams = 0
        
        for (const team of this.teamList) {
          const memberCount = team.memberCount || 0
          totalMembers += memberCount
          if (memberCount >= 7) {
            fullTeams++
          }
        }

        // 获取待处理申请数量
        const appRes = await request.get('/teamApplication/selectAll', {
          params: { status: 'pending' }
        })
        const pendingApplications = appRes.data?.length || 0

        this.teamStats = {
          totalTeams,
          totalMembers,
          pendingApplications,
          fullTeams
        }
      } catch (error) {
        console.error('加载统计数据失败:', error)
      }
    },
    // 显示团队详情
    async showTeamDetail(team) {
      this.selectedTeam = team
      await Promise.all([
        this.loadTeamMembers(team.id),
        this.loadTeamApplications(team.id)
      ])
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
    // 加载团队申请
    async loadTeamApplications(teamId) {
      try {
        const res = await request.get(`/teamApplication/selectByTeamId/${teamId}`)
        this.teamApplications = res.data || []
      } catch (error) {
        console.error('加载团队申请失败:', error)
      }
    },
    // 成员管理
    async manageMembers(team) {
      this.selectedTeam = team
      await this.loadTeamMembers(team.id)
      this.showMembersDialog = true
    },
    // 移除成员
    async removeMember(member) {
      try {
        await ElMessageBox.confirm(`确定要移除成员 ${member.studentName} 吗？`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        await request.delete(`/teamMember/delete/${member.id}`)
        ElMessage.success('移除成员成功')
        await this.loadTeamMembers(this.selectedTeam.id)
        await this.loadTeamList()
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.error(error.message || '移除成员失败')
        }
      }
    },
    // 删除团队
    async deleteTeam(team) {
      try {
        await ElMessageBox.confirm(`确定要删除团队 ${team.teamName} 吗？此操作不可恢复！`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        await request.delete(`/team/delete/${team.id}`)
        ElMessage.success('删除团队成功')
        await this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.error(error.message || '删除团队失败')
        }
      }
    },
    // 重置搜索
    resetSearch() {
      this.searchForm.teamName = ''
      this.loadTeamList()
    },
    // 刷新数据
    refreshData() {
      this.loadData()
    },
    // 导出数据
    exportTeamData() {
      ElMessage.info('导出功能开发中...')
    },
    // 分页处理
    handleSizeChange(val) {
      this.pagination.size = val
      this.loadTeamList()
    },
    handleCurrentChange(val) {
      this.pagination.page = val
      this.loadTeamList()
    },
    // 工具方法
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
    }
  }
}
</script>

<style scoped>
.team-manage {
  padding: 20px;
}

.header {
  margin-bottom: 30px;
}

.header h2 {
  color: #2c3e50;
  margin-bottom: 10px;
}

.header p {
  color: #7f8c8d;
  margin: 0;
}

/* 统计卡片 */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  border-radius: 12px;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.stat-card .el-card__body {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 2.5em;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 5px;
}

.stat-label {
  color: #7f8c8d;
  font-size: 14px;
}

.stat-icon {
  color: #409eff;
  opacity: 0.8;
}

/* 工具栏 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
}

.search-section {
  display: flex;
  gap: 10px;
  align-items: center;
}

.action-section {
  display: flex;
  gap: 10px;
}

/* 分页 */
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 团队详情 */
.team-detail .detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 15px;
  margin-bottom: 30px;
}

.detail-item {
  display: flex;
  align-items: center;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 6px;
}

.detail-item label {
  width: 100px;
  font-weight: bold;
  color: #606266;
}

.members-section, .applications-section {
  margin-top: 30px;
}

.members-section h4, .applications-section h4 {
  color: #2c3e50;
  margin-bottom: 15px;
  border-left: 4px solid #409eff;
  padding-left: 10px;
}

.members-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 15px;
}

.member-card {
  display: flex;
  align-items: center;
  padding: 15px;
  background: #f8f9fa;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.member-info {
  margin-left: 15px;
  flex: 1;
}

.member-name {
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 5px;
}

.member-time {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

/* 成员管理 */
.members-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.members-header h4 {
  margin: 0;
  color: #2c3e50;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .toolbar {
    flex-direction: column;
    gap: 15px;
  }
  
  .search-section {
    width: 100%;
    flex-wrap: wrap;
  }
  
  .stats-cards {
    grid-template-columns: 1fr;
  }
  
  .team-detail .detail-grid {
    grid-template-columns: 1fr;
  }
  
  .members-list {
    grid-template-columns: 1fr;
  }
}
</style> 