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
	
	/* #### Insert Start #####*/
	
	String getDocNo(Map<String, Object> params)throws Exception;
	
	void insertGovAgreementInfo(Map<String,  Object > params )throws Exception;
	
	EgovMap getUserInfo (Map<String, Object> params) throws Exception;
	
	void insertGovAgreementMessLog (Map<String, Object> params) throws Exception;
	
	void insertConsignment(Map<String, Object> params) throws Exception;
	
	void insertGovAgreementSub(Map<String, Object> params) throws Exception;
	
	void insertCallEntry (Map<String, Object> params) throws Exception;
	
	void insertCallResult(Map<String, Object> params) throws Exception;
	
	void updateResultId() throws Exception;
	
	void updatePreUpdUserId() throws Exception;
	
	String getReturnMsgId() throws Exception;
	/* #### Insert End #####*/
	
}
