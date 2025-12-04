package com.example.mapper;

import com.example.entity.InnovationEvaluation;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface InnovationEvaluationMapper {

    int insert(InnovationEvaluation innovationEvaluation);

    void updateById(InnovationEvaluation innovationEvaluation);

    void deleteById(Integer id);

    @Select("select ie.*, u.name as studentName, COALESCE(t.name, a.name) as evaluatorName " +
            "from `innovation_evaluation` ie " +
            "left join user u on ie.student_id = u.id " +
            "left join teacher t on ie.evaluator_id = t.id " +
            "left join admin a on ie.evaluator_id = a.id " +
            "where ie.id = #{id}")
    InnovationEvaluation selectById(Integer id);

    @Select("select ie.*, u.name as studentName, COALESCE(t.name, a.name) as evaluatorName " +
            "from `innovation_evaluation` ie " +
            "left join user u on ie.student_id = u.id " +
            "left join teacher t on ie.evaluator_id = t.id " +
            "left join admin a on ie.evaluator_id = a.id " +
            "where ie.student_id = #{studentId} " +
            "order by ie.evaluation_time desc")
    List<InnovationEvaluation> selectByStudentId(Integer studentId);

    @Select("select ie.*, u.name as studentName, COALESCE(t.name, a.name) as evaluatorName " +
            "from `innovation_evaluation` ie " +
            "left join user u on ie.student_id = u.id " +
            "left join teacher t on ie.evaluator_id = t.id " +
            "left join admin a on ie.evaluator_id = a.id " +
            "where ie.student_id = #{studentId} and ie.evaluator_id = #{evaluatorId}")
    InnovationEvaluation selectByStudentAndEvaluator(@Param("studentId") Integer studentId, @Param("evaluatorId") Integer evaluatorId);

    List<InnovationEvaluation> selectAll(InnovationEvaluation innovationEvaluation);

    /**
     * 根据评价人ID查询创新能力评价列表
     */
    List<InnovationEvaluation> selectMyEvaluations(InnovationEvaluation innovationEvaluation);

} 