<template>
  <div class="main-content" style="">
    <div class="card" style="margin-bottom: 20px; padding: 20px 30px">
      <div style="display: flex; grid-gap: 20px">
        <img :src="data.project.img" alt="" style="width: 300px; height: 280px; border-radius: 5px">
        <div style="flex: 1">
          <div style="display: flex; align-items: center; grid-gap: 20px">
            <div style="flex: 1; margin-bottom: 10px; font-size: 24px" class="line2">{{data.project.title}}</div>
            <div style="margin-top: 5px; cursor: pointer; display: flex; align-items: center" v-if="data.project.userCollect" @click="toggleCollect(data.project.id)">
              <!-- 根据 isCollectd 状态显示不同图片 -->
              <img src="@/assets/imgs/collect1.png" style="width: 16px; height: 16px; display: block; cursor: pointer" alt="已收藏">
              <div style="color: red; margin-left: 5px">取消收藏</div>
            </div>
            <div style="margin-top: 5px; cursor: pointer; display: flex; align-items: center" v-else @click="toggleCollect(data.project.id)">
              <!-- 根据 isCollectd 状态显示不同图片 -->
              <img src="@/assets/imgs/collect0.png" style="width: 16px; height: 16px; display: block; cursor: pointer" alt="未收藏">
              <div style="margin-left: 5px">收藏</div>
            </div>
          </div>

          <div style="display: flex; align-items: center; margin-bottom: 10px">
            项目类型：<el-tag type="primary" style="margin-right: 40px">{{ data.project.classifyName }}</el-tag>
            <div style="display: flex; align-items: center; justify-content: center">
              <img src="@/assets/imgs/views.png" style="height: 15px; width: 15px" alt="">
              <div style="margin-left: 5px"> {{ data.project.views}}</div>
            </div>
          </div>

          <div style="color: #666; margin-bottom: 10px">
            <span>指导教师: {{ data.project.teacherName}}</span>

            <span style="margin-left: 40px">发布时间：{{ data.project.time }}</span>
          </div>
          <div style="font-size: 15px; line-height: 28px; margin-bottom: 20px" class="line4">{{data.project.introduce}}</div>
          <el-button type="primary" size="large" style="width: 150px" @click="handleAdd">加入项目</el-button>
        </div>
      </div>
      <div style="margin-top: 50px; line-height: 30px" v-html="data.project.content"> </div>
    </div>

    <el-dialog title="加入项目" style="padding: 20px" v-model="data.formVisible" width="40%" destroy-on-close>
      <el-form ref="formRef" :model="data.form" :rules="data.rules" label-width="80px" style="padding: 20px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="data.form.name" placeholder="姓名"></el-input>
        </el-form-item>
        <el-form-item label="联系方式" prop="phone">
          <el-input v-model="data.form.phone" placeholder="联系方式"></el-input>
        </el-form-item>
        <el-form-item prop="content" label="个人简介">
          <el-input type="textarea" :rows="4" v-model="data.form.content" placeholder="个人简介"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible = false">取 消</el-button>
          <el-button type="primary" @click="save">确 定</el-button>
        </span>
      </template>
    </el-dialog>



  </div>


</template>

<script setup>
import { reactive, ref } from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import router from "@/router/index.js";


const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  id: router.currentRoute.value.query.id,
  formVisible: false,
  project: {},
  projectList: [],
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 5,  // 每页的个数
  activeName: '活动详情',
  rules: {
    name: [
      { required: true, message: '请输入姓名', trigger: 'blur' }
    ],
    phone: [
      { required: true, message: '请输入联系方式', trigger: 'blur' }
    ],
  }
})

const handleClick = (tab, event ) => {
}


const formRef = ref()

const loadEvaluate = () => {
  request.get('/evaluate/selectPage?projectId='+ data.id , {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
      projectId: data.id
    }
  }).then(res => {
    data.evaluateList = res.data?.list || []
    data.total = res.data?.total
  })
}
loadEvaluate()


const handleAdd = () => {
  data.form = {}
  data.formVisible = true
}

const loadProject = () => {
  request.get('/project/selectById/' + data.id).then(res => {
    if (res.code === '200') {
      data.project = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadProject()

const load = () => {
  request.get('/project/selectAll').then(res => {
    if (res.code === '200') {
      data.projectList = res.data
    }
  })
}
load()


// 新增
const add = () => {
  data.form.projectId = data.id
  request.post('/enroll/add', data.form).then(res => {
    if (res.code === '200') {
      data.formVisible = false;
      ElMessage.success("报名成功！等待教师审核")
      data.form = {}
    } else {
      ElMessage.error(res.msg)
    }
  })

}

const toggleCollect = (projectId) => {
  request.post('collect/add', { projectId: projectId, userId: data.user.id  }).then(res => {
    if (res.code === '200') {
      if (data.project.userCollect){
        ElMessage.success("取消收藏成功")
      } else {
        ElMessage.success("收藏成功")
      }

      loadProject()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

const updateViews = () => {
  request.get('/project/updateViews/' + data.id).then(res => {
    if (res.code === '200') {
      loadProject()
    }
  })
}
updateViews()


const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      add()
    }
  })
}



</script>
<style>
.demo-tabs > .el-tabs__content {
  padding: 30px;
  color: #373636;
  font-size: 16px;
  font-weight: normal;
}

</style>
