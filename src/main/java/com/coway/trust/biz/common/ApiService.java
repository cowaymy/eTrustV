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
  EgovMap selectAccountCode(HttpServletRequest request,Map<String, Object> params);//4
  EgovMap selectCustTotalProductsCount(HttpServletRequest request,Map<String, Object> params);//5
  EgovMap getCustTotalOutstanding(HttpServletRequest request, Map<String, Object> params);//7
  EgovMap getTotalMembershipExpired(HttpServletRequest request, Map<String, Object> params);//8
  EgovMap selectCustVANo(HttpServletRequest request,Map<String, Object> params);//9
  EgovMap selectAutoDebitEnrolmentsList(HttpServletRequest request, Map<String, Object> params);//10
  EgovMap selectHeartServiceList(HttpServletRequest request, Map<String, Object> params);//14
  EgovMap selectTechnicianServicesList(HttpServletRequest request, Map<String, Object> params);//15
  EgovMap isUserHasOrdNo(HttpServletRequest request, Map<String, Object> params);//16
  EgovMap selectMembershipProgrammesList(HttpServletRequest request, Map<String, Object> params);//24





}
