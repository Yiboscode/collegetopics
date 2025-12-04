<template>
  <div class="main-content" style="width: 50%">
    <div class="card" style="margin-bottom: 20px">
      <div style="padding: 20px">
        <div style="display: flex; margin-bottom: 30px">
          <div><img src="@/assets/imgs/tips.png" alt="" style="width: 15px; height: 15px; margin-right: 5px"></div>
          <div style="font-size: 14px; color: #666">温馨提示:您可以在下方提问创业相关问题，专业老师会为您解答～</div>
        </div>
        <div style="display: flex; grid-gap: 10px; margin-bottom: 10px">
          <img :src="data.user.avatar" alt="" style="height: 50px; width: 50px; border-radius: 50%">
          <div style="flex: 1">
            <div style="margin-bottom: 5px; font-size: 18px">{{data.user.name}}</div>
            <div>
              <el-input type="textarea" :rows="4" v-model="data.form.question" placeholder="请输入提问内容"></el-input>
            </div>
            <div style="text-align: right; margin-top: 5px"><el-button size="large" type="primary" @click="save" :disabled="!isValid">提交问题</el-button></div>
          </div>
        </div>
      </div>
    </div>

    <div style="margin-bottom: 20px">
      <div v-if="data.total">
        <div class="card">
          <div  style="padding: 20px">
            <div v-for="item in data.qaList">
              <div style="display: flex; grid-gap: 10px; margin-bottom: 10px">
                <img :src="item.userAvatar" alt="" style="height: 40px; width: 40px; border-radius: 50%">
                <div>
                  <div style="margin-bottom: 5px; font-size: 18px">{{item.userName}}</div>
                  <div class="line4" style="font-size: 12px">{{item.question}}</div>
                </div>
              </div>
              <div style="margin: 0 0 20px 40px">
                <div style="display: flex; grid-gap: 10px; margin-bottom: 10px" v-if="item.teacherAvatar !== null">
                  <img :src="item.teacherAvatar" alt="" style="height: 40px; width: 40px; border-radius: 50%">
                  <div>
                    <div style="margin-bottom: 5px; font-size: 18px">{{item.teacherName}}</div>
                    <div class="line4" style="font-size: 12px">{{item.answer}}</div>
                  </div>
                </div>
              </div>
              <div style="width: 100%; margin: 20px auto; border-bottom: 1px dashed #999; height: 1px; "></div>
            </div>

          </div>
        </div>
      </div>
      <div v-else style="padding: 30px; text-align: center">
        <div style="font-size: 16px; color: #666666">暂无问答...</div>
      </div>

    </div>
    <div style="display: flex">
      <div style="flex: 1" v-if="data.total">
        <el-pagination @current-change="loadQa" layout="total,prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
      </div>
    </div>

  </div>
</template>

<script setup>
import { reactive, computed } from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import router from "@/router/index.js";


const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 4,  // 每页的个数
  form: {
    question: ''
  },
  qaList: [],

})


const loadQa = () => {
  // 假设后端接口支持接收 userId 参数，这里将 userId 作为参数传递
  request.get('/qa/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      userId: data.user.id,
    }
  }).then(res => {
    data.qaList = res.data?.list || []
    data.total = res.data?.total
  })
}
loadQa();


const isValid = computed(() => {
  return data.form.question.trim().length > 0;
});

// 新增
const add = () => {
  request.post('/qa/add', data.form).then(res => {
    if (res.code === '200') {
      data.form.question = ''
      ElMessage.success('操作成功')
      loadQa();
    } else {
      ElMessage.error(res.msg)
    }
  })
}

const save = () => {
  if (isValid.value) {
    add();
  } else {
    ElMessage.warning('请输入问题内容');
  }
};

</script>