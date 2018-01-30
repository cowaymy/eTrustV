package com.coway.trust.biz.services.mlog.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;

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

	String getUseridToMemid(Object object);

	List<EgovMap> getInstallationJobList(Map<String, Object> params);

	List<EgovMap> getProductRetrunJobList(Map<String, Object> params);

	void insertAsResultLog(Map<String, Object> asTransLog);

	void updateSuccessASStatus(String transactionId);
	
	void updateSuccessInstallStatus(String transactionId);

	void insertInstallServiceLog(Map<String, Object> params);

	EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

	void insertInstallResult(Map<String, Object> installResult);

	List<EgovMap> getRentalCustomerList(Map<String, Object> params);

	List<EgovMap> serviceHistory(Map<String, Object> params);

	List<EgovMap> getFilterHistoryDList(Map<String, Object> params);

	List<EgovMap> getPartsHistoryDList(Map<String, Object> params);

	List<EgovMap> getHsPartsHistoryDList(Map<String, Object> params);

	List<EgovMap> getHsFilterHistoryDList(Map<String, Object> params);

	List<EgovMap> getAsPartsHistoryDList(Map<String, Object> params);

	List<EgovMap> getAsFilterHistoryDList(Map<String, Object> params);

	EgovMap selectOutstandingResult(Map<String, Object> params);
	
	List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params);

	Map<String, Object> getAsBasic(Map<String, Object> params);

	void insertAsReServiceLog(Map<String, Object> params);

	void insertAsReServiceLog(String transactionId);

	void insertHsReServiceLog(String transactionId);

	void insertInsReServiceLog(String transactionId);

	void insertHsReServiceLog(Map<String, Object> params);

	void insertInsReServiceLog(Map<String, Object> params);

	void insertPrReServiceLog(Map<String, Object> params);

	Map<String, Object> getHsBasic(Map<String, Object> params);

	void insertPrFailServiceLog(Map<String, Object> params);

	void insertInssFailServiceLog(Map<String, Object> params);

	void insertAsFailServiceLog(Map<String, Object> params);

	void insertHsFailServiceLog(Map<String, Object> params);

	void insertCanSMSServiceLog(Map<String, Object> params);

	void updateReApointResult(Map<String, Object> params);

	EgovMap selectAsBasicInfo(Map<String, Object> params);

	void updateInsReAppointmentReturnResult(Map<String, Object> params);

	void updateHsReAppointmentReturnResult(Map<String, Object> params);

	void updatePrReAppointmentReturnResult(Map<String, Object> params);

	void insertASRequestRegistrationLogs(Map<String, Object> params);

	void updateSuccessRequestRegiStatus(String transactionId);

	void insertASRequestRegist(Map<String, Object> params);

	void insertHsFailJobResult(Map<String, Object> params);

	void insertAsFailJobResult(Map<String, Object> params);

	void insertInstallFailJobResult(Map<String, Object> params);

	List<EgovMap> getASRequestResultList(Map<String, Object> params);

	List<EgovMap> getASRequestCustList(Map<String, Object> params);

	void upDateHsFailJobResultM(Map<String, Object> params);

	void upDatetAsFailJobResultM(Map<String, Object> params);

	void upDateInstallFailJobResultM(Map<String, Object> params);

	void insertInsFailServiceLog(Map<String, Object> params);
	
	
	/*ProductReturnResult  API*/
	int  updateState_LOG0038D(Map<String, Object> params);
	int  updateState_SAL0001D(Map<String, Object> params);
	int  insert_SAL0009D(Map<String, Object> params);
	int  updateState_SAL0020D(Map<String, Object> params);
	int  updateState_SAL0071D(Map<String, Object> params);
	
	int  insert_LOG0039D(Map<String, Object> params);
	int  updateAppTm_LOG0038D(Map<String, Object> params);
	int  insertFailed_LOG0039D(Map<String, Object> params);  
	int  updateFailed_LOG0038D(Map<String, Object> params);
	
	String   getRetnCrtUserId(Map<String, Object> params);

	void insertCancelSMS(Map<String, Object> params);
	String getcancReqNo(Map<String, Object> params);

	List<EgovMap> getHeartServiceJobList_b(Map<String, Object> params);

	List<EgovMap> getAfterServiceJobList_b(Map<String, Object> params);

	List<EgovMap> heartServiceParts_b(Map<String, Object> params);

	List<EgovMap> afterServiceParts_b(Map<String, Object> params);

	List<EgovMap> getInstallationJobList_b(Map<String, Object> params);

	List<EgovMap> getProductRetrunJobList_b(Map<String, Object> params);
	  
	// call SP_RETURN_BILLING_EARLY_TERMI( #{ORD_ID},#{USER_ID},#{SERVICE_NO} )
	void SP_RETURN_BILLING_EARLY_TERMI ( Map<String, Object> params);
	
}
