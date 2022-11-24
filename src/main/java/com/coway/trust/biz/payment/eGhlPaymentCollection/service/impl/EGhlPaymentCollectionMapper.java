package com.coway.trust.biz.payment.eGhlPaymentCollection.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("eGhlPaymentCollectionMapper")
public interface EGhlPaymentCollectionMapper {
	List<EgovMap> orderNumberBillMobileSearch(Map<String, Object> params);

	int selectNextPay0336mId();

	int insertPaymentCollectionMaster(Map<String, Object> params);

	int insertPaymentCollectionDetail(Map<String, Object> params);

	EgovMap getUserByUserName(Map<String, Object> params);

	List<EgovMap> paymentCollectionMobileHistoryGet(Map<String, Object> params);

	List<EgovMap> selectPaymentCollectionList(Map<String,Object> params);
}
