package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Promote;
import com.example.mapper.PromoteMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 宣传视频信息业务处理
 **/
@Service
public class PromoteService {

    @Resource
    private PromoteMapper promoteMapper;

    /**
     * 新增
     */
    public void add(Promote promote) {
        promote.setTime(DateUtil.now());
        promoteMapper.insert(promote);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        promoteMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            promoteMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Promote promote) {
        promoteMapper.updateById(promote);
    }

    /**
     * 根据ID查询
     */
    public Promote selectById(Integer id) {
        return promoteMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Promote> selectAll(Promote promote) {
        return promoteMapper.selectAll(promote);
    }

    /**
     * 分页查询
     */
    public PageInfo<Promote> selectPage(Promote promote, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Promote> list = this.selectAll(promote);
        return PageInfo.of(list);
    }

    public void updateViews(Integer id) {
        Promote promote = promoteMapper.selectById(id);
        promote.setViews(promote.getViews() + 1);
        promoteMapper.updateById(promote);
    }

}