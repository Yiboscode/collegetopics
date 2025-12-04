<template>
  <div>
    <!-- 统计卡片 -->
    <div style="display: flex; align-items: center; grid-gap: 10px; margin-bottom: 10px">
      <!-- 创业项目统计 -->
      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">创业项目数量</div>
          <div style="font-size: 20px"> {{data.count.project}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">用户数量</div>
          <div style="font-size: 20px"> {{data.count.teacher}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">项目种类</div>
          <div style="font-size: 20px"> {{data.count.classify}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">项目累计报名人数</div>
          <div style="font-size: 20px"> {{data.count.enroll}}</div>
        </div>
      </div>
    </div>

    <!-- 选题统计卡片 -->
    <div style="display: flex; align-items: center; grid-gap: 10px; margin-bottom: 10px">
      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">选题总数</div>
          <div style="font-size: 20px"> {{data.topicStats.totalTopics || 0}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">评价总数</div>
          <div style="font-size: 20px"> {{data.topicStats.totalEvaluations || 0}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">平均评分</div>
          <div style="font-size: 20px"> {{data.topicStats.averageScore || 0}}</div>
        </div>
      </div>

      <div class="card" style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px 0">
        <div style="text-align: center; font-size: 20px">
          <div style="margin-bottom: 10px">本月新增</div>
          <div style="font-size: 20px"> {{data.topicStats.thisMonthTopics || 0}}</div>
        </div>
      </div>
    </div>

    <!-- 切换标签 -->
    <el-tabs v-model="activeTab" @tab-change="handleTabChange" style="margin-bottom: 10px">
      <el-tab-pane label="创业项目统计" name="project">
    <div style="display: flex; grid-gap: 10px">
      <div class="card" style="flex: 1; padding: 40px">
        <div style="height: 500px;" id="line"></div>
      </div>
      <div class="card" style="flex: 1; padding: 40px">
        <div style="height: 500px;" id="pie"></div>
      </div>
    </div>
      </el-tab-pane>

      <el-tab-pane label="选题管理统计" name="topic">
        <div style="display: flex; grid-gap: 10px; margin-bottom: 10px">
          <div class="card" style="flex: 1; padding: 40px">
            <div style="height: 400px;" id="topicCategory"></div>
          </div>
          <div class="card" style="flex: 1; padding: 40px">
            <div style="height: 400px;" id="topicStatus"></div>
          </div>
        </div>
        <div style="display: flex; grid-gap: 10px">
          <div class="card" style="flex: 1; padding: 40px">
            <div style="height: 400px;" id="topicTrend"></div>
          </div>
          <div class="card" style="flex: 1; padding: 40px">
            <div style="height: 400px;" id="evaluationScore"></div>
          </div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="月度趋势分析" name="monthly">
        <div class="card" style="padding: 40px">
          <div style="height: 500px;" id="monthlyTopic"></div>
        </div>
      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<script setup>

import {onMounted, reactive, ref} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import * as echarts from "echarts";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  noticeData: [],
  count: {},
  topicStats: {}
})

const activeTab = ref('project')

// 加载基础统计数据
request.get('/count').then(res => {
  data.count = res.data
})

// 加载选题统计数据
request.get('/echarts/topicStats').then(res => {
  data.topicStats = res.data
})

const loadPie = () => {
  request.get('/echarts/pie').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('pie')
      let myChart = echarts.init(chartDom)
      pieOptions.series[0].data = res.data
      myChart.setOption(pieOptions)
    } else {
      ElMessage.error(res.msg)
    }
  })
}


const loadLine = () =>{
  request.get('/echarts/line').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('line')
      let myChart = echarts.init(chartDom)
      lineOption.xAxis.data = res.data.xAxis
      lineOption.series[0].data = res.data.yAxis
      myChart.setOption(lineOption)
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 选题分类统计
const loadTopicCategory = () => {
  request.get('/echarts/topicCategory').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('topicCategory')
      if (chartDom) {
        let myChart = echarts.init(chartDom)
        topicCategoryOption.series[0].data = res.data
        myChart.setOption(topicCategoryOption)
      }
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 选题状态统计
const loadTopicStatus = () => {
  request.get('/echarts/topicStatus').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('topicStatus')
      if (chartDom) {
        let myChart = echarts.init(chartDom)
        topicStatusOption.series[0].data = res.data
        myChart.setOption(topicStatusOption)
      }
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 选题提交趋势
const loadTopicTrend = () => {
  request.get('/echarts/topicTrend').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('topicTrend')
      if (chartDom) {
        let myChart = echarts.init(chartDom)
        topicTrendOption.xAxis.data = res.data.xAxis
        topicTrendOption.series[0].data = res.data.yAxis
        myChart.setOption(topicTrendOption)
      }
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 评价分数分布
const loadEvaluationScore = () => {
  request.get('/echarts/evaluationScore').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('evaluationScore')
      if (chartDom) {
        let myChart = echarts.init(chartDom)
        evaluationScoreOption.xAxis.data = res.data.xAxis
        evaluationScoreOption.series[0].data = res.data.yAxis
        myChart.setOption(evaluationScoreOption)
      }
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 月度选题统计
const loadMonthlyTopic = () => {
  request.get('/echarts/monthlyTopic').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('monthlyTopic')
      if (chartDom) {
        let myChart = echarts.init(chartDom)
        monthlyTopicOption.xAxis.data = res.data.xAxis
        monthlyTopicOption.series[0].data = res.data.yAxis
        myChart.setOption(monthlyTopicOption)
      }
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 标签切换处理
const handleTabChange = (tabName) => {
  setTimeout(() => {
    if (tabName === 'topic') {
      loadTopicCategory()
      loadTopicStatus()
      loadTopicTrend()
      loadEvaluationScore()
    } else if (tabName === 'monthly') {
      loadMonthlyTopic()
    }
  }, 100)
}

onMounted(() => {
  loadPie()
  loadLine()
})

//折线图

const lineOption = {
  title: {
    text: '近一周创业活动报名数量统计图',
    left: 'center',
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    left: 'left'
  },
  xAxis: {
    name: '日期',
    type: 'category',
    data: []
  },
  yAxis: {
    name: '人数/个',
    type: 'value'
  },
  series: [
    {
      data: [],
      type: 'line',
      smooth: true,
      areaStyle: {
        opacity: 0.5, // 阴影的透明度
        color: 'rgb(185,190,255)' // 阴影的颜色和透明度
      },
      markPoint: {
        data: [
          {type: 'max', name: 'Max'},
          {type: 'min', name: 'Min'}
        ]
      },
      // markLine: {
      //   data: [{type: 'average', name: 'Avg'}]
      // }
    },
  ]
}


//饼图
let pieOptions = {
  title: {
    text: '每个分类的创业项目数量',
    subtext: '比例图',
    left: 'center'
  },
  tooltip: {
    trigger: 'item'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      type: 'pie',
      radius: '50%',
      center: ['60%', '60%'],
      data: [],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }
  ]
}

// 选题分类饼图
const topicCategoryOption = {
  title: {
    text: '选题分类分布',
    subtext: '按分类统计',
    left: 'center'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b}: {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '选题分类',
      type: 'pie',
      radius: ['40%', '70%'],
      center: ['60%', '60%'],
      data: [],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }
  ]
}

// 选题状态饼图
const topicStatusOption = {
  title: {
    text: '选题状态分布',
    subtext: '按状态统计',
    left: 'center'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b}: {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '选题状态',
      type: 'pie',
      radius: '50%',
      center: ['60%', '60%'],
      data: [],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }
  ]
}

// 选题提交趋势折线图
const topicTrendOption = {
  title: {
    text: '近一周选题提交趋势',
    left: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    left: 'left'
  },
  xAxis: {
    name: '日期',
    type: 'category',
    data: []
  },
  yAxis: {
    name: '提交数量',
    type: 'value'
  },
  series: [
    {
      name: '选题提交数',
      data: [],
      type: 'line',
      smooth: true,
      areaStyle: {
        opacity: 0.3,
        color: 'rgb(135,206,250)'
      },
      markPoint: {
        data: [
          {type: 'max', name: 'Max'},
          {type: 'min', name: 'Min'}
        ]
      }
    }
  ]
}

// 评价分数分布柱状图
const evaluationScoreOption = {
  title: {
    text: '评价分数分布',
    left: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  xAxis: {
    name: '分数区间',
    type: 'category',
    data: []
  },
  yAxis: {
    name: '数量',
    type: 'value'
  },
  series: [
    {
      name: '评价数量',
      data: [],
      type: 'bar',
      itemStyle: {
        color: 'rgb(135,206,250)'
      },
      markPoint: {
        data: [
          {type: 'max', name: 'Max'},
          {type: 'min', name: 'Min'}
        ]
      }
    }
  ]
}

// 月度选题统计柱状图
const monthlyTopicOption = {
  title: {
    text: '最近12个月选题提交统计',
    left: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  xAxis: {
    name: '月份',
    type: 'category',
    data: [],
    axisLabel: {
      rotate: 45
    }
  },
  yAxis: {
    name: '选题数量',
    type: 'value'
  },
  series: [
    {
      name: '选题数量',
      data: [],
      type: 'bar',
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          {offset: 0, color: 'rgb(135,206,250)'},
          {offset: 1, color: 'rgb(30,144,255)'}
        ])
      },
      markLine: {
        data: [{type: 'average', name: 'Avg'}]
      }
    }
  ]
}


</script>