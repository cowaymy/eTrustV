package com.coway.trust.biz.sales.rcms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RCMSAgentManageService {

	
	List<EgovMap> selectAgentTypeList(Map<String, Object> params)throws Exception;

	List<EgovMap> selectRosCaller(Map<String, Object> params);

	List<EgovMap> selectAssignAgentList(Map<String, Object> params);

	void saveAssignAgent(Map<String, Object> params);
	
	List<Object> checkWebId(Map<String, Object> params) throws Exception;
	
	List<Object> chkDupWebId(Map<String, Object> params) throws Exception;
	
	void insUpdAgent(Map<String, Object> params) throws Exception; 
	
	List<EgovMap> selectAgentList(Map<String, Object> params) throws Exception;

	List<EgovMap> checkAssignAgentList(Map<String, Object> params);

	void saveAgentList(Map<String, Object> params);

	void updateRemark(Map<String, Object> params);

	EgovMap selectRcmsInfo(Map<String, Object> params);

	List<EgovMap> selectAssignedList(Map<String, Object> params);

	List<EgovMap> selectRosCallDetailList(Map<String, Object> params);
	
	List<EgovMap> rentalStatusListForBadAcc(Map<String, Object> params);
}
