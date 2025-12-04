package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.entity.Account;
import com.example.entity.Collect;
import com.example.entity.Project;
import com.example.mapper.CollectMapper;
import com.example.mapper.ProjectMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 创业项目业务处理
 **/
@Service
public class ProjectService {

    @Resource
    private ProjectMapper projectMapper;
    @Resource
    private CollectMapper collectMapper;

    /**
     * 新增
     */
    public void add(Project project) {
        Account currentUser = TokenUtils.getCurrentUser();
        project.setTeacherId(currentUser.getId());
        project.setTime(DateUtil.now());
        project.setStatus("待审核");
        projectMapper.insert(project);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        projectMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            projectMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Project project) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (currentUser.getRole().equals("TEACHER")) {
            project.setStatus("待审核");
            project.setReason("");
        }
        projectMapper.updateById(project);
    }

    /**
     * 根据ID查询
     */
    public Project selectById(Integer id) {

        Account currentUser = TokenUtils.getCurrentUser();
        Project project = projectMapper.selectById(id);
        Collect collect = collectMapper.selectByUserIdAndProjectId(currentUser.getId(), project.getId());
        if (ObjectUtil.isNotEmpty(collect)) {
            project.setUserCollect(true);
        } else {
            project.setUserCollect(false);
        }
//        project.setUserCollect(collect != null);
        return project; //注意返回我们赋值后的project
    }

    /**
     * 查询所有
     */
    public List<Project> selectAll(Project project) {
        return projectMapper.selectAll(project);
    }

    /**
     * 分页查询
     */
    public PageInfo<Project> selectPage(Project project, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Project> list = this.selectAll(project);
        return PageInfo.of(list);
    }

    public void updateViews(Integer id) {
        Project project = projectMapper.selectById(id);
        project.setViews(project.getViews() + 1);
        projectMapper.updateById(project);
    }

}