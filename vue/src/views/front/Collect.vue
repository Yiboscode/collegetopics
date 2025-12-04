<template>
  <div class="main-content">
    <div style="font-weight: bold; font-size: 20px; margin-bottom: 20px">我的收藏（{{ data.collectList.length }}）</div>
    <div style="">
      <div style="margin-bottom: 20px;">
        <div>
          <el-row :gutter="10">
            <el-col :span="6" v-for="item in data.collectList" :key="item.id">
              <div style="margin-bottom: 10px" class="card"  @click="router.push('/front/projectDetail?id=' + item.projectId)">
                <img style="height: 220px; width: 100%; border-radius: 5px; cursor: pointer; margin-bottom: 10px" :src="item.projectImg" alt="" />
                <div style="font-size: 16px; margin-bottom: 10px" class="line1">{{item.projectTitle}}</div>
                <div style="display: flex; justify-content: space-between">
                  <span style=" margin-bottom: 10px"><el-button type="danger" size="small" @click.stop="del(item.id)">取消收藏</el-button></span>
                </div>
              </div>
            </el-col>
          </el-row>

        </div>
        <div style="display: flex">
          <div style="flex: 1" v-if="data.total">
            <el-pagination @current-change="loadCollect" layout="total,prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import {reactive} from "vue"
import request from "@/utils/request";
import {ElMessage, ElMessageBox} from "element-plus";
import {Delete, Edit} from "@element-plus/icons-vue";
import router from "@/router/index.js";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 8,  // 每页的个数
  form: {},
  ids: [],
  collectList: [],
})

const loadCollect = () => {
  // 假设后端接口支持接收 userId 参数，这里将 userId 作为参数传递
  request.get('/collect/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      userId: data.user.id,
    }
  }).then(res => {
    data.collectList = res.data?.list || []
    data.total = res.data?.total
  })
}
loadCollect();

// 删除
const del = (id) => {
  ElMessageBox.confirm('您确定取消收藏吗?', '取消确认', {type: 'warning'}).then(res => {
    request.delete('/collect/delete/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success('取消成功')
        loadCollect()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => {
    console.error(err)
  })
}

</script>
