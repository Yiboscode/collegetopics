package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.entity.TopicEvaluation;
import com.example.mapper.TopicEvaluationMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 选题评价业务层方法
 */
@Service
public class TopicEvaluationService {

    @Resource
    private TopicEvaluationMapper topicEvaluationMapper;

    public void add(TopicEvaluation topicEvaluation) {
        if (ObjectUtil.isEmpty(topicEvaluation.getEvaluationTime())) {
            topicEvaluation.setEvaluationTime(DateUtil.now());
        }
        topicEvaluationMapper.insert(topicEvaluation);
    }

    public void updateById(TopicEvaluation topicEvaluation) {
        topicEvaluationMapper.updateById(topicEvaluation);
    }

    public void deleteById(Integer id) {
        topicEvaluationMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            topicEvaluationMapper.deleteById(id);
        }
    }

    public TopicEvaluation selectById(Integer id) {
        return topicEvaluationMapper.selectById(id);
    }

    public TopicEvaluation selectByTopicId(Integer topicId) {
        return topicEvaluationMapper.selectByTopicId(topicId);
    }

    public TopicEvaluation selectByTopicAndEvaluator(Integer topicId, Integer evaluatorId) {
        return topicEvaluationMapper.selectByTopicAndEvaluator(topicId, evaluatorId);
    }

    public List<TopicEvaluation> selectAll(TopicEvaluation topicEvaluation) {
        return topicEvaluationMapper.selectAll(topicEvaluation);
    }

    public PageInfo<TopicEvaluation> selectPage(TopicEvaluation topicEvaluation, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<TopicEvaluation> list = topicEvaluationMapper.selectAll(topicEvaluation);
        return PageInfo.of(list);
    }

    /**
     * 获取选题平均分
     */
    public BigDecimal getTopicAverageScore(Integer topicId) {
        TopicEvaluation queryEvaluation = new TopicEvaluation();
        queryEvaluation.setTopicId(topicId);
        List<TopicEvaluation> evaluations = selectAll(queryEvaluation);
        if (evaluations.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal totalScore = evaluations.stream()
            .map(TopicEvaluation::getTotalScore)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
            
        return totalScore.divide(new BigDecimal(evaluations.size()), 2, RoundingMode.HALF_UP);
    }

    /**
     * 检查选题是否已被某教师评价
     */
    public boolean hasEvaluated(Integer topicId, Integer evaluatorId) {
        TopicEvaluation evaluation = topicEvaluationMapper.selectByTopicAndEvaluator(topicId, evaluatorId);
        return evaluation != null;
    }

    /**
     * 根据评价人ID查询评价列表 (分页)
     */
    public PageInfo<TopicEvaluation> selectMyEvaluations(TopicEvaluation topicEvaluation, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<TopicEvaluation> list = topicEvaluationMapper.selectMyEvaluations(topicEvaluation);
        return PageInfo.of(list);
    }
} 