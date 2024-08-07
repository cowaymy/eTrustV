package com.coway.trust.biz.common.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ApiMapper")
public interface ApiMapper {
  EgovMap selectCowayCustNricOrPassport(Map<String, Object> params);
  EgovMap isNricOrPassportMatchInvoiceNo(Map<String, Object> params);
  List<EgovMap> selectInvoiceSubscriptionsList(Map<String, Object> params);
  List<EgovMap> selectAccountCode(Map<String, Object> params);
  EgovMap selectCustVANo(Map<String, Object> params);
  List<EgovMap> selectAutoDebitEnrolmentsList(Map<String, Object> params);
  EgovMap selectCustTotalProductsCount(Map<String, Object> params);
  EgovMap selectLastPayment(Map<String, Object> params);
  EgovMap getCustTotalOutstanding(Map<String, Object> params);
  EgovMap getTotalMembershipExpired(Map<String, Object> params);
  List<EgovMap> selectCowayAccountProductPreviewList(Map<String, Object> params);
  List<EgovMap> selectCowayAccountProductPreviewListByAccountCode(Map<String, Object> params);
  EgovMap selectProductDetail(Map<String, Object> params);
  EgovMap selectLatestMembership(Map<String, Object> params);

  EgovMap selectMembershipExpiredDate(Map<String, Object> params);

  EgovMap selectHeartServiceList(Map<String, Object> params);
  List<EgovMap> selectTechnicianServicesList(Map<String, Object> params);
  EgovMap isUserHasOrdNo(Map<String, Object> params);
  List<EgovMap> selectInvoiceListByOrderNumber(Map<String, Object> params);
  List<EgovMap> selectTransactionHistoryList(Map<String, Object> params);
  List<EgovMap> selectInvoiceDetailByTaxInvoiceRefNo(Map<String, Object> params);
  EgovMap isUserHasTaxInvoiceRefNo(Map<String, Object> params);
  List<EgovMap> selectMembershipProgrammesList(Map<String, Object> params);
  List<EgovMap> selectProductList(Map<String, Object> params);
  List<EgovMap> selectOrderNumberList(Map<String, Object> params);


  EgovMap selectCustomerPortalTemp(Map<String, Object> params);

  int customerPortalSeq();

  int addOrEditPersonInCharge(Map<String, Object> params);
  int addOrEditCustomerInfo(Map<String, Object> params);
  int addEInvoiceSubscription(Map<String, Object> params);

  int updatePersonInChargeContact(Map<String, Object> params);
  int insertCustomerNewContact(Map<String,Object> params);

  int updateStatus(Map<String,Object> params);


  void insertApiAccessLog(Map<String, Object> params);

  int updateTokenStaging(Map<String, Object> params);

}
