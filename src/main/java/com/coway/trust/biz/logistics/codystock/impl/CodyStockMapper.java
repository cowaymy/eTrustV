package com.coway.trust.biz.logistics.codystock.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CodyStockMapper")
public interface CodyStockMapper {
  
  List<EgovMap> selectBranchList(Map<String, Object> params);
  
  List<EgovMap> getDeptCodeList(Map<String, Object> params);

  List<EgovMap> getCodyCodeList(Map<String, Object> params);

  List<EgovMap> selectCMGroupList(Map<String, Object> params);
  
}
