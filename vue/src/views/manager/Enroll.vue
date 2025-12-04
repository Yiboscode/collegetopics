<template>
  <div>
    <div class="card" style="margin-bottom: 5px;">
      <el-input v-model="data.projectName" placeholder="请输入项目名称查询" style="width: 240px"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px;">
      <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="projectName" label="项目名称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="userName" label="用户"></el-table-column>
        <el-table-column prop="teacherName" label="指导教师"></el-table-column>
        <el-table-column prop="name" label="报名人"></el-table-column>
        <el-table-column prop="content" label="个人简介" show-overflow-tooltip></el-table-column>
        <el-table-column prop="phone" label="联系方式" show-overflow-tooltip></el-table-column>
        <el-table-column prop="time" label="报名时间" show-overflow-tooltip></el-table-column>
          <el-table-column prop="status" label="审核状态">
            <template v-slot="scope">
              <el-tag type="warning" v-if="scope.row.status === '待审核'">待审核</el-tag>
              <el-tag type="success" v-if="scope.row.status === '审核通过'">审核通过</el-tag>
              <el-tag type="danger" v-if="scope.row.status === '审核未通过'">审核未通过</el-tag>
            </template>
          </el-table-column>
        <el-table-column prop="reason" label="审核原因" show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template v-slot="scope">
            <el-button type="primary" size="small" @click="handleEdit(scope.row)" :disabled="scope.row.status === '审核通过'" v-if="data.user.role === 'TEACHER'">审核</el-button>
            <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
          </template>
        </el-table-column>
      </el-table>

    </div>
    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="total, prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
    </div>
<!--   审核弹窗-->
    <el-dialog title="审核" v-model="data.formVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form" label-width="100px"  style="padding: 20px 30px" ref="formRef" >
        <el-form-item label="审核状态" prop="status">
          <el-radio-group v-model="data.form.status">
            <el-radio-button label="审核通过"></el-radio-button>
            <el-radio-button label="审核未通过"></el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理意见" prop="reason">
          <el-input type="textarea" :rows="3" v-model="data.form.reason"></el-input>
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
import '@wangeditor/editor/dist/css/style.css' // 引入 css
import {onBeforeUnmount, shallowRef} from "vue";

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
  projectName: null,
  content: '',
})

// 加载表格数据
const load = () => {

  const params = {
    pageNum: data.pageNum,
    pageSize: data.pageSize,
    projectName: data.projectName,
  }
  if (data.user.role === 'TEACHER'){
    params.teacherId = data.user.id
  }
  request.get('/enroll/selectPage', {params}).then(res => {
    data.tableData = res.data?.list || []
    data.total = res.data?.total
  })
}

// 打开编辑弹窗
const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row))
  data.formVisible = true
}


// 更新
const update = () => {
  request.put('/enroll/update', data.form).then(res => {
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
    request.delete('/enroll/delete/' + id).then(res => {
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
    request.delete('/enroll/delete/batch', {data: data.ids}).then(res => {
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
      update()
    }
  })
}

const reset = () => {
  data.projectName = null
  load()
}

load()

</script>