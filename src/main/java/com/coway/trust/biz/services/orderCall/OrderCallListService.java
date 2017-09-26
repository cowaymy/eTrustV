package com.coway.trust.biz.services.orderCall;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCallListService {
	List<EgovMap> selectOrderCall();
	
	EgovMap getOrderCall(Map<String, Object> params);
	
	boolean insertCallResult(Map<String, Object> params, SessionVO sessionVO);
	
	List<EgovMap> selectCallStatus();
	
}
