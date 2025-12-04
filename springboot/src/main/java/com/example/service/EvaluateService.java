package com.example.service;

import com.example.entity.Evaluate;
import com.example.mapper.EvaluateMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 评论信息业务处理
 **/
@Service
public class EvaluateService {

    @Resource
    private EvaluateMapper evaluateMapper;

    /**
     * 新增
     */
    public void add(Evaluate evaluate) {
        evaluateMapper.insert(evaluate);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        evaluateMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            evaluateMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Evaluate evaluate) {
        evaluateMapper.updateById(evaluate);
    }

    /**
     * 根据ID查询
     */
    public Evaluate selectById(Integer id) {
        return evaluateMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Evaluate> selectAll(Evaluate evaluate) {
        return evaluateMapper.selectAll(evaluate);
    }

    /**
     * 分页查询
     */
    public PageInfo<Evaluate> selectPage(Evaluate evaluate, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Evaluate> list = this.selectAll(evaluate);
        return PageInfo.of(list);
    }

}