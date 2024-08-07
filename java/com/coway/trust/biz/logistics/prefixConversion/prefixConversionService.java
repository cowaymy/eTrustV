package com.coway.trust.biz.logistics.prefixConversion;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface prefixConversionService
{
  List<EgovMap> searchPrefixConfigList(Map<String, Object> params);

  EgovMap selectPrefixConfigInfo(Map<String, Object> params);

  void savePrefixConversion(Map<String, Object> params, SessionVO sessionVO);
}
