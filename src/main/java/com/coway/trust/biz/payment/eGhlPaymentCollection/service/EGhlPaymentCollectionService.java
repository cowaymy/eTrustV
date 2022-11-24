package com.coway.trust.biz.payment.eGhlPaymentCollection.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EGhlPaymentCollectionService {
	public List<EgovMap> orderNumberBillMobileSearch(Map<String,Object> params);

	String paymentCollectionRunningNumberGet();

	int paymentCollectionMobileCreation(Map<String, Object> params, List<Map<String, Object>> paramDetails);

	List<EgovMap> paymentCollectionMobileHistoryGet(Map<String, Object> params);

	public List<EgovMap> selectPaymentCollectionList(Map<String, Object> params);
}
