package com.coway.trust.biz.common.impl;

import com.coway.trust.biz.common.MenuService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("menuService")
public class MenuServiceImpl implements MenuService {

    @Autowired
    private MenuMapper menuMapper;

    @Override
    @Cacheable("menu-cache")
    public List<EgovMap> getMenuList(Map<String, Object> params) {
        return menuMapper.selectMenuList(params);
    }
}
