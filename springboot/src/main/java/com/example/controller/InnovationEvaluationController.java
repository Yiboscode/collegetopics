package com.example.controller;

import cn.hutool.core.date.DateUtil;
import com.example.common.Result;
import com.example.entity.InnovationEvaluation;
import com.example.entity.Account;
import com.example.service.InnovationEvaluationService;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 前端请求接口
 */
@RestController
@RequestMapping("/innovationEvaluation")
public class InnovationEvaluationController {

    @Resource
    private InnovationEvaluationService innovationEvaluationService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody InnovationEvaluation innovationEvaluation, HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        innovationEvaluation.setEvaluatorId(currentUser.getId());
        innovationEvaluation.setEvaluationTime(DateUtil.now());
        innovationEvaluationService.add(innovationEvaluation);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result update(@RequestBody InnovationEvaluation innovationEvaluation) {
        innovationEvaluationService.updateById(innovationEvaluation);
        return Result.success();
    }

    /**
     * 单个删除
     */
    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        innovationEvaluationService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result delete(@RequestBody List<Integer> ids) {
        innovationEvaluationService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 单个查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        InnovationEvaluation innovationEvaluation = innovationEvaluationService.selectById(id);
        return Result.success(innovationEvaluation);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(InnovationEvaluation innovationEvaluation) {
        List<InnovationEvaluation> list = innovationEvaluationService.selectAll(innovationEvaluation);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(InnovationEvaluation innovationEvaluation,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<InnovationEvaluation> pageInfo = innovationEvaluationService.selectPage(innovationEvaluation, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 获取学生创新能力统计数据
     */
    @GetMapping("/student/{studentId}/statistics")
    public Result getStudentStatistics(@PathVariable Integer studentId) {
        Map<String, Object> statistics = innovationEvaluationService.getStudentStatistics(studentId);
        return Result.success(statistics);
    }

    /**
     * 获取当前用户的所有创新能力评价记录
     */
    @GetMapping("/my")
    public Result getMyEvaluations(InnovationEvaluation innovationEvaluation,
                                   @RequestParam(defaultValue = "1") Integer pageNum,
                                   @RequestParam(defaultValue = "10") Integer pageSize,
                                   HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        
        // 设置当前用户为评价人
        innovationEvaluation.setEvaluatorId(currentUser.getId());
        
        PageInfo<InnovationEvaluation> pageInfo = innovationEvaluationService.selectMyEvaluations(innovationEvaluation, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 检查学生是否已经被评价过
     */
    @GetMapping("/checkEvaluated/{studentId}")
    public Result checkEvaluated(@PathVariable Integer studentId, HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        
        boolean isEvaluated = innovationEvaluationService.isStudentEvaluated(studentId, currentUser.getId());
        return Result.success(isEvaluated);
    }

} 