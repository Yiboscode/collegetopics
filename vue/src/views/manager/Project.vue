<template>
  <div>
    <div class="card" style="margin-bottom: 5px;">
      <el-input v-model="data.title" placeholder="请输入项目名称查询" style="width: 240px"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-button type="primary" plain @click="handleAdd" v-if="data.user.role === 'TEACHER'">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px;">
      <el-table :data="data.tableData" stripe @selection-change="handleSelectionChange" tooltip-effect="dark dark1">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="title" label="项目名称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="teacherName" label="教师名称"></el-table-column>
        <el-table-column prop="classifyName" label="分类名称"></el-table-column>
        <el-table-column prop="introduce" label="简介" show-overflow-tooltip></el-table-column>
        <el-table-column label="查看内容">
          <template v-slot="scope">
            <el-button type="primary" size="small" @click="preview(scope.row.content)">查看内容</el-button>
          </template>
        </el-table-column>
        <el-table-column label="图片">
          <template #default="scope">
            <el-image style="width: 40px; height: 40px; border-radius: 5px" v-if="scope.row.img" :src="scope.row.img" :preview-src-list="[scope.row.img]" preview-teleported></el-image>
          </template>
        </el-table-column>
        <el-table-column prop="views" label="浏览量"></el-table-column>
        <el-table-column prop="time" label="发布时间" show-overflow-tooltip></el-table-column>
        <el-table-column prop="status" label="审核状态">
          <template v-slot="scope">
            <el-tag type="warning" v-if="scope.row.status === '待审核'">待审核</el-tag>
            <el-tag type="success" v-if="scope.row.status === '审核通过'">审核通过</el-tag>
            <el-tag type="danger" v-if="scope.row.status === '审核未通过'">审核未通过</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="审核原因"></el-table-column>
        <el-table-column label="操作" width="120" fixed="right" v-if="data.user.role === 'ADMIN'">
          <template v-slot="scope">
            <el-button type="primary" size="small" @click="handleEdit1(scope.row)" :disabled="scope.row.status === '审核通过'">审核</el-button>
            <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right" v-if="data.user.role === 'TEACHER'">
          <template v-slot="scope">
            <el-button type="primary" circle :icon="Edit" @click="handleEdit(scope.row)" :disabled="scope.row.status === '审核通过'" v-if="data.user.role === 'TEACHER'"></el-button>
            <el-button type="danger" circle :icon="Delete" @click="del(scope.row.id)"></el-button>
          </template>
        </el-table-column>
      </el-table>

    </div>
    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="total, prev, pager, next" :page-size="data.pageSize" v-model:current-page="data.pageNum" :total="data.total"/>
    </div>

    <el-dialog title="审核" v-model="data.formVisible1" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form1" label-width="100px"  style="padding: 20px 30px" ref="formRef1" :rules="data.rules1" >
        <el-form-item label="审核状态" prop="status">
          <el-radio-group v-model="data.form1.status">
            <el-radio-button label="审核通过"></el-radio-button>
            <el-radio-button label="审核未通过"></el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理意见" prop="reason">
          <el-input type="textarea" :rows="3" v-model="data.form1.reason"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible1 = false">取消</el-button>
          <el-button type="primary" @click="save1">保存</el-button>
        </span>
      </template>
    </el-dialog>

    <el-dialog title="创业项目" v-model="data.formVisible" width="50%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="data.form" :rules="data.rules" label-width="80px"  style="padding: 20px 30px" ref="formRef">
        <el-form-item label="分类" prop="classifyId">
          <el-select style="width: 100%" v-model="data.form.classifyId">
            <el-option v-for="item in data.classifyList" :key="item.id" :value="item.id" :label="item.name"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="项目名称" prop="title">
          <el-input v-model="data.form.title" placeholder="标题"></el-input>
        </el-form-item>
        <el-form-item label="图片" prop="img">
          <el-upload
              :action="baseUrl + '/files/upload'"
              :headers="{ token: data.user.token }"
              list-type="picture"
              :on-success="handleImgSuccess"
          >
            <el-button type="primary">上传</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="简介" prop="introduce">
          <el-input type="textarea" :rows="4" v-model="data.form.introduce" placeholder="简介"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <div style="border: 1px solid #ccc; width: 100%">
            <Toolbar
                style="border-bottom: 1px solid #ccc"
                :editor="editorRef"
                :mode="mode"
            />
            <Editor
                style="height: 500px; overflow-y: hidden;"
                v-model="data.form.content"
                :mode="mode"
                :defaultConfig="editorConfig"
                @onCreated="handleCreated"
            />
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible = false">取消</el-button>
          <el-button type="primary" @click="save">保存</el-button>
        </span>
      </template>
    </el-dialog>

    <el-dialog title="内容" v-model="data.fromVisibleContent" width="50%" :close-on-click-modal="false" destroy-on-close>
      <div style="padding: 15px">
        <div v-html="data.content"></div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.fromVisibleContent = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { reactive, ref } from "vue"
import request from "@/utils/request";
import {ElMessage, ElMessageBox} from "element-plus";
import {Delete, Edit} from "@element-plus/icons-vue";
import '@wangeditor/editor/dist/css/style.css' // 引入 css
import {onBeforeUnmount, shallowRef} from "vue";
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'

const baseUrl = import.meta.env.VITE_BASE_URL
const formRef = ref()
const formRef1 = ref()
const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  tableData: [],
  total: 0,
  pageNum: 1,  // 当前的页码
  pageSize: 5,  // 每页的个数
  formVisible: false,
  formVisible1: false,
  form: {},
  form1: {},
  ids: [],
  title: null,
  rules: {
    teacherId: [
      { required: true, message: '请输入教师%name%name|教师名称', trigger: 'blur' },
    ],
    classifyId: [
      { required: true, message: '请输入分类%name%name|分类名称', trigger: 'blur' },
    ],
    title: [
      { required: true, message: '请输入标题', trigger: 'blur' },
    ],
    introduce: [
      { required: true, message: '请输入简介', trigger: 'blur' },
    ],
    content: [
      { required: true, message: '请输入内容', trigger: 'blur' },
    ],
    img: [
      { required: true, message: '请输入图片', trigger: 'blur' },
    ],
    views: [
      { required: true, message: '请输入浏览量', trigger: 'blur' },
    ],
    status: [
      { required: true, message: '请输入审核状态', trigger: 'blur' },
    ],
    reason: [
      { required: true, message: '请输入审核原因', trigger: 'blur' },
    ],
  },
  rules1: {
    status: [
      { required: true, message: '请输入状态', trigger: 'blur' },
    ],
    reason: [
      { required: true, message: '请输入审核原因', trigger: 'blur' },
    ],
  },
  teacherList: [],
  classifyList: [],
  content: '',
  fromVisibleContent: false,
})

/* wangEditor5 初始化开始 */
const editorRef = shallowRef()  // 编辑器实例，必须用 shallowRef
const mode = 'default' 
const editorConfig = { MENU_CONF: {} }
// 图片上传配置
editorConfig.MENU_CONF['uploadImage'] = {
  headers: {
    token: data.user.token,
  },
  server: baseUrl + '/files/wang/upload',  // 服务端图片上传接口
  fieldName: 'file'  // 服务端图片上传接口参数
}
// 组件销毁时，也及时销毁编辑器，否则可能会造成内存泄漏
onBeforeUnmount(() => {
  const editor = editorRef.value
  if (editor == null) return
  editor.destroy()
})
// 记录 editor 实例，重要！
const handleCreated = (editor) => {
  editorRef.value = editor 
}
/* wangEditor5 初始化结束 */

const preview = (content) => {
  data.content = content
  data.fromVisibleContent = true
}

const handleImgSuccess = (res) => {
  data.form.img = res.data
}

const loadTeacher = () => {
  request.get('/teacher/selectAll').then(res => {
    if (res.code === '200') {
      data.teacherList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadTeacher()
const loadClassify = () => {
  request.get('/classify/selectAll').then(res => {
    if (res.code === '200') {
      data.classifyList = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
loadClassify()
// 加载表格数据
const load = () => {
  const params = {
    pageNum: data.pageNum,
    pageSize: data.pageSize,
    title: data.title
  }
  if (data.user.role === 'TEACHER') {
    params.teacherId = data.user.id;
  }
  request.get('/project/selectPage', {params}).then(res => {
    data.tableData = res.data?.list || []
    data.total = res.data?.total
  })
}

// 打开新增弹窗
const handleAdd = () => {
  data.form = {}
  data.formVisible = true
}

// 打开编辑弹窗
const handleEdit = (row) => {
  data.form = JSON.parse(JSON.stringify(row))
  data.formVisible = true
}

// 打开编辑弹窗
const handleEdit1 = (row) => {
  data.form1 = JSON.parse(JSON.stringify(row))
  data.formVisible1 = true
}

// 新增
const add = () => {
  formRef.value.validate(valid => {
    if (valid) {
      request.post('/project/add', data.form).then(res => {
        if (res.code === '200') {
          data.formVisible = false
          ElMessage.success('新增成功')
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
  request.put('/project/update', data.form).then(res => {
    if (res.code === '200') {
      data.formVisible = false
      data.formVisible1 = false
      ElMessage.success('修改成功')
      load()
    } else {
      ElMessage.error(res.msg)
    }
  })
}

// 删除
const del = (id) => {
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(res => {
    request.delete('/project/delete/' + id).then(res => {
      if (res.code === '200') {
        ElMessage.success('删除成功')
        load()
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => {
    console.error(err)
  })
}

// 批量删除
const handleSelectionChange = (rows) => {
  data.ids = rows.map(v => v.id)
}

const delBatch = () => {
  if (!data.ids.length) {
    ElMessage.warning("请选择数据")
    return
  }
  ElMessageBox.confirm('删除后数据无法恢复，您确定删除吗?', '删除确认', { type: 'warning' }).then(res => {
    request.delete('/project/delete/batch', {data: data.ids}).then(res => {
      if (res.code === '200') {
        ElMessage.success('操作成功')
        load()  // 刷新表格数据
      } else {
        ElMessage.error(res.msg)
      }
    })
  }).catch(err => console.log(err))
}

const save = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      data.form.id ? update() : add()
    }
  })
}
const save1 = () => {
  formRef1.value.validate((valid) => {
    if (valid) {
      request.put('/project/update', data.form1).then(res => {
        if (res.code === '200') {
          data.formVisible1 = false
          ElMessage.success('修改成功')
          load()
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}

const reset = () => {
  data.title = null
  load()
}

load()

</script>