import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/login' },
    {
      path: '/manager',
      component: () => import('@/views/Manager.vue'),
      children: [
        { path: 'home', meta: { name: '系统首页' }, component: () => import('@/views/manager/Home.vue'),  },
        { path: 'admin', meta: { name: '管理员信息' }, component: () => import('@/views/manager/Admin.vue'), },
        { path: 'user', meta: { name: '用户信息' }, component: () => import('@/views/manager/User.vue'), },
        { path: 'teacher', meta: { name: '教师信息' }, component: () => import('@/views/manager/Teacher.vue'), },
        { path: 'notice', meta: { name: '系统公告' }, component: () => import('@/views/manager/Notice.vue'), },
        { path: 'person', meta: { name: '个人资料' }, component: () => import('@/views/manager/Person.vue'), },
        { path: 'password', meta: { name: '修改密码' }, component: () => import('@/views/manager/Password.vue'), },
        { path: 'certify', meta: { name: '认证信息' }, component: () => import('@/views/manager/Certify.vue')},
        { path: 'frontCertify', meta: { name: '我的认证' }, component: () => import('@/views/manager/FrontCertify.vue')},
        { path: 'classify', meta: { name: '分类信息' }, component: () => import('@/views/manager/Classify.vue')},
        { path: 'collect', meta: { name: '收藏信息' }, component: () => import('@/views/manager/Collect.vue')},
        { path: 'competition', meta: { name: '大赛动态' }, component: () => import('@/views/manager/Competition.vue')},
        { path: 'enroll', meta: { name: '报名信息' }, component: () => import('@/views/manager/Enroll.vue')},
        // { path: 'project', meta: { name: '创业项目' }, component: () => import('@/views/manager/Project.vue')},
        { path: 'promote', meta: { name: '宣传视频信息' }, component: () => import('@/views/manager/Promote.vue')},
        { path: 'submit', meta: { name: '任务成果' }, component: () => import('@/views/manager/Submit.vue')},
        { path: 'task', meta: { name: '任务信息' }, component: () => import('@/views/manager/Task.vue')},
        { path: 'carousel', meta: { name: '轮播图信息' }, component: () => import('@/views/manager/Carousel.vue')},
        { path: 'qa', meta: { name: '创业问答' }, component: () => import('@/views/manager/Qa.vue')},
        { path: 'data', meta: { name: '数据统计' }, component: () => import('@/views/manager/Data.vue')},
        // 选题管理相关路由
        { path: 'topic', meta: { name: '选题管理' }, component: () => import('@/views/manager/Topic.vue')},
        { path: 'topicEvaluation', meta: { name: '选题评价' }, component: () => import('@/views/manager/TopicEvaluation.vue')},
        { path: 'innovationEvaluation', meta: { name: '创新能力评价' }, component: () => import('@/views/manager/InnovationEvaluation.vue')},
        { path: 'excellentTopic', meta: { name: '优秀选题库' }, component: () => import('@/views/manager/ExcellentTopic.vue')},
        // 团队管理相关路由
        { path: 'teamManage', meta: { name: '团队管理' }, component: () => import('@/views/manager/TeamManage.vue')},
      ]
    },
    {
      path: '/front',
      component: () => import('@/views/Front.vue'),
      children: [
        { path: 'home', component: () => import('@/views/front/Home.vue'),  },
        { path: 'person', component: () => import('@/views/front/Person.vue'),  },
        { path: 'notice', component: () => import('@/views/front/Notice.vue'),  },
        { path: 'password', component: () => import('@/views/front/Password.vue'),  },
        { path: 'project', component: () => import('@/views/front/Project.vue'),  },
        { path: 'projectDetail', component: () => import('@/views/front/ProjectDetail.vue'),  },
        { path: 'promote', component: () => import('@/views/front/Promote.vue'),  },
        { path: 'promoteDetail', component: () => import('@/views/front/PromoteDetail.vue'),  },
        { path: 'qa', component: () => import('@/views/front/Qa.vue'),  },
        { path: 'myQa', component: () => import('@/views/front/MyQa.vue'),  },
        { path: 'collect', component: () => import('@/views/front/Collect.vue'),  },
        { path: 'enroll', component: () => import('@/views/front/Enroll.vue'),  },
        { path: 'task', component: () => import('@/views/front/Task.vue'),  },
        { path: 'competitionDetail', component: () => import('@/views/front/CompetitionDetail.vue'),  },
        { path: 'submit', component: () => import('@/views/front/Submit.vue'),  },
        // 选题相关路由
        { path: 'topic', component: () => import('@/views/front/Topic.vue'),  },
        { path: 'topicSubmit', component: () => import('@/views/front/TopicSubmit.vue'),  },
        { path: 'topicDetail/:id', component: () => import('@/views/front/TopicDetail.vue'),  },
        { path: 'excellentTopics', component: () => import('@/views/front/ExcellentTopics.vue'),  },
        { path: 'myEvaluation', component: () => import('@/views/front/MyEvaluation.vue'),  },
        // 团队相关路由
        { path: 'team', component: () => import('@/views/front/Team.vue'),  },
      ]
    },
    { path: '/login', component: () => import('@/views/Login.vue') },
    { path: '/register', component: () => import('@/views/Register.vue') },
    { path: '/404', component: () => import('@/views/404.vue') },
    { path: '/:pathMatch(.*)', redirect: '/404' }
  ]
})

router.afterEach(() => {
  setTimeout(() => {
    window.scrollTo({top: 0, behavior: 'smooth'})
  }, 0)
})


export default router
