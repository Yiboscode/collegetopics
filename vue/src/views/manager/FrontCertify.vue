<template>
  <div style="width: 50%; margin: 0 auto; padding: 20px 0; min-height: 100vh">
    <div class="card" style="padding: 20px">
      <div>
        <el-form ref="formRef" :model="data.form" :rules="data.rules" label-width="100px"  style="padding: 20px 30px">
          <el-form-item label="姓名" prop="name">
            <el-input v-model="data.form.name" :disabled="data.form.status === '审核通过'" placeholder="请输入姓名" ></el-input>
          </el-form-item>
          <el-form-item label="性别" prop="gender">
            <el-radio-group v-model="data.form.gender" :disabled="data.form.status === '审核通过'">
              <el-radio-button label="男" value="男"></el-radio-button>
              <el-radio-button label="女" value="女"></el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="身份证号" prop="cardNo">
            <el-input v-model="data.form.cardNo" :disabled="data.form.status === '审核通过'" placeholder="请输入身份证号"></el-input>
          </el-form-item>
          <el-form-item label="身份证照片" prop="img1">
            <el-upload :disabled="data.form.status === '审核通过'"
                :action="baseUrl + '/files/upload'"
                :on-success="handleFileUpload1"
                :show-file-list="false"
                class="avatar-uploader"
            >
              <img v-if="data.form.img1" :src="data.form.img1" class="avatar" />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
          </el-form-item>
          <el-form-item label="工作证照片" prop="img2">
            <el-upload :disabled="data.form.status === '审核通过'"
                :action="baseUrl + '/files/upload'"
                :on-success="handleFileUpload2"
                :show-file-list="false"
                class="avatar-uploader"
            >
              <img v-if="data.form.img2" :src="data.form.img2" class="avatar"/>
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
          </el-form-item>
          <div style="margin: 20px 0 0 80px; ;font-size: 13px;" v-if="data.form.status ==='审核未通过'"> 审核原因：{{data.form.reason}}</div>
          <div style="margin: 10px 0 20px 80px; font-size: 13px; color: #ff9824;" v-if="data.form.status === '待审核'">状态：{{data.form.status}}</div>
          <div style="margin: 10px 0 20px 80px; font-size: 13px; color: #41d142;" v-if="data.form.status === '审核通过'">您的认证已{{data.form.status}}</div>
          <div style="margin: 20px 0 20px 80px; font-size: 13px; color: #f80f0f;" v-if="data.form.status === '审核未通过'">您的认证{{data.form.status}}</div>
          <div style="text-align: center">
            <el-button type="primary" size="default" @click="save" style="text-align: center; width: 200px" :disabled="data.form.status === '审核通过'">提交认证</el-button>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import {reactive,ref} from "vue"
import request from "@/utils/request";
import {ElMessage, ElMessageBox} from "element-plus";

const baseUrl = import.meta.env.VITE_BASE_URL

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  form: {},
  certifyList: [],
  rules: {
    name: [
      { required: true, message: '请输入姓名', trigger: 'blur' }
    ],
    gender: [
      { required: true, message: '请选择性别', trigger: 'change' }
    ],
    cardNo: [
      { required: true, message: '请输入身份证号', trigger: 'blur' }
    ],
    img1: [
      { required: true, message: '请上传上传身份证照片', trigger: 'change' }
    ],
    img2: [
      { required: true, message: '请上传上传工作证照片', trigger: 'change' }
    ],
  }
})

const handleFileUpload1 = (res) => {
  data.form.img1 = res.data
}

const handleFileUpload2 = (res) => {
  data.form.img2 = res.data
}

const formRef = ref()

// 加载表格数据
const load = () => {
  request.get('/certify/selectByUserId/' + data.user.id).then(res => {
    data.form = res.data || {}
  })
}

// 新增

const add = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      request.post('/certify/add', data.form).then(res => {
        if (res.code === '200') {
          ElMessage.success('操作成功')
          data.form = {}
          load()
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}

// 更新
const update = () => {
  data.form.status = "待审核"
  data.form.reason = null
  request.put('/certify/update', data.form).then(res => {
    if (res.code === '200') {
      ElMessage.success("提交成功")
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

const save = () => {
  data.form.id ? update() : add()
}

load()

</script>

<style>
.avatar-uploader {
  height: 120px;
}
.avatar-uploader .avatar {
  width: 200px;
  height: 120px;
  display: block;
}
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 0;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 200px;
  height: 120px;
  text-align: center;
}
</style>
