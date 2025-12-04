package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Account;
import com.example.entity.Qa;
import com.example.mapper.QaMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 创业问答业务处理
 **/
@Service
public class QaService {

    @Resource
    private QaMapper qaMapper;
    @Autowired
    private TokenUtils tokenUtils;

    /**
     * 新增
     */
    public void add(Qa qa) {
        Account currentUser = TokenUtils.getCurrentUser();
        qa.setUserId(currentUser.getId());
        qa.setTime(DateUtil.now());
        qaMapper.insert(qa);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        qaMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            qaMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Qa qa) {
        Account currentUser = TokenUtils.getCurrentUser();
        qa.setTeacherId(currentUser.getId());
        qaMapper.updateById(qa);
    }

    /**
     * 根据ID查询
     */
    public Qa selectById(Integer id) {
        return qaMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Qa> selectAll(Qa qa) {
        return qaMapper.selectAll(qa);
    }

    /**
     * 分页查询
     */
    public PageInfo<Qa> selectPage(Qa qa, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Qa> list = this.selectAll(qa);
        return PageInfo.of(list);
    }

}