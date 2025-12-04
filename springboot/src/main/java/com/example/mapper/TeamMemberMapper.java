package com.example.mapper;

import com.example.entity.TeamMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TeamMemberMapper {
    
    /**
     * 插入团队成员
     */
    int insert(TeamMember teamMember);
    
    /**
     * 删除团队成员
     */
    int deleteById(Integer id);
    
    /**
     * 根据团队ID和学生ID删除成员
     */
    int deleteByTeamIdAndStudentId(@Param("teamId") Integer teamId, @Param("studentId") Integer studentId);
    
    /**
     * 更新团队成员信息
     */
    int updateById(TeamMember teamMember);
    
    /**
     * 根据ID查询团队成员
     */
    TeamMember selectById(Integer id);
    
    /**
     * 根据团队ID查询所有成员
     */
    List<TeamMember> selectByTeamId(Integer teamId);
    
    /**
     * 根据学生ID查询其所在的团队成员信息
     */
    TeamMember selectByStudentId(Integer studentId);
    
    /**
     * 查询所有团队成员
     */
    List<TeamMember> selectAll();
    
    /**
     * 获取团队成员数量
     */
    Integer getTeamMemberCount(Integer teamId);
    
    /**
     * 检查学生是否已经在团队中
     */
    TeamMember checkMemberExists(@Param("teamId") Integer teamId, @Param("studentId") Integer studentId);
} 