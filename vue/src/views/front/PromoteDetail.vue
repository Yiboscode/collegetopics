<template>
  <div  style=" width: 60%; margin: 0 auto; padding: 20px 0">
    <div class="card" style="padding: 30px; margin-bottom: 50px">
      <div style="font-weight: bold; font-size: 24px; text-align: center; margin-bottom: 10px">{{data.form.title}}</div>
      <div style="text-align: center; font-size: 12px; color: #666; margin-bottom: 30px">
        发布时间：<span style="margin-right: 20px">{{data.form.time}}</span>
        浏览量：<span> {{data.form.views}}</span>
      </div>
      <div style="text-align: center">
        <video style="width: 100%; height: 500px" :src="data.form.video" controls></video>
      </div>
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
const getPromote = () => {
  request.get('/promote/selectById/' + data.id).then(res => {
    if (res.code === '200') {
      data.form = res.data
    }
  })
}

const updateViews = () => {
  request.get('/promote/updateViews/' + data.id).then(res => {
    if (res.code === '200') {
      getPromote()
    }
  })
}
updateViews()


</script>
