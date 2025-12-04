<template>
  <div>
    <div class="card" style="margin-bottom: 5px;">
      <el-input v-model="data.title" placeholder="请输入选题名称查询" style="width: 240px"></el-input>
      <el-select v-model="data.category" clearable placeholder="请选择分类" style="width: 150px; margin-left: 10px">
        <el-option v-for="item in data.categories" :key="item" :label="item" :value="item"></el-option>
      </el-select>
      <el-select v-model="data.year" clearable placeholder="请选择年份" style="width: 120px; margin-left: 10px">
        <el-option v-for="year in data.years" :key="year" :label="year" :value="year"></el-option>
      </el-select>
      <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-button type="primary" plain @click="handleAdd">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px;">
      <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="title" label="选题名称" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="category" label="分类" width="120">
          <template #default="scope">
            <el-tag :type="getCategoryType(scope.row.category)">{{ scope.row.category }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="图片" width="80">
          <template #default="scope">
            <el-image 
              style="width: 40px; height: 40px; border-radius: 5px" 
              v-if="scope.row.imageUrl" 
              :src="scope.row.imageUrl" 
              :preview-src-list="[scope.row.imageUrl]" 
              preview-teleported
              fit="cover">
            </el-image>
            <span v-else style="color: #ccc;">暂无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="awardInfo" label="获奖信息" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="year" label="年份" width="100"></el-table-column>
        <el-table-column prop="tags" label="标签" width="200" show-overflow-tooltip>
          <template #default="scope">
            <el-tag
              v-for="tag in scope.row.tags?.split(',') || []"
              :key="tag"
              size="small"
              effect="plain"
              style="margin-right: 5px; margin-bottom: 3px;">
              {{ tag.trim() }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button type="success" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="danger" size="small" @click="del(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="card" v-if="data.total">
      <el-pagination 
        @current-change="load" 
        background 
        layout="total, prev, pager, next" 
        :page-size="data.pageSize" 
        v-model:current-page="data.pageNum" 
        :total="data.total"/>
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="data.form.id ? '编辑优秀选题' : '新增优秀选题'" v-model="data.formVisible" width="60%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form" :rules="data.rules" label-width="100px" style="padding: 20px 30px" ref="formRef">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="选题名称" prop="title">
              <el-input v-model="data.form.title" placeholder="请输入选题名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="选题分类" prop="category">
              <el-select v-model="data.form.category" placeholder="请选择分类" style="width: 100%">
                <el-option v-for="item in data.categories" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="年份" prop="year">
              <el-date-picker
                v-model="data.form.year"
                type="year"
                placeholder="请选择年份"
                style="width: 100%"
                value-format="YYYY"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="获奖信息" prop="awardInfo">
              <el-input v-model="data.form.awardInfo" placeholder="请输入获奖信息"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="图片" prop="imageUrl">
          <el-upload
            :action="baseUrl + '/files/upload'"
            :headers="{ token: data.user.token }"
            list-type="picture"
            :on-success="handleImgSuccess">
            <el-button type="primary">上传图片</el-button>
          </el-upload>
          <!-- 显示当前图片 -->
          <div v-if="data.form.imageUrl" style="margin-top: 10px;">
            <div style="margin-bottom: 5px; color: #666;">当前图片：</div>
            <el-image 
              :src="data.form.imageUrl" 
              style="width: 100px; height: 100px; border-radius: 5px;"
              fit="cover">
            </el-image>
          </div>
        </el-form-item>
        <el-form-item label="选题描述" prop="description">
          <el-input v-model="data.form.description" type="textarea" :rows="4" placeholder="请输入选题描述"></el-input>
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <el-input v-model="data.form.tags" placeholder="请输入标签，多个标签用逗号分隔"></el-input>
          <div style="margin-top: 8px; color: #999; font-size: 12px;">
            例如：人工智能,大数据,机器学习
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible = false">取消</el-button>
          <el-button type="primary" @click="save">保存</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog title="优秀选题详情" v-model="data.viewVisible" width="70%" :close-on-click-modal="false" destroy-on-close>
      <div v-if="data.currentTopic" style="padding: 20px">
        <el-row :gutter="20">
          <el-col :span="16">
            <h3>{{ data.currentTopic.title }}</h3>
            <p><strong>分类：</strong>
              <el-tag :type="getCategoryType(data.currentTopic.category)">{{ data.currentTopic.category }}</el-tag>
            </p>
            <p><strong>年份：</strong>{{ data.currentTopic.year }}</p>
            <p><strong>获奖信息：</strong>{{ data.currentTopic.awardInfo }}</p>
            <p><strong>标签：</strong>
              <el-tag
                v-for="tag in data.currentTopic.tags?.split(',') || []"
                :key="tag"
                size="small"
                effect="plain"
                style="margin-right: 5px;">
                {{ tag.trim() }}
              </el-tag>
            </p>
            <div><strong>选题描述：</strong></div>
            <div style="margin-top: 10px; padding: 15px; background-color: #f8f9fa; border-radius: 6px; line-height: 1.6;">
              {{ data.currentTopic.description }}
            </div>
          </el-col>
          <el-col :span="8">
            <div v-if="data.currentTopic.imageUrl" style="text-align: center;">
              <el-image 
                :src="data.currentTopic.imageUrl" 
                style="width: 100%; max-width: 300px; border-radius: 8px;"
                :preview-src-list="[data.currentTopic.imageUrl]"
                preview-teleported
                fit="cover">
              </el-image>
            </div>
            <div v-else style="text-align: center; color: #ccc; padding: 50px 0;">
              暂无图片
            </div>
          </el-col>
        </el-row>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.viewVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue"
import request from "@/utils/request"
import { ElMessage, ElMessageBox } from "element-plus"

const baseUrl = import.meta.env.VITE_BASE_URL
const formRef = ref()

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  tableData: [],
  total: 0,
  pageNum: 1,
  pageSize: 10,
  title: '',
  category: '',
  year: null,
  formVisible: false,
  viewVisible: false,
  form: {},
  currentTopic: null,
  ids: [],
  categories: ['科技创新', '社会公益', '文化创意', '商业模式', '环境保护', '教育培训'],
  years: [],
  rules: {
    title: [
      { required: true, message: '请输入选题名称', trigger: 'blur' }
    ],
    category: [
      { required: true, message: '请选择分类', trigger: 'change' }
    ],
    year: [
      { required: true, message: '请选择年份', trigger: 'change' }
    ],
    awardInfo: [
      { required: true, message: '请输入获奖信息', trigger: 'blur' }
    ]
  }
})

// 初始化年份选项
const initYears = () => {
  const currentYear = new Date().getFullYear()
  for (let i = currentYear; i >= 2010; i--) {
    data.years.push(i)
  }
}

// 加载表格数据
const load = () => {
  const params = {
    pageNum: data.pageNum,
    pageSize: data.pageSize,
    title: data.title,
    category: data.category,
    year: data.year
  }
  request.get('/excellentTopic/selectPage', { params }).then(res => {
    if (res.code === '200') {
      data.tableData = res.data?.list || []
      data.total = res.data?.total || 0
    } else {
      ElMessage.error(res.msg || '查询失败')
    }
  })
}

// 重置
const reset = () => {
  data.title = ''
  data.category = ''
  data.year = null
  load()
}

// 打开新增弹窗
const handleAdd = () => {
  data.form = {}
  data.formVisible = true
}

// 打开编辑弹窗
const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row))
  data.formVisible = true
}

// 查看详情
const handleView = (row) => {
  data.currentTopic = row
  data.viewVisible = true
}

// 图片上传成功回调
const handleImgSuccess = (res) => {
  data.form.imageUrl = res.data
  ElMessage.success('图片上传成功')
}

// 新增
const add = () => {
  formRef.value.validate(valid => {
    if (valid) {
      request.post('/excellentTopic/add', data.form).then(res => {
        if (res.code === '200') {
          data.formVisible = false
          ElMessage.success('新增成功')
          load()
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}

// 更新
const update = () => {
  request.put('/excellentTopic/update', data.form).then(res => {
    if (res.code === '200') {
      data.formVisible = false
      ElMessage.success('修改成功')
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 保存
const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      data.form.id ? update() : add()
    }
  })
}

// 删除
const del = (id) => {
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(() => {
    request.delete('/excellentTopic/delete/' + id).then(res => {
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
const handleSelectionChange = (rows) => {
  data.ids = rows.map(v => v.id)
}

const delBatch = () => {
  if (!data.ids.length) {
    ElMessage.warning("请选择数据")
    return
  }
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(() => {
    request.delete('/excellentTopic/delete/batch', { data: data.ids }).then(res => {
      if (res.code === '200') {
        ElMessage.success('操作成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(() => {})
}

// 获取分类标签类型
const getCategoryType = (category) => {
  const types = {
    '科技创新': 'primary',
    '社会公益': 'success',
    '文化创意': 'warning',
    '商业模式': 'danger',
    '环境保护': 'info',
    '教育培训': ''
  }
  return types[category] || ''
}

// 初始化
initYears()
load()
</script>

<style scoped>
.card {
  background: white;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
}
</style> 