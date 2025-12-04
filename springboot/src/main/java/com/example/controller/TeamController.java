package com.example.controller;

import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.Team;
import com.example.service.TeamService;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/team")
public class TeamController {

    @Autowired
    private TeamService teamService;

    @PostMapping("/add")
    public Result add(@RequestBody Team team) {
        Account currentUser = TokenUtils.getCurrentUser();
        team.setLeaderId(currentUser.getId());
        teamService.createTeam(team);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.deleteTeam(id, currentUser.getId());
        return Result.success();
    }

    @PutMapping("/update")
    public Result updateById(@RequestBody Team team) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.updateTeam(team, currentUser.getId());
        return Result.success();
    }

    @GetMapping("/selectAll")
    public Result selectAll(@RequestParam(required = false) String teamName) {
        List<Team> list = teamService.selectAll(teamName);
        return Result.success(list);
    }

    @GetMapping("/selectPage")
    public Result selectPage(Team team,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Team> pageInfo = teamService.selectPage(team, pageNum, pageSize);
        return Result.success(pageInfo);
    }

    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Team team = teamService.selectById(id);
        return Result.success(team);
    }

    @GetMapping("/selectByTopicId/{topicId}")
    public Result selectByTopicId(@PathVariable Integer topicId) {
        Team team = teamService.selectByTopicId(topicId);
        return Result.success(team);
    }

    @GetMapping("/myTeam")
    public Result getMyTeam() {
        Account currentUser = TokenUtils.getCurrentUser();
        Team team = teamService.selectByStudentId(currentUser.getId());
        return Result.success(team);
    }

    @PostMapping("/quit/{teamId}")
    public Result quitTeam(@PathVariable Integer teamId) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.quitTeam(teamId, currentUser.getId());
        return Result.success();
    }

    @PostMapping("/transferLeadership")
    public Result transferLeadership(@RequestParam Integer teamId, @RequestParam Integer newLeaderId) {
        Account currentUser = TokenUtils.getCurrentUser();
        teamService.transferLeadership(teamId, currentUser.getId(), newLeaderId);
        return Result.success();
    }

    @GetMapping("/isTeamFull/{teamId}")
    public Result isTeamFull(@PathVariable Integer teamId) {
        boolean isFull = teamService.isTeamFull(teamId);
        return Result.success(isFull);
    }
}
