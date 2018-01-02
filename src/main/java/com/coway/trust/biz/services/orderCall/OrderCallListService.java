package com.coway.trust.biz.services.orderCall;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCallListService {
	List<EgovMap> selectOrderCall(Map<String, Object> params);
	
	EgovMap getOrderCall(Map<String, Object> params);
	
	 Map<String, Object> insertCallResult(Map<String, Object> params, SessionVO sessionVO);
	
	List<EgovMap> selectCallStatus();
	
	List<EgovMap> selectCallLogTransaction(Map<String, Object> params);

	List<EgovMap> getstateList();

	List<EgovMap> getAreaList(Map<String, Object> params);

	EgovMap selectCdcAvaiableStock(Map<String, Object> params);

	EgovMap selectRdcStock(Map<String, Object> params);

	EgovMap getRdcInCdc(Map<String, Object> params);
	      
} 
