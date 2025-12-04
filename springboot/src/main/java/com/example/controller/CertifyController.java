package com.example.controller;

import com.example.common.Result;
import com.example.entity.Certify;
import com.example.service.CertifyService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 认证信息前端操作接口
 **/
@RestController
@RequestMapping("/certify")
public class CertifyController {

    @Resource
    private CertifyService certifyService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Certify certify) {
        certifyService.add(certify);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        certifyService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        certifyService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Certify certify) {
        certifyService.updateById(certify);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Certify certify = certifyService.selectById(id);
        return Result.success(certify);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Certify certify) {
        List<Certify> list = certifyService.selectAll(certify);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Certify certify,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Certify> page = certifyService.selectPage(certify, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 根据UserID查询
     */
    @GetMapping("/selectByUserId/{userId}")
    public Result selectByUserId(@PathVariable Integer userId) {
        Certify certify = certifyService.selectByUserId(userId);
        return Result.success(certify);
    }

}