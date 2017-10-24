package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASManagementListMapper")
public interface ASManagementListMapper {
	
	 List<EgovMap> selectASManagementList(Map<String, Object> params);
	 
	 List<EgovMap> getASHistoryList(Map<String, Object> params);

	 
	 List<EgovMap> getBSHistoryList(Map<String, Object> params);

	 
	 EgovMap selectOrderBasicInfo(Map<String, Object> params);
}
