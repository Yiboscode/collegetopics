package com.example.controller;

import com.example.common.Result;
import com.example.entity.Competition;
import com.example.service.CompetitionService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 大赛动态前端操作接口
 **/
@RestController
@RequestMapping("/competition")
public class CompetitionController {

    @Resource
    private CompetitionService competitionService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Competition competition) {
        competitionService.add(competition);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        competitionService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        competitionService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Competition competition) {
        competitionService.updateById(competition);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Competition competition = competitionService.selectById(id);
        return Result.success(competition);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Competition competition) {
        List<Competition> list = competitionService.selectAll(competition);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Competition competition,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Competition> page = competitionService.selectPage(competition, pageNum, pageSize);
        return Result.success(page);
    }

    @GetMapping("/updateViews/{id}")
    public Result updateViews(@PathVariable Integer id) {
        competitionService.updateViews(id);
        return Result.success();
    }

}