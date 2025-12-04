package com.example.controller;


import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import com.example.common.Result;
import com.example.entity.Classify;
import com.example.entity.Enroll;
import com.example.entity.Project;
import com.example.entity.Topic;
import com.example.entity.TopicEvaluation;
import com.example.service.ClassifyService;
import com.example.service.EnrollService;
import com.example.service.ProjectService;
import com.example.service.TopicService;
import com.example.service.TopicEvaluationService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@RestController
@RequestMapping("/echarts")
public class EchartsController {


    @Resource
    public ProjectService projectService;
    @Resource
    private ClassifyService classifyService;
    @Resource
    private EnrollService enrollService;
    @Resource
    private TopicService topicService;
    @Resource
    private TopicEvaluationService topicEvaluationService;

    @GetMapping("/pie")
    public Result pie() {
        List<Map<String, Object>> list = new ArrayList<>();

    //查询出所有分类信息
    List<Classify> classifys = classifyService.selectAll(null);
    //查出所有信息
    List<Project> project = projectService.selectAll(null);
         for (Classify classify : classifys) {
        long count = project.stream().filter(x -> x.getClassifyId().equals(classify.getId())).count();
        Map<String, Object> map = new HashMap<>();
        map.put("name", classify.getName());
        map.put("value", count);
        list.add(map);
    }
        return Result.success(list);
}

    @GetMapping("line")
    public Result line() {
        Map<String, Object> resultMap = new HashMap<>();
        List<Integer> yList = new ArrayList<>();

        Date today = new Date();
        DateTime start = DateUtil.offsetDay(today, -6);
        List<String> xList = DateUtil.rangeToList(start, today, DateField.DAY_OF_YEAR).stream().map(DateUtil::formatDate).toList();
        List<Enroll> enroll = enrollService.selectAll(new Enroll());
        // 按日期统计审核通过的记录数
        for (String day : xList) {
            long count = enroll.stream().filter(x -> x.getTime() != null && DateUtil.formatDate(DateUtil.parse(x.getTime())).startsWith(day) && "审核通过".equals(x.getStatus())).count();
            yList.add((int) count);
        }
        resultMap.put("xAxis",xList);
        resultMap.put("yAxis",yList);
        return Result.success(resultMap);
    }

    /**
     * 选题分类统计 - 饼图
     */
    @GetMapping("/topicCategory")
    public Result topicCategory() {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Topic> topics = topicService.selectAll(new Topic());
        
        // 按分类统计选题数量
        Map<String, Long> categoryCount = new HashMap<>();
        for (Topic topic : topics) {
            String category = topic.getCategory();
            categoryCount.put(category, categoryCount.getOrDefault(category, 0L) + 1);
        }
        
        for (Map.Entry<String, Long> entry : categoryCount.entrySet()) {
            Map<String, Object> map = new HashMap<>();
            map.put("name", entry.getKey());
            map.put("value", entry.getValue());
            list.add(map);
        }
        
        return Result.success(list);
    }

    /**
     * 选题状态统计 - 饼图
     */
    @GetMapping("/topicStatus")
    public Result topicStatus() {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Topic> topics = topicService.selectAll(new Topic());
        
        // 按状态统计选题数量
        Map<String, Long> statusCount = new HashMap<>();
        for (Topic topic : topics) {
            String status = topic.getStatus();
            statusCount.put(status, statusCount.getOrDefault(status, 0L) + 1);
        }
        
        for (Map.Entry<String, Long> entry : statusCount.entrySet()) {
            Map<String, Object> map = new HashMap<>();
            map.put("name", entry.getKey());
            map.put("value", entry.getValue());
            list.add(map);
        }
        
        return Result.success(list);
    }

    /**
     * 选题提交趋势 - 折线图
     */
    @GetMapping("/topicTrend")
    public Result topicTrend() {
        Map<String, Object> resultMap = new HashMap<>();
        List<Integer> yList = new ArrayList<>();

        Date today = new Date();
        DateTime start = DateUtil.offsetDay(today, -6);
        List<String> xList = DateUtil.rangeToList(start, today, DateField.DAY_OF_YEAR).stream().map(DateUtil::formatDate).toList();
        List<Topic> topics = topicService.selectAll(new Topic());
        
        // 按日期统计选题提交数
        for (String day : xList) {
            long count = topics.stream().filter(x -> x.getSubmitTime() != null && 
                DateUtil.formatDate(DateUtil.parse(x.getSubmitTime())).equals(day)).count();
            yList.add((int) count);
        }
        
        resultMap.put("xAxis", xList);
        resultMap.put("yAxis", yList);
        return Result.success(resultMap);
    }

    /**
     * 评价分数分布 - 柱状图
     */
    @GetMapping("/evaluationScore")
    public Result evaluationScore() {
        Map<String, Object> resultMap = new HashMap<>();
        List<TopicEvaluation> evaluations = topicEvaluationService.selectAll(new TopicEvaluation());
        
        // 分数区间
        List<String> scoreRanges = Arrays.asList("0-3分", "4-6分", "7-9分", "10-12分", "13-15分");
        List<Integer> counts = new ArrayList<>();
        
        for (String range : scoreRanges) {
            long count = 0;
            switch (range) {
                case "0-3分":
                    count = evaluations.stream().filter(e -> e.getTotalScore().doubleValue() <= 3).count();
                    break;
                case "4-6分":
                    count = evaluations.stream().filter(e -> e.getTotalScore().doubleValue() > 3 && e.getTotalScore().doubleValue() <= 6).count();
                    break;
                case "7-9分":
                    count = evaluations.stream().filter(e -> e.getTotalScore().doubleValue() > 6 && e.getTotalScore().doubleValue() <= 9).count();
                    break;
                case "10-12分":
                    count = evaluations.stream().filter(e -> e.getTotalScore().doubleValue() > 9 && e.getTotalScore().doubleValue() <= 12).count();
                    break;
                case "13-15分":
                    count = evaluations.stream().filter(e -> e.getTotalScore().doubleValue() > 12).count();
                    break;
            }
            counts.add((int) count);
        }
        
        resultMap.put("xAxis", scoreRanges);
        resultMap.put("yAxis", counts);
        return Result.success(resultMap);
    }

    /**
     * 月度选题统计 - 柱状图
     */
    @GetMapping("/monthlyTopic")
    public Result monthlyTopic() {
        Map<String, Object> resultMap = new HashMap<>();
        List<Topic> topics = topicService.selectAll(new Topic());
        
        // 最近12个月
        List<String> months = new ArrayList<>();
        List<Integer> counts = new ArrayList<>();
        
        Calendar cal = Calendar.getInstance();
        for (int i = 11; i >= 0; i--) {
            cal.add(Calendar.MONTH, -i);
            String month = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
            months.add(month);
            
            final String monthStr = month;
            long count = topics.stream().filter(t -> t.getSubmitTime() != null && 
                t.getSubmitTime().startsWith(monthStr)).count();
            counts.add((int) count);
            
            cal = Calendar.getInstance(); // 重置
        }
        
        resultMap.put("xAxis", months);
        resultMap.put("yAxis", counts);
        return Result.success(resultMap);
    }

    /**
     * 综合数据统计
     */
    @GetMapping("/topicStats")
    public Result topicStats() {
        Map<String, Object> stats = new HashMap<>();
        
        List<Topic> topics = topicService.selectAll(new Topic());
        List<TopicEvaluation> evaluations = topicEvaluationService.selectAll(new TopicEvaluation());
        
        // 基础统计
        stats.put("totalTopics", topics.size());
        stats.put("totalEvaluations", evaluations.size());
        stats.put("pendingTopics", topics.stream().filter(t -> "待评价".equals(t.getStatus())).count());
        stats.put("approvedTopics", topics.stream().filter(t -> "审核通过".equals(t.getStatus())).count());
        
        // 平均分
        if (!evaluations.isEmpty()) {
            double avgScore = evaluations.stream()
                .mapToDouble(e -> e.getTotalScore().doubleValue())
                .average()
                .orElse(0.0);
            stats.put("averageScore", Math.round(avgScore * 100.0) / 100.0);
        } else {
            stats.put("averageScore", 0.0);
        }
        
        // 本月新增
        String thisMonth = DateUtil.format(new Date(), "yyyy-MM");
        long thisMonthCount = topics.stream()
            .filter(t -> t.getSubmitTime() != null && t.getSubmitTime().startsWith(thisMonth))
            .count();
        stats.put("thisMonthTopics", thisMonthCount);
        
        return Result.success(stats);
    }

}
