package com.example.controller;

import com.example.common.Result;
import com.example.entity.ExcellentTopic;
import com.example.service.ExcellentTopicService;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 前端请求接口
 */
@RestController
@RequestMapping("/excellentTopic")
public class ExcellentTopicController {

    @Resource
    private ExcellentTopicService excellentTopicService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody ExcellentTopic excellentTopic) {
        excellentTopicService.add(excellentTopic);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result update(@RequestBody ExcellentTopic excellentTopic) {
        excellentTopicService.updateById(excellentTopic);
        return Result.success();
    }

    /**
     * 单个删除
     */
    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        excellentTopicService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result delete(@RequestBody List<Integer> ids) {
        excellentTopicService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 单个查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        ExcellentTopic excellentTopic = excellentTopicService.selectById(id);
        return Result.success(excellentTopic);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(ExcellentTopic excellentTopic) {
        List<ExcellentTopic> list = excellentTopicService.selectAll(excellentTopic);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(ExcellentTopic excellentTopic,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<ExcellentTopic> pageInfo = excellentTopicService.selectPage(excellentTopic, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 根据分类查询优秀选题
     */
    @GetMapping("/category/{category}")
    public Result getByCategory(@PathVariable String category) {
        List<ExcellentTopic> list = excellentTopicService.getByCategory(category);
        return Result.success(list);
    }

    /**
     * 根据年份查询优秀选题
     */
    @GetMapping("/year/{year}")
    public Result getByYear(@PathVariable Integer year) {
        List<ExcellentTopic> list = excellentTopicService.getByYear(year);
        return Result.success(list);
    }

    /**
     * 获取所有分类
     */
    @GetMapping("/categories")
    public Result getAllCategories() {
        List<String> categories = excellentTopicService.getAllCategories();
        return Result.success(categories);
    }

    /**
     * 获取所有年份
     */
    @GetMapping("/years")
    public Result getAllYears() {
        List<Integer> years = excellentTopicService.getAllYears();
        return Result.success(years);
    }

    /**
     * 推荐相似选题
     */
    @GetMapping("/recommend")
    public Result recommend(@RequestParam(required = false) String keywords,
                            @RequestParam(required = false) String category,
                            @RequestParam(defaultValue = "5") Integer limit) {
        List<ExcellentTopic> list = excellentTopicService.recommend(keywords, category, limit);
        return Result.success(list);
    }

    /**
     * 获取统计信息
     */
    @GetMapping("/stats")
    public Result getStats() {
        return excellentTopicService.getStats();
    }
} 