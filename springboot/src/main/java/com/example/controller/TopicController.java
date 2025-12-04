package com.example.controller;

import cn.hutool.core.date.DateUtil;
import com.example.common.Result;
import com.example.entity.Topic;
import com.example.entity.Account;
import com.example.service.TopicService;
import com.example.service.UserService;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 前端请求接口
 */
@RestController
@RequestMapping("/topic")
public class TopicController {

    @Resource
    private TopicService topicService;

    @Resource
    private UserService userService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Topic topic, HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        topic.setStudentId(currentUser.getId());
        topic.setStatus("待评价");
        topic.setSubmitTime(DateUtil.now());
        topic.setUpdateTime(DateUtil.now());
        topicService.add(topic);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result update(@RequestBody Topic topic) {
        topic.setUpdateTime(DateUtil.now());
        topicService.updateById(topic);
        return Result.success();
    }

    /**
     * 单个删除
     */
    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        topicService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result delete(@RequestBody List<Integer> ids) {
        topicService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 单个查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Topic topic = topicService.selectById(id);
        return Result.success(topic);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Topic topic) {
        List<Topic> list = topicService.selectAll(topic);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Topic topic,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        // 调试日志
        System.out.println("查询参数 - title: " + topic.getTitle() + ", category: " + topic.getCategory() + ", status: " + topic.getStatus());
        PageInfo<Topic> pageInfo = topicService.selectPage(topic, pageNum, pageSize);
        System.out.println("查询结果 - 总数: " + pageInfo.getTotal() + ", 当前页数据: " + pageInfo.getList().size());
        return Result.success(pageInfo);
    }

    /**
     * 获取我的选题
     */
    @GetMapping("/my")
    public Result selectMyTopics(@RequestParam(defaultValue = "1") Integer pageNum,
                                 @RequestParam(defaultValue = "10") Integer pageSize,
                                 HttpServletRequest request) {
        String token = TokenUtils.getToken(request);
        Account currentUser = TokenUtils.getCurrentUser(token);
        
        Topic topic = new Topic();
        topic.setStudentId(currentUser.getId());
        PageInfo<Topic> pageInfo = topicService.selectPage(topic, pageNum, pageSize);
        return Result.success(pageInfo);
    }
} 