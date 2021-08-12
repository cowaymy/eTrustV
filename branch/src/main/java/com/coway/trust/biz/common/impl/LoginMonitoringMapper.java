package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("loginMonitoringtMapper")
public interface LoginMonitoringMapper {
	List<EgovMap> selectLoginMonitoringList(Map<String, Object> params);

	List<EgovMap> selectCommonCodeSystemList(Map<String, Object> params);
}
