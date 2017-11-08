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

	List<EgovMap> heartServiceParts(Map<String, Object> params);

	List<EgovMap> afterServiceParts(Map<String, Object> params);

	int getNextSvc006dSeq();

	void insertHsResultD(Map<String, Object> insMap);

	void insertHsResultSAL0090D(Map<String, Object> insMap);

	void insertHsResultSVC0006D(Map<String, Object> insMap);

	int selectHSScheduleMCnt(Map<String, Object> insMap);

	EgovMap selectHSResultMList(Map<String, Object> insMap);

	void updateHsSVC0008D(Map<String, Object> insMap);

	EgovMap selectSrvConfiguration(Map<String, Object> insMap);

	EgovMap selectHsAssiinlList(Map<String, Object> insMap);

	String getUseridToMemid(Map<String, Object> insMap);

	List<EgovMap> getInstallationJobList(Map<String, Object> params);

	List<EgovMap> getProductRetrunJobList(Map<String, Object> params);

	void insertAsResultLog(Map<String, Object> asTransLog);

	void updateSuccessASStatus(String transactionId);
	
	void updateSuccessInstallStatus(String transactionId);

	void insertInstallServiceLog(Map<String, Object> params);

	EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

	void insertInstallResult(Map<String, Object> installResult);

	
	
	
	
}
