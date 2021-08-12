package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpAgreementMapper")
public interface CcpAgreementMapper {

	List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception;
	
	List<String> selectItemBatchNofromSalesOrdNo(Map<String, Object> params) throws Exception;
	
	EgovMap getOrderId(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAfterServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectBeforeServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSearchOrderNo (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSearchMemberCode (Map<String, Object> params) throws Exception;
	
	EgovMap getMemCodeConfirm (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectCurierListJsonList() throws Exception;
	
	List<EgovMap> selectOrderJsonList(Map<String, Object> params) throws Exception;
	
	/*###### SEQUENCE ######*/
	
	String crtSeqSAL0033D();//
	
	String crtSeqSAL0036D();
	
	String crtSeqSAL0035D();
	
	String crtSeqSAL0034D();
	
	String crtSeqCCR0006D();
	
	String crtSeqCCR0007D();
	
	/* #### Insert Start #####*/
	
	String getDocNo(Map<String, Object> params)throws Exception;
	
	void insertGovAgreementInfo(Map<String,  Object > params )throws Exception;
	
	EgovMap getUserInfo (Map<String, Object> params) throws Exception;
	
	void insertGovAgreementMessLog (Map<String, Object> params) throws Exception;
	
	void insertConsignment(Map<String, Object> params) throws Exception;
	
	void insertGovAgreementSub(Map<String, Object> params) throws Exception;
	
	void insertCallEntry (Map<String, Object> params) throws Exception;
	
	void insertCallResult(Map<String, Object> params) throws Exception;
	
	void updateResultId(Map<String, Object> params) throws Exception;
	
	void updatePreUpdUserId(Map<String, Object> params) throws Exception;
	
	/* #### Insert End #####*/
	
	/*### View and Edit Start###*/
	EgovMap selectAgreementInfo (Map<String, Object> params) throws Exception;
	
	/*### View and Edit End###*/
	
	List<EgovMap> getMessageStatusCode(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectConsignmentLogAjax (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectMessageLogAjax (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectContactOrdersAjax(Map<String, Object> params) throws Exception;
	
	/*####### Consign Save ######*/
	
	void updateReceiveDate (Map<String, Object> params ) throws Exception;
	
	EgovMap getConsignId(Map<String, Object> params) throws Exception;
	
	void updateCurrentStatus(Map<String, Object> params) throws Exception;
	
	void insertNewConsign(Map<String, Object> params) throws Exception;
	
	/* Consing Save End*/
	
	/*############  Agreement Maintenance Save #########*/
	EgovMap selectProgressStatus (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAgmSoIdList (Map<String, Object> params) throws Exception; // 2
	
	EgovMap getRosCallLog (Map<String, Object> params)throws Exception;
	
	void updateRosCall (EgovMap params) throws Exception;
	
	EgovMap selectCallEntry (Map<String, Object> params) throws Exception;
	
	void insertEditCallResult(Map<String, Object> params) throws Exception;
	
	void insertEditCallEntry(Map<String, Object> params) throws Exception;
	
	void updateEditCallEntry(EgovMap params) throws Exception;
	
	void insertRosCall(Map<String, Object> params) throws Exception;
	
	void insertAgreementMessLog(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectEditAfAgreementList(Map<String, Object> params) throws Exception;
	
	void updateAgreement(Map<String, Object> params) throws Exception;
	
	void updateCcpAgreementMessageFile(Map<String, Object> parmas) throws Exception;
	
	void updateCcpLatMessageId(Map<String, Object> params);    
}
