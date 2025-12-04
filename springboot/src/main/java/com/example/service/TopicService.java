package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.entity.Topic;
import com.example.mapper.TopicMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 选题业务层方法
 */
@Service
public class TopicService {

    @Resource
    private TopicMapper topicMapper;

    public void add(Topic topic) {
        if (ObjectUtil.isEmpty(topic.getSubmitTime())) {
            topic.setSubmitTime(DateUtil.now());
        }
        if (ObjectUtil.isEmpty(topic.getStatus())) {
            topic.setStatus("待评价");
        }
        topicMapper.insert(topic);
    }

    public void updateById(Topic topic) {
        topic.setUpdateTime(DateUtil.now());
        topicMapper.updateById(topic);
    }

    public void deleteById(Integer id) {
        topicMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            topicMapper.deleteById(id);
        }
    }

    public Topic selectById(Integer id) {
        return topicMapper.selectById(id);
    }

    public List<Topic> selectAll(Topic topic) {
        return topicMapper.selectAll(topic);
    }

    public PageInfo<Topic> selectPage(Topic topic, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Topic> list = topicMapper.selectAll(topic);
        return PageInfo.of(list);
    }

} 