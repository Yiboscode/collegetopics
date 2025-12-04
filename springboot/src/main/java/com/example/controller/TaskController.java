package com.example.controller;

import com.example.common.Result;
import com.example.entity.Task;
import com.example.service.TaskService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 任务信息前端操作接口
 **/
@RestController
@RequestMapping("/task")
public class TaskController {

    @Resource
    private TaskService taskService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Task task) {
        taskService.add(task);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        taskService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        taskService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Task task) {
        taskService.updateById(task);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Task task = taskService.selectById(id);
        return Result.success(task);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Task task) {
        List<Task> list = taskService.selectAll(task);
        return Result.success(list);
    }

    /**
     * 查询用户报名过的项目的任务列表
     */
    @GetMapping("/selectUserTask")
    public Result selectUserTask() {
        List<Task> list = taskService.selectUserTask();
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Task task,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Task> page = taskService.selectPage(task, pageNum, pageSize);
        return Result.success(page);
    }

}