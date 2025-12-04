package com.example.mapper;

import com.example.entity.TopicEvaluation;

import java.util.List;

public interface TopicEvaluationMapper {

    int insert(TopicEvaluation topicEvaluation);

    void updateById(TopicEvaluation topicEvaluation);

    void deleteById(Integer id);

    TopicEvaluation selectById(Integer id);

    TopicEvaluation selectByTopicId(Integer topicId);

    List<TopicEvaluation> selectAll(TopicEvaluation topicEvaluation);

    TopicEvaluation selectByTopicAndEvaluator(Integer topicId, Integer evaluatorId);

    /**
     * 根据评价人ID查询评价列表
     */
    List<TopicEvaluation> selectMyEvaluations(TopicEvaluation topicEvaluation);

} 