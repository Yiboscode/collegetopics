package com.example.service;

import com.example.entity.Classify;
import com.example.mapper.ClassifyMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 分类信息业务处理
 **/
@Service
public class ClassifyService {

    @Resource
    private ClassifyMapper classifyMapper;

    /**
     * 新增
     */
    public void add(Classify classify) {
        classifyMapper.insert(classify);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        classifyMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            classifyMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Classify classify) {
        classifyMapper.updateById(classify);
    }

    /**
     * 根据ID查询
     */
    public Classify selectById(Integer id) {
        return classifyMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Classify> selectAll(Classify classify) {
        return classifyMapper.selectAll(classify);
    }

    /**
     * 分页查询
     */
    public PageInfo<Classify> selectPage(Classify classify, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Classify> list = this.selectAll(classify);
        return PageInfo.of(list);
    }

}