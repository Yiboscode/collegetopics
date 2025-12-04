<template>
  <div class="card">
    <div class="card-header">
      <span class="card-title">选题提交</span>
    </div>
    <div class="card-body">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="选题标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入选题标题"></el-input>
        </el-form-item>
        
        <el-form-item label="选题分类" prop="category">
          <el-select v-model="form.category" placeholder="请选择选题分类" style="width: 100%">
            <el-option label="科技创新" value="科技创新"></el-option>
            <el-option label="社会实践" value="社会实践"></el-option>
            <el-option label="文化创意" value="文化创意"></el-option>
            <el-option label="环境保护" value="环境保护"></el-option>
            <el-option label="商业模式" value="商业模式"></el-option>
            <el-option label="公益服务" value="公益服务"></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="选题图片">
          <el-upload
            :action="$baseUrl + '/files/upload'"
            :before-upload="beforeUpload"
            :on-success="handleFileUploadSuccess"
            :show-file-list="false"
            style="display: inline-block"
          >
            <el-button type="primary">点击上传图片</el-button>
          </el-upload>
          <div style="color: #999; font-size: 12px; margin-top: 5px">
            支持 JPG、PNG、GIF 格式，文件大小不超过 10MB
          </div>
          <div v-if="form.imageUrl" style="margin-top: 15px">
            <el-image
              :src="form.imageUrl"
              style="width: 200px; height: 150px; border-radius: 8px; border: 1px solid #dcdfe6"
              fit="cover"
              :preview-src-list="[form.imageUrl]"
            />
            <div style="margin-top: 10px">
              <el-button type="danger" size="small" @click="form.imageUrl = ''">删除图片</el-button>
            </div>
          </div>
        </el-form-item>
        
        <el-form-item label="关键词" prop="keywords">
          <el-input v-model="form.keywords" placeholder="请输入关键词，用逗号分隔"></el-input>
        </el-form-item>
        
        <el-form-item label="选题描述" prop="description">
          <el-input 
            v-model="form.description" 
            type="textarea" 
            :rows="4" 
            placeholder="请简要描述您的选题">
          </el-input>
        </el-form-item>
        
        <el-form-item label="项目背景" prop="background">
          <el-input 
            v-model="form.background" 
            type="textarea" 
            :rows="5" 
            placeholder="请详细描述项目背景和现状">
          </el-input>
        </el-form-item>
        
        <el-form-item label="项目目标" prop="objectives">
          <el-input 
            v-model="form.objectives" 
            type="textarea" 
            :rows="5" 
            placeholder="请描述项目要达到的目标">
          </el-input>
        </el-form-item>
        
        <el-form-item label="研究方法" prop="methodology">
          <el-input 
            v-model="form.methodology" 
            type="textarea" 
            :rows="5" 
            placeholder="请描述研究方法和实施方案">
          </el-input>
        </el-form-item>
        
        <el-form-item label="预期成果" prop="expectedResults">
          <el-input 
            v-model="form.expectedResults" 
            type="textarea" 
            :rows="5" 
            placeholder="请描述预期取得的成果">
          </el-input>
        </el-form-item>
        
        <div style="text-align: center">
          <el-button type="primary" @click="save" :loading="loading">提交选题</el-button>
          <el-button @click="resetForm">重置</el-button>
          <el-button @click="$router.go(-1)">返回</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const router = useRouter()
const formRef = ref()
const loading = ref(false)

const form = reactive({
  title: '',
  category: '',
  keywords: '',
  description: '',
  background: '',
  objectives: '',
  methodology: '',
  expectedResults: '',
  imageUrl: ''
})

const rules = reactive({
  title: [
    { required: true, message: '请输入选题标题', trigger: 'blur' },
    { min: 5, max: 100, message: '选题标题长度在 5 到 100 个字符', trigger: 'blur' }
  ],
  category: [
    { required: true, message: '请选择选题分类', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入选题描述', trigger: 'blur' },
    { min: 20, message: '选题描述至少 20 个字符', trigger: 'blur' }
  ],
  background: [
    { required: true, message: '请输入项目背景', trigger: 'blur' },
    { min: 50, message: '项目背景至少 50 个字符', trigger: 'blur' }
  ],
  objectives: [
    { required: true, message: '请输入项目目标', trigger: 'blur' },
    { min: 30, message: '项目目标至少 30 个字符', trigger: 'blur' }
  ],
  methodology: [
    { required: true, message: '请输入研究方法', trigger: 'blur' },
    { min: 30, message: '研究方法至少 30 个字符', trigger: 'blur' }
  ],
  expectedResults: [
    { required: true, message: '请输入预期成果', trigger: 'blur' },
    { min: 30, message: '预期成果至少 30 个字符', trigger: 'blur' }
  ]
})

const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      loading.value = true
      request.post('/topic/add', form).then(res => {
        if (res.code === '200') {
          ElMessage.success('操作成功')
          router.push('/front/topic')
        } else {
          ElMessage.error(res.msg)
        }
      }).finally(() => {
        loading.value = false
      })
    }
  })
}

const resetForm = () => {
  formRef.value.resetFields()
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
  margin: 20px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.card-header {
  padding: 20px 20px 0;
  border-bottom: 1px solid #f0f0f0;
}

.card-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.card-body {
  padding: 20px;
}
</style> 