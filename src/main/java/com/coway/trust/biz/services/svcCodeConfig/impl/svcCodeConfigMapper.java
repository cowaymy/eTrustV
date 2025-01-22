package com.coway.trust.biz.services.svcCodeConfig.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("svcCodeConfigMapper")
public interface svcCodeConfigMapper {
  void addDefectCodes( Map<String, Object> params );

  List<EgovMap> selectSvcCodeConfigList( Map<String, Object> params );

  EgovMap selectCodeConfigList( Map<String, Object> params );

  void updateDefectCodes( Map<String, Object> params );

  EgovMap getDefectId();

  List<EgovMap> selectProductCategoryList();

  List<EgovMap> selectStatusCategoryCodeList();
}
