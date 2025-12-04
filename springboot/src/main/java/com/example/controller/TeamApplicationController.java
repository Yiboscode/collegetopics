package com.example.controller;

import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.TeamApplication;
import com.example.service.TeamApplicationService;
import com.example.utils.TokenUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/teamApplication")
public class TeamApplicationController {

    @Autowired
    private TeamApplicationService teamApplicationService;

    /**
     * 申请加入团队
     */
    @PostMapping("/apply")
    public Result applyToTeam(@RequestBody TeamApplication teamApplication) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamApplication.setApplicantId(currentUser.getId());
        teamApplicationService.applyToTeam(teamApplication);
        return Result.success();
    }

    /**
     * 处理申请（同意或拒绝）
     */
    @PostMapping("/handle")
    public Result handleApplication(@RequestParam Integer applicationId, 
                                   @RequestParam String status, 
                                   @RequestParam(required = false) String rejectReason) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamApplicationService.handleApplication(applicationId, status, rejectReason, currentUser.getId());
        return Result.success();
    }

    /**
     * 删除申请
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        teamApplicationService.deleteApplication(id);
        return Result.success();
    }

    /**
     * 根据团队ID查询所有申请（队长查看）
     */
    @GetMapping("/selectByTeamId/{teamId}")
    public Result selectByTeamId(@PathVariable Integer teamId) {
        List<TeamApplication> list = teamApplicationService.selectByTeamId(teamId);
        return Result.success(list);
    }

    /**
     * 查询当前用户的所有申请
     */
    @GetMapping("/myApplications")
    public Result getMyApplications() {
        Account currentUser = TokenUtils.getCurrentUser();
        List<TeamApplication> list = teamApplicationService.selectByApplicantId(currentUser.getId());
        return Result.success(list);
    }

    /**
     * 查询所有申请
     */
    @GetMapping("/selectAll")
    public Result selectAll(@RequestParam(required = false) String status) {
        List<TeamApplication> list = teamApplicationService.selectAll(status);
        return Result.success(list);
    }

    /**
     * 根据ID查询申请详情
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        TeamApplication teamApplication = teamApplicationService.selectById(id);
        return Result.success(teamApplication);
    }

    /**
     * 获取团队待处理申请数量
     */
    @GetMapping("/getPendingApplicationCount/{teamId}")
    public Result getPendingApplicationCount(@PathVariable Integer teamId) {
        Integer count = teamApplicationService.getPendingApplicationCount(teamId);
        return Result.success(count);
    }

    /**
     * 撤销申请
     */
    @PostMapping("/withdraw/{id}")
    public Result withdrawApplication(@PathVariable Integer id) {
        Account currentUser = TokenUtils.getCurrentUser();
        TeamApplication application = teamApplicationService.selectById(id);
        
        // 只有申请人可以撤销自己的申请
        if (application != null && application.getApplicantId().equals(currentUser.getId()) 
            && "pending".equals(application.getStatus())) {
            teamApplicationService.deleteApplication(id);
            return Result.success();
        } else {
            return Result.error("400", "无法撤销该申请！");
        }
    }
} 