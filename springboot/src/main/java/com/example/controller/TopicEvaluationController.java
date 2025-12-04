package com.example.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.Result;
import com.example.entity.Topic;
import com.example.entity.TopicEvaluation;
import com.example.entity.Account;
import com.example.service.TopicEvaluationService;
import com.example.service.TopicService;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * 前端请求接口
 */
@RestController
@RequestMapping("/topicEvaluation")
public class TopicEvaluationController {

    @Resource
    private TopicEvaluationService topicEvaluationService;

    @Resource
    private TopicService topicService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody TopicEvaluation topicEvaluation, HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        topicEvaluation.setEvaluatorId(currentUser.getId());
        
        // 检查该评价人是否已经对此选题进行过评价
        if (topicEvaluationService.hasEvaluated(topicEvaluation.getTopicId(), currentUser.getId())) {
            return Result.error("您已经对此选题进行过评价，请勿重复评价");
        }
        
        topicEvaluation.setEvaluationTime(DateUtil.now());
        
        // 计算总分
        BigDecimal total = BigDecimal.ZERO;
        if (topicEvaluation.getInnovationScore() != null) {
            total = total.add(topicEvaluation.getInnovationScore());
        }
        if (topicEvaluation.getFeasibilityScore() != null) {
            total = total.add(topicEvaluation.getFeasibilityScore());
        }
        if (topicEvaluation.getSignificanceScore() != null) {
            total = total.add(topicEvaluation.getSignificanceScore());
        }
        topicEvaluation.setTotalScore(total);
        
        topicEvaluationService.add(topicEvaluation);
        
        // 更新选题状态为"评价中"
        Topic topic = topicService.selectById(topicEvaluation.getTopicId());
        if (ObjectUtil.isNotNull(topic) && "待评价".equals(topic.getStatus())) {
            topic.setStatus("评价中");
            topicService.updateById(topic);
        }
        
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result update(@RequestBody TopicEvaluation topicEvaluation) {
        // 重新计算总分
        BigDecimal total = BigDecimal.ZERO;
        if (topicEvaluation.getInnovationScore() != null) {
            total = total.add(topicEvaluation.getInnovationScore());
        }
        if (topicEvaluation.getFeasibilityScore() != null) {
            total = total.add(topicEvaluation.getFeasibilityScore());
        }
        if (topicEvaluation.getSignificanceScore() != null) {
            total = total.add(topicEvaluation.getSignificanceScore());
        }
        topicEvaluation.setTotalScore(total);
        
        topicEvaluationService.updateById(topicEvaluation);
        return Result.success();
    }

    /**
     * 单个删除
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        topicEvaluationService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/del/batch")
    public Result delete(@RequestBody List<Integer> ids) {
        topicEvaluationService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 单个查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        TopicEvaluation topicEvaluation = topicEvaluationService.selectById(id);
        return Result.success(topicEvaluation);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(TopicEvaluation topicEvaluation) {
        List<TopicEvaluation> list = topicEvaluationService.selectAll(topicEvaluation);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(TopicEvaluation topicEvaluation,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<TopicEvaluation> pageInfo = topicEvaluationService.selectPage(topicEvaluation, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    /**
     * 根据选题ID查询评价
     */
    @GetMapping("/topic/{topicId}")
    public Result selectByTopicId(@PathVariable Integer topicId) {
        TopicEvaluation evaluation = topicEvaluationService.selectByTopicId(topicId);
        return Result.success(evaluation);
    }

    /**
     * 获取当前用户对特定选题的评价
     */
    @GetMapping("/myEvaluation/{topicId}")
    public Result getMyEvaluation(@PathVariable Integer topicId, HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        TopicEvaluation evaluation = topicEvaluationService.selectByTopicAndEvaluator(topicId, currentUser.getId());
        return Result.success(evaluation);
    }

    /**
     * 获取当前用户的所有评价记录
     */
    @GetMapping("/my")
    public Result getMyEvaluations(TopicEvaluation topicEvaluation,
                                   @RequestParam(defaultValue = "1") Integer pageNum,
                                   @RequestParam(defaultValue = "10") Integer pageSize,
                                   HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        
        // 设置当前用户为评价人
        topicEvaluation.setEvaluatorId(currentUser.getId());
        
        PageInfo<TopicEvaluation> pageInfo = topicEvaluationService.selectMyEvaluations(topicEvaluation, pageNum, pageSize);
        return Result.success(pageInfo);
    }

} 