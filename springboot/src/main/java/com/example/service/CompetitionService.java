package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Competition;
import com.example.mapper.CompetitionMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import javax.xml.crypto.Data;
import java.util.List;

/**
 * 大赛动态业务处理
 **/
@Service
public class CompetitionService {

    @Resource
    private CompetitionMapper competitionMapper;

    /**
     * 新增
     */
    public void add(Competition competition) {
        competition.setTime(DateUtil.now());
        competitionMapper.insert(competition);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        competitionMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            competitionMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Competition competition) {
        competitionMapper.updateById(competition);
    }

    /**
     * 根据ID查询
     */
    public Competition selectById(Integer id) {
        return competitionMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Competition> selectAll(Competition competition) {
        return competitionMapper.selectAll(competition);
    }

    /**
     * 分页查询
     */
    public PageInfo<Competition> selectPage(Competition competition, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Competition> list = this.selectAll(competition);
        return PageInfo.of(list);
    }
    public void updateViews(Integer id) {
        Competition competition = competitionMapper.selectById(id);
        competition.setViews(competition.getViews() + 1);
        competitionMapper.updateById(competition);
    }

}