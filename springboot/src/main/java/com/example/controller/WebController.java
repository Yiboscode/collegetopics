package com.example.controller;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.lang.Dict;
import com.example.common.Result;
import com.example.common.enums.RoleEnum;
import com.example.entity.*;
import com.example.service.*;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class WebController {

    @Resource
    private AdminService adminService;
    @Resource
    private UserService userService;
    @Resource
    private TeacherService teacherService;
    @Resource
    private ClassifyService classifyService;
    @Resource
    private ProjectService projectService;
    @Resource
    private EnrollService enrollService;

    /**
     * 默认请求接口
     */
    @GetMapping("/")
    public Result hello () {
        return Result.success();
    }

    /**
     * 登录
     */
    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        Account loginAccount = null;
        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
            loginAccount = adminService.login(account);
        } else if (RoleEnum.TEACHER.name().equals(account.getRole())) {
            loginAccount = teacherService.login(account);
        } else if (RoleEnum.USER.name().equals(account.getRole())) {
            loginAccount = userService.login(account);
        }
        return Result.success(loginAccount);
    }

    /**
     * 注册
     */
    @PostMapping("/register")
    public Result register(@RequestBody Account account) {
        if (RoleEnum.USER.name().equals(account.getRole())) {
            User user = new User();
            BeanUtil.copyProperties(account, user);
            userService.add(user);
        } else if (RoleEnum.TEACHER.name().equals(account.getRole())) {
            Teacher teacher = new Teacher();
            BeanUtil.copyProperties(account, teacher);
            teacher.setStatus("未认证");
            teacherService.add(teacher);
        }
        return Result.success();
    }

    /**
     * 修改密码
     */
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Account account) {
        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
            adminService.updatePassword(account);
        } else if (RoleEnum.TEACHER.name().equals(account.getRole())) {
            teacherService.updatePassword(account);
        } else if (RoleEnum.USER.name().equals(account.getRole())) {
            userService.updatePassword(account);
        }
        return Result.success();
    }

    @GetMapping("/count")
    public Result count () {
        List<Teacher> teacherList = teacherService.selectAll(null);
        List<Project> projects = projectService.selectAll(null);
        List<Classify> classifies = classifyService.selectAll(null);
        List<Enroll> enrolls = enrollService.selectAll(null);

        Dict dict = Dict.create().set("teacher", teacherList.stream().filter(teacher -> "认证通过" .equals(teacher.getStatus())).count())
                .set("project", projects.stream().filter(project -> "审核通过" .equals(project.getStatus())).count())
                .set("classify", classifies.size())
                .set("enroll", enrolls.stream().filter(enroll -> "审核通过" .equals(enroll.getStatus())).count());
        return Result.success(dict);
    }



}
