package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CustVaExcludeService
{
  List<EgovMap> selectCustVaExcludeList(Map<String, Object> params);
  EgovMap getCustIdByVaNo(Map<String, Object> params);
  void saveCustVaExclude(Map<String, Object> params);
  void updCustVaExclude(List<Object> updList,int userId);
  int saveCustVaExcludeUpload(Map<String, Object> params,List<Map<String, Object>> list);
}
