package com.example.entity;


/**
 * 创业项目
*/
public class Project {
    /** 主键ID */
    private Integer id;
    /** 教师Id */
    private Integer teacherId;
    /** 分类Id */
    private Integer classifyId;
    /** 标题 */
    private String title;
    /** 简介 */
    private String introduce;
    /** 内容 */
    private String content;
    /** 图片 */
    private String img;
    /** 浏览量 */
    private Integer views;
    /** 审核状态 */
    private String status;
    /** 审核原因 */
    private String reason;
    private String teacherName;
    private String classifyName;
    private String time;
    private Boolean userCollect;
    private Integer collectCount;

    public Boolean getUserCollect() {
        return userCollect;
    }

    public void setUserCollect(Boolean userCollect) {
        this.userCollect = userCollect;
    }

    public Integer getCollectCount() {
        return collectCount;
    }

    public void setCollectCount(Integer collectCount) {
        this.collectCount = collectCount;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Integer teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public Integer getClassifyId() {
        return classifyId;
    }

    public void setClassifyId(Integer classifyId) {
        this.classifyId = classifyId;
    }

    public String getClassifyName() {
        return classifyName;
    }

    public void setClassifyName(String classifyName) {
        this.classifyName = classifyName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

}