package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("rcmsAgentManageMapper")
public interface RCMSAgentManageMapper {

	List<EgovMap> selectAgentTypeList(Map<String, Object> params);
	
	List<EgovMap> selectRosCaller();

	List<EgovMap> selectAssignAgentList(Map<String, Object> params);

	int updateAgent(Map<String, Object> updateMap);
	
	EgovMap chkUserNameByUserId(Map<String, Object> params);
	
	int getSeqSAL0148M();
	
	void insAgentMaster(Map<String, Object> params);
	
	void updAgentMaster(Map<String, Object> params);
	
	EgovMap chkDupWebId(Map<String, Object> params);
	
	List<EgovMap> selectAgentList(Map<String, Object> params);

	void updateCompany(Map<String, Object> updateMap);
	
}
