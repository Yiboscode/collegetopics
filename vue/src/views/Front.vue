<template>
  <div class="page-container">
    <div class="front-header">
      <div class="front-header-left">
        <div class="logo-section">
          <img src="@/assets/imgs/logo.png" alt="" class="logo-img">
          <div class="title" @click="router.push('/front/home')">创新创业课程考核项目选题系统</div>
        </div>
      </div>

      <div class="front-header-center">
        <el-menu
            :default-active="router.currentRoute.value.path"
            router
            mode="horizontal"
            class="custom-menu">
          <el-menu-item index="/front/home" class="menu-item">
            <span class="menu-text">首页</span>
          </el-menu-item>
          <el-menu-item index="/front/topic" class="menu-item">
            <span class="menu-text">选题管理</span>
          </el-menu-item>
          <el-menu-item index="/front/team" class="menu-item">
            <span class="menu-text">团队管理</span>
          </el-menu-item>
          <el-menu-item index="/front/excellentTopics" class="menu-item">
            <span class="menu-text">优秀选题</span>
          </el-menu-item>
          <el-menu-item index="/front/promote" class="menu-item">
            <span class="menu-text">创业宣传</span>
          </el-menu-item>
          <el-menu-item index="/front/qa" class="menu-item">
            <span class="menu-text">创业问答</span>
          </el-menu-item>
          <el-menu-item index="/front/notice" class="menu-item">
            <span class="menu-text">系统公告</span>
          </el-menu-item>
        </el-menu>
      </div>

      <div class="front-header-right">
        <div v-if="!data.user.id" class="auth-buttons">
          <el-button
              @click="router.push('/login')"
              class="login-btn"
              size="default">
            登录
          </el-button>
          <el-button
              @click="router.push('/register')"
              class="register-btn"
              type="primary"
              size="default">
            注册
          </el-button>
        </div>

        <div v-else class="user-section">
          <el-dropdown class="user-dropdown">
            <div class="user-info">
              <div class="avatar-wrapper">
                <img :src="data.user.avatar" alt="" class="user-avatar">
                <div class="online-indicator"></div>
              </div>
              <span class="user-name">{{ data.user.name }}</span>
              <el-icon class="dropdown-icon"><arrow-down /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu class="custom-dropdown-menu">
                <el-dropdown-item @click="router.push('/front/person')" class="dropdown-item">
                  <span class="item-icon">👤</span>
                  <span>个人中心</span>
                </el-dropdown-item>
                <el-dropdown-item @click="router.push('/front/topicSubmit')" class="dropdown-item">
                  <span class="item-icon">📝</span>
                  <span>选题提交</span>
                </el-dropdown-item>
                <el-dropdown-item @click="router.push('/front/team')" class="dropdown-item">
                  <span class="item-icon">👥</span>
                  <span>我的团队</span>
                </el-dropdown-item>
                <el-dropdown-item @click="router.push('/front/myEvaluation')" class="dropdown-item">
                  <span class="item-icon">⭐</span>
                  <span>我的评价</span>
                </el-dropdown-item>
                <el-dropdown-item @click="router.push('/front/myQa')" class="dropdown-item">
                  <span class="item-icon">💬</span>
                  <span>我的问答</span>
                </el-dropdown-item>
                <el-dropdown-item @click="router.push('/front/password')" class="dropdown-item">
                  <span class="item-icon">🔐</span>
                  <span>修改密码</span>
                </el-dropdown-item>
                <el-dropdown-item @click="logout" class="dropdown-item logout-item">
                  <span class="item-icon">🚪</span>
                  <span>退出登录</span>
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </div>

    <div class="main-body">
      <RouterView @updateUser="updateUser" />
    </div>

    <footer class="custom-footer">
      <div class="footer-content">
        <div class="footer-top">
          <div class="footer-logo-section">
            <img src="@/assets/imgs/logo2.png" alt="" class="footer-logo">
            <span class="footer-title">创新创业课程考核项目选题系统</span>
          </div>
        </div>

        <div class="footer-middle">
          <div class="contact-info">
            <div class="contact-item">
              <span class="contact-icon">📞</span>
              <span>联系方式: 0551-88888888</span>
            </div>
            <div class="contact-item">
              <span class="contact-icon">📧</span>
              <span>联系邮箱：dxscy@xmsz.com</span>
            </div>
          </div>
        </div>

        <div class="footer-bottom">
          <div class="copyright">
            CopyRight 2022-2025©创新创业课程考核项目选题系统 All rights reserved.
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import router from "@/router/index.js";
import { reactive } from "vue";
import request from "@/utils/request.js";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  top: '',
  noticeData: []
})

const logout = () => {
  localStorage.removeItem('xm-user')
  router.push('/login')
}

const updateUser = () => {
  data.user =  JSON.parse(localStorage.getItem('xm-user') || '{}')
}

const loadNotice = () => {
  request.get('/notice/selectAll').then(res => {
    data.noticeData = res.data
    let i = 0
    if (data.noticeData && data.noticeData.length) {
      data.top = data.noticeData[0].content
      setInterval(() => {
        data.top = data.noticeData[i].content
        i++
        if (i === data.noticeData.length) {
          i = 0
        }
      }, 2500)
    }
  })
}
loadNotice()
</script>

<style scoped>
@import "@/assets/css/front.css";

.page-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

/* 头部导航美化 */
.front-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
  padding: 0 20px;
  height: 70px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* Logo区域 */
.front-header-left {
  flex-shrink: 0;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-img {
  width: 45px;
  height: 45px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.logo-img:hover {
  transform: scale(1.1);
}

.title {
  font-size: 20px;
  font-weight: 700;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.title:hover {
  transform: translateY(-1px);
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

/* 导航菜单美化 */
.front-header-center {
  flex: 1;
  display: flex;
  justify-content: center;
  max-width: 800px;
}

:deep(.custom-menu) {
  background: transparent !important;
  border: none !important;
  flex: 1;
}

:deep(.custom-menu .el-menu-item) {
  color: rgba(255, 255, 255, 0.9) !important;
  border: none !important;
  margin: 0 8px;
  border-radius: 8px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  font-weight: 500;
}

:deep(.custom-menu .el-menu-item:hover) {
  background: rgba(255, 255, 255, 0.15) !important;
  color: white !important;
  transform: translateY(-2px);
}

:deep(.custom-menu .el-menu-item.is-active) {
  background: rgba(255, 255, 255, 0.2) !important;
  color: white !important;
  border-bottom: none !important;
}

:deep(.custom-menu .el-menu-item::before) {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
  transition: left 0.6s;
}

:deep(.custom-menu .el-menu-item:hover::before) {
  left: 100%;
}

.menu-text {
  font-size: 14px;
  letter-spacing: 0.5px;
}

/* 右侧用户区域 */
.front-header-right {
  flex-shrink: 0;
}

.auth-buttons {
  display: flex;
  gap: 12px;
}

.login-btn {
  background: transparent !important;
  border: 2px solid rgba(255, 255, 255, 0.3) !important;
  color: white !important;
  border-radius: 20px !important;
  padding: 8px 20px !important;
  transition: all 0.3s ease !important;
}

.login-btn:hover {
  background: rgba(255, 255, 255, 0.1) !important;
  border-color: white !important;
  transform: translateY(-2px);
}

.register-btn {
  background: rgba(255, 255, 255, 0.2) !important;
  border: 2px solid rgba(255, 255, 255, 0.3) !important;
  color: white !important;
  border-radius: 20px !important;
  padding: 8px 20px !important;
  transition: all 0.3s ease !important;
}

.register-btn:hover {
  background: white !important;
  color: #667eea !important;
  transform: translateY(-2px);
}

/* 用户信息区域 */
.user-section {
  height: 60px;
  display: flex;
  align-items: center;
}

.user-dropdown {
  cursor: pointer;
  height: 100%;
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 16px;
  border-radius: 25px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.avatar-wrapper {
  position: relative;
}

.user-avatar {
  width: 35px;
  height: 35px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.online-indicator {
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 10px;
  height: 10px;
  background: #4ade80;
  border-radius: 50%;
  border: 2px solid white;
  animation: pulse 2s infinite;
}

.user-name {
  color: white;
  font-weight: 500;
  font-size: 14px;
}

.dropdown-icon {
  color: white;
  transition: transform 0.3s ease;
}

.user-info:hover .dropdown-icon {
  transform: rotate(180deg);
}

/* 下拉菜单美化 */
:deep(.custom-dropdown-menu) {
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  border-radius: 12px !important;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1) !important;
  padding: 8px !important;
  min-width: 180px !important;
}

:deep(.dropdown-item) {
  display: flex !important;
  align-items: center !important;
  gap: 10px !important;
  padding: 12px 16px !important;
  border-radius: 8px !important;
  transition: all 0.3s ease !important;
  font-size: 14px !important;
  margin-bottom: 4px !important;
}

:deep(.dropdown-item:hover) {
  background: linear-gradient(135deg, #667eea, #764ba2) !important;
  color: white !important;
  transform: translateX(4px);
}

:deep(.logout-item:hover) {
  background: linear-gradient(135deg, #ef4444, #dc2626) !important;
}

.item-icon {
  font-size: 16px;
  width: 20px;
  text-align: center;
}

/* 主体内容区域 */
.main-body {
  flex: 1;
  min-height: calc(100vh - 70px - 200px);
  background: transparent;
}

/* 页脚美化 */
.custom-footer {
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  color: white;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 20px;
}

.footer-top {
  margin-bottom: 30px;
}

.footer-logo-section {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
  margin-bottom: 30px;
}

.footer-logo {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.footer-title {
  font-size: 20px;
  font-weight: 600;
  background: linear-gradient(135deg, #74b9ff, #0984e3);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.footer-middle {
  margin-bottom: 30px;
}

.contact-info {
  display: flex;
  justify-content: center;
  gap: 40px;
  flex-wrap: wrap;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.contact-icon {
  font-size: 16px;
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 20px;
}

.copyright {
  text-align: center;
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
}

/* 动画效果 */
@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(74, 222, 128, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(74, 222, 128, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(74, 222, 128, 0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .front-header {
    padding: 0 15px;
    height: 60px;
    flex-direction: column;
    height: auto;
    padding: 15px;
  }

  .front-header-center {
    margin: 10px 0;
    width: 100%;
  }

  :deep(.custom-menu) {
    flex-wrap: wrap;
    justify-content: center;
  }

  :deep(.custom-menu .el-menu-item) {
    margin: 2px;
    font-size: 12px;
  }

  .title {
    font-size: 16px;
  }

  .contact-info {
    flex-direction: column;
    gap: 15px;
    text-align: center;
  }

  .footer-content {
    padding: 30px 15px 15px;
  }
}

@media (max-width: 480px) {
  .logo-section {
    gap: 8px;
  }

  .logo-img {
    width: 35px;
    height: 35px;
  }

  .title {
    font-size: 14px;
  }

  .user-name {
    display: none;
  }

  .auth-buttons {
    gap: 8px;
  }

  .login-btn, .register-btn {
    padding: 6px 12px !important;
    font-size: 12px !important;
  }
}
</style>