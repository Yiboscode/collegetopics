<template>
  <div>
    <div class="card" style="margin-bottom: 5px;">
      <el-input v-model="data.userName" placeholder="请输入用户查询" style="width: 240px"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px;">
      <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="userName" label="用户名称" width="100"></el-table-column>
        <el-table-column prop="question" label="问题" show-overflow-tooltip></el-table-column>
        <el-table-column prop="teacherName" label="教师名称" width="100"></el-table-column>
        <el-table-column prop="answer" label="回复" show-overflow-tooltip></el-table-column>
        <el-table-column prop="time" label="时间"></el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template v-slot="scope">
            <el-button type="primary" size="small" @click="handle(scope.row)" v-if="data.user.role === 'TEACHER'">回复</el-button>
            <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
          </template>
        </el-table-column>
      </el-table>

    </div>
    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="total, prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
    </div>

    <el-dialog title="项目问答回复" style="padding: 20px; min-height: 200px" v-model="data.formVisible"  width="50%" :close-on-click-modal="false" destroy-on-close>
      <div style="padding: 20px">
        <el-form ref="formRef" :model="data.form" :rules="data.rules"  label-width="80px">
          <el-form-item label="回复" prop="answer" >
            <el-input type="textarea" rows="4" v-model="data.form.answer" placeholder="请输入回复内容"></el-input>
          </el-form-item>
        </el-form>
      </div>

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
  form: {},
  ids: [],
  userName: null,
  rules: {
    answer: [
      { required: true, message: '请输入回复', trigger: 'blur' },
    ],
  },
  teacherList: [],
  userList: [],
})

const handle = (row) => {
  data.form = JSON.parse(JSON.stringify(row))
  data.formVisible = true;
}

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
const loadUser = () => {
  request.get('/user/selectAll').then(res => {
    if (res.code === '200') {
      data.userList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadUser()
// 加载表格数据
const load = () => {
  request.get('/qa/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      userName: data.userName,
      teacherId: data.user.role === 'TEACHER' ? data.user.id : null
    }
  }).then(res => {
    data.tableData = res.data?.list || []
    data.total = res.data?.total
  })
}

// 打开新增弹窗
const handleAdd = () => {
  data.form = {}
  data.formVisible = true
}


// 更新
const update = () => {
  request.put('/qa/update', data.form).then(res => {
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
    request.delete('/qa/delete/' + id).then(res => {
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
    request.delete('/qa/delete/batch', {data: data.ids}).then(res => {
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
  formRef.value.validate((valid) => {
    if (valid) {
      update()
    }
  })
}

const reset = () => {
  data.userName = null
  load()
}

load()

</script>