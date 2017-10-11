package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASManagementListService {

	List<EgovMap> selectASManagementList();
	
	EgovMap selectOrderBasicInfo(Map<String, Object> params);
	
	boolean insertASNo(Map<String, Object> params,SessionVO sessionVO);
}
