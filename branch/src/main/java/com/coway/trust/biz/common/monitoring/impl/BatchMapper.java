package com.coway.trust.biz.common.monitoring.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("batchMapper")
public interface BatchMapper {
	List<EgovMap> selectJobNames(Map<String, Object> params);

	List<EgovMap> selectBatchMonitoring(Map<String, Object> params);

	List<EgovMap> selectBatchDetailMonitoring(String stepexecutionid);
}
