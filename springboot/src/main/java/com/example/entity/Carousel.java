package com.example.entity;


/**
 * 轮播图信息
*/
public class Carousel {
    /** ID */
    private Integer id;
    /** 项目IDId */
    private Integer projectId;
    /** 图片 */
    private String img;
    private String projectTitle;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

}