package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MobileLumpSumPaymentKeyInService {
	List<EgovMap> customerInfoSearch(Map<String,Object> params);

	List<EgovMap> getCustomerOutstandingDistinctOrder(Map<String, Object> params);

	List<EgovMap> getCustomerOutstandingOrderDetailList(Map<String, Object> params);

	Map<String, Object> submissionSave(Map<String, Object> params);

	List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params);

	int mobileUpdateCashMatchingData(Map<String, Object> params);

	List<EgovMap> mobileSelectCashMatchingPayGroupList(Map<String, Object> params);
}
