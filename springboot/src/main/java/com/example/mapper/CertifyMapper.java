package com.example.mapper;

import com.example.entity.Certify;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 操作certify相关数据接口
*/
public interface CertifyMapper {

    /**
      * 新增
    */
    int insert(Certify certify);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Certify certify);

    /**
      * 根据ID查询
    */
    Certify selectById(Integer id);

    /**
      * 查询所有
    */
    List<Certify> selectAll(Certify certify);

    @Select("select * from certify where teacher_id = #{teacherId}")
    Certify selectByUserId(Integer userId);

}