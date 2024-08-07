package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CustomerMobileContactUpdateService {

  List<EgovMap> selectMobileUpdateJsonList(Map<String, Object> params);
  EgovMap selectMobileUpdateDetail(Map<String, Object> params);
  void updateAppvStatus(Map<String, Object> params) throws Exception;;
}
