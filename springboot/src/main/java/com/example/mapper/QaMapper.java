package com.example.mapper;

import com.example.entity.Qa;
import java.util.List;

/**
 * 操作qa相关数据接口
*/
public interface QaMapper {

    /**
      * 新增
    */
    int insert(Qa qa);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Qa qa);

    /**
      * 根据ID查询
    */
    Qa selectById(Integer id);

    /**
      * 查询所有
    */
    List<Qa> selectAll(Qa qa);

}