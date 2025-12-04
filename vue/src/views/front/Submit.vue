<template>
  <div class="main-content">
    <div style="font-weight: bold; font-size: 20px; margin-bottom: 20px">我的成果</div>
    <div class="card" style="padding: 20px">
      <div style="margin-bottom: 20px;">
        <div style="display: flex">
          <el-input v-model="data.taskTitle" placeholder="请输入活动名称查询" style="width: 240px"></el-input>
          <el-select v-model="data.status" style="width: 240px; margin-left: 20px" placeholder="请选择审核状态查询">
            <el-option label="待审核" value="待审核"></el-option>
            <el-option label="审核通过" value="审核通过"></el-option>
            <el-option label="审核未通过" value="审核未通过"></el-option>
          </el-select>
          <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
          <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
        </div>
      </div>
      <div style="margin-bottom: 20px;">
        <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange">
          <el-table-column prop="taskTitle" label="任务名称" show-overflow-tooltip></el-table-column>
          <el-table-column prop="teacherName" label="教师名称"></el-table-column>
          <el-table-column prop="title" label="标题" show-overflow-tooltip></el-table-column>
          <el-table-column prop="detail" label="我的成果" show-overflow-tooltip>
            <template v-slot="scope">
              <el-button type="primary" @click="down(scope.row.detail)" size="small">点击下载</el-button>
            </template>
          </el-table-column>
          <el-table-column prop="time" label="时间" show-overflow-tooltip></el-table-column>
          <el-table-column prop="status" label="审核状态">
            <template v-slot="scope">
              <el-tag type="warning" v-if="scope.row.status === '待审核'">待审核</el-tag>
              <el-tag type="danger" v-if="scope.row.status === '审核未通过'">审核未通过</el-tag>
              <el-tag type="success" v-if="scope.row.status === '审核通过'">审核通过</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="reason" label="原因" show-overflow-tooltip></el-table-column>
        </el-table>
      </div>
      <div v-if="data.total">
        <el-pagination @current-change="load" layout="total,prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
      </div>
    </div>

  </div>
</template>

<script setup>
import {reactive,ref} from "vue"
import request from "@/utils/request";
import {ElMessage, ElMessageBox} from "element-plus";
import {Delete, Edit} from "@element-plus/icons-vue";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  tableData: [],
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 5,  // 每页的个数
  form: {},
  ids: [],
  status: null,
  taskTitle: null,
})

const down = (url) => {
  window.open(url)
}

// 加载表格数据
const load = () => {
  request.get('/submit/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      taskTitle: data.taskTitle,
      status: data.status,
    }
  }).then(res => {
    data.tableData = res.data?.list || []
    data.total = res.data?.total
  })
}

// 删除
const del = (id) => {
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', {type: 'warning'}).then(res => {
    request.delete('/order/delete/' + id).then(res => {
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
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', {type: 'warning'}).then(res => {
    request.delete('/order/delete/batch', {data: data.ids}).then(res => {
      if (res.code === '200') {
        ElMessage.success('操作成功')
        load()  // 刷新表格数据
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => console.log(err))
}

const reset = () => {
  data.taskTitle = null
  data.status = null
  load()
}

load()

</script>

<style scoped>
.demo-rate-block {
  padding: 30px 0;
  text-align: center;
  display: inline-block;
  width: 60%;
  box-sizing: border-box;
}
.demo-rate-block:last-child {
  border-right: none;
}
.demo-rate-block .demonstration {
  display: block;
  color: var(--el-text-color-secondary);
  font-size: 20px;
}
</style>