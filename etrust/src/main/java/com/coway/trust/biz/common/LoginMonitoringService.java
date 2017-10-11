package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoginMonitoringService {
	List<EgovMap> selectLoginMonitoringList(Map<String, Object> params);

	List<EgovMap> selectCommonCodeSystemList(Map<String, Object> params);
}
