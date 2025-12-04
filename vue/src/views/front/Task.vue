<template>
  <div class="main-content">
    <div>
      <div>
        <el-row :gutter="20">
          <el-col :span="8" v-for="item in data.taskList" :key="item.id">
            <div class="card" style="margin-bottom: 20px; padding: 20px">
              <div style="font-size: 20px; font-weight: bold; cursor: pointer" class="line1">{{ item.title }}</div>
              <div style="margin-top: 10px; line-height: 20px; height: 60px; color: #666" class="line3">{{ item.detail }}</div>
              <!-- 新增查看详情按钮 -->
              <div style="font-size: 12px; color: #0066ff; cursor: pointer" @click="openDetailDialog(item.detail)">查看详情</div>
              <div style="margin-top: 10px; color: #666; font-size: 13px">
                <div>指导老师：<span style="margin-left: 5px">{{ item.teacherName }}</span></div>
                <div>发布时间：<span style="margin-left: 5px">{{ item.time }}</span></div>
                <div class="line1" style="margin-bottom: 10px">项目名称：<span style="margin-left: 5px">{{ item.projectTitle }}</span></div>
                <div  style="text-align: center"><el-button type="primary" @click="handleAdd(item.id,item.teacherId)">成果提交</el-button></div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 详情弹窗 -->
      <el-dialog title="任务详情" v-model="data.dialogVisible" width="50%" :close-on-click-modal="false">
        <div style="padding: 20px">{{ data.detailContent }}</div>
        <template #footer>
          <el-button @click="data.dialogVisible = false">关闭</el-button>
        </template>
      </el-dialog>

      <el-dialog title="成果信息" v-model="data.formVisible" width="50%" destroy-on-close>
        <el-form el-form ref="formRef" :model="data.form" :rules="data.rules" label-width="80px" style="padding: 20px">
          <el-form-item prop="title" label="成果描述">
            <el-input  type="textarea" :rows="4" v-model="data.form.title" placeholder="成果描述"></el-input>
          </el-form-item>
          <el-form-item prop="detail" label="成果附件">
            <el-upload
                :action="baseUrl + '/files/upload'"
                :on-success="handleFileUpload"
                list-type="text"
            >
              <el-button type="primary">点击上传</el-button>
            </el-upload>
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
  </div>
</template>

<script setup>
import { reactive,ref } from "vue";
import request from "@/utils/request.js";
import { ElMessage } from "element-plus";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  taskList: [],
  dialogVisible: false, // 弹窗显示状态
  detailContent: "", // 弹窗内容
  form: {},
  formVisible: false,
  rules: {
    title: [
      { required: true, message: '请输入标题内容', trigger: 'blur' }
    ],
    detail: [
      { required: true, message: '请上传完成成果', trigger: 'change' }
    ],
  }

});
const formRef = ref()

const baseUrl = import.meta.env.VITE_BASE_URL

const handleFileUpload = (res) => {
  data.form.detail = res.data
}

const loadTask = () => {
  request.get('/task/selectUserTask').then(res => {
    data.taskList = res.data || [];
  });
};
loadTask();

// 打开详情弹窗
const openDetailDialog = (detail) => {
  data.detailContent = detail; // 赋值详情内容
  data.dialogVisible = true; // 显示弹窗
};
// 打开新增弹窗
const handleAdd = (taskId, teacherId) => {
  data.form = {
    taskId,
    teacherId,
  }
  data.formVisible = true
}

const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      add()
    }
  })
}

const add = () => {
  request.post('/submit/add', data.form).then(res => {
    if (res.code === '200') {
      ElMessage.success('操作成功')
      data.formVisible = false
    } else {
      ElMessage.error(res.msg)
    }
  })
}
</script>