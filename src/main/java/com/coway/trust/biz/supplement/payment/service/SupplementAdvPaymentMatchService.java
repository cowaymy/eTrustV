package com.coway.trust.biz.supplement.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementAdvPaymentMatchService {
  List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);

  List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

  void saveAdvPaymentMapping(Map<String, Object> params);

  void saveAdvPaymentDebtor(Map<String, Object> params);

  List<EgovMap> getAccountList(Map<String, Object> params);

  List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

  List<EgovMap> selectAdvKeyInReport(Map<String, Object> params);
}
