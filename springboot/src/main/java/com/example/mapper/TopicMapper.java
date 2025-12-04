package com.example.mapper;

import com.example.entity.Topic;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface TopicMapper {

    int insert(Topic topic);

    void updateById(Topic topic);

    void deleteById(Integer id);

    @Select("select * from `topic` where id = #{id}")
    Topic selectById(Integer id);

    List<Topic> selectAll(Topic topic);

} 