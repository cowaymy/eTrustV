package com.coway.trust.biz.common.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ApiMapper")
public interface ApiMapper {
  EgovMap selectCowayCustNricOrPassport(Map<String, Object> params);
  EgovMap isNricOrPassportMatchInvoiceNo(Map<String, Object> params);
  List<EgovMap> selectAccountCode(Map<String, Object> params);
  EgovMap selectCustVANo(Map<String, Object> params);
  List<EgovMap> selectAutoDebitEnrolmentsList(Map<String, Object> params);
  EgovMap selectCustTotalProductsCount(Map<String, Object> params);
  EgovMap getCustTotalOutstanding(Map<String, Object> params);
  EgovMap getTotalMembershipExpired(Map<String, Object> params);
  EgovMap selectHeartServiceList(Map<String, Object> params);
  EgovMap selectTechnicianServicesList(Map<String, Object> params);
  EgovMap isUserHasOrdNo(Map<String, Object> params);
  List<EgovMap> selectMembershipProgrammesList(Map<String, Object> params);

  void insertApiAccessLog(Map<String, Object> params);


}
