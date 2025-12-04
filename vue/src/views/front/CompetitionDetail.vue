<template>
  <div class="main-content">
    <div class="card" style="padding: 20px 60px">
      <div style="font-weight: bold; margin: 30px 0 20px 0; font-size: 24px; text-align: center;">{{data.form.title}}</div>
      <div style="text-align: center; color: #666; margin-bottom: 30px">
        发布时间：<span style="margin-right: 30px">{{data.form.time}}</span>
        浏览量：<span style="margin-left: 10px"> {{data.form.views}}</span>
      </div>
      <div style="margin-bottom: 30px; line-height: 30px" v-html="data.form.content"> </div>
    </div>
  </div>
</template>

<script setup>
import {reactive, ref} from "vue"
import request from "@/utils/request";
import router from "@/router/index.js";
import {ElMessage} from "element-plus";
import {Delete} from "@element-plus/icons-vue";


const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  id: router.currentRoute.value.query.id,
  form: {},
})
const getCompetition = () => {
  request.get('/competition/selectById/' + data.id).then(res => {
    if (res.code === '200') {
      data.form = res.data
    }
  })
}

const updateViews = () => {
  request.get('/competition/updateViews/' + data.id).then(res => {
    if (res.code === '200') {
      getCompetition()
    }
  })
}
updateViews()


</script>
