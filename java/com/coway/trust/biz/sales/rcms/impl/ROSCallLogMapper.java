package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("rosCallLogMapper")
public interface ROSCallLogMapper {

	List<EgovMap> getAppTypeList(Map<String, Object> params);
	
	List<EgovMap> selectRosCallLogList(Map<String, Object> params);
	
	EgovMap getRentInstallLatestNo(Map<String, Object> params);
	
	EgovMap getRentalStatus(Map<String, Object> params);
	
	List<EgovMap> selectROSSMSCodyTicketLogList(Map<String, Object> params);
	
	List<EgovMap> getReasonCodeList (Map<String, Object> params);
	
	List<EgovMap> getFeedbackCodeList(Map<String, Object> params);
	
	List<EgovMap> selectROSCallLogBillGroupOrderCnt(Map<String, Object> params);
	
	EgovMap getOrderServiceMemberViewByOrderID(Map<String, Object> params);
	
	EgovMap chkCurrRosCall(Map<String, Object> params);
	
	//Start
	
	void updateROSCallInfo(Map<String, Object> params);
	
	void updateCallEntryInfo(Map<String, Object> params);
	
	void insertROSCallInfo(Map<String, Object> params);
	
	EgovMap chkCurrCallEntryInfo(Map<String, Object> params);
	
	void insertCallResultInfo(Map<String, Object> params);
	
	int getSeqCCR0007D();
	
	int getSeqCCR0006D();
	
	void insertCallEntryInfo(Map<String, Object> params);
	
	List<EgovMap> selectOrderRemList(Map<String, Object> params);
	
	int getSeqSAL0054D();
	
	void insertOrderRem(Map<String, Object> params);
	
	int getSeqSAL0055D();
	
	void insertOrderRemDetail(Map<String, Object> params);
	
	Map<String, Object> spOrderRemarkUpload_DetVerify(Map<String, Object> param);
	
	EgovMap selectBatchViewInfo(Map<String, Object> params);
	
	List<EgovMap> getBatchDetailInfoList(Map<String, Object> params);
	
	int cntOrdRemUpload(Map<String, Object> params);
	
	EgovMap searchExistOrdNo(Map<String, Object> params);
	
	EgovMap alreadyExistOrdNo(Map<String, Object> params);
	
	void addNewOrdNo(Map<String, Object> params);
	
	void updOrdNo(Map<String, Object> params);
	
	void updBatch(Map<String, Object> params);
	
	EgovMap chkBatchMasterInfo(Map<String, Object> params);
	
	void updConfirmOrdRemMaster(Map<String, Object> params);
	
	Map<String, Object> spOrderRemarkUpload_Confirm(Map<String, Object> param);
	
	List<EgovMap> selectCallerList(Map<String, Object> params);
	
	int getSeqMSC0011D();
	
	void instCallerMaster(Map<String, Object> params);
	
	int getSeqMSC0012D();
	
	void insertCallerDetail(Map<String, Object> params);
	
	Map<String, Object> spROSCallerUpdate(Map<String, Object> params);
	
	EgovMap countInfoByBatchId (Map<String, Object> params);
	
	List<EgovMap> getCallerDetailList(Map<String, Object> params);
}
