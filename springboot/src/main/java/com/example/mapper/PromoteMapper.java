package com.example.mapper;

import com.example.entity.Promote;
import java.util.List;

/**
 * 操作promote相关数据接口
*/
public interface PromoteMapper {

    /**
      * 新增
    */
    int insert(Promote promote);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Promote promote);

    /**
      * 根据ID查询
    */
    Promote selectById(Integer id);

    /**
      * 查询所有
    */
    List<Promote> selectAll(Promote promote);

}