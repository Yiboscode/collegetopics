package com.example.mapper;

import com.example.entity.Team;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TeamMapper {
    
    /**
     * 插入团队
     */
    int insert(Team team);
    
    /**
     * 删除团队
     */
    int deleteById(Integer id);
    
    /**
     * 更新团队信息
     */
    int updateById(Team team);
    
    /**
     * 根据ID查询团队
     */
    Team selectById(Integer id);
    
    /**
     * 根据选题ID查询团队
     */
    Team selectByTopicId(Integer topicId);
    
    /**
     * 根据队长ID查询团队
     */
    Team selectByLeaderId(Integer leaderId);
    
    /**
     * 查询所有团队
     */
    List<Team> selectAll(@Param("teamName") String teamName);
    
    /**
     * 检查学生是否已经在某个团队中
     */
    Team selectByStudentId(Integer studentId);
    
    /**
     * 获取团队成员数量
     */
    Integer getTeamMemberCount(Integer teamId);
} 