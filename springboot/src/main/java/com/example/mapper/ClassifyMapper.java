package com.example.mapper;

import com.example.entity.Classify;
import java.util.List;

/**
 * 操作classify相关数据接口
*/
public interface ClassifyMapper {

    /**
      * 新增
    */
    int insert(Classify classify);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Classify classify);

    /**
      * 根据ID查询
    */
    Classify selectById(Integer id);

    /**
      * 查询所有
    */
    List<Classify> selectAll(Classify classify);

}