package com.example.entity;

public class TeamApplication {
    private Integer id;
    private Integer teamId;
    private Integer applicantId;
    private String message;
    private String applyTime;
    private String status;
    private String handleTime;
    private String rejectReason;
    
    // 关联字段
    private String applicantName;
    private String teamName;
    private String topicTitle;
    private String avatar;

    public TeamApplication() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTeamId() {
        return teamId;
    }

    public void setTeamId(Integer teamId) {
        this.teamId = teamId;
    }

    public Integer getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(Integer applicantId) {
        this.applicantId = applicantId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(String applyTime) {
        this.applyTime = applyTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getHandleTime() {
        return handleTime;
    }

    public void setHandleTime(String handleTime) {
        this.handleTime = handleTime;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getTopicTitle() {
        return topicTitle;
    }

    public void setTopicTitle(String topicTitle) {
        this.topicTitle = topicTitle;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "TeamApplication{" +
                "id=" + id +
                ", teamId=" + teamId +
                ", applicantId=" + applicantId +
                ", message='" + message + '\'' +
                ", applyTime='" + applyTime + '\'' +
                ", status='" + status + '\'' +
                ", handleTime='" + handleTime + '\'' +
                ", rejectReason='" + rejectReason + '\'' +
                ", applicantName='" + applicantName + '\'' +
                ", teamName='" + teamName + '\'' +
                ", topicTitle='" + topicTitle + '\'' +
                ", avatar='" + avatar + '\'' +
                '}';
    }
} 