package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.entity.InnovationEvaluation;
import com.example.mapper.InnovationEvaluationMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 创新能力评价业务层方法
 */
@Service
public class InnovationEvaluationService {

    @Resource
    private InnovationEvaluationMapper innovationEvaluationMapper;

    public void add(InnovationEvaluation innovationEvaluation) {
        if (ObjectUtil.isEmpty(innovationEvaluation.getEvaluationTime())) {
            innovationEvaluation.setEvaluationTime(DateUtil.now());
        }
        // 计算总分
        calculateTotalScore(innovationEvaluation);
        innovationEvaluationMapper.insert(innovationEvaluation);
    }

    public void updateById(InnovationEvaluation innovationEvaluation) {
        // 重新计算总分
        calculateTotalScore(innovationEvaluation);
        innovationEvaluationMapper.updateById(innovationEvaluation);
    }

    public void deleteById(Integer id) {
        innovationEvaluationMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            innovationEvaluationMapper.deleteById(id);
        }
    }

    public InnovationEvaluation selectById(Integer id) {
        return innovationEvaluationMapper.selectById(id);
    }

    public List<InnovationEvaluation> selectAll(InnovationEvaluation innovationEvaluation) {
        return innovationEvaluationMapper.selectAll(innovationEvaluation);
    }

    public PageInfo<InnovationEvaluation> selectPage(InnovationEvaluation innovationEvaluation, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<InnovationEvaluation> list = innovationEvaluationMapper.selectAll(innovationEvaluation);
        return PageInfo.of(list);
    }

    /**
     * 获取学生创新能力统计数据
     */
    public Map<String, Object> getStudentStatistics(Integer studentId) {
        List<InnovationEvaluation> evaluations = innovationEvaluationMapper.selectByStudentId(studentId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("evaluations", evaluations);
        result.put("count", evaluations.size());
        
        if (!evaluations.isEmpty()) {
            // 计算各项能力的平均分
            Map<String, Double> averageScores = calculateAverageScores(evaluations);
            result.put("averageScores", averageScores);
            
            // 获取最新评价
            InnovationEvaluation latestEvaluation = evaluations.get(0);
            result.put("latestEvaluation", latestEvaluation);
        }
        
        return result;
    }
    
    /**
     * 检查学生是否已经被某个评价人评价过
     */
    public boolean isStudentEvaluated(Integer studentId, Integer evaluatorId) {
        InnovationEvaluation evaluation = innovationEvaluationMapper.selectByStudentAndEvaluator(studentId, evaluatorId);
        return evaluation != null;
    }
    
    /**
     * 计算各项能力的平均分
     */
    private Map<String, Double> calculateAverageScores(List<InnovationEvaluation> evaluations) {
        Map<String, Double> averages = new HashMap<>();
        int count = evaluations.size();
        
        double knowledgeSeekingSum = 0, processingAbilitySum = 0, understandingAbilitySum = 0;
        double selfLearningSum = 0, innovationDesireSum = 0, innovationInterestSum = 0;
        double innovationMotivationSum = 0, innovationSpiritSum = 0, cooperationSum = 0;
        double handsOnSum = 0, expressionSum = 0, researchSum = 0;
        
        for (InnovationEvaluation eval : evaluations) {
            knowledgeSeekingSum += eval.getKnowledgeSeeking() != null ? eval.getKnowledgeSeeking().doubleValue() : 0;
            processingAbilitySum += eval.getProcessingAbility() != null ? eval.getProcessingAbility().doubleValue() : 0;
            understandingAbilitySum += eval.getUnderstandingAbility() != null ? eval.getUnderstandingAbility().doubleValue() : 0;
            selfLearningSum += eval.getSelfLearningAbility() != null ? eval.getSelfLearningAbility().doubleValue() : 0;
            innovationDesireSum += eval.getInnovationDesire() != null ? eval.getInnovationDesire().doubleValue() : 0;
            innovationInterestSum += eval.getInnovationInterest() != null ? eval.getInnovationInterest().doubleValue() : 0;
            innovationMotivationSum += eval.getInnovationMotivation() != null ? eval.getInnovationMotivation().doubleValue() : 0;
            innovationSpiritSum += eval.getInnovationSpirit() != null ? eval.getInnovationSpirit().doubleValue() : 0;
            cooperationSum += eval.getCooperationAbility() != null ? eval.getCooperationAbility().doubleValue() : 0;
            handsOnSum += eval.getHandsOnAbility() != null ? eval.getHandsOnAbility().doubleValue() : 0;
            expressionSum += eval.getExpressionAbility() != null ? eval.getExpressionAbility().doubleValue() : 0;
            researchSum += eval.getResearchAbility() != null ? eval.getResearchAbility().doubleValue() : 0;
        }
        
        averages.put("求知能力", Math.round(knowledgeSeekingSum / count * 100.0) / 100.0);
        averages.put("处理能力", Math.round(processingAbilitySum / count * 100.0) / 100.0);
        averages.put("理解能力", Math.round(understandingAbilitySum / count * 100.0) / 100.0);
        averages.put("自学能力", Math.round(selfLearningSum / count * 100.0) / 100.0);
        averages.put("创新欲望", Math.round(innovationDesireSum / count * 100.0) / 100.0);
        averages.put("创新兴趣", Math.round(innovationInterestSum / count * 100.0) / 100.0);
        averages.put("创新动力", Math.round(innovationMotivationSum / count * 100.0) / 100.0);
        averages.put("创新精神", Math.round(innovationSpiritSum / count * 100.0) / 100.0);
        averages.put("合作能力", Math.round(cooperationSum / count * 100.0) / 100.0);
        averages.put("动手能力", Math.round(handsOnSum / count * 100.0) / 100.0);
        averages.put("表达能力", Math.round(expressionSum / count * 100.0) / 100.0);
        averages.put("研究能力", Math.round(researchSum / count * 100.0) / 100.0);
        
        return averages;
    }

    /**
     * 计算总分 (12个维度，每项5分，总分60分)
     */
    private void calculateTotalScore(InnovationEvaluation evaluation) {
        BigDecimal total = BigDecimal.ZERO;
        
        if (evaluation.getKnowledgeSeeking() != null) {
            total = total.add(evaluation.getKnowledgeSeeking());
        }
        if (evaluation.getProcessingAbility() != null) {
            total = total.add(evaluation.getProcessingAbility());
        }
        if (evaluation.getUnderstandingAbility() != null) {
            total = total.add(evaluation.getUnderstandingAbility());
        }
        if (evaluation.getSelfLearningAbility() != null) {
            total = total.add(evaluation.getSelfLearningAbility());
        }
        if (evaluation.getInnovationDesire() != null) {
            total = total.add(evaluation.getInnovationDesire());
        }
        if (evaluation.getInnovationInterest() != null) {
            total = total.add(evaluation.getInnovationInterest());
        }
        if (evaluation.getInnovationMotivation() != null) {
            total = total.add(evaluation.getInnovationMotivation());
        }
        if (evaluation.getInnovationSpirit() != null) {
            total = total.add(evaluation.getInnovationSpirit());
        }
        if (evaluation.getCooperationAbility() != null) {
            total = total.add(evaluation.getCooperationAbility());
        }
        if (evaluation.getHandsOnAbility() != null) {
            total = total.add(evaluation.getHandsOnAbility());
        }
        if (evaluation.getExpressionAbility() != null) {
            total = total.add(evaluation.getExpressionAbility());
        }
        if (evaluation.getResearchAbility() != null) {
            total = total.add(evaluation.getResearchAbility());
        }
        
        evaluation.setTotalScore(total);
    }

    /**
     * 根据评价人ID查询创新能力评价列表 (分页)
     */
    public PageInfo<InnovationEvaluation> selectMyEvaluations(InnovationEvaluation innovationEvaluation, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<InnovationEvaluation> list = innovationEvaluationMapper.selectMyEvaluations(innovationEvaluation);
        return PageInfo.of(list);
    }

} 