package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("interfaceMonitoringtMapper")
public interface InterfaceMonitoringMapper {
	List<EgovMap> selectInterfaceMonitoringList(Map<String, Object> params);

	List<EgovMap> selectInterfaceMonitoringDtmList(Map<String, Object> params);

	List<EgovMap> selectInterfaceMonitoringKeyList(Map<String, Object> params);

	List<EgovMap> selectCommonCodeStatusList(Map<String, Object> params);

	List<EgovMap> selectInterfaceTypeList(Map<String, Object> params);

}
