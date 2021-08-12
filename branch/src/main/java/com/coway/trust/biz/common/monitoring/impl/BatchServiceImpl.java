package com.coway.trust.biz.common.monitoring.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.monitoring.BatchService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("batchService")
public class BatchServiceImpl implements BatchService {

	@Autowired
	private BatchMapper batchMapper;

	public List<EgovMap> getJobNames(Map<String, Object> params) {
		return batchMapper.selectJobNames(params);
	}

	public List<EgovMap> getBatchMonitoring(Map<String, Object> params) {
		return batchMapper.selectBatchMonitoring(params);
	}

	public List<EgovMap> getBatchDetailMonitoring(Map<String, Object> params) {
		String stepexecutionid = (String) params.get("stepExecutionId");
		return batchMapper.selectBatchDetailMonitoring(stepexecutionid);
	}
}
