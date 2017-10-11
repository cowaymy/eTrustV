package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("userMenuMappingMapper")
public interface UserMenuMappingMapper {

	List<EgovMap> selectUserList(Map<String, Object> params);		
	
	List<EgovMap> selectUserMenuMappingList(Map<String, Object> params);		
	
	void updateUserMenuMapping(Map<String, Object> params);		
		
}
