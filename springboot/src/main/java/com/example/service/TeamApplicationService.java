package com.example.service;

import com.example.common.enums.ResultCodeEnum;
import com.example.entity.Team;
import com.example.entity.TeamApplication;
import com.example.entity.TeamMember;
import com.example.exception.CustomException;
import com.example.mapper.TeamApplicationMapper;
import com.example.mapper.TeamMapper;
import com.example.mapper.TeamMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class TeamApplicationService {

    @Autowired
    private TeamApplicationMapper teamApplicationMapper;

    @Autowired
    private TeamMapper teamMapper;

    @Autowired
    private TeamMemberMapper teamMemberMapper;

    /**
     * 申请加入团队
     */
    public void applyToTeam(TeamApplication teamApplication) {
        // 检查团队是否存在
        Team team = teamMapper.selectById(teamApplication.getTeamId());
        if (team == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队不存在！");
        }

        // 检查申请人是否已经在其他团队中
        Team existingTeam = teamMapper.selectByStudentId(teamApplication.getApplicantId());
        if (existingTeam != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "您已经在其他团队中了！");
        }

        // 检查是否已经申请过该团队
        TeamApplication existingApplication = teamApplicationMapper.checkApplicationExists(
                teamApplication.getTeamId(), teamApplication.getApplicantId());
        if (existingApplication != null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "您已经申请过该团队了！");
        }

        // 检查团队是否已满员
        Integer memberCount = teamMapper.getTeamMemberCount(teamApplication.getTeamId());
        if (memberCount >= 7) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队已满员！");
        }

        // 设置申请时间和状态
        teamApplication.setApplyTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        teamApplication.setStatus("pending");

        teamApplicationMapper.insert(teamApplication);
    }

    /**
     * 处理申请（同意或拒绝）
     */
    @Transactional
    public void handleApplication(Integer applicationId, String status, String rejectReason, Integer currentUserId) {
        TeamApplication application = teamApplicationMapper.selectById(applicationId);
        if (application == null) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "申请不存在！");
        }

        // 检查当前用户是否是队长
        Team team = teamMapper.selectById(application.getTeamId());
        if (!team.getLeaderId().equals(currentUserId)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "只有队长可以处理申请！");
        }

        // 如果是同意申请
        if ("approved".equals(status)) {
            // 再次检查团队是否已满员
            Integer memberCount = teamMapper.getTeamMemberCount(application.getTeamId());
            if (memberCount >= 7) {
                throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "团队已满员，无法加入！");
            }

            // 检查申请人是否已经在其他团队中
            Team existingTeam = teamMapper.selectByStudentId(application.getApplicantId());
            if (existingTeam != null) {
                throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "申请人已经在其他团队中了！");
            }

            // 将申请人加入团队成员表
            TeamMember newMember = new TeamMember();
            newMember.setTeamId(application.getTeamId());
            newMember.setStudentId(application.getApplicantId());
            newMember.setRole("成员");
            newMember.setJoinTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            newMember.setStatus("已加入");
            teamMemberMapper.insert(newMember);
        }

        // 更新申请状态
        application.setStatus(status);
        application.setHandleTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        if ("rejected".equals(status) && rejectReason != null) {
            application.setRejectReason(rejectReason);
        }
        teamApplicationMapper.updateById(application);
    }

    /**
     * 删除申请
     */
    public void deleteApplication(Integer id) {
        teamApplicationMapper.deleteById(id);
    }

    /**
     * 根据团队ID查询所有申请（队长查看）
     */
    public List<TeamApplication> selectByTeamId(Integer teamId) {
        return teamApplicationMapper.selectByTeamId(teamId);
    }

    /**
     * 根据申请人ID查询其所有申请
     */
    public List<TeamApplication> selectByApplicantId(Integer applicantId) {
        return teamApplicationMapper.selectByApplicantId(applicantId);
    }

    /**
     * 查询所有申请
     */
    public List<TeamApplication> selectAll(String status) {
        return teamApplicationMapper.selectAll(status);
    }

    /**
     * 根据ID查询申请详情
     */
    public TeamApplication selectById(Integer id) {
        return teamApplicationMapper.selectById(id);
    }

    /**
     * 获取团队待处理申请数量
     */
    public Integer getPendingApplicationCount(Integer teamId) {
        return teamApplicationMapper.getPendingApplicationCount(teamId);
    }
} 