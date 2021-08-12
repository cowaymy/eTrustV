package com.coway.trust.biz.sales.pos;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosOthService {

	
	List<EgovMap> selectPOthItmTypeList() throws Exception;
	
//	List<EgovMap> selectPOthItmList(Map<String, Object> params) throws Exception;
	
	Boolean chkAllowSalesKeyInPrc(Map<String, Object> params)throws Exception;
	
	EgovMap posReversalOthDetail(Map<String, Object> params) throws Exception;
	
	EgovMap getAddressDetails(Map<String, Object> params) throws Exception;
}
