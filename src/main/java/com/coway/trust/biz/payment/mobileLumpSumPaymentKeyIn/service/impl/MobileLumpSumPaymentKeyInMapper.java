package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("mobileLumpSumPaymentKeyInMapper")
public interface MobileLumpSumPaymentKeyInMapper {
	EgovMap getCustomerBillingInfoByInvoiceNo(Map<String, Object> params);
	List<EgovMap> getCustomerInfo(Map<String, Object> params);
	List<EgovMap> getCustomerOutstandingOrder(Map<String, Object> params);
    int selectNextMobPayId();
    int selectNextMobPayGroupId();
    EgovMap selectUser(Map<String, Object> params);
    int insertPaymentMasterInfo(Map<String, Object> params);
    int insertPaymentDetailInfo(Map<String, Object> params);
    List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params);
    List<EgovMap> selectCashMatchingPayGroupList(Map<String, Object> params);
    int mobileUpdateCashMatchingData(Map<String, Object> params);
}
