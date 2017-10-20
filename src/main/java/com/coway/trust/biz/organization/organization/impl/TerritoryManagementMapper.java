package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("territoryManagementMapper")
public interface TerritoryManagementMapper {

	List<EgovMap> selectList(Map<String, Object> params);
	
	EgovMap  cody42Vaild(Map<String, Object> params);
	EgovMap  dream43Vaild(Map<String, Object> params);
	
}
