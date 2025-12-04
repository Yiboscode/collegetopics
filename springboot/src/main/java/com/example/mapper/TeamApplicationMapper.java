package com.example.mapper;

import com.example.entity.TeamApplication;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TeamApplicationMapper {
    
    /**
     * 插入组队申请
     */
    int insert(TeamApplication teamApplication);
    
    /**
     * 删除组队申请
     */
    int deleteById(Integer id);
    
    /**
     * 更新组队申请
     */
    int updateById(TeamApplication teamApplication);
    
    /**
     * 根据ID查询组队申请
     */
    TeamApplication selectById(Integer id);
    
    /**
     * 根据团队ID查询所有申请（队长查看）
     */
    List<TeamApplication> selectByTeamId(Integer teamId);
    
    /**
     * 根据申请人ID查询其所有申请
     */
    List<TeamApplication> selectByApplicantId(Integer applicantId);
    
    /**
     * 查询所有申请
     */
    List<TeamApplication> selectAll(@Param("status") String status);
    
    /**
     * 检查是否已经申请过该团队
     */
    TeamApplication checkApplicationExists(@Param("teamId") Integer teamId, @Param("applicantId") Integer applicantId);
    
    /**
     * 获取待处理申请数量
     */
    Integer getPendingApplicationCount(Integer teamId);
} 