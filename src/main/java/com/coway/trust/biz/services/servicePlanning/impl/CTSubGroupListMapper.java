package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CTSubGroupListMapper")
public interface CTSubGroupListMapper {
	
	List<EgovMap> selectCTSubGroupList(Map<String, Object> params);
	
	void insertCTSubGroup(Map<String, Object> params);
	
	List<EgovMap> selectCTAreaSubGroupList(Map<String, Object> params);
	
	void insertCTSubAreaGroup(Map<String, Object> params);
	
	List<EgovMap> selectCTSubGroupDscList(Map<String, Object> params);
	
	List<EgovMap> selectCTM(Map<String, Object> params);
	
	List<EgovMap> selectCTMByDSC(Map<String, Object> params);
	
	List<EgovMap> selectCTSubGrb(Map<String, Object> params);

	List<EgovMap> selectCTSubGroupMajor(Map<String, Object> params);

}
