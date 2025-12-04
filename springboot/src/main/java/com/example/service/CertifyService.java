package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Certify;
import com.example.entity.Teacher;
import com.example.mapper.CertifyMapper;
import com.example.mapper.TeacherMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 认证信息业务处理
 **/
@Service
public class CertifyService {

    @Resource
    private CertifyMapper certifyMapper;
    @Resource
    private TeacherMapper teacherMapper;

    /**
     * 新增
     */
    public void add(Certify certify) {
        Account currentUser = TokenUtils.getCurrentUser();
        certify.setTeacherId(currentUser.getId());
        certify.setStatus("待审核");
        certify.setTime(DateUtil.now());
        Teacher teacher = teacherMapper.selectById(currentUser.getId());
        teacher.setStatus("待审核");
        teacherMapper.updateById(teacher);
        certifyMapper.insert(certify);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        certifyMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            certifyMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Certify certify) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.TEACHER.name().equals(currentUser.getRole())) {
            certify.setReason("");
        }
        if ("审核通过".equals(certify.getStatus())) {
            Teacher teacher = teacherMapper.selectById(certify.getTeacherId());
            teacher.setStatus("认证通过");
            teacherMapper.updateById(teacher);
            teacherMapper.selectById(currentUser.getId());
        }
        if (certify.getStatus().equals("审核未通过")) {
            Integer teacherId = certify.getTeacherId();
            Teacher teacher = teacherMapper.selectById(teacherId);
            teacher.setStatus("认证未通过");
            teacherMapper.updateById(teacher);
            teacherMapper.selectById(currentUser.getId());
        }
        certifyMapper.updateById(certify);
    }

    /**
     * 根据ID查询
     */
    public Certify selectById(Integer id) {
        return certifyMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Certify> selectAll(Certify certify) {
        return certifyMapper.selectAll(certify);
    }

    /**
     * 分页查询
     */
    public PageInfo<Certify> selectPage(Certify certify, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Certify> list = this.selectAll(certify);
        return PageInfo.of(list);
    }

    public Certify selectByUserId(Integer userId) {
        return certifyMapper.selectByUserId(userId);
    }


}