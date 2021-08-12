package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("custVaExcludeMapper")
public interface CustVaExcludeMapper {

  List<EgovMap> selectCustVaExcludeList(Map<String, Object> params);
  EgovMap getCustIdByVaNo(Map<String, Object> params);
  void insertCustVaExclude(Map<String, Object> params);
  void updateCustVaExclude(Map<String, Object> params);
  int saveCustVaExcludeBulk(Map<String, Object> params);
}
