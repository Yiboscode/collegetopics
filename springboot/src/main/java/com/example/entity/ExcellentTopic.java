package com.example.entity;

public class ExcellentTopic {

    /** 主键ID */
    private Integer id;
    /** 选题标题 */
    private String title;
    /** 选题描述 */
    private String description;
    /** 选题分类 */
    private String category;
    /** 获奖信息 */
    private String awardInfo;
    /** 年份 */
    private Integer year;
    /** 标签 */
    private String tags;
    /** 图片地址 */
    private String imageUrl;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getAwardInfo() {
        return awardInfo;
    }

    public void setAwardInfo(String awardInfo) {
        this.awardInfo = awardInfo;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
} 