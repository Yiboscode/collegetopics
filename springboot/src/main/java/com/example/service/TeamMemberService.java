package com.example.service;

import com.example.entity.TeamMember;
import com.example.mapper.TeamMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamMemberService {

    @Autowired
    private TeamMemberMapper teamMemberMapper;

    /**
     * 添加团队成员
     */
    public void addMember(TeamMember teamMember) {
        teamMemberMapper.insert(teamMember);
    }

    /**
     * 删除团队成员
     */
    public void deleteMember(Integer id) {
        teamMemberMapper.deleteById(id);
    }

    /**
     * 更新团队成员信息
     */
    public void updateMember(TeamMember teamMember) {
        teamMemberMapper.updateById(teamMember);
    }

    /**
     * 根据团队ID查询所有成员
     */
    public List<TeamMember> selectByTeamId(Integer teamId) {
        return teamMemberMapper.selectByTeamId(teamId);
    }

    /**
     * 根据学生ID查询其所在的团队成员信息
     */
    public TeamMember selectByStudentId(Integer studentId) {
        return teamMemberMapper.selectByStudentId(studentId);
    }

    /**
     * 查询所有团队成员
     */
    public List<TeamMember> selectAll() {
        return teamMemberMapper.selectAll();
    }

    /**
     * 获取团队成员数量
     */
    public Integer getTeamMemberCount(Integer teamId) {
        return teamMemberMapper.getTeamMemberCount(teamId);
    }

    /**
     * 检查学生是否已经在团队中
     */
    public boolean isMemberExists(Integer teamId, Integer studentId) {
        TeamMember member = teamMemberMapper.checkMemberExists(teamId, studentId);
        return member != null;
    }
} 