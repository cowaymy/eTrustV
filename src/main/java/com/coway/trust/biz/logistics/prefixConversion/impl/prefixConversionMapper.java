package com.coway.trust.biz.logistics.prefixConversion.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("prefixConversionMapper")
public interface prefixConversionMapper {
  List<EgovMap> searchPrefixConfigList(Map<String, Object> params);

  EgovMap selectPrefixConfigInfo(Map<String, Object> params);

  void addPrefixConfig(Map<String, Object> params);

  void updatePrefixConfig(Map<String, Object> params);

  public String selectPrefixConversionByProdId(Map<String, Object> params);

}
