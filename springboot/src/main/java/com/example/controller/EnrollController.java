package com.example.controller;

import com.example.common.Result;
import com.example.entity.Enroll;
import com.example.service.EnrollService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 报名信息前端操作接口
 **/
@RestController
@RequestMapping("/enroll")
public class EnrollController {

    @Resource
    private EnrollService enrollService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Enroll enroll) {
        enrollService.add(enroll);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        enrollService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        enrollService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Enroll enroll) {
        enrollService.updateById(enroll);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Enroll enroll = enrollService.selectById(id);
        return Result.success(enroll);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Enroll enroll) {
        List<Enroll> list = enrollService.selectAll(enroll);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Enroll enroll,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Enroll> page = enrollService.selectPage(enroll, pageNum, pageSize);
        return Result.success(page);
    }

}