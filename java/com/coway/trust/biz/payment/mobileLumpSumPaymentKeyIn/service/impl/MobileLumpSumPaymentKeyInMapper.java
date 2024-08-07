package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("mobileLumpSumPaymentKeyInMapper")
public interface MobileLumpSumPaymentKeyInMapper {
	List<EgovMap> getCustomerInfoBySalesOrderNo(Map<String, Object> params);
	EgovMap getCustomerBillingInfoByInvoiceNo(Map<String, Object> params);
	List<EgovMap> getCustomerInfo(Map<String, Object> params);
	List<EgovMap> getCustomerOutstandingOrder(Map<String, Object> params);
    int selectNextMobPayId();
    int selectNextMobPayGroupId();
    EgovMap selectUser(Map<String, Object> params);
    int insertPaymentMasterInfo(Map<String, Object> params);
    int insertPaymentDetailInfo(Map<String, Object> params);
    List<EgovMap> getLumpSumEnrollmentList(Map<String, Object> params);
    List<EgovMap> mobileSelectCashMatchingPayGroupList(Map<String, Object> params);
    EgovMap selectLumpSumPaymentDetail(Map<String, Object> params);
    EgovMap selectBankStatementInfo(Map<String, Object> params);
    List<EgovMap> selectLumpSumPaymentSubDetail(Map<String, Object> params);
    EgovMap selectOrderDetailInfo(Map<String, Object> params);
    void updateApproveLumpSumPaymentInfo(Map<String, Object> params);
    int updateRejectLumpSumPayment(Map<String, Object> params);
    EgovMap getPay0024D(Map<String, Object> params);
    EgovMap getServiceMembershipDetail(Map<String, Object> params);
    List<EgovMap> getMobileLumpSumHistory(Map<String, Object> params);
    int selectNextMatchingId();
    int mobileUpdateCashMatchingData(Map<String, Object> params);
    EgovMap getAdditionalEmailDetailInfo(Map<String, Object> params);
    List<EgovMap> getAdditionalEmailDetailOrderInfo(Map<String, Object> params);
    String getSmsTemplate(Map<String, Object> params);
}
