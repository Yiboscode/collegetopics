package com.example.mapper;

import com.example.entity.Task;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 操作task相关数据接口
*/
public interface TaskMapper {

    /**
      * 新增
    */
    int insert(Task task);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Task task);

    /**
      * 根据ID查询
    */
    Task selectById(Integer id);

    /**
      * 查询所有
    */
    List<Task> selectAll(Task task);

    @Select("select task.*, teacher.name as teacherName, project.title as projectTitle " +
            "from task " +
            "left join teacher on task.teacher_id = teacher.id " +  // 补全ON关键字
            "left join project on task.project_id = project.id " +  // 补全ON关键字
            "where task.project_id = #{projectId}")                // 添加表名前缀
    List<Task> selectByProjectId(Integer projectId);

}