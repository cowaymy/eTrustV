package com.coway.trust.biz.common;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ApiService {

  EgovMap displayResponseMessage(HttpServletRequest request, Map<String, Object> params, List<EgovMap> custDetails);
  EgovMap displayResponseMessage(HttpServletRequest request, Map<String, Object> params, EgovMap custDetails);

  EgovMap selectCowayCustNricOrPassport(HttpServletRequest request, Map<String, Object> params); //1
  EgovMap isNricOrPassportMatchInvoiceNo(HttpServletRequest request, Map<String, Object> params);//2
  EgovMap selectInvoiceSubscriptionsList(HttpServletRequest request, Map<String, Object> params);//3
  EgovMap selectAccountCode(HttpServletRequest request,Map<String, Object> params);//4
  EgovMap selectCustTotalProductsCount(HttpServletRequest request,Map<String, Object> params);//5
  EgovMap selectLastPayment(HttpServletRequest request, Map<String, Object> params);//6
  EgovMap getCustTotalOutstanding(HttpServletRequest request, Map<String, Object> params);//7
  EgovMap getTotalMembershipExpired(HttpServletRequest request, Map<String, Object> params);//8
  EgovMap selectCustVANo(HttpServletRequest request,Map<String, Object> params);//9
  EgovMap selectAutoDebitEnrolmentsList(HttpServletRequest request, Map<String, Object> params);//10
  EgovMap selectCowayAccountProductPreviewList(HttpServletRequest request, Map<String, Object> params);//11
  EgovMap selectCowayAccountProductPreviewListByAccountCode(HttpServletRequest request, Map<String, Object> params);//12
  EgovMap selectProductDetail(HttpServletRequest request, Map<String, Object> params);//13
  EgovMap selectHeartServiceList(HttpServletRequest request, Map<String, Object> params);//14
  EgovMap selectTechnicianServicesList(HttpServletRequest request, Map<String, Object> params);//15
  EgovMap isUserHasOrdNo(HttpServletRequest request, Map<String, Object> params);//16
  EgovMap selectInvoiceListByOrderNumber(HttpServletRequest request, Map<String, Object> params);//17
  EgovMap selectTransactionHistoryList(HttpServletRequest request, Map<String, Object> params);//18
  EgovMap selectInvoiceDetailByTaxInvoiceRefNo(HttpServletRequest request, Map<String, Object> params);//20
  EgovMap isUserHasTaxInvoiceRefNo(HttpServletRequest request, Map<String, Object> params);//21
  EgovMap selectOrderNumberList(HttpServletRequest request, Map<String, Object> params);//23
  EgovMap selectMembershipProgrammesList(HttpServletRequest request, Map<String, Object> params);//24
  EgovMap selectProductList(HttpServletRequest request, Map<String, Object> params);//28

  EgovMap addOrEditPersonInCharge(HttpServletRequest request, Map<String, Object> params);//25
  EgovMap addOrEditCustomerInfo(HttpServletRequest request, Map<String, Object> params);//26
  EgovMap addEInvoiceSubscription(HttpServletRequest request, Map<String, Object> params);//27

  EgovMap verify(HttpServletRequest request, Map<String, Object> params);

  EgovMap tokenizationProcess(HttpServletRequest request, Map<String, Object> params);

  EgovMap checkRenEInv(Map<String, Object> params);
  EgovMap checkOutEInv(Map<String, Object> params);
  EgovMap checkSvmEInv(Map<String, Object> params);













}
