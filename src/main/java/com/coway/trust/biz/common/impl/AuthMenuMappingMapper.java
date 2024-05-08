package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("authMenuMappingMapper")
public interface AuthMenuMappingMapper {

	List<EgovMap> selectAuthList(Map<String, Object> params);		
	
	List<EgovMap> selectAuthMenuMappingList(Map<String, Object> params);		
	
	void updateAuthMenuMapping(Map<String, Object> params);		
		
	List<EgovMap> selectMultAuthMenuMappingList(Map<String, Object> params);		
}
