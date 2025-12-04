<template>
  <div>
    <div class="card" style="margin-bottom: 5px;">
      <el-input v-model="data.projectTitle" placeholder="请输入项目名称查询" style="width: 240px"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-button type="primary" plain @click="handleAdd" v-if="data.user.role === 'TEACHER'">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px;">
      <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="projectTitle" label="项目" show-overflow-tooltip></el-table-column>
        <el-table-column prop="teacherName" label="教师名称"></el-table-column>
        <el-table-column prop="title" label="任务名称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="detail" label="任务内容" show-overflow-tooltip></el-table-column>
        <el-table-column prop="time" label="时间" show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template v-slot="scope">
            <el-button type="primary" circle :icon="Edit" @click="handleEdit(scope.row)" v-if="data.user.role === 'TEACHER'"></el-button>
            <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
          </template>
        </el-table-column>
      </el-table>

    </div>
    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="total, prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
    </div>

    <el-dialog title="任务信息" v-model="data.formVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form" :rules="data.rules" label-width="80px"  style="padding: 20px 30px" ref="formRef">
        <el-form-item label="项目" prop="projectId">
          <el-select style="width: 100%" v-model="data.form.projectId">
            <el-option v-for="item in data.projectList" :key="item.id" :value="item.id" :label="item.title"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="data.form.title" placeholder="标题"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="detail">
          <el-input type="textarea" :rows="4" v-model="data.form.detail" placeholder="内容"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible = false">取消</el-button>
          <el-button type="primary" @click="save">保存</el-button>
        </span>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { reactive, ref } from "vue"
import request from "@/utils/request";
import {ElMessage, ElMessageBox} from "element-plus";
import {Delete, Edit} from "@element-plus/icons-vue";
const baseUrl = import.meta.env.VITE_BASE_URL
const formRef = ref()
const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  tableData: [],
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 5,  // 每页的个数
  formVisible: false,
  form: {},
  ids: [],
  projectTitle: null,
  rules: {
    projectId: [
      { required: true, message: '请选择项目', trigger: 'change' },
    ],
    title: [
      { required: true, message: '请输入标题', trigger: 'blur' },
    ],
    detail: [
      { required: true, message: '请输入内容', trigger: 'blur' },
    ],
  },
  teacherList: [],
  projectList: [],
})

const loadTeacher = () => {
  request.get('/teacher/selectAll').then(res => {
    if (res.code === '200') {
      data.teacherList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadTeacher()
const loadProject = () => {
  request.get('/project/selectAll',{
    params:{
      teacherName: data.user.name,
      status: "审核通过"
    }
  }).then(res => {
    if (res.code === '200') {
      data.projectList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadProject()
// 加载表格数据
const load = () => {

  const params = {
    pageNum: data.pageNum,
    pageSize: data.pageSize,
    projectTitle: data.projectTitle,
  }
  if (data.user.role === 'TEACHER'){
    params.teacherId = data.user.id
  }
  request.get('/task/selectPage', {params}).then(res => {
    data.tableData = res.data?.list || []
    data.total = res.data?.total
  })
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

// 新增
const add = () => {
  request.post('/task/add', data.form).then(res => {
    if (res.code === '200') {
      data.formVisible = false
      ElMessage.success('操作成功')
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 更新
const update = () => {
  request.put('/task/update', data.form).then(res => {
    if (res.code === '200') {
      data.formVisible = false
      ElMessage.success('操作成功')
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 删除
const del = (id) => {
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(res => {
    request.delete('/task/delete/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => {
    console.error(err)
  })
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
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(res => {
    request.delete('/task/delete/batch', {data: data.ids}).then(res => {
      if (res.code === '200') {
        ElMessage.success('操作成功')
        load()  // 刷新表格数据
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => console.log(err))
}

const save = () => {
  formRef.value.validate(valid => {
    if (valid) {
      data.form.id ? update() : add()
    }
  })
}

const reset = () => {
  data.projectTitle = null
  load()
}

load()

</script>