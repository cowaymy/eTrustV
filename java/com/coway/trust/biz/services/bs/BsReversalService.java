package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BsReversalService {

	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	EgovMap selectConfigBasicInfo(Map<String, Object> params);
	
	List<EgovMap> selectReverseReason();
	
	List<EgovMap> selectFailReason();
	
	
}
