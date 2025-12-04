package com.example.mapper;

import com.example.entity.Competition;
import java.util.List;

/**
 * 操作competition相关数据接口
*/
public interface CompetitionMapper {

    /**
      * 新增
    */
    int insert(Competition competition);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Competition competition);

    /**
      * 根据ID查询
    */
    Competition selectById(Integer id);

    /**
      * 查询所有
    */
    List<Competition> selectAll(Competition competition);

}