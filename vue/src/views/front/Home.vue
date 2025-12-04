<template>
  <div class="main-content">
    <!-- 轮播图区域 -->
    <div class="carousel-section">
      <el-carousel height="400px" class="custom-carousel">
        <el-carousel-item
            v-for="item in data.carouselList"
            :key="item.id"
            @click="router.push('/front/projectDetail?id=' + item.projectId)"
            class="carousel-item">
          <div class="carousel-image-wrapper">
            <img :src="item.img" alt="" class="carousel-image">
            <div class="carousel-overlay">
              <div class="carousel-content">
                <h3 class="carousel-title">探索创业机会</h3>
                <p class="carousel-subtitle">点击查看详情</p>
              </div>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <!-- 主要功能区域 -->
    <div class="hero-section">
      <div class="hero-background">
        <div class="hero-content">
          <h1 class="hero-title">我敢闯 我会创</h1>
          <p class="hero-subtitle">大学生创业梦想启航的地方</p>
          <div class="action-buttons">
            <div class="button-wrapper">
              <el-button size="large" class="action-btn excellent-btn" @click="router.push('/front/excellentTopics')">
                <span class="btn-icon">🏆</span>
                <span>优秀选题</span>
              </el-button>
            </div>
            <div class="button-wrapper">
              <el-button size="large" class="action-btn promote-btn" @click="router.push('/front/promote')">
                <span class="btn-icon">📢</span>
                <span>创业宣传</span>
              </el-button>
            </div>
            <div class="button-wrapper">
              <el-button size="large" class="action-btn qa-btn" @click="router.push('/front/qa')">
                <span class="btn-icon">💬</span>
                <span>创业问答</span>
              </el-button>
            </div>
            <div class="button-wrapper">
              <el-button size="large" class="action-btn topic-btn" @click="router.push('/front/topic')">
                <span class="btn-icon">📝</span>
                <span>我的选题</span>
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 优秀选题展示区域 -->
    <div class="excellent-topics-section">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-text">优 秀 选 题</span>
          <div class="title-underline"></div>
        </h2>
        <div class="view-all-link" @click="router.push('/front/excellentTopics')">
          查看全部 →
        </div>
      </div>

      <el-row :gutter="20" class="topics-grid">
        <el-col :span="6" v-for="item in data.excellentTopicList" :key="item.id" class="topic-col">
          <div class="topic-card" @click="viewTopicDetail(item)">
            <div class="card-image-wrapper">
              <img
                  :src="item.imageUrl || '/src/assets/imgs/1748334301734-万物有灵 创业项目.png'"
                  alt=""
                  class="card-image">
              <div class="card-overlay">
                <div class="overlay-content">
                  <span class="view-detail">查看详情</span>
                </div>
              </div>
            </div>
            <div class="card-content">
              <div class="card-title">
                <span class="category-tag">{{ item.category }}</span>
                <span class="separator">|</span>
                <span class="card-title-text">{{ item.title }}</span>
              </div>
              <div class="card-footer">
                <div class="award-info">{{ item.awardInfo }}</div>
                <div class="year-badge">{{ item.year }}年</div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 大赛动态区域 -->
    <div class="competition-section">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-text">大 赛 动 态</span>
          <div class="title-underline"></div>
        </h2>
      </div>

      <el-row :gutter="30" class="competition-grid">
        <el-col :span="12" v-for="item in data.competitionList" :key="item.id" class="competition-col">
          <div class="competition-card" @click="router.push('/front/competitionDetail?id=' +item.id)">
            <div class="competition-image-wrapper">
              <img :src="item.img" alt="" class="competition-image">
              <div class="image-overlay">
                <div class="play-icon">▶</div>
              </div>
            </div>
            <div class="competition-content">
              <h3 class="competition-title">{{ item.title }}</h3>
              <p class="competition-intro">{{ item.introduce }}</p>
              <div class="competition-meta">
                <div class="meta-item">
                  <span class="meta-icon">👁️</span>
                  <span class="meta-text">{{ item.views }}</span>
                </div>
                <div class="meta-item">
                  <span class="meta-icon">📅</span>
                  <span class="meta-text">{{ item.time }}</span>
                </div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 选题详情对话框 -->
    <el-dialog
        v-model="data.detailVisible"
        :title="data.selectedTopic?.title"
        width="70%"
        class="custom-dialog"
        :before-close="handleDetailClose"
    >
      <div v-if="data.selectedTopic" class="dialog-content">
        <el-descriptions :column="2" border class="custom-descriptions">
          <el-descriptions-item label="选题名称" :span="2" class="title-item">
            <span class="topic-name">{{ data.selectedTopic.title }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="分类">
            <el-tag type="primary" class="category-tag-dialog">{{ data.selectedTopic.category }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="年份">
            <span class="year-text">{{ data.selectedTopic.year }}年</span>
          </el-descriptions-item>
          <el-descriptions-item label="获奖情况" :span="2">
            <span class="award-text">{{ data.selectedTopic.awardInfo }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="选题描述" :span="2">
            <div class="description-text">{{ data.selectedTopic.description }}</div>
          </el-descriptions-item>
          <el-descriptions-item label="相关标签" :span="2" v-if="data.selectedTopic.tags">
            <div class="tags-container">
              <el-tag
                  v-for="tag in data.selectedTopic.tags.split(',')"
                  :key="tag"
                  size="small"
                  effect="plain"
                  class="tag-item"
              >
                {{ tag.trim() }}
              </el-tag>
            </div>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleDetailClose" class="footer-btn">关 闭</el-button>
          <el-button type="primary" @click="router.push('/front/excellentTopics')" class="footer-btn primary">
            查看更多
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive } from "vue";
import request from "@/utils/request.js";
import {ElMessage, ElMessageBox} from "element-plus";
import router from "@/router/index.js";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  carouselList:[],
  pageNum: 1,
  pageSize: 4,
  total: 0,
  excellentTopicList:[],
  selectedTopic: null,
  detailVisible: false
})

const loadCarousel = () => {
  request.get('/carousel/selectAll').then(res => {
    if(res.code === '200') {
      data.carouselList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadCarousel()

const loadExcellentTopic = () => {
  request.get('/excellentTopic/selectPage', {
    params: {
      pageNum: data.pageNum,
      pageSize: data.pageSize,
    }
  }).then(res => {
    if (res.code === '200') {
      data.excellentTopicList = res.data?.list || []
      data.total = res.data?.total
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadExcellentTopic()

const loadCompetition = () => {
  request.get('/competition/selectAll').then(res => {
    if (res.code === '200') {
      data.competitionList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadCompetition()

const updateViews = () => {
  request.get('/competition/updateViews/' + data.id).then(res => {
    if (res.code === '200') {
      loadCompetition()
    }
  })
}
updateViews()

// 查看选题详情
const viewTopicDetail = (topic) => {
  data.selectedTopic = topic
  data.detailVisible = true
}

// 关闭详情对话框
const handleDetailClose = () => {
  data.detailVisible = false
  data.selectedTopic = null
}
</script>

<style scoped>
.main-content {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: 100vh;
}

/* 轮播图区域 */
.carousel-section {
  margin-bottom: 0;
  position: relative;
}

.custom-carousel {
  border-radius: 0 0 20px 20px;
  overflow: hidden;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
}

.carousel-item {
  cursor: pointer;
  position: relative;
}

.carousel-image-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.carousel-item:hover .carousel-image {
  transform: scale(1.05);
}

.carousel-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.carousel-item:hover .carousel-overlay {
  opacity: 1;
}

.carousel-content {
  text-align: center;
  color: white;
}

.carousel-title {
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 10px;
}

.carousel-subtitle {
  font-size: 16px;
  opacity: 0.9;
}

/* 主要功能区域 */
.hero-section {
  margin-bottom: 60px;
  position: relative;
}

.hero-background {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 80px 0;
  position: relative;
  overflow: hidden;
}

.hero-background::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><circle cx="10" cy="10" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="30" cy="5" r="1.5" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="15" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="70" cy="8" r="1.2" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="12" r="1" fill="rgba(255,255,255,0.1)"/></svg>');
  animation: float 20s linear infinite;
}

@keyframes float {
  0% { transform: translateX(-100px); }
  100% { transform: translateX(100vw); }
}

.hero-content {
  text-align: center;
  position: relative;
  z-index: 2;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.hero-title {
  font-size: 48px;
  color: white;
  font-weight: 700;
  margin-bottom: 15px;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  letter-spacing: 2px;
}

.hero-subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 50px;
  font-weight: 300;
}

.action-buttons {
  display: flex;
  justify-content: center;
  gap: 30px;
  flex-wrap: wrap;
}

.button-wrapper {
  animation: fadeInUp 0.6s ease-out;
}

.button-wrapper:nth-child(1) { animation-delay: 0.1s; }
.button-wrapper:nth-child(2) { animation-delay: 0.2s; }
.button-wrapper:nth-child(3) { animation-delay: 0.3s; }
.button-wrapper:nth-child(4) { animation-delay: 0.4s; }

.action-btn {
  height: 60px !important;
  padding: 0 30px !important;
  border-radius: 30px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  border: 2px solid rgba(255, 255, 255, 0.3) !important;
  background: rgba(255, 255, 255, 0.1) !important;
  color: white !important;
  backdrop-filter: blur(10px) !important;
  transition: all 0.3s ease !important;
  display: flex !important;
  align-items: center !important;
  gap: 8px !important;
}

.action-btn:hover {
  transform: translateY(-5px) !important;
  background: white !important;
  color: #667eea !important;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2) !important;
}

.btn-icon {
  font-size: 18px;
}

/* 区域标题样式 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
  padding: 0 20px;
}

.section-title {
  position: relative;
  margin: 0;
}

.title-text {
  font-size: 32px;
  font-weight: 700;
  color: #2c3e50;
  letter-spacing: 3px;
}

.title-underline {
  width: 60px;
  height: 4px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  margin: 10px auto 0;
  border-radius: 2px;
}

.view-all-link {
  color: #667eea;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  padding: 8px 16px;
  border-radius: 20px;
  border: 1px solid transparent;
}

.view-all-link:hover {
  color: #764ba2;
  background: rgba(102, 126, 234, 0.1);
  border-color: #667eea;
}

/* 优秀选题区域 */
.excellent-topics-section {
  padding: 60px 20px;
  background: white;
  margin: 0 20px 60px;
  border-radius: 20px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.topics-grid {
  margin: 0 !important;
}

.topic-col {
  margin-bottom: 30px;
  padding: 0 10px !important;
}

.topic-card {
  background: white;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.topic-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.card-image-wrapper {
  position: relative;
  height: 220px;
  overflow: hidden;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.topic-card:hover .card-image {
  transform: scale(1.1);
}

.card-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(102, 126, 234, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.topic-card:hover .card-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
  color: white;
}

.view-detail {
  font-size: 16px;
  font-weight: 600;
  padding: 10px 20px;
  border: 2px solid white;
  border-radius: 25px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.card-content {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-title {
  font-size: 16px;
  line-height: 24px;
  margin-bottom: 15px;
  height: 48px;
  display: flex;
  align-items: flex-start;
  gap: 8px;
}

.category-tag {
  color: #667eea;
  font-weight: 600;
  flex-shrink: 0;
}

.separator {
  color: #ddd;
  flex-shrink: 0;
}

.card-title-text {
  color: #2c3e50;
  font-weight: 500;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: auto;
}

.award-info {
  color: #e6a23c;
  font-weight: 600;
  font-size: 14px;
  flex: 1;
}

.year-badge {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

/* 大赛动态区域 */
.competition-section {
  padding: 60px 20px;
  background: white;
  margin: 0 20px 40px;
  border-radius: 20px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.competition-grid {
  margin: 0 !important;
}

.competition-col {
  margin-bottom: 30px;
  padding: 0 15px !important;
}

.competition-card {
  display: flex;
  background: white;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  height: 180px;
}

.competition-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.competition-image-wrapper {
  position: relative;
  width: 240px;
  flex-shrink: 0;
  overflow: hidden;
}

.competition-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.competition-card:hover .competition-image {
  transform: scale(1.1);
}

.image-overlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.competition-card:hover .image-overlay {
  opacity: 1;
}

.play-icon {
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  color: #667eea;
  font-weight: bold;
}

.competition-content {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.competition-title {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 12px 0;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}

.competition-intro {
  color: #666;
  line-height: 22px;
  font-size: 14px;
  margin: 0 0 20px 0;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  flex: 1;
}

.competition-meta {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #999;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.meta-icon {
  font-size: 14px;
}

/* 对话框美化 */
:deep(.custom-dialog) {
  border-radius: 15px;
  overflow: hidden;
}

:deep(.custom-dialog .el-dialog__header) {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 20px 30px;
  border-bottom: none;
}

:deep(.custom-dialog .el-dialog__title) {
  font-size: 20px;
  font-weight: 600;
}

:deep(.custom-dialog .el-dialog__headerbtn) {
  top: 15px;
  right: 20px;
}

:deep(.custom-dialog .el-dialog__close) {
  color: white;
  font-size: 18px;
}

.dialog-content {
  padding: 30px;
}

:deep(.custom-descriptions) {
  border-radius: 10px;
  overflow: hidden;
}

:deep(.custom-descriptions .el-descriptions__label) {
  background: #f8f9fa;
  font-weight: 600;
  color: #2c3e50;
  width: 120px;
}

:deep(.custom-descriptions .el-descriptions__content) {
  background: white;
}

.topic-name {
  font-weight: 600;
  font-size: 18px;
  color: #2c3e50;
}

.category-tag-dialog {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  color: white;
  font-weight: 500;
}

.year-text {
  color: #667eea;
  font-weight: 600;
}

.award-text {
  color: #e6a23c;
  font-weight: 600;
  font-size: 16px;
}

.description-text {
  line-height: 26px;
  color: #606266;
  font-size: 15px;
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag-item {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  color: white;
  font-weight: 500;
}

.dialog-footer {
  padding: 20px 30px;
  background: #f8f9fa;
  display: flex;
  justify-content: flex-end;
  gap: 15px;
}

.footer-btn {
  padding: 10px 25px;
  border-radius: 20px;
  font-weight: 500;
}

.footer-btn.primary {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
}

/* 动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .hero-title {
    font-size: 32px;
  }

  .action-buttons {
    gap: 15px;
  }

  .action-btn {
    height: 50px !important;
    padding: 0 20px !important;
    font-size: 14px !important;
  }

  .topic-col {
    margin-bottom: 20px;
  }

  .competition-card {
    flex-direction: column;
    height: auto;
  }

  .competition-image-wrapper {
    width: 100%;
    height: 200px;
  }

  .section-header {
    flex-direction: column;
    gap: 20px;
    text-align: center;
  }

  .excellent-topics-section,
  .competition-section {
    margin: 0 10px 40px;
    padding: 40px 15px;
  }
}

@media (max-width: 480px) {
  .topic-col {
    padding: 0 5px !important;
  }

  .competition-col {
    padding: 0 5px !important;
  }

  .action-buttons {
    flex-direction: column;
    align-items: center;
  }

  .hero-content {
    padding: 0 15px;
  }
}
</style>
