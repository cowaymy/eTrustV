package com.coway.trust.biz.logistics.useFilterBlock.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("useFilterBlockMapper")
public interface useFilterBlockMapper {
  List<EgovMap> searchUseFilterBlockList(Map<String, Object> params);

  EgovMap selectUseFilterBlockInfo(Map<String, Object> params);

  void addUseFilterBlock(Map<String, Object> params);

  void updateUseFilterBlock(Map<String, Object> params);

  public String selectUseFilterBlockByStkId(Map<String, Object> params);

}
