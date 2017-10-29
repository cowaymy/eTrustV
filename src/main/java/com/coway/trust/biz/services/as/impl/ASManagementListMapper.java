package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASManagementListMapper")
public interface ASManagementListMapper {
	
	 List<EgovMap> selectASManagementList(Map<String, Object> params);
	 EgovMap selectOrderBasicInfo(Map<String, Object> params);

	 
	 List<EgovMap> getASHistoryList(Map<String, Object> params);
	 List<EgovMap> getBSHistoryList(Map<String, Object> params);
	 List<EgovMap> getBrnchId(Map<String, Object> params);
	 
	 EgovMap  getMemberBymemberID(Map<String, Object> params);
	 
	 EgovMap   selASEntryView(Map<String, Object> params);
	 
	 int   insertSVC0001D(Map<String, Object> params);
	 int   updateSVC0001D(Map<String, Object> params);
	 int   updateStateSVC0001D(Map<String, Object> params);
	 
	 
	 int   insertSVC0003D(Map<String, Object> params);
	 int   updateSVC0003D(Map<String, Object> params);
	 
	 
	 
	 List<EgovMap> getASOrderInfo(Map<String, Object> params);
	 List<EgovMap> getASEvntsInfo(Map<String, Object> params);
	 List<EgovMap> getASHistoryInfo(Map<String, Object> params);
	 List<EgovMap> getASStockPrice(Map<String, Object> params);
	 List<EgovMap> getASFilterInfo(Map<String, Object> params);
	 List<EgovMap> getASReasonCode(Map<String, Object> params);
	 List<EgovMap> getASMember(Map<String, Object> params);
	 List<EgovMap> getASReasonCode2(Map<String, Object> params);
	 List<EgovMap> getCallLog(Map<String, Object> params);
	 
	 List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params);
	 List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params);
	 

	 
	 EgovMap  asResult_insert(Map<String, Object> params);
	 
	 int   insertSVC0004D(Map<String, Object> params);
	 int   updateSVC0004D(Map<String, Object> params);
	 int   updateBasicSVC0004D(Map<String, Object> params);
	 
	 int   insertSVC0005D(Map<String, Object> params);
	 
	 //콜로그 
	 int   insertCCR0006D(Map<String, Object> params);
	 int   insertCCR0007D(Map<String, Object> params);
	 int   insertAddCCR0007D(Map<String, Object> params);
	 int   updateCCR0006D(Map<String, Object> params);
	 
	 int   updateAssignCT(Map<String, Object> params);
	 
	 
	 //물류 처리 프로시져 
	 Map<String, Object> callSP_LOGISTIC_REQUEST(Map<String, Object> param);
	 
	 //시퀀스 
	 EgovMap   getASEntryDocNo(Map<String, Object> params);

	 EgovMap   getCCR0006D_CALL_ENTRY_ID_SEQ(Map<String, Object> params);		//CCR0006D_CALL_ENTRY_ID_SEQ
	 EgovMap   getASEntryId(Map<String, Object> params);   										//SVC0001D_AS_ID_SEQ
	 EgovMap   getResultASEntryId(Map<String, Object> params);								//SVC0004D_AS_RESULT_ID_SEQ

	 
	 List<EgovMap> assignCtList(Map<String, Object> params);
	 List<EgovMap> assignCtOrderList(Map<String, Object> params);
	 
	 
}
