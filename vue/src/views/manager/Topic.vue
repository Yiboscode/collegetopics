<template>
  <div>
    <!-- 搜索区域 -->
    <div class="card" style="margin-bottom: 20px">
      <el-input v-model="searchParams.title" prefix-icon="Search" style="width: 240px; margin-right: 10px" placeholder="请输入选题名称查询"></el-input>
      <el-select v-model="searchParams.category" placeholder="请选择分类" style="width: 150px; margin-right: 10px" clearable>
        <el-option v-for="item in categories" :key="item" :label="item" :value="item"></el-option>
      </el-select>
      <el-select v-model="searchParams.status" placeholder="请选择状态" style="width: 150px; margin-right: 10px" clearable>
        <el-option label="待评价" value="待评价"></el-option>
        <el-option label="评价中" value="评价中"></el-option>
        <el-option label="审核中" value="审核中"></el-option>
        <el-option label="审核通过" value="审核通过"></el-option>
        <el-option label="审核不通过" value="审核不通过"></el-option>
      </el-select>
      <el-button type="primary" @click="load">查询</el-button>
      <el-button style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <!-- 操作区域 -->
    <div class="card">
      <div style="margin-bottom: 20px">
        <el-button type="primary" @click="handleAdd">新增</el-button>
        <el-button type="danger" @click="delBatch" :disabled="!ids.length">批量删除</el-button>
      </div>

      <!-- 表格区域 -->
      <el-table :data="tableData" @selection-change="handleSelectionChange" row-key="id">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column label="图片" width="100">
          <template #default="scope">
            <el-image
              v-if="scope.row.imageUrl"
              :src="scope.row.imageUrl"
              style="width: 60px; height: 40px; border-radius: 5px"
              fit="cover"
              :preview-src-list="[scope.row.imageUrl]"
            />
            <span v-else style="color: #999; font-size: 12px">暂无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="选题名称" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="category" label="分类" width="120">
          <template #default="scope">
            <el-tag>{{ scope.row.category }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="submitTime" label="提交时间" width="180"></el-table-column>
        <el-table-column label="操作" width="320" align="center" fixed="right">
          <template #default="scope">
            <el-button type="primary" @click="handleView(scope.row)" size="small">查看</el-button>
            <el-button type="success" @click="handleEdit(scope.row)" size="small">编辑</el-button>
            <el-button type="danger" @click="del(scope.row.id)" size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页区域 -->
      <div style="margin-top: 20px; text-align: center">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 30, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="load"
          @current-change="load"
        />
      </div>
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="formVisible" :title="form.id ? '编辑选题' : '新增选题'" width="70%" @close="resetForm">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="选题名称" prop="title">
              <el-input v-model="form.title" placeholder="请输入选题名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="选题分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择分类" style="width: 100%">
                <el-option v-for="item in categories" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="选题图片">
          <el-upload
            :action="baseUrl + '/files/upload'"
            :headers="{ token: JSON.parse(localStorage.getItem('xm-user') || '{}').token }"
            :before-upload="beforeUpload"
            :on-success="handleFileUploadSuccess"
            :show-file-list="false"
            style="display: inline-block"
          >
            <el-button type="primary">点击上传</el-button>
          </el-upload>
          <div v-if="form.imageUrl" style="margin-top: 10px">
            <el-image
              :src="form.imageUrl"
              style="width: 100px; height: 100px; border-radius: 5px"
              fit="cover"
              :preview-src-list="[form.imageUrl]"
            />
            <div>
              <el-button type="danger" size="small" @click="form.imageUrl = ''" style="margin-top: 5px">删除图片</el-button>
            </div>
          </div>
        </el-form-item>

        <el-form-item label="关键词" prop="keywords">
          <el-input v-model="form.keywords" placeholder="请输入关键词，多个关键词用逗号分隔"></el-input>
        </el-form-item>
        
        <el-form-item label="选题描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入选题描述"></el-input>
        </el-form-item>
        
        <el-form-item label="项目背景" prop="background">
          <el-input v-model="form.background" type="textarea" :rows="4" placeholder="请输入项目背景"></el-input>
        </el-form-item>
        
        <el-form-item label="项目目标" prop="objectives">
          <el-input v-model="form.objectives" type="textarea" :rows="4" placeholder="请输入项目目标"></el-input>
        </el-form-item>
        
        <el-form-item label="研究方法" prop="methodology">
          <el-input v-model="form.methodology" type="textarea" :rows="4" placeholder="请输入研究方法"></el-input>
        </el-form-item>
        
        <el-form-item label="预期成果" prop="expectedResults">
          <el-input v-model="form.expectedResults" type="textarea" :rows="4" placeholder="请输入预期成果"></el-input>
        </el-form-item>
        
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="待评价" value="待评价"></el-option>
            <el-option label="评价中" value="评价中"></el-option>
            <el-option label="审核中" value="审核中"></el-option>
            <el-option label="审核通过" value="审核通过"></el-option>
            <el-option label="审核不通过" value="审核不通过"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="formVisible = false">取消</el-button>
          <el-button type="primary" @click="save">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog v-model="viewVisible" title="选题详情" width="70%">
      <div v-if="currentRow">
        <el-row :gutter="20">
          <el-col :span="16">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="选题名称" :span="2">{{ currentRow.title }}</el-descriptions-item>
              <el-descriptions-item label="分类">
                <el-tag>{{ currentRow.category }}</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="状态">
                <el-tag :type="getStatusType(currentRow.status)">{{ currentRow.status }}</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="关键词" :span="2">{{ currentRow.keywords }}</el-descriptions-item>
              <el-descriptions-item label="提交时间" :span="2">{{ currentRow.submitTime }}</el-descriptions-item>
              <el-descriptions-item label="更新时间" :span="2">{{ currentRow.updateTime }}</el-descriptions-item>
            </el-descriptions>
          </el-col>
          <el-col :span="8" v-if="currentRow.imageUrl">
            <div style="text-align: center">
              <el-image
                :src="currentRow.imageUrl"
                style="width: 200px; height: 150px; border-radius: 8px; border: 1px solid #dcdfe6"
                fit="cover"
                :preview-src-list="[currentRow.imageUrl]"
              />
            </div>
          </el-col>
        </el-row>
        
        <div style="margin-top: 20px">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="选题描述">
              <div style="white-space: pre-wrap; line-height: 1.6">{{ currentRow.description }}</div>
            </el-descriptions-item>
            <el-descriptions-item label="项目背景">
              <div style="white-space: pre-wrap; line-height: 1.6">{{ currentRow.background }}</div>
            </el-descriptions-item>
            <el-descriptions-item label="项目目标">
              <div style="white-space: pre-wrap; line-height: 1.6">{{ currentRow.objectives }}</div>
            </el-descriptions-item>
            <el-descriptions-item label="研究方法">
              <div style="white-space: pre-wrap; line-height: 1.6">{{ currentRow.methodology }}</div>
            </el-descriptions-item>
            <el-descriptions-item label="预期成果">
              <div style="white-space: pre-wrap; line-height: 1.6">{{ currentRow.expectedResults }}</div>
            </el-descriptions-item>
          </el-descriptions>
        </div>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

const baseUrl = import.meta.env.VITE_BASE_URL

// 响应式数据
const searchParams = reactive({
  title: '',
  category: '',
  status: ''
})

const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const ids = ref([])

const formVisible = ref(false)
const viewVisible = ref(false)
const currentRow = ref(null)

const form = reactive({
  id: null,
  title: '',
  category: '',
  keywords: '',
  description: '',
  background: '',
  objectives: '',
  methodology: '',
  expectedResults: '',
  imageUrl: '',
  status: '待评价'
})

const formRef = ref()

const categories = ['科技创新', '社会实践', '文化创意', '环境保护', '商业模式', '公益服务']

const rules = {
  title: [
    { required: true, message: '请输入选题名称', trigger: 'blur' }
  ],
  category: [
    { required: true, message: '请选择分类', trigger: 'change' }
  ]
}

// 生命周期
onMounted(() => {
  load()
})

// 方法
const load = () => {
  // 过滤掉空字符串参数
  const params = {
    pageNum: pageNum.value,
    pageSize: pageSize.value
  }
  
  if (searchParams.title && searchParams.title.trim() !== '') {
    params.title = searchParams.title.trim()
  }
  if (searchParams.category && searchParams.category.trim() !== '') {
    params.category = searchParams.category.trim()
  }
  if (searchParams.status && searchParams.status.trim() !== '') {
    params.status = searchParams.status.trim()
  }

  request.get('/topic/selectPage', { params }).then(res => {
    if (res.code === '200') {
      tableData.value = res.data?.list || []
      total.value = res.data?.total || 0
    }
  }).catch(err => {
    console.error('加载数据失败:', err)
  })
}

const reset = () => {
  searchParams.title = ''
  searchParams.category = ''
  searchParams.status = ''
  pageNum.value = 1
  load()
}

const handleAdd = () => {
  resetForm()
  formVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, row)
  formVisible.value = true
}

const handleView = (row) => {
  currentRow.value = row
  viewVisible.value = true
}

const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      const url = form.id ? '/topic/update' : '/topic/add'
      const method = form.id ? 'put' : 'post'
      
      request[method](url, form).then(res => {
        if (res.code === '200') {
          ElMessage.success('操作成功')
          formVisible.value = false
          load()
        } else {
          ElMessage.error(res.msg || '操作失败')
        }
      })
    }
  })
}

const del = (id) => {
  ElMessageBox.confirm('您确认删除吗？', '确认删除', { type: 'warning' }).then(() => {
    request.delete('/topic/delete/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg || '删除失败')
      }
    })
  }).catch(() => {})
}

const handleSelectionChange = (selection) => {
  ids.value = selection.map(item => item.id)
}

const delBatch = () => {
  if (!ids.value.length) {
    ElMessage.warning('请选择数据')
    return
  }
  ElMessageBox.confirm('您确认批量删除这些数据吗？', '确认删除', { type: 'warning' }).then(() => {
    request.delete('/topic/del/batch', { data: ids.value }).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg || '删除失败')
      }
    })
  }).catch(() => {})
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    title: '',
    category: '',
    keywords: '',
    description: '',
    background: '',
    objectives: '',
    methodology: '',
    expectedResults: '',
    imageUrl: '',
    status: '待评价'
  })
}

const getStatusType = (status) => {
  const types = {
    '待评价': 'warning',
    '评价中': 'primary',
    '审核中': 'info',
    '审核通过': 'success',
    '审核不通过': 'danger'
  }
  return types[status] || 'info'
}

const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt10M = file.size / 1024 / 1024 < 10

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt10M) {
    ElMessage.error('图片大小不能超过 10MB!')
    return false
  }
  return true
}

const handleFileUploadSuccess = (response) => {
  if (response.code === '200') {
    form.imageUrl = response.data
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error('图片上传失败')
  }
}
</script>

<style scoped>
.card {
  background: white;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
}
</style> 