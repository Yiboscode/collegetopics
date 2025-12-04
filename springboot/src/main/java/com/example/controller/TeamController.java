package com.example.controller;

import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.Team;
import com.example.service.TeamService;
import com.example.utils.TokenUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/team")
public class TeamController {

    @Autowired
    private TeamService teamService;

    /**
     * 创建团队
     */
    @PostMapping("/add")
    public Result add(@RequestBody Team team) {
        Account currentUser = TokenUtils.getCurrentUser();
        team.setLeaderId(currentUser.getId());
        teamService.createTeam(team);
        return Result.success();
    }

    /**
     * 删除团队
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.deleteTeam(id, currentUser.getId());
        return Result.success();
    }

    /**
     * 更新团队信息
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Team team) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.updateTeam(team, currentUser.getId());
        return Result.success();
    }

    /**
     * 查询团队列表
     */
    @GetMapping("/selectAll")
    public Result selectAll(@RequestParam(required = false) String teamName) {
        List<Team> list = teamService.selectAll(teamName);
        return Result.success(list);
    /**
     * 分页查询团队列表
     */
    @GetMapping("/selectPage")
    public Result selectPage(Team team,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        com.github.pagehelper.PageInfo<Team> pageInfo = teamService.selectPage(team, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    }
    /**
     * 根据ID查询团队详情
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Team team = teamService.selectById(id);
        return Result.success(team);
    }

    /**
     * 根据选题ID查询团队
     */
    @GetMapping("/selectByTopicId/{topicId}")
    public Result selectByTopicId(@PathVariable Integer topicId) {
        Team team = teamService.selectByTopicId(topicId);
        return Result.success(team);
    }

    /**
     * 查询当前用户所在的团队
     */
    @GetMapping("/myTeam")
    public Result getMyTeam() {
        Account currentUser = TokenUtils.getCurrentUser();
        Team team = teamService.selectByStudentId(currentUser.getId());
        return Result.success(team);
    }

    /**
     * 退出团队
     */
    @PostMapping("/quit/{teamId}")
    public Result quitTeam(@PathVariable Integer teamId) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.quitTeam(teamId, currentUser.getId());
        return Result.success();
    }

    /**
     * 转让队长
     */
    @PostMapping("/transferLeadership")
    public Result transferLeadership(@RequestParam Integer teamId, @RequestParam Integer newLeaderId) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.transferLeadership(teamId, currentUser.getId(), newLeaderId);
        return Result.success();
    }

    /**
     * 检查团队是否已满员
     */
    @GetMapping("/isTeamFull/{teamId}")
    public Result isTeamFull(@PathVariable Integer teamId) {
        boolean isFull = teamService.isTeamFull(teamId);
        return Result.success(isFull);
    }
} 