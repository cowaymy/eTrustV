package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InterfaceMonitoringService {
	List<EgovMap> selectInterfaceMonitoringList(Map<String, Object> params);

	List<EgovMap> selectInterfaceMonitoringDtmList(Map<String, Object> params);

	List<EgovMap> selectInterfaceMonitoringKeyList(Map<String, Object> params);

	List<EgovMap> selectCommonCodeStatusList(Map<String, Object> params);

	List<EgovMap> selectInterfaceTypeList(Map<String, Object> params);

}
