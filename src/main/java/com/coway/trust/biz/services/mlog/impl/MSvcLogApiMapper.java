package com.coway.trust.biz.services.mlog.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MSvcLogApiMapper")
public interface MSvcLogApiMapper {


	List<EgovMap> getHeartServiceJobList(Map<String, Object> params);
	
	List<EgovMap> getAfterServiceJobList(Map<String, Object> params);
	
	void insertHeatLog(Map<String, Object> log);

	void updateSuccessStatus(String transactionId);
	
	
	
	
}
