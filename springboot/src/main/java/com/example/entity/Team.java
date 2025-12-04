package com.example.entity;

public class Team {
    private Integer id;
    private Integer topicId;
    private Integer leaderId;
    private String teamName;
    private String status;
    private String createTime;
    
    // 关联字段
    private String topicTitle;
    private String leaderName;
    private Integer memberCount;

    public Team() {}

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

    public Integer getLeaderId() {
        return leaderId;
    }

    public void setLeaderId(Integer leaderId) {
        this.leaderId = leaderId;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getTopicTitle() {
        return topicTitle;
    }

    public void setTopicTitle(String topicTitle) {
        this.topicTitle = topicTitle;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public void setLeaderName(String leaderName) {
        this.leaderName = leaderName;
    }

    public Integer getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(Integer memberCount) {
        this.memberCount = memberCount;
    }

    @Override
    public String toString() {
        return "Team{" +
                "id=" + id +
                ", topicId=" + topicId +
                ", leaderId=" + leaderId +
                ", teamName='" + teamName + '\'' +
                ", status='" + status + '\'' +
                ", createTime='" + createTime + '\'' +
                ", topicTitle='" + topicTitle + '\'' +
                ", leaderName='" + leaderName + '\'' +
                ", memberCount=" + memberCount +
                '}';
    }
} 