package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASManagementListService {

	List<EgovMap> selectASManagementList(Map<String, Object> params);
	
	List<EgovMap> getASHistoryList(Map<String, Object> params);
	
	List<EgovMap> getBSHistoryList(Map<String, Object> params);
	
	
	
	EgovMap selectOrderBasicInfo(Map<String, Object> params);
	
	boolean insertASNo(Map<String, Object> params,SessionVO sessionVO);
}
