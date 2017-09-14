package com.coway.trust.biz.sales.ccp.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpRentMemShipMapper")
public interface CcpRentMemShipMapper {

	List<EgovMap> getBranchCodeList() throws Exception;
	
	List<EgovMap> getReasonCodeList() throws Exception;
	
	List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception;
	
	/* ### Deatil ### */
	EgovMap selectServiceContract (Map<String, Object> params) throws Exception;
	
	EgovMap selectOutstandingUnbill (Map<String, Object> params) throws Exception;
	
	EgovMap selectServiceSchedule (Map<String, Object> params) throws Exception;
	
	BigDecimal getOutstandingAmount (Map<String, Object> params) throws Exception;
	
	EgovMap selectOrderInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectOrderInfoInstallation(Map<String, Object> params) throws Exception;
	
	EgovMap selectSrvMemConfigInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectPaySetInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectCustThridPartyInfo(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPaymentList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectCallLogList(Map<String, Object> params) throws Exception;
	
	EgovMap confirmationInfoByContractID(Map<String, Object> params) throws Exception;
	
	EgovMap selectCustBasicInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectContactPerson(Map<String, Object> params) throws Exception;
	
	EgovMap selectMembershipInfo(Map<String, Object> params) throws Exception;
	
	void updMembershipInfo(Map<String, Object> params) throws Exception;
	
	void insertMessageLog(Map<String, Object> params) throws Exception;
	
	EgovMap selectContractSub(Map<String, Object> params) throws Exception;
	
	void updateContractSub(Map<String, Object> params) throws Exception;
	
	EgovMap getSrvContractId(Map<String, Object> params) throws Exception; 
	
	void updateSrvContractSub(Map<String, Object> params) throws Exception;
	
	EgovMap getSrvCntrcStatus(Map<String, Object> params) throws Exception;
	
	void updateServiceContract(Map<String, Object> params) throws Exception;
	
	void updateServiceContractCancel(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectContractSubList(Map<String, Object> params) throws Exception;
	
	void updateContractSubCancel(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getSrvContractIdList(Map<String, Object> params) throws Exception;
	
	void updateSrvContractSubCancel(Map<String, Object> params) throws Exception;
	
	EgovMap getSalesOrderInfo(Map<String, Object> params) throws Exception;
	
	void insertServiceContractTerminations(Map<String, Object> params) throws Exception;
}
