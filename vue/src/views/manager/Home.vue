<template>
  <div>
    <div  class="card"  style="margin-bottom: 10px"  v-if="data.user.role === 'TEACHER'">
      <div v-if="data.certify.status === '审核通过'" style="color: green; margin-left: 10px">教师已认证</div>
      <div v-if="data.certify.status === '待审核'" style="color: orange; margin-left: 10px">您已提交认证，等待管理员审核中</div>
      <div v-if="data.certify.status === '审核未通过'" style="color: red; margin-left: 10px">您的认证未通过，请您重新上传认证
        <span style="color: #0066bc; margin-left: 20px; cursor: pointer" @click="router.push('/manager/frontCertify')">去修改</span>
      </div>
      <div v-if="data.user.status === '未认证'">您好！{{ data.user?.name }}，您当前还未通过教师认证，
        <span style="color: #0066bc; margin-left: 20px; cursor: pointer" @click="router.push('/manager/frontCertify')">请认证</span>
      </div>
    </div>
    <div style="display: flex">
      <div class="card" style="flex: 50%; padding: 20px" >
        <div style="font-weight: bold; font-size: 18px; margin-bottom: 20px">系统公告</div>
        <el-timeline>
          <el-timeline-item
              v-for="(item, index) in data.noticeData"
              :key="index"
              :timestamp="item.time"
          >
            {{ item.content }}
          </el-timeline-item>
        </el-timeline>
      </div>
      <div style="flex: 50%"></div>
    </div>
  </div>
</template>

<script setup>

import {reactive} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import router from "@/router/index.js";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  noticeData: [],
  certify: []
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

const loadCertify = () => {
  request.get('/certify/selectByUserId/' + data.user.id).then(res => {
    if (res.code === '200') {
      data.certify = res.data || {}
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadCertify()
</script>