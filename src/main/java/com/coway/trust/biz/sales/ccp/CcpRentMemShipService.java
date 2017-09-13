package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpRentMemShipService {

	List<EgovMap> getBranchCodeList() throws Exception;
	
	List<EgovMap> getReasonCodeList() throws Exception;
	
	List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception;
	
	/*### Detail ### */
	EgovMap selectServiceContract (Map<String, Object> params) throws Exception;
	
	Map<String, Object> selectServiceContactBillingInfo (Map<String, Object> params) throws Exception;
	
	//Order Info
	EgovMap selectOrderInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectOrderInfoInstallation(Map<String, Object> params) throws Exception;
	
	EgovMap selectSrvMemConfigInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectPaySetInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectCustThridPartyInfo(Map<String, Object> params) throws Exception; //Third Party
	
	EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params) throws Exception;
	
	//Gird
	List<EgovMap> selectPaymentList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectCallLogList(Map<String, Object> params) throws Exception;
	
	
	/*### Confirmation Result ####*/
	EgovMap confirmationInfoByContractID(Map<String, Object> params) throws Exception;
	
	EgovMap selectCustBasicInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectContactPerson(Map<String, Object> params) throws Exception;
	
	
	/* ### Save ### */
	void insUpdConfrimResult(Map<String, Object> params) throws Exception;
}
