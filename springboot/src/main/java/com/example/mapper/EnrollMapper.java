package com.example.mapper;

import com.example.entity.Enroll;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 操作enroll相关数据接口
*/
public interface EnrollMapper {

    /**
      * 新增
    */
    int insert(Enroll enroll);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Enroll enroll);

    /**
      * 根据ID查询
    */
    Enroll selectById(Integer id);

    /**
      * 查询所有
    */
    List<Enroll> selectAll(Enroll enroll);

    List<Integer> selectUserProject(Integer userId);

    @Select("select * from enroll where user_id = #{userId} and project_id = #{projectId} and status= '审核通过'")
    Enroll selectByUserIdAndProjectId(@Param("userId") Integer userId,
                                      @Param("projectId") Integer projectId);
}