<template>
  <div class="main-content">
    <div>
      <!-- 搜索区域 -->
      <div class="search-card">
        <el-form :model="searchForm" inline>
          <el-form-item label="选题标题">
            <el-input v-model="searchForm.title" placeholder="请输入选题标题" clearable style="width: 200px"></el-input>
          </el-form-item>
          <el-form-item label="选题分类">
            <el-select v-model="searchForm.category" placeholder="请选择分类" clearable style="width: 150px">
              <el-option label="科技创新" value="科技创新"></el-option>
              <el-option label="社会实践" value="社会实践"></el-option>
              <el-option label="文化创意" value="文化创意"></el-option>
              <el-option label="环境保护" value="环境保护"></el-option>
              <el-option label="商业模式" value="商业模式"></el-option>
              <el-option label="公益服务" value="公益服务"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="选题状态">
            <el-select v-model="searchForm.status" placeholder="请选择状态" clearable style="width: 150px">
              <el-option label="待评价" value="待评价"></el-option>
              <el-option label="评价中" value="评价中"></el-option>
              <el-option label="审核中" value="审核中"></el-option>
              <el-option label="审核通过" value="审核通过"></el-option>
              <el-option label="审核不通过" value="审核不通过"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="load">查询</el-button>
            <el-button @click="reset">重置</el-button>
            <el-button type="success" @click="$router.push('/front/topicSubmit')">
              <el-icon><Plus /></el-icon>
              提交选题
            </el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 选题列表 -->
      <div>
        <el-row :gutter="20">
          <el-col :span="8" v-for="item in data" :key="item.id">
            <div class="card" style="margin-bottom: 20px; padding: 20px">
              <!-- 图片显示 -->
              <div v-if="item.imageUrl" style="text-align: center; margin-bottom: 15px">
                <el-image
                  :src="item.imageUrl"
                  style="width: 100%; height: 180px; border-radius: 8px"
                  fit="cover"
                  :preview-src-list="[item.imageUrl]"
                />
              </div>
              
              <!-- 标题和状态 -->
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px">
                <div style="font-size: 18px; font-weight: bold; cursor: pointer" class="line1" @click="viewDetail(item)">
                  {{ item.title }}
                </div>
                <el-tag :type="getStatusType(item.status)" size="small">{{ item.status }}</el-tag>
              </div>
              
              <!-- 描述内容 -->
              <div style="margin-bottom: 15px; line-height: 20px; height: 60px; color: #666" class="line3">
                {{ item.description }}
              </div>
              
              <!-- 查看详情链接 -->
              <div style="font-size: 12px; color: #0066ff; cursor: pointer; margin-bottom: 15px" @click="openDetailDialog(item)">
                查看详情
              </div>
              
              <!-- 信息区域 -->
              <div style="color: #666; font-size: 13px">
                <div style="margin-bottom: 5px">
                  <span>选题分类：</span>
                  <el-tag size="small">{{ item.category }}</el-tag>
                </div>
                <div style="margin-bottom: 5px">关键词：<span style="margin-left: 5px">{{ item.keywords }}</span></div>
                <div style="margin-bottom: 5px">提交时间：<span style="margin-left: 5px">{{ item.submitTime }}</span></div>
                <div style="margin-bottom: 15px">更新时间：<span style="margin-left: 5px">{{ item.updateTime }}</span></div>
                
                <!-- 操作按钮 -->
                <div style="text-align: center">
                  <el-button type="primary" size="small" @click="viewDetail(item)">详情</el-button>
                  <el-button 
                    v-if="item.status === '待评价' || item.status === '审核不通过'" 
                    type="warning" 
                    size="small"
                    @click="editTopic(item)">
                    修改
                  </el-button>
                  <el-button 
                    v-if="item.status === '待评价'" 
                    type="danger" 
                    size="small"
                    @click="deleteTopic(item)">
                    删除
                  </el-button>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div style="text-align: center; margin-top: 20px">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[6, 12, 18, 24]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>

      <!-- 详情弹窗 -->
      <el-dialog title="选题详情" v-model="dialogVisible" width="70%" :close-on-click-modal="false">
        <div v-if="currentTopic" style="padding: 20px">
          <el-row :gutter="20">
            <el-col :span="16">
              <el-descriptions :column="2" border>
                <el-descriptions-item label="选题名称" :span="2">{{ currentTopic.title }}</el-descriptions-item>
                <el-descriptions-item label="分类">
                  <el-tag>{{ currentTopic.category }}</el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="状态">
                  <el-tag :type="getStatusType(currentTopic.status)">{{ currentTopic.status }}</el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="关键词" :span="2">{{ currentTopic.keywords }}</el-descriptions-item>
                <el-descriptions-item label="提交时间" :span="2">{{ currentTopic.submitTime }}</el-descriptions-item>
                <el-descriptions-item label="更新时间" :span="2">{{ currentTopic.updateTime }}</el-descriptions-item>
              </el-descriptions>
            </el-col>
            <el-col :span="8" v-if="currentTopic.imageUrl">
              <div style="text-align: center">
                <el-image
                  :src="currentTopic.imageUrl"
                  style="width: 200px; height: 150px; border-radius: 8px; border: 1px solid #dcdfe6"
                  fit="cover"
                  :preview-src-list="[currentTopic.imageUrl]"
                />
              </div>
            </el-col>
          </el-row>
          
          <div style="margin-top: 20px">
            <el-descriptions :column="1" border>
              <el-descriptions-item label="选题描述">
                <div style="white-space: pre-wrap; line-height: 1.6">{{ currentTopic.description }}</div>
              </el-descriptions-item>
              <el-descriptions-item label="项目背景" v-if="currentTopic.background">
                <div style="white-space: pre-wrap; line-height: 1.6">{{ currentTopic.background }}</div>
              </el-descriptions-item>
              <el-descriptions-item label="项目目标" v-if="currentTopic.objectives">
                <div style="white-space: pre-wrap; line-height: 1.6">{{ currentTopic.objectives }}</div>
              </el-descriptions-item>
              <el-descriptions-item label="研究方法" v-if="currentTopic.methodology">
                <div style="white-space: pre-wrap; line-height: 1.6">{{ currentTopic.methodology }}</div>
              </el-descriptions-item>
              <el-descriptions-item label="预期成果" v-if="currentTopic.expectedResults">
                <div style="white-space: pre-wrap; line-height: 1.6">{{ currentTopic.expectedResults }}</div>
              </el-descriptions-item>
            </el-descriptions>
          </div>
        </div>
        <template #footer>
          <el-button @click="dialogVisible = false">关闭</el-button>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import request from '@/utils/request'

const router = useRouter()
const data = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(6)

const searchForm = reactive({
  title: '',
  category: '',
  status: ''
})

const dialogVisible = ref(false)
const currentTopic = ref(null)

onMounted(() => {
  load()
})

const load = () => {
  request.get('/topic/my', {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      ...searchForm
    }
  }).then(res => {
    if (res.code === '200') {
      data.value = res.data.list || res.data.records || []
      total.value = res.data.total || 0
    }
  })
}

const reset = () => {
  Object.keys(searchForm).forEach(key => {
    searchForm[key] = ''
  })
  pageNum.value = 1
  load()
}

const handleSizeChange = (val) => {
  pageSize.value = val
  pageNum.value = 1
  load()
}

const handleCurrentChange = (val) => {
  pageNum.value = val
  load()
}

const getStatusType = (status) => {
  const statusMap = {
    '待评价': 'warning',
    '评价中': 'primary',
    '审核中': 'info',
    '审核通过': 'success',
    '审核不通过': 'danger'
  }
  return statusMap[status] || 'info'
}

const openDetailDialog = (item) => {
  currentTopic.value = item
  dialogVisible.value = true
}

const viewDetail = (item) => {
  router.push(`/front/topicDetail/${item.id}`)
}

const editTopic = (item) => {
  router.push({
    path: '/front/topicSubmit',
    query: { id: item.id }
  })
}

const deleteTopic = (item) => {
  ElMessageBox.confirm('确定要删除这个选题吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request.delete(`/topic/delete/${item.id}`).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  })
}
</script>

<style scoped>
.main-content {
  padding: 20px;
}

.search-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease-in-out;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
}

.line1 {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.line3 {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}
</style> 