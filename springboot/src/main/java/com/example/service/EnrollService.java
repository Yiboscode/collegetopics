package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.entity.Account;
import com.example.entity.Enroll;
import com.example.entity.Project;
import com.example.exception.CustomException;
import com.example.mapper.EnrollMapper;
import com.example.mapper.ProjectMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
/**
 * 报名信息业务处理
 **/
@Service
public class EnrollService {

    @Resource
    private EnrollMapper enrollMapper;
    @Resource
    private ProjectMapper projectMapper;
    /**
     * 新增
     */
    public void add(Enroll enroll) {
        Account currentUser = TokenUtils.getCurrentUser();
        Integer userId = currentUser.getId();
        Integer projectId = enroll.getProjectId();

        Enroll Enrolls = enrollMapper.selectByUserIdAndProjectId(userId, projectId);
        if (Enrolls != null) {
            throw new CustomException("500","您已报名该项目,请勿重复提交");
        }

        // 设置基础信息
        enroll.setUserId(userId);
        enroll.setTime(DateUtil.now());
        enroll.setStatus("待审核");

        // 插入记录
        enrollMapper.insert(enroll);

        // 获取项目教师信息并更新
        Project project = projectMapper.selectById(projectId);
        enroll.setTeacherId(project.getTeacherId());
        enroll.setTeacherName(project.getTeacherName());
        enrollMapper.updateById(enroll);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        enrollMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            enrollMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Enroll enroll) {
        enrollMapper.updateById(enroll);
    }

    /**
     * 根据ID查询
     */
    public Enroll selectById(Integer id) {
        return enrollMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Enroll> selectAll(Enroll enroll) {
        return enrollMapper.selectAll(enroll);
    }

    /**
     * 分页查询
     */
    public PageInfo<Enroll> selectPage(Enroll enroll, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Enroll> list = this.selectAll(enroll);
        return PageInfo.of(list);
    }

}