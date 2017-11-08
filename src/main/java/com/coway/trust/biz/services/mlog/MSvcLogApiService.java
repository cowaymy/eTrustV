package com.coway.trust.biz.services.mlog;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MSvcLogApiService {

	List<EgovMap> getHeartServiceJobList(Map<String, Object> params);

	List<EgovMap> getAfterServiceJobList(Map<String, Object> params); 
	
	void saveHearLogs(List<Map<String, Object>> heartLogs);

	void updateSuccessStatus(String transactionId);

	List<EgovMap> heartServiceParts(Map<String, Object> params);

	List<EgovMap> afterServiceParts(Map<String, Object> params);

	void resultRegistration(List<Map<String, Object>> heartLogs);

	List<EgovMap> getInstallationJobList(Map<String, Object> params);

	List<EgovMap> getProductRetrunJobList(Map<String, Object> params);

	void saveAfterServiceLogs(List<Map<String, Object>> asTransLogs);

	void updateSuccessASStatus(String transactionId);

	void saveInstallServiceLogs(Map<String, Object> params);

	void updateSuccessInstallStatus(String transactionId);

	void insertInstallationResult(Map<String, Object> params);


	
	
	
	
	
}
