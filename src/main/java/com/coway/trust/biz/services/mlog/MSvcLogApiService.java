package com.coway.trust.biz.services.mlog;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;

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

	void insertProductReturnResult(Map<String, Object> params);

	void aSresultRegistration(List<Map<String, Object>> asTransLogs);

	List<EgovMap> serviceHistory(Map<String, Object> params);

	List<EgovMap> getAsFilterHistoryDList(Map<String, Object> tmpMap);

	List<EgovMap> getAsPartsHistoryDList(Map<String, Object> tmpMap);

	List<EgovMap> getHsPartsHistoryDList(Map<String, Object> tmpMap);

	List<EgovMap> getHsFilterHistoryDList(Map<String, Object> tmpMap1);

	List<EgovMap> getRentalCustomerList(Map<String, Object> params);	
	
	Map<String, Object> selectOutstandingResult(Map<String, Object> params);
	
	List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params);
	
	Map<String, Object> getAsBasic(Map<String, Object> params);

	void saveAsReServiceLogs(Map<String, Object> params);

	void updateSuccessAsReStatus(String transactionId);
	
	void updateSuccessHsReStatus(String transactionId);
	
	void updateSuccessInsReStatus(String transactionId);

	EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

	String getUseridToMemid(Map<String, Object> params);

	void savePrFailServiceLogs(Map<String, Object> params);

	void saveInsFailServiceLogs(Map<String, Object> params);

	void saveAsFailServiceLogs(Map<String, Object> params);

	void saveHsFailServiceLogs(Map<String, Object> params);

	void savePrReServiceLogs(Map<String, Object> params);

	void saveInsReServiceLogs(Map<String, Object> params);

	void saveHsReServiceLogs(Map<String, Object> params);

	Map<String, Object> getHsBasic(Map<String, Object> params);

	void saveCanSMSServiceLogs(Map<String, Object> params);
	
	

}
