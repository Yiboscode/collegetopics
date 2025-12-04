<template>
  <div class="manager-container">
    <div class="manager-header">
      <div class="manager-header-left">
        <img src="@/assets/imgs/logo.png" alt="">
        <div class="title">创新创业课程考核项目选题系统</div>
      </div>
      <div class="manager-header-center">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/manager/home' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>{{ router.currentRoute.value.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="manager-header-right">
        <el-dropdown style="cursor: pointer">
          <div style="padding-right: 20px; display: flex; align-items: center">
            <img style="width: 40px; height: 40px; border-radius: 50%;" :src="data.user.avatar" alt="">
            <span style="margin-left: 5px; color: #666">{{ data.user.name }}</span><el-icon color="#666"><arrow-down /></el-icon>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item @click="router.push('/manager/person')">个人资料</el-dropdown-item>
              <el-dropdown-item @click="router.push('/manager/frontCertify')" v-if="data.user.role === 'TEACHER'">教师认证</el-dropdown-item>
              <el-dropdown-item @click="router.push('/manager/password')">修改密码</el-dropdown-item>
              <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
    <!-- 下面部分开始 -->
    <div style="display: flex">
      <div class="manager-main-left">
        <el-menu :default-active="router.currentRoute.value.path"
                 :default-openeds="['1', '2', '3']"
                 router
        >
          <el-menu-item index="/manager/home">
            <el-icon><HomeFilled /></el-icon>
            <span>系统首页</span>
          </el-menu-item>
          <el-menu-item index="/manager/data" v-if="data.user.role ==='ADMIN'">
            <el-icon><DataAnalysis /></el-icon>
            <span>数据统计</span>
          </el-menu-item>
          <el-sub-menu index="1" v-if="data.user.role === 'ADMIN' || (data.user.role === 'TEACHER' && data.user.status === '认证通过')">
            <template #title>
              <el-icon><Menu /></el-icon>
              <span>信息管理</span>
            </template>
<!--            <el-menu-item index="/manager/project" v-if=" (data.user.role === 'TEACHER') || data.user.role === 'ADMIN'">创业项目</el-menu-item>-->
<!--            <el-menu-item index="/manager/task"  v-if=" (data.user.role === 'TEACHER') || data.user.role === 'ADMIN'">项目任务</el-menu-item>-->
<!--            <el-menu-item index="/manager/enroll"  v-if=" (data.user.role === 'TEACHER') || data.user.role === 'ADMIN'">报名信息</el-menu-item>-->
<!--            <el-menu-item index="/manager/submit"  v-if=" (data.user.role === 'TEACHER') || data.user.role === 'ADMIN'">任务成果</el-menu-item>-->
            <el-menu-item index="/manager/qa"  v-if=" (data.user.role === 'TEACHER') || data.user.role === 'ADMIN'">项目问答 </el-menu-item>
            <el-menu-item index="/manager/certify" v-if="data.user.role === 'ADMIN'">认证信息</el-menu-item>
            <el-menu-item index="/manager/classify" v-if="data.user.role === 'ADMIN'">分类信息</el-menu-item>
            <el-menu-item index="/manager/competition" v-if="data.user.role === 'ADMIN'">大赛动态</el-menu-item>
            <el-menu-item index="/manager/promote" v-if="data.user.role === 'ADMIN'">宣传视频信息</el-menu-item>
            <el-menu-item index="/manager/notice" v-if="data.user.role === 'ADMIN'">系统公告</el-menu-item>
            <el-menu-item index="/manager/carousel" v-if="data.user.role === 'ADMIN'">轮播图信息</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="3" v-if="data.user.role === 'ADMIN' || (data.user.role === 'TEACHER' && data.user.status === '认证通过')">
            <template #title>
              <el-icon><Menu /></el-icon>
              <span>选题管理</span>
            </template>
            <el-menu-item index="/manager/topic" v-if="data.user.role === 'ADMIN' || data.user.role === 'TEACHER'">选题管理</el-menu-item>
            <el-menu-item index="/manager/teamManage" v-if="data.user.role === 'ADMIN' || data.user.role === 'TEACHER'">团队管理</el-menu-item>
            <el-menu-item index="/manager/topicEvaluation" v-if="data.user.role === 'ADMIN' || data.user.role === 'TEACHER'">选题评价</el-menu-item>
            <el-menu-item index="/manager/innovationEvaluation" v-if="data.user.role === 'ADMIN' || data.user.role === 'TEACHER'">创新能力评价</el-menu-item>
            <el-menu-item index="/manager/excellentTopic" v-if="data.user.role === 'ADMIN'">优秀选题库</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="2"  v-if="data.user.role === 'ADMIN'">
            <template #title>
              <el-icon><Menu /></el-icon>
              <span>用户管理</span>
            </template>
            <el-menu-item index="/manager/admin">管理员信息</el-menu-item>
            <el-menu-item index="/manager/user">用户信息</el-menu-item>
            <el-menu-item index="/manager/teacher">教师信息</el-menu-item>
          </el-sub-menu>
        </el-menu>
      </div>
      <div class="manager-main-right">
        <RouterView @updateUser="updateUser" />
      </div>
    </div>
    <!-- 下面部分结束 -->


  </div>
</template>

<script setup>
import { reactive } from "vue";
import router from "@/router/index.js";
import {ElMessage} from "element-plus";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}')
})

const logout = () => {
  localStorage.removeItem('xm-user')
  router.push('/login')
}

const updateUser = () => {
  data.user =  JSON.parse(localStorage.getItem('xm-user') || '{}')
}

if (!data.user.id) {
  logout()
  ElMessage.error('请登录！')
}
</script>

<style scoped>
@import "@/assets/css/manager.css";
</style>