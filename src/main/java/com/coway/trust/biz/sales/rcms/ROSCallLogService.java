package com.coway.trust.biz.sales.rcms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ROSCallLogService {

	List<EgovMap> getAppTypeList(Map<String, Object> params);
	
	List<EgovMap> selectRosCallLogList(Map<String, Object> params);
}
