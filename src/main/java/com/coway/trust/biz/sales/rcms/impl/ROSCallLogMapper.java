package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("rosCallLogMapper")
public interface ROSCallLogMapper {

	List<EgovMap> getAppTypeList(Map<String, Object> params);
	
	List<EgovMap> selectRosCallLogList(Map<String, Object> params);
	
	EgovMap getRentInstallLatestNo(Map<String, Object> params);
	
	EgovMap getRentalStatus(Map<String, Object> params);
	
	List<EgovMap> selectROSSMSCodyTicketLogList(Map<String, Object> params);
	
	List<EgovMap> getReasonCodeList (Map<String, Object> params);
	
	List<EgovMap> getFeedbackCodeList(Map<String, Object> params);
}
