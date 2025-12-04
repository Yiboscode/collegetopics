package com.example.mapper;

import com.example.entity.ExcellentTopic;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface ExcellentTopicMapper {

    int insert(ExcellentTopic excellentTopic);

    void updateById(ExcellentTopic excellentTopic);

    void deleteById(Integer id);

    @Select("select * from `excellent_topic` where id = #{id}")
    ExcellentTopic selectById(Integer id);

    List<ExcellentTopic> selectAll(ExcellentTopic excellentTopic);

    List<ExcellentTopic> selectByCategory(String category);

    List<ExcellentTopic> selectByYear(Integer year);

    List<String> selectAllCategories();

    List<Integer> selectAllYears();

    List<ExcellentTopic> selectRecommend(String keywords, String category, Integer limit);

} 