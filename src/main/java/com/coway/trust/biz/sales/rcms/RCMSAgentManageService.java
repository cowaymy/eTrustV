package com.coway.trust.biz.sales.rcms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RCMSAgentManageService {

	
	List<EgovMap> selectAgentTypeList(Map<String, Object> params)throws Exception;
	
}
