package com.example.service;

import com.example.common.enums.ResultCodeEnum;
import com.example.entity.Team;
import com.example.entity.TeamMember;
import com.example.exception.CustomException;
import com.example.mapper.TeamMapper;
import com.example.mapper.TeamMemberMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
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

    @Transactional
    public void createTeam(Team team) {
        Team existingTeam = teamMapper.selectByTopicId(team.getTopicId());
        if (existingTeam != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "该选题已经有团队了！");
        }

        Team leaderTeam = teamMapper.selectByStudentId(team.getLeaderId());
        if (leaderTeam != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "您已经在其他团队中了！");
        }

        team.setCreateTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        team.setStatus("招募中");

        teamMapper.insert(team);

        TeamMember leaderMember = new TeamMember();
        leaderMember.setTeamId(team.getId());
        leaderMember.setStudentId(team.getLeaderId());
        leaderMember.setRole("队长");
        leaderMember.setJoinTime(team.getCreateTime());
        leaderMember.setStatus("已加入");
        teamMemberMapper.insert(leaderMember);
    }

    @Transactional
    public void deleteTeam(Integer id, Integer currentUserId) {
        Team team = teamMapper.selectById(id);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        if (!team.getLeaderId().equals(currentUserId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以解散团队！");
        }

        List<TeamMember> members = teamMemberMapper.selectByTeamId(id);
        for (TeamMember member : members) {
            teamMemberMapper.deleteById(member.getId());
        }

        teamMapper.deleteById(id);
    }

    public void updateTeam(Team team, Integer currentUserId) {
        Team existingTeam = teamMapper.selectById(team.getId());
        if (existingTeam == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        if (!existingTeam.getLeaderId().equals(currentUserId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以修改团队信息！");
        }

        teamMapper.updateById(team);
    }

    public List<Team> selectAll(String teamName) {
        return teamMapper.selectAll(teamName);
    }

    public PageInfo<Team> selectPage(Team team, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        String teamName = team != null ? team.getTeamName() : null;
        List<Team> list = teamMapper.selectAll(teamName);
        return PageInfo.of(list);
    }

    public Team selectById(Integer id) {
        return teamMapper.selectById(id);
    }

    public Team selectByTopicId(Integer topicId) {
        return teamMapper.selectByTopicId(topicId);
    }

    public Team selectByStudentId(Integer studentId) {
        return teamMapper.selectByStudentId(studentId);
    }

    @Transactional
    public void quitTeam(Integer teamId, Integer studentId) {
        Team team = teamMapper.selectById(teamId);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        if (team.getLeaderId().equals(studentId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "队长不能直接退出团队，请先转让队长或解散团队！");
        }

        teamMemberMapper.deleteByTeamIdAndStudentId(teamId, studentId);
    }

    @Transactional
    public void transferLeadership(Integer teamId, Integer currentLeaderId, Integer newLeaderId) {
        Team team = teamMapper.selectById(teamId);
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        if (!team.getLeaderId().equals(currentLeaderId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以转让队长职位！");
        }

        TeamMember newLeaderMember = teamMemberMapper.checkMemberExists(teamId, newLeaderId);
        if (newLeaderMember == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "新队长必须是团队成员！");
        }

        Team updateTeam = new Team();
        updateTeam.setId(teamId);
        updateTeam.setLeaderId(newLeaderId);
        teamMapper.updateById(updateTeam);

        TeamMember oldLeaderMember = teamMemberMapper.checkMemberExists(teamId, currentLeaderId);
        oldLeaderMember.setRole("成员");
        teamMemberMapper.updateById(oldLeaderMember);

        newLeaderMember.setRole("队长");
        teamMemberMapper.updateById(newLeaderMember);
    }

    public boolean isTeamFull(Integer teamId) {
        Integer memberCount = teamMapper.getTeamMemberCount(teamId);
        return memberCount >= 7;
    }
}
