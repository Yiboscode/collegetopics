package com.example.entity;


/**
 * 评论信息
*/
public class Evaluate {
    /** ID */
    private Integer id;
    /** 用户IDId */
    private Integer userId;
    /** 项目IDId */
    private Integer projectId;
    /** 报名IDId */
    private Integer enrollId;
    /** 评论内容 */
    private String context;
    /** 时间 */
    private String time;
    private String userName;
    private String projectName;
    private String enrollName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public Integer getEnrollId() {
        return enrollId;
    }

    public void setEnrollId(Integer enrollId) {
        this.enrollId = enrollId;
    }

    public String getEnrollName() {
        return enrollName;
    }

    public void setEnrollName(String enrollName) {
        this.enrollName = enrollName;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

}