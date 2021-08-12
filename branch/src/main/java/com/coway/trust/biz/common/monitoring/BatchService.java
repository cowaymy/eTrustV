package com.coway.trust.biz.common.monitoring;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BatchService {
	List<EgovMap> getJobNames(Map<String, Object> params);

	List<EgovMap> getBatchMonitoring(Map<String, Object> params);

	List<EgovMap> getBatchDetailMonitoring(Map<String, Object> params);
}
