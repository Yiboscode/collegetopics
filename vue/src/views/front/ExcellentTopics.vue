<template>
  <div class="excellent-topics">
    <!-- 标题和搜索区域 -->
    <div class="header-section">
      <el-row :gutter="20">
        <el-col :span="8">
          <h2 class="page-title">优秀选题库</h2>
          <p class="page-subtitle">学习优秀案例，启发创新思维</p>
        </el-col>
        <el-col :span="16">
          <div class="search-section">
            <el-row :gutter="15">
              <el-col :span="8">
                <el-input
                  v-model="form.title"
                  placeholder="搜索选题名称"
                  clearable
                  @clear="search"
                  @keyup.enter="search"
                >
                  <template #prefix>
                    <el-icon><Search /></el-icon>
                  </template>
                </el-input>
              </el-col>
              <el-col :span="6">
                <el-select v-model="form.category" placeholder="选择分类" clearable @change="search">
                  <el-option
                    v-for="category in categories"
                    :key="category"
                    :label="category"
                    :value="category"
                  />
                </el-select>
              </el-col>
              <el-col :span="6">
                <el-select v-model="form.year" placeholder="选择年份" clearable @change="search">
                  <el-option
                    v-for="year in years"
                    :key="year"
                    :label="year"
                    :value="year"
                  />
                </el-select>
              </el-col>
              <el-col :span="4">
                <el-button type="primary" @click="search" :icon="Search">搜索</el-button>
              </el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 统计信息 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ total }}</div>
            <div class="stat-label">优秀选题总数</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ categories.length }}</div>
            <div class="stat-label">涵盖分类</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ years.length }}</div>
            <div class="stat-label">年份跨度</div>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-number">{{ currentYear }}</div>
            <div class="stat-label">当前年份</div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 选题列表 -->
    <div class="content-section">
      <el-row :gutter="15">
        <el-col :span="24" v-if="tableData.length === 0">
          <el-empty description="暂无优秀选题数据" />
        </el-col>
        <el-col :span="6" v-for="topic in tableData" :key="topic.id" style="margin-bottom: 20px">
          <div class="card topic-card" @click="viewDetail(topic)">
            <!-- 图片部分 -->
            <div class="topic-image">
              <img 
                :src="topic.imageUrl || '/src/assets/imgs/1748334301734-万物有灵 创业项目.png'" 
                :alt="topic.title"
                @error="handleImageError"
              />
              <div class="image-overlay">
                <el-tag :type="getCategoryType(topic.category)" class="category-tag">
                  {{ topic.category }}
                </el-tag>
                <div class="year-badge">{{ topic.year }}年</div>
              </div>
            </div>
            
            <!-- 内容部分 -->
            <div class="topic-content">
              <h3 class="topic-title">{{ topic.title }}</h3>
              <p class="topic-description">{{ topic.description }}</p>
              
              <div class="topic-footer">
                <div class="award-info">
                  <el-icon class="award-icon"><Trophy /></el-icon>
                  <span class="award-text">{{ topic.awardInfo }}</span>
                </div>
                
                <div class="topic-tags" v-if="topic.tags">
                  <el-tag
                    v-for="(tag, index) in topic.tags.split(',').slice(0, 2)"
                    :key="tag"
                    size="small"
                    effect="plain"
                    class="tag-item"
                  >
                    {{ tag.trim() }}
                  </el-tag>
                  <span v-if="topic.tags.split(',').length > 2" class="more-tags">
                    +{{ topic.tags.split(',').length - 2 }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>

      <!-- 分页 -->
      <div class="pagination-section" v-if="total > 0">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[8, 16, 24, 32]"
          :small="false"
          :disabled="false"
          :background="true"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      :title="selectedTopic?.title"
      width="70%"
      :before-close="handleDetailClose"
    >
      <div class="topic-detail" v-if="selectedTopic">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="选题名称" :span="2">
            {{ selectedTopic.title }}
          </el-descriptions-item>
          <el-descriptions-item label="分类">
            <el-tag :type="getCategoryType(selectedTopic.category)">
              {{ selectedTopic.category }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="年份">
            {{ selectedTopic.year }}年
          </el-descriptions-item>
          <el-descriptions-item label="获奖情况" :span="2">
            {{ selectedTopic.awardInfo }}
          </el-descriptions-item>
          <el-descriptions-item label="选题描述" :span="2">
            <p class="detail-description">{{ selectedTopic.description }}</p>
          </el-descriptions-item>
          <el-descriptions-item label="标签" :span="2" v-if="selectedTopic.tags">
            <el-tag
              v-for="tag in selectedTopic.tags.split(',')"
              :key="tag"
              size="small"
              effect="plain"
              class="tag-item"
            >
              {{ tag.trim() }}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>

        <!-- 相似推荐 -->
        <div class="recommend-section" v-if="recommendTopics.length > 0">
          <h3>相似推荐</h3>
          <el-row :gutter="15">
            <el-col :span="8" v-for="topic in recommendTopics" :key="topic.id">
              <el-card class="recommend-card" @click="viewRecommend(topic)">
                <div class="recommend-title">{{ topic.title }}</div>
                <div class="recommend-info">
                  <span>{{ topic.category }}</span>
                  <span>{{ topic.year }}年</span>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { Search, Calendar, Trophy, User } from '@element-plus/icons-vue'
import request from '@/utils/request'

export default {
  name: 'ExcellentTopics',
  components: {
    Search,
    Calendar,
    Trophy,
    User
  },
  data() {
    return {
      form: {
        title: '',
        category: '',
        year: null
      },
      tableData: [],
      categories: [],
      years: [],
      total: 0,
      pageNum: 1,
      pageSize: 8,
      detailVisible: false,
      selectedTopic: null,
      recommendTopics: [],
      currentYear: new Date().getFullYear()
    }
  },
  mounted() {
    this.loadData()
    this.loadCategories()
    this.loadYears()
  },
  methods: {
    loadData() {
      request.get('/excellentTopic/selectPage', {
        params: {
          ...this.form,
          pageNum: this.pageNum,
          pageSize: this.pageSize
        }
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data.list || res.data.records || []
          this.total = res.data.total || 0
          console.log('优秀选题数据:', res.data) // 调试用
        } else {
          this.$message.error(res.msg || '加载数据失败')
        }
      }).catch(err => {
        console.error('加载优秀选题数据失败:', err)
        this.$message.error('加载数据失败')
      })
    },
    loadCategories() {
      request.get('/excellentTopic/categories').then(res => {
        if (res.code === '200') {
          this.categories = res.data || []
        }
      }).catch(err => {
        console.error('加载分类失败:', err)
      })
    },
    loadYears() {
      request.get('/excellentTopic/years').then(res => {
        if (res.code === '200') {
          this.years = res.data || []
        }
      }).catch(err => {
        console.error('加载年份失败:', err)
      })
    },
    search() {
      this.pageNum = 1
      this.loadData()
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.loadData()
    },
    handleCurrentChange(val) {
      this.pageNum = val
      this.loadData()
    },
    getCategoryType(category) {
      const types = {
        '科技创新': 'primary',
        '社会公益': 'success',
        '文化创意': 'warning',
        '商业模式': 'danger',
        '环境保护': 'info'
      }
      return types[category] || ''
    },
    viewDetail(topic) {
      this.selectedTopic = topic
      this.detailVisible = true
      this.loadRecommendations(topic)
    },
    viewRecommend(topic) {
      this.selectedTopic = topic
      this.loadRecommendations(topic)
    },
    loadRecommendations(topic) {
      request.get('/excellentTopic/recommend', {
        params: {
          keywords: topic.title,
          category: topic.category,
          limit: 3
        }
      }).then(res => {
        if (res.code === '200') {
          this.recommendTopics = (res.data || []).filter(item => item.id !== topic.id)
        }
      }).catch(err => {
        console.error('加载推荐失败:', err)
      })
    },
    handleDetailClose() {
      this.detailVisible = false
      this.selectedTopic = null
      this.recommendTopics = []
    },
    handleImageError(event) {
      // 图片加载失败时使用默认图片
      event.target.src = '/src/assets/imgs/1748334301734-万物有灵 创业项目.png'
    }
  }
}
</script>

<style scoped>
.excellent-topics {
  padding: 20px;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.header-section {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.page-title {
  margin: 0 0 8px 0;
  color: #1f2937;
  font-size: 28px;
  font-weight: 600;
}

.page-subtitle {
  margin: 0;
  color: #6b7280;
  font-size: 14px;
}

.search-section {
  margin-top: 20px;
}

.stats-section {
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.stat-number {
  font-size: 24px;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 5px;
}

.stat-label {
  color: #6b7280;
  font-size: 12px;
}

.content-section {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.topic-card {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
  overflow: hidden;
  padding: 0;
  position: relative;
}

.topic-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
}

.topic-image {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
}

.topic-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.topic-card:hover .topic-image img {
  transform: scale(1.05);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0.1), rgba(0,0,0,0.3));
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 12px;
}

.category-tag {
  background: rgba(255, 255, 255, 0.9);
  border: none;
  font-weight: 500;
}

.year-badge {
  background: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.topic-content {
  padding: 16px;
}

.topic-title {
  font-size: 16px;
  font-weight: 600;
  color: #1f2937;
  margin: 0 0 8px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.topic-description {
  font-size: 13px;
  color: #6b7280;
  line-height: 1.5;
  margin: 0 0 12px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.topic-footer {
  border-top: 1px solid #f3f4f6;
  padding-top: 12px;
}

.award-info {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.award-icon {
  color: #f59e0b;
  margin-right: 6px;
  font-size: 14px;
}

.award-text {
  font-size: 12px;
  color: #4b5563;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  flex: 1;
}

.topic-tags {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
}

.tag-item {
  font-size: 11px;
  height: 20px;
  line-height: 18px;
  border-radius: 10px;
}

.more-tags {
  font-size: 11px;
  color: #9ca3af;
  background: #f3f4f6;
  padding: 2px 6px;
  border-radius: 8px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.topic-title {
  font-weight: 600;
  color: #1f2937;
  font-size: 16px;
}

.topic-content {
  padding: 0;
}

.topic-description {
  color: #6b7280;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 15px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.topic-info {
  margin-bottom: 15px;
}

.info-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  font-size: 12px;
  color: #6b7280;
}

.info-icon {
  margin-right: 6px;
  color: #9ca3af;
}

.topic-tags {
  margin-top: 15px;
}

.tag-item {
  margin-right: 8px;
  margin-bottom: 5px;
}

.pagination-section {
  margin-top: 30px;
  text-align: center;
}

.topic-detail {
  padding: 20px 0;
}

.detail-description {
  line-height: 1.8;
  color: #374151;
  margin: 0;
}

.recommend-section {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #e5e7eb;
}

.recommend-section h3 {
  margin: 0 0 15px 0;
  color: #1f2937;
  font-size: 18px;
}

.recommend-card {
  cursor: pointer;
  transition: all 0.3s ease;
}

.recommend-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.recommend-title {
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 8px;
  font-size: 14px;
}

.recommend-info {
  font-size: 12px;
  color: #6b7280;
}

.recommend-info span {
  margin-right: 10px;
}
</style> 