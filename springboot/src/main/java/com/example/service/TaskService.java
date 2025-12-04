package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Account;
import com.example.entity.Task;
import com.example.mapper.EnrollMapper;
import com.example.mapper.ProjectMapper;
import com.example.mapper.TaskMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 任务信息业务处理
 **/
@Service
public class TaskService {

    @Resource
    private TaskMapper taskMapper;
    @Resource
    EnrollMapper enrollMapper;

    /**
     * 新增
     */
    public void add(Task task) {
        Account currentUser = TokenUtils.getCurrentUser();
        task.setTeacherId(currentUser.getId());
        task.setTime(DateUtil.now());
        taskMapper.insert(task);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        taskMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            taskMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Task task) {
        taskMapper.updateById(task);
    }

    /**
     * 根据ID查询
     */
    public Task selectById(Integer id) {
        return taskMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Task> selectAll(Task task) {
        return taskMapper.selectAll(task);
    }

    /**
     * 分页查询
     */
    public PageInfo<Task> selectPage(Task task, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Task> list = this.selectAll(task);
        return PageInfo.of(list);
    }

    public List<Task> selectUserTask() {
        // 1. 根据当前的登录的用户ID查到用户报名审核通过的项目列表
        Account currentUser = TokenUtils.getCurrentUser();
        Integer userId = currentUser.getId();
        List<Integer> projectIds = enrollMapper.selectUserProject(userId);
        //  2. 根据项目找到任务
        List<Task> taskList = new ArrayList<>();
        for (Integer projectId : projectIds) {
            List<Task> tasks = taskMapper.selectByProjectId(projectId);
            taskList.addAll(tasks);
        }
        return taskList;
    }

}