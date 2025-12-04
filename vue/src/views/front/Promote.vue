<template>
  <div class="main-content">
    <div style="margin-bottom: 20px">
      <el-input v-model="data.title" placeholder="请输入标题查询" style="width: 400px; height: 40px" clearable @clear="loadPromote"></el-input>
      <el-button type="primary" plain style="margin-left: 10px; height: 40px; width: 100px" @click="loadPromote">查询</el-button>
    </div>

    <div style="display: flex; grid-gap: 20px">
      <div style="flex: 1;">
        <el-row :gutter="20">
          <el-col :span="8" v-for="item in data.tableData" class="item" :key="item.id" style="cursor: pointer;" @click="router.push('/front/promoteDetail?id=' + item.id)">
            <div style="margin-bottom: 20px">
              <img :src="item.img" style="width: 100%; height: 200px; border-radius: 5px 5px 0 0"></img>
              <div style="font-size: 20px; font-weight: bold; margin: 10px 0" class="line1">{{ item.title }}</div>
              <div style="display: flex; align-items: center; grid-gap: 5px">
                <div style="flex: 1; color: #666; font-size: 13px; display: flex; align-items: center">
                  浏览量：<span style="margin-left: 5px">{{ item.views }}</span>
                </div>
                <div style="font-size: 13px; color: #666; display: flex; align-items: center">
                  发布时间：<span style="margin-left: 2px">{{ item.time }}</span>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

    </div>
    <div v-if="data.total">
      <el-pagination @current-change="loadPromote" layout="total,prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
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
  total: 0,
  pageNum: 1,
  pageSize: 6,
  tableData: [],
  title: null,
})

const loadPromote = () => {
  request.get('/promote/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      title: data.title,
    }
  }).then(res => {
    data.tableData = res.data?.list || [];
    data.total = res.data?.total;
  }).catch(err => {
    ElMessage.error('加载数据失败');
  });
};
loadPromote();

</script>