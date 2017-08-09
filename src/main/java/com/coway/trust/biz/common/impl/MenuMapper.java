package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("menuMapper")
public interface MenuMapper {
	List<EgovMap> selectMenuList(SessionVO sessionVO);

	PageAuthVO selectPageAuth(Map<String, Object> params);
}
