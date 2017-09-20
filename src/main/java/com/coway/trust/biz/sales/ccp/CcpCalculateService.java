package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpCalculateService {

	List<EgovMap> selectDscCodeList() throws Exception;
	
	List<EgovMap> selectReasonCodeFbList() throws Exception;
	
	List<EgovMap> selectCalCcpListAjax(Map<String, Object> params) throws Exception;
	
	EgovMap getLatestOrderLogByOrderID(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getOrderUnitList (Map<String, Object> params) throws Exception;
	
	EgovMap getCalViewEditField(Map<String, Object> params) throws Exception;
}
