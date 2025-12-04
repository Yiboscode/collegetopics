<template>
  <div class="main-content">
    <div style="font-weight: bold; font-size: 20px; margin-bottom: 20px">我的问答</div>
    <div class="card" style="padding: 20px">
      <div style="margin-bottom: 20px;">
        <div style="display: flex">
          <el-input v-model="data.question" placeholder="请输入问题查询" style="width: 240px"></el-input>
          <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
          <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
        </div>
      </div>
      <div style="margin-bottom: 20px;">
        <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
          <el-table-column prop="question" label="问题" show-overflow-tooltip></el-table-column>
          <el-table-column prop="teacherName" label="教师名称" show-overflow-tooltip width="100px"></el-table-column>
          <el-table-column prop="answer" label="教师回复" show-overflow-tooltip></el-table-column>
          <el-table-column prop="time" label="提问时间" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template v-slot="scope">
              <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
            </template>
          </el-table-column>
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
  question: null,
})

// 加载表格数据
const load = () => {
  request.get('/qa/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      userId: data.user.id,
      question: data.question,
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
  data.question = null

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