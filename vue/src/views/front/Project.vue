<template>
  <div class="main-content" style="padding-bottom: 100px">
    <div style="display: flex; margin-bottom: 20px">
      <el-input v-model="data.title" placeholder="请输入活动名称查询" style="width: 240px"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="loadProject">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>
    <div>
      <el-row :gutter="10">
        <el-col :span="6" v-for="item in data.projectList" :key="item.id" style="margin-bottom: 10px">
          <div class="card" style="padding: 0 0 10px 0; cursor: pointer" @click="router.push('/front/projectDetail?id=' + item.id)">
            <img :src="item.img" alt="" style="width: 100%; height: 200px; border-radius: 5px 5px 0 0">
            <div style="font-size: 16px; margin: 10px; line-height: 20px; height: 40px" class="line2">{{item.classifyName}} | {{ item.title }}</div>
            <div style="display: flex; align-items: center; margin: 10px 10px 0 10px; justify-content: space-between">
              <div style="flex: 1">教师: {{item.teacherName}}</div>
              <div>浏览量: {{item.views}}</div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <div v-if="data.total" style="margin-top: 10px">
      <el-pagination @current-change="loadProject" layout="total, prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total" />
    </div>

  </div>
</template>

<script setup>
import { reactive } from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import router from "@/router/index.js";


const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  projectList: [],
  classifyList: [],
  pageNum: 1,
  pageSize: 8,
  total: 0,
  title: null,
})

const loadProject = () => {
  request.get('/project/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      title: data.title,
      status: "审核通过",
    }
  }).then(res => {
    if (res.code === '200') {
      data.projectList = res.data?.list || []
      data.total = res.data?.total
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadProject()

const loadClassify = () => {
  request.get('/classify/selectAll').then(res => {
    if (res.code === '200') {
      data.classifyList = res.data
    }
  })
}
loadClassify()

const reset = () => {
  data.title = null
  loadProject()
}


</script>