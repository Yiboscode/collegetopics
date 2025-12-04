package com.example.controller;

import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.Project;
import com.example.service.ProjectService;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 创业项目前端操作接口
 **/
@RestController
@RequestMapping("/project")
public class ProjectController {

    @Resource
    private ProjectService projectService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Project project) {
        projectService.add(project);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        projectService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        projectService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Project project) {
        projectService.updateById(project);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Project project = projectService.selectById(id);
        return Result.success(project);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Project project) {
        List<Project> list = projectService.selectAll(project);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Project project,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Project> page = projectService.selectPage(project, pageNum, pageSize);
        return Result.success(page);
    }

    @GetMapping("/updateViews/{id}")
    public Result updateViews(@PathVariable Integer id) {
        projectService.updateViews(id);
        return Result.success();
    }

}