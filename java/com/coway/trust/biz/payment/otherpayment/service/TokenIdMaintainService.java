package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TokenIdMaintainService
{
  List<EgovMap> selectTokenIdMaintain(Map<String, Object> params);
  List<EgovMap> selectTokenIdMaintainDetailPop(Map<String, Object> params);
  List<EgovMap> selectTokenIdMaintainHistoryUpload(Map<String, Object> params);
  int saveTokenIdMaintainUploadHistory(Map<String, Object> params);
  int saveTokenIdMaintainUpload(Map<String, Object> params,List<Map<String, Object>> list);
}
