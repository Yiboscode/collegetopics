package com.example.entity;

public class TeamMember {
    private Integer id;
    private Integer teamId;
    private Integer studentId;
    private String role;
    private String joinTime;
    private String status;
    
    // 关联字段
    private String studentName;
    private String teamName;
    private String avatar;

    public TeamMember() {}

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

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getJoinTime() {
        return joinTime;
    }

    public void setJoinTime(String joinTime) {
        this.joinTime = joinTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "TeamMember{" +
                "id=" + id +
                ", teamId=" + teamId +
                ", studentId=" + studentId +
                ", role='" + role + '\'' +
                ", joinTime='" + joinTime + '\'' +
                ", status='" + status + '\'' +
                ", studentName='" + studentName + '\'' +
                ", teamName='" + teamName + '\'' +
                ", avatar='" + avatar + '\'' +
                '}';
    }
} 