package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementAdvPaymentMatchMapper")
public interface SupplementAdvPaymentMatchMapper {
  List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);

  List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

  void mappingAdvGroupPayment(Map<String, Object> params);

  void mappingBankStatementAdv(Map<String, Object> params);

  List<EgovMap> selectMappedData(Map<String, Object> paramMap);

  void insertAdvPaymentMatchIF(EgovMap params);

  void insertAdvPaymentDebtorIF(EgovMap params);

  void updateDiffTypeDiffAmt(Map<String, Object> params);

  List<EgovMap> getAccountList(Map<String, Object> params);

  List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

  List<EgovMap> selectAdvKeyInReport(Map<String, Object> params);

  void updSupplementOrdStage(Map<String, Object> params);
}
