package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("guardianOfComplianceMapper")
public interface GuardianOfComplianceMapper {

	
	List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params);
	
	int   saveGuardian(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);
	
	EgovMap selectGuardianofComplianceInfo(Map<String, Object> params);
}

