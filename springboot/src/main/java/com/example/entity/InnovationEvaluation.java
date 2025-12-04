package com.example.entity;

import java.math.BigDecimal;

/**
 * 创新能力评价实体类
 */
public class InnovationEvaluation {

    /** 主键ID */
    private Integer id;
    /** 学生ID */
    private Integer studentId;
    /** 评价人ID */
    private Integer evaluatorId;
    /** 求知能力 */
    private BigDecimal knowledgeSeeking;
    /** 处理能力 */
    private BigDecimal processingAbility;
    /** 理解能力 */
    private BigDecimal understandingAbility;
    /** 自主学习能力 */
    private BigDecimal selfLearningAbility;
    /** 创新欲望 */
    private BigDecimal innovationDesire;
    /** 创新兴趣 */
    private BigDecimal innovationInterest;
    /** 创新动力 */
    private BigDecimal innovationMotivation;
    /** 创新精神 */
    private BigDecimal innovationSpirit;
    /** 合作能力 */
    private BigDecimal cooperationAbility;
    /** 动手能力 */
    private BigDecimal handsOnAbility;
    /** 表达能力 */
    private BigDecimal expressionAbility;
    /** 科研能力 */
    private BigDecimal researchAbility;
    /** 总分 */
    private BigDecimal totalScore;
    /** 评价时间 */
    private String evaluationTime;
    /** 评价意见 */
    private String comments;
    
    // 关联查询字段
    /** 学生姓名 */
    private String studentName;
    /** 评价教师姓名 */
    private String evaluatorName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public Integer getEvaluatorId() {
        return evaluatorId;
    }

    public void setEvaluatorId(Integer evaluatorId) {
        this.evaluatorId = evaluatorId;
    }

    public BigDecimal getKnowledgeSeeking() {
        return knowledgeSeeking;
    }

    public void setKnowledgeSeeking(BigDecimal knowledgeSeeking) {
        this.knowledgeSeeking = knowledgeSeeking;
    }

    public BigDecimal getProcessingAbility() {
        return processingAbility;
    }

    public void setProcessingAbility(BigDecimal processingAbility) {
        this.processingAbility = processingAbility;
    }

    public BigDecimal getUnderstandingAbility() {
        return understandingAbility;
    }

    public void setUnderstandingAbility(BigDecimal understandingAbility) {
        this.understandingAbility = understandingAbility;
    }

    public BigDecimal getSelfLearningAbility() {
        return selfLearningAbility;
    }

    public void setSelfLearningAbility(BigDecimal selfLearningAbility) {
        this.selfLearningAbility = selfLearningAbility;
    }

    public BigDecimal getInnovationDesire() {
        return innovationDesire;
    }

    public void setInnovationDesire(BigDecimal innovationDesire) {
        this.innovationDesire = innovationDesire;
    }

    public BigDecimal getInnovationInterest() {
        return innovationInterest;
    }

    public void setInnovationInterest(BigDecimal innovationInterest) {
        this.innovationInterest = innovationInterest;
    }

    public BigDecimal getInnovationMotivation() {
        return innovationMotivation;
    }

    public void setInnovationMotivation(BigDecimal innovationMotivation) {
        this.innovationMotivation = innovationMotivation;
    }

    public BigDecimal getInnovationSpirit() {
        return innovationSpirit;
    }

    public void setInnovationSpirit(BigDecimal innovationSpirit) {
        this.innovationSpirit = innovationSpirit;
    }

    public BigDecimal getCooperationAbility() {
        return cooperationAbility;
    }

    public void setCooperationAbility(BigDecimal cooperationAbility) {
        this.cooperationAbility = cooperationAbility;
    }

    public BigDecimal getHandsOnAbility() {
        return handsOnAbility;
    }

    public void setHandsOnAbility(BigDecimal handsOnAbility) {
        this.handsOnAbility = handsOnAbility;
    }

    public BigDecimal getExpressionAbility() {
        return expressionAbility;
    }

    public void setExpressionAbility(BigDecimal expressionAbility) {
        this.expressionAbility = expressionAbility;
    }

    public BigDecimal getResearchAbility() {
        return researchAbility;
    }

    public void setResearchAbility(BigDecimal researchAbility) {
        this.researchAbility = researchAbility;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public String getEvaluationTime() {
        return evaluationTime;
    }

    public void setEvaluationTime(String evaluationTime) {
        this.evaluationTime = evaluationTime;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getEvaluatorName() {
        return evaluatorName;
    }

    public void setEvaluatorName(String evaluatorName) {
        this.evaluatorName = evaluatorName;
    }
} 