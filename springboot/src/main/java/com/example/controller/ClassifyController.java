package com.example.controller;

import com.example.common.Result;
import com.example.entity.Classify;
import com.example.service.ClassifyService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 分类信息前端操作接口
 **/
@RestController
@RequestMapping("/classify")
public class ClassifyController {

    @Resource
    private ClassifyService classifyService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Classify classify) {
        classifyService.add(classify);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        classifyService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        classifyService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Classify classify) {
        classifyService.updateById(classify);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Classify classify = classifyService.selectById(id);
        return Result.success(classify);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Classify classify) {
        List<Classify> list = classifyService.selectAll(classify);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Classify classify,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Classify> page = classifyService.selectPage(classify, pageNum, pageSize);
        return Result.success(page);
    }

}