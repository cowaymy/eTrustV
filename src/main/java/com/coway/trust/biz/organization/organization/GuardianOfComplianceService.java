package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GuardianOfComplianceService {
	

	List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params);
	
	EgovMap saveGuardian(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);
	
	EgovMap selectGuardianofComplianceInfo(Map<String, Object> params);

}
