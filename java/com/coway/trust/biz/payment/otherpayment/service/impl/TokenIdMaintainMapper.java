package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("tokenIdMaintainMapper")
public interface TokenIdMaintainMapper {

  List<EgovMap> selectTokenIdMaintain(Map<String, Object> params);
  List<EgovMap> selectTokenIdMaintainDetailPop(Map<String, Object> params);
  List<EgovMap> selectTokenIdMaintainHistoryUpload(Map<String, Object> params);
  int saveTokenIdMaintainUploadHistory(Map<String, Object> params);
  int saveTokenIdMaintainBulk(Map<String, Object> params);
}
