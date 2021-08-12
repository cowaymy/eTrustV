package com.coway.trust.biz.services.performanceMgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HappyCallPlanningService {
	
	List<EgovMap> selectCodeNameList(Map<String, Object> params);

	List<EgovMap> selectHappyCallList(Map<String, Object> params);

	boolean insertHappyCall(List<Object> addList, SessionVO sessionVO);
	
	boolean updateHappyCall(List<Object> udtList, SessionVO sessionVO);

	boolean deleteHappyCall(List<Object> delList, SessionVO sessionVO);
	
}
