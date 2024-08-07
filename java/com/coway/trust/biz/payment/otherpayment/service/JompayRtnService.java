package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface JompayRtnService
{
  List<EgovMap> selectJompayRtnList(Map<String, Object> params);

  List<EgovMap> selectJompayRtnDetailsList(Map<String, Object> params);
}
