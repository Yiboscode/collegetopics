package com.example.entity;

import java.math.BigDecimal;

/**
 * 选题评价实体类
 */
public class TopicEvaluation {

    /** 主键ID */
    private Integer id;
    /** 选题ID */
    private Integer topicId;
    /** 评价教师ID */
    private Integer evaluatorId;
    /** 创新性评分 */
    private BigDecimal innovationScore;
    /** 可行性评分 */
    private BigDecimal feasibilityScore;
    /** 意义性评分 */
    private BigDecimal significanceScore;
    /** 总评分 */
    private BigDecimal totalScore;
    /** 修改建议 */
    private String suggestions;
    /** 评价状态 */
    private String status;
    /** 评价时间 */
    private String evaluationTime;
    
    // 连表查询字段
    /** 选题标题 */
    private String topicTitle;
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

    public Integer getTopicId() {
        return topicId;
    }

    public void setTopicId(Integer topicId) {
        this.topicId = topicId;
    }

    public Integer getEvaluatorId() {
        return evaluatorId;
    }

    public void setEvaluatorId(Integer evaluatorId) {
        this.evaluatorId = evaluatorId;
    }

    public BigDecimal getInnovationScore() {
        return innovationScore;
    }

    public void setInnovationScore(BigDecimal innovationScore) {
        this.innovationScore = innovationScore;
    }

    public BigDecimal getFeasibilityScore() {
        return feasibilityScore;
    }

    public void setFeasibilityScore(BigDecimal feasibilityScore) {
        this.feasibilityScore = feasibilityScore;
    }

    public BigDecimal getSignificanceScore() {
        return significanceScore;
    }

    public void setSignificanceScore(BigDecimal significanceScore) {
        this.significanceScore = significanceScore;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public String getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(String suggestions) {
        this.suggestions = suggestions;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEvaluationTime() {
        return evaluationTime;
    }

    public void setEvaluationTime(String evaluationTime) {
        this.evaluationTime = evaluationTime;
    }

    public String getTopicTitle() {
        return topicTitle;
    }

    public void setTopicTitle(String topicTitle) {
        this.topicTitle = topicTitle;
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