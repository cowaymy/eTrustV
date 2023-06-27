package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preCcpRegisterMapper")
public interface PreCcpRegisterMapper {

	int  insertPreCcpSubmission(Map<String, Object> params);

	EgovMap getExistCustomer(Map<String, Object> params);

	List<EgovMap> searchOrderSummaryList(Map<String, Object> params);

	Map<String, Object> insertNewCustomerInfo(Map<String, Object> params);

	void updateCcrisScre(Map<String, Object> params);

	void updateCcrisId(Map<String, Object> params);

	int getSeqSAL0343D();

	Map<String, Object> insertNewCustomerDetails(Map<String, Object> params);

	EgovMap getPreccpResult(Map<String, Object> params);

	List<EgovMap> getPreCcpRemark(Map<String, Object> params);

	int  editRemarkRequest(Map<String, Object> params);

	int  insertRemarkRequest(Map<String, Object> params);

	EgovMap chkDuplicated(Map<String, Object> params);

	EgovMap getRegisteredCust(Map<String, Object> params);

	List<EgovMap> selectSmsConsentHistory(Map<String, Object> params);

	void updateSmsCount(Map<String,Object> params);

	EgovMap chkSendSmsValidTime(Map<String,Object> params);

	int resetSmsConsent();

	EgovMap chkSmsResetFlag();

	void updateResetFlag(Map<String, Object> params);

	EgovMap getCustInfo(Map<String, Object> params);

	void insertSmsHistory(Map<String, Object> params);

}