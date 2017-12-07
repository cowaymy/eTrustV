package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ComplianceCallLogService {

	List<EgovMap> selectComplianceLog(Map<String, Object> params);
	
	EgovMap getMemberDetail(Map<String, Object> params);
	
	void insertCompliance(Map<String, Object> params,SessionVO sessionVo, List<EgovMap> gridOrder);
	
	EgovMap selectCheckOrder(Map<String, Object> params);
	
	EgovMap selectComplianceOrderDetail(Map<String, Object> params);
}
