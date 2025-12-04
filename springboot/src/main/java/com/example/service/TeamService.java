package com.example.service;

import com.example.common.enums.ResultCodeEnum;
import com.example.entity.Team;
import com.example.entity.TeamMember;
import com.example.exception.CustomException;
import com.example.mapper.TeamMapper;
import com.example.mapper.TeamMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class TeamService {

    @Autowired
    private TeamMapper teamMapper;

    @Autowired
    private TeamMemberMapper teamMemberMapper;

    /**
     * 创建团队
     */
    @Transactional
    public void createTeam(Team team) {
        // 检查选题是否已经有团队
        Team existingTeam = teamMapper.selectByTopicId(team.getTopicId());
        if (existingTeam != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "该选题已经有团队了！");
        }

        // 检查队长是否已经在其他团队中
        Team leaderTeam = teamMapper.selectByStudentId(team.getLeaderId());
        if (leaderTeam != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "您已经在其他团队中了！");
        }

        // 设置创建时间和状态
        team.setCreateTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        team.setStatus("招募中");

        // 创建团队
        teamMapper.insert(team);

        // 将队长加入团队成员表
        TeamMember leaderMember = new TeamMember();
        leaderMember.setTeamId(team.getId());
        leaderMember.setStudentId(team.getLeaderId());
        leaderMember.setRole("队长");
        leaderMember.setJoinTime(team.getCreateTime());
        leaderMember.setStatus("已加入");
        teamMemberMapper.insert(leaderMember);
    }

    /**
     * 删除团队
     */
    @Transactional
    public void deleteTeam(Integer id, Integer currentUserId) {
        Team team = teamMapper.selectById(id);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        // 只有队长可以解散团队
        if (!team.getLeaderId().equals(currentUserId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以解散团队！");
        }

        // 删除团队成员
        List<TeamMember> members = teamMemberMapper.selectByTeamId(id);
        for (TeamMember member : members) {
            teamMemberMapper.deleteById(member.getId());
        }

        // 删除团队
        teamMapper.deleteById(id);
    }

    /**
     * 更新团队信息
     */
    public void updateTeam(Team team, Integer currentUserId) {
        Team existingTeam = teamMapper.selectById(team.getId());
        if (existingTeam == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        // 只有队长可以修改团队信息
        if (!existingTeam.getLeaderId().equals(currentUserId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以修改团队信息！");
        }

        teamMapper.updateById(team);
    }

    /**
     * 查询团队列表
     */
    public List<Team> selectAll(String teamName) {
        return teamMapper.selectAll(teamName);

    /**
     * 分页查询团队列表
     */
    public com.github.pagehelper.PageInfo<Team> selectPage(Team team, Integer pageNum, Integer pageSize) {
        com.github.pagehelper.PageHelper.startPage(pageNum, pageSize);
        List<Team> list = teamMapper.selectAll(team.getTeamName());
        return com.github.pagehelper.PageInfo.of(list);
    }

    /**
     * 根据ID查询团队详情
     */
    public Team selectById(Integer id) {
        return teamMapper.selectById(id);
    }

    /**
     * 根据选题ID查询团队
     */
    public Team selectByTopicId(Integer topicId) {
        return teamMapper.selectByTopicId(topicId);
    }

    /**
     * 根据学生ID查询其所在的团队
     */
    public Team selectByStudentId(Integer studentId) {
        return teamMapper.selectByStudentId(studentId);
    }

    /**
     * 退出团队
     */
    @Transactional
    public void quitTeam(Integer teamId, Integer studentId) {
        Team team = teamMapper.selectById(teamId);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        // 队长不能直接退出，需要先转让队长
        if (team.getLeaderId().equals(studentId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "队长不能直接退出团队，请先转让队长或解散团队！");
        }

        // 从团队成员表中删除
        teamMemberMapper.deleteByTeamIdAndStudentId(teamId, studentId);
    }

    /**
     * 转让队长
     */
    @Transactional
    public void transferLeadership(Integer teamId, Integer currentLeaderId, Integer newLeaderId) {
        Team team = teamMapper.selectById(teamId);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        // 只有当前队长可以转让
        if (!team.getLeaderId().equals(currentLeaderId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以转让队长职位！");
        }

        // 检查新队长是否是团队成员
        TeamMember newLeaderMember = teamMemberMapper.checkMemberExists(teamId, newLeaderId);
        if (newLeaderMember == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "新队长必须是团队成员！");
        }

        // 更新团队表中的队长
        Team updateTeam = new Team();
        updateTeam.setId(teamId);
        updateTeam.setLeaderId(newLeaderId);
        teamMapper.updateById(updateTeam);

        // 更新原队长角色为成员
        TeamMember oldLeaderMember = teamMemberMapper.checkMemberExists(teamId, currentLeaderId);
        oldLeaderMember.setRole("成员");
        teamMemberMapper.updateById(oldLeaderMember);

        // 更新新队长角色
        newLeaderMember.setRole("队长");
        teamMemberMapper.updateById(newLeaderMember);
    }

    /**
     * 检查团队是否已满员（最多7人）
     */
    public boolean isTeamFull(Integer teamId) {
        Integer memberCount = teamMapper.getTeamMemberCount(teamId);
        return memberCount >= 7;
    }
} 