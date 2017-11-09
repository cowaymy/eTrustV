package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASManagementListMapper")
public interface ASManagementListMapper {
	
	 List<EgovMap> selectASManagementList(Map<String, Object> params);
	 EgovMap selectOrderBasicInfo(Map<String, Object> params);
	 
	 
	 
	 List<EgovMap> selectASDataInfo(Map<String, Object> params);
	 List<EgovMap> getASHistoryList(Map<String, Object> params);
	 List<EgovMap> getBSHistoryList(Map<String, Object> params);
	 List<EgovMap> getBrnchId(Map<String, Object> params);
	 
	 EgovMap  getMemberBymemberID(Map<String, Object> params);
	 EgovMap  spFilterClaimCheck(Map<String, Object> params);

	 
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
	 
	 EgovMap   geTtotalAASLeft(Map<String, Object> params);	
	 EgovMap   geGST_CHK(Map<String, Object> params);	
	 
	 
	 int   insert_Pay0031d(Map<String, Object> params);
	 int   insert_Pay0032d(Map<String, Object> params);
	 int   insert_Pay0016d(Map<String, Object> params);
	 int   insert_Pay0006d(Map<String, Object> params);
	 int   insert_Pay0007d(Map<String, Object> params);
	 int   insert_Ccr0001d(Map<String, Object> params);
	 int   updateSTATE_CCR0006D(Map<String, Object> params);
	 
	 
	 
	 //update
	 EgovMap   getPAY0017SEQ(Map<String, Object> params);		 
	 EgovMap   getLOG0015DSEQ(Map<String, Object> params);
	 EgovMap   getPAY0016DSEQ(Map<String, Object> params);
	 EgovMap   getPAY0017DSEQ(Map<String, Object> params);
	 EgovMap   getPAY0027DSEQ(Map<String, Object> params);
	 EgovMap   getPAY0069DSEQ(Map<String, Object> params);
	 
	 
	 
	 
	 List<EgovMap> getResult_SVC0004D(Map<String, Object> params);
	 List<EgovMap> getResult_PAY0016D(Map<String, Object> params);
	 List<EgovMap> getResult_PAY0031D(Map<String, Object> params);
	 List<EgovMap> getResult_PAY0006D(Map<String, Object> params);
	 List<EgovMap> getResult_PAY0007D(Map<String, Object> params);
	 List<EgovMap> getResult_PAY0064D(Map<String, Object> params);
	 
	 
	 
	 int   reverse_SVC0004D(Map<String, Object> params);  				  // reverse_SVC0004D  기존 금액 -처리 
	 int   reverse_CURR_SVC0004D(Map<String, Object> params);   	  // CURR  false 처리 
	 int   reverse_CURR_SVC0005D(Map<String, Object> params);  	  // reverse_SVC0005D  기존 수량 -처리 
	 int   insert_LOG0015D(Map<String, Object> params);  	 
	 int   insert_LOG0016D(Map<String, Object> params);  	 
	 int   insert_LOG0014D(Map<String, Object> params);  	 
	 int   insert_PAY0069D(Map<String, Object> params); 
	 
	 
	 int   reverse_PAY0007D(Map<String, Object> params);  	 			 //UPDATE 
	 int   reverse_PAY0016D(Map<String, Object> params);  	 			 //UPDATE 
	 int   reverse_PAY0012D(Map<String, Object> params);  	 			 //UPDATE 
	 int   reverse_PAY0027D(Map<String, Object> params);  	 			 //UPDATE 
	 int   reverse_PAY0028D(Map<String, Object> params);  	 			 //UPDATE 
	 int   reverse_PAY0006D(Map<String, Object> params);  	 			 //UPDATE 
	 int	reverse_StateUpPAY0007D(Map<String, Object> params);  	 //UPDATE 
	 
	 
	 
	 
	 EgovMap   getLog0016DCount(Map<String, Object> params);	      //log0016d count

	 

	 
	 
	 
	 
	 
}
