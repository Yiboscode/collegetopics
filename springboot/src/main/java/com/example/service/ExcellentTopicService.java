package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.common.Result;
import com.example.entity.ExcellentTopic;
import com.example.mapper.ExcellentTopicMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 优秀选题库业务层方法
 */
@Service
public class ExcellentTopicService {

    @Resource
    private ExcellentTopicMapper excellentTopicMapper;

    public void add(ExcellentTopic excellentTopic) {
        excellentTopicMapper.insert(excellentTopic);
    }

    public void updateById(ExcellentTopic excellentTopic) {
        excellentTopicMapper.updateById(excellentTopic);
    }

    public void deleteById(Integer id) {
        excellentTopicMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            excellentTopicMapper.deleteById(id);
        }
    }

    public ExcellentTopic selectById(Integer id) {
        return excellentTopicMapper.selectById(id);
    }

    public List<ExcellentTopic> selectAll(ExcellentTopic excellentTopic) {
        return excellentTopicMapper.selectAll(excellentTopic);
    }

    public PageInfo<ExcellentTopic> selectPage(ExcellentTopic excellentTopic, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<ExcellentTopic> list = excellentTopicMapper.selectAll(excellentTopic);
        return PageInfo.of(list);
    }

    /**
     * 根据分类查询优秀选题
     */
    public List<ExcellentTopic> getByCategory(String category) {
        return excellentTopicMapper.selectByCategory(category);
    }

    /**
     * 根据年份查询优秀选题
     */
    public List<ExcellentTopic> getByYear(Integer year) {
        return excellentTopicMapper.selectByYear(year);
    }

    /**
     * 获取所有分类
     */
    public List<String> getAllCategories() {
        return excellentTopicMapper.selectAllCategories();
    }

    /**
     * 获取所有年份
     */
    public List<Integer> getAllYears() {
        return excellentTopicMapper.selectAllYears();
    }

    /**
     * 推荐相似选题
     */
    public List<ExcellentTopic> recommend(String keywords, String category, Integer limit) {
        return excellentTopicMapper.selectRecommend(keywords, category, limit);
    }

    /**
     * 获取统计信息
     */
    public Result getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取所有数据进行统计
        List<ExcellentTopic> allTopics = excellentTopicMapper.selectAll(new ExcellentTopic());
        
        // 总数统计
        stats.put("total", allTopics.size());
        
        // 分类统计
        long categoriesCount = allTopics.stream()
                .map(ExcellentTopic::getCategory)
                .filter(category -> category != null && !category.trim().isEmpty())
                .distinct()
                .count();
        stats.put("categories", categoriesCount);
        
        // 年份统计
        long yearsCount = allTopics.stream()
                .map(ExcellentTopic::getYear)
                .filter(year -> year != null)
                .distinct()
                .count();
        stats.put("years", yearsCount);
        
        // 本年新增统计
        int currentYear = LocalDateTime.now().getYear();
        long thisYearCount = allTopics.stream()
                .filter(topic -> topic.getYear() != null && topic.getYear().equals(currentYear))
                .count();
        stats.put("thisYear", thisYearCount);
        
        return Result.success(stats);
    }
} 