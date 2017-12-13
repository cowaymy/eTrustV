package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("happyCallPlanningMapper")
public interface HappyCallPlanningMapper {
	
	List<EgovMap> selectCodeNameList(Map<String, Object> params);

	List<EgovMap> selectHappyCallList(Map<String, Object> params);

}
