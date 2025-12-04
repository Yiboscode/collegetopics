<template>
  <div class="main-content">
    <div style="font-weight: bold; font-size: 20px; margin-bottom: 20px">我的报名</div>
    <div class="card" style="padding: 20px">
      <div style="margin-bottom: 20px;">
        <div style="display: flex">
          <el-input v-model="data.projectName" placeholder="请输入活动名称查询" style="width: 240px"></el-input>
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
        <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
          <el-table-column prop="projectName" label="项目名称" show-overflow-tooltip></el-table-column>
          <el-table-column prop="name" label="参加人姓名" show-overflow-tooltip></el-table-column>
          <el-table-column prop="phone" label="联系方式" show-overflow-tooltip></el-table-column>
          <el-table-column prop="time" label="申请时间" show-overflow-tooltip></el-table-column>
          <el-table-column prop="content" label="个人简介" show-overflow-tooltip></el-table-column>
          <el-table-column prop="status" label="审核状态">
            <template v-slot="scope">
              <el-tag type="warning" v-if="scope.row.status === '待审核'">待审核</el-tag>
              <el-tag type="danger" v-if="scope.row.status === '审核未通过'">审核未通过</el-tag>
              <el-tag type="success" v-if="scope.row.status === '审核通过'">审核通过</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="reason" label="审核原因" show-overflow-tooltip></el-table-column>
        </el-table>
      </div>
      <div v-if="data.total">
        <el-pagination @current-change="load" layout="total,prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
      </div>
    </div>

    <!-- 评价对话框 -->
    <el-dialog title="活动评价" v-model="data.evaluateFormVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form" label-width="80px" style="padding: 10px 20px" ref="evaluateFormRef">
        <el-form-item label="活动评价" prop="content">
          <el-input type="textarea" :rows="4" v-model="data.form.content"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.evaluateFormVisible = false">取消</el-button>
          <el-button type="primary" @click="submitEvaluation">提交</el-button>
        </span>
      </template>
    </el-dialog>

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
  formVisible: false,
  form: {},
  ids: [],
  status: null,
  projectName: null,
})

// 打开新增弹窗
const handleAdd = (row) => {
  data.form = { activityId: row.activityId}
  data.evaluateFormVisible = true
}


// 加载表格数据
const load = () => {
  request.get('/enroll/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      userId: data.user.id,
      projectName: data.projectName,
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
  data.projectName = null
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