package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpAgreementService {

	List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception;
	
	EgovMap getOrderId(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAfterServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectBeforeServiceJsonList (Map<String, Object> params) throws Exception;
	
}
