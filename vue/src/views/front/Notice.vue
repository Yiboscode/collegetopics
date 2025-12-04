<template>
  <div class="main-content" >
    <div class="card" style="width: 60%; padding: 20px; margin: 0 auto">
      <div style="font-weight: bold; font-size: 18px; padding: 10px 0 30px 10px">系统公告</div>
      <el-timeline>
        <el-timeline-item
            v-for="(item, index) in data.noticeData"
            :key="index"
            :timestamp="item.time"
            color="#0066bc"
        >
          {{ item.content }}
        </el-timeline-item>
      </el-timeline>
    </div>

  </div>
</template>

<script setup>

import {reactive} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  noticeData: []
})

const loadNotice = () => {
  request.get('/notice/selectAll').then(res => {
    if (res.code === '200') {
      data.noticeData = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadNotice()
</script>