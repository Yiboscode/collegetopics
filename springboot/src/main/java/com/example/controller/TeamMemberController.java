package com.example.controller;

import com.example.common.Result;
import com.example.entity.TeamMember;
import com.example.service.TeamMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/teamMember")
public class TeamMemberController {

    @Autowired
    private TeamMemberService teamMemberService;

    /**
     * 添加团队成员
     */
    @PostMapping("/add")
    public Result add(@RequestBody TeamMember teamMember) {
        teamMemberService.addMember(teamMember);
        return Result.success();
    }

    /**
     * 删除团队成员
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        teamMemberService.deleteMember(id);
        return Result.success();
    }

    /**
     * 更新团队成员信息
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody TeamMember teamMember) {
        teamMemberService.updateMember(teamMember);
        return Result.success();
    }

    /**
     * 根据团队ID查询所有成员
     */
    @GetMapping("/selectByTeamId/{teamId}")
    public Result selectByTeamId(@PathVariable Integer teamId) {
        List<TeamMember> list = teamMemberService.selectByTeamId(teamId);
        return Result.success(list);
    }

    /**
     * 根据学生ID查询其所在的团队成员信息
     */
    @GetMapping("/selectByStudentId/{studentId}")
    public Result selectByStudentId(@PathVariable Integer studentId) {
        TeamMember teamMember = teamMemberService.selectByStudentId(studentId);
        return Result.success(teamMember);
    }

    /**
     * 查询所有团队成员
     */
    @GetMapping("/selectAll")
    public Result selectAll() {
        List<TeamMember> list = teamMemberService.selectAll();
        return Result.success(list);
    }

    /**
     * 获取团队成员数量
     */
    @GetMapping("/getTeamMemberCount/{teamId}")
    public Result getTeamMemberCount(@PathVariable Integer teamId) {
        Integer count = teamMemberService.getTeamMemberCount(teamId);
        return Result.success(count);
    }

    /**
     * 检查学生是否已经在团队中
     */
    @GetMapping("/isMemberExists")
    public Result isMemberExists(@RequestParam Integer teamId, @RequestParam Integer studentId) {
        boolean exists = teamMemberService.isMemberExists(teamId, studentId);
        return Result.success(exists);
    }
} 