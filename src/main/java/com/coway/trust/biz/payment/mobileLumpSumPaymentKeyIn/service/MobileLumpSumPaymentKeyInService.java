package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service;

import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.coway.trust.cmmn.model.SessionVO;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MobileLumpSumPaymentKeyInService {
	List<EgovMap> customerInfoSearch(Map<String,Object> params);

	List<EgovMap> getCustomerOutstandingDistinctOrder(Map<String, Object> params);

	List<EgovMap> getCustomerOutstandingOrderDetailList(Map<String, Object> params);

	Map<String, Object> submissionSave(Map<String, Object> params);

	List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params);

	int mobileUpdateCashMatchingData(Map<String, Object> params);

	List<EgovMap> mobileSelectCashMatchingPayGroupList(Map<String, Object> params);

	Map<String, Object> saveNormalPayment(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> savePaymentCard(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> rejectApproval(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getMobileLumpSumHistory(Map<String, Object> params);

	List<EgovMap> checkBatchPaymentExist(Map<String, Object> params);

	void sendEmail(Map<String, Object> params);

	void sendSms(Map<String, Object> params);

	EgovMap getLumpSumReceiptInfo(Map<String, Object> params);
}
