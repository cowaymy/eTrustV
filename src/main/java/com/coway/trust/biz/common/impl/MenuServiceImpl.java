package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.MenuService;
import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("menuService")
public class MenuServiceImpl implements MenuService {

	@Autowired
	private MenuMapper menuMapper;

	@Override
	// @Cacheable("menu-cache")
	public List<EgovMap> getMenuList(SessionVO sessionVO) {
		return menuMapper.selectMenuList(sessionVO);
	}

	@Override
	public List<EgovMap> getFavoritesList(SessionVO sessionVO) {
		return menuMapper.getFavoritesList(sessionVO);
	}

	@Override
	@Cacheable("menu-cache")
	public PageAuthVO getPageAuth(Map<String, Object> params) {
		return menuMapper.selectPageAuth(params);
	}
}
