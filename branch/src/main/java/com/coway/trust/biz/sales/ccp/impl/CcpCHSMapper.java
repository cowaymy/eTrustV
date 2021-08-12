package com.coway.trust.biz.sales.ccp.impl;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpCHSMapper")
public interface CcpCHSMapper {

  int insertCustHealthScoreDtl(Map<String, Object> params);

  int insertCustHealthScoreMst(Map<String, Object> params);

  List<EgovMap> selectLastCHSMaster(Map<String, Object> params);

  int selectNextBatchId();

  int selectNextDetId();

  List<EgovMap> selectCcpCHSMstList(Map<String, Object> params);

  EgovMap selectCHSMasterInfo(Map<String, Object> params);

  List<EgovMap> selectCHSDetailInfo(Map<String, Object> params);

  void callBatchCHSUpdScore(Map<String, Object> params);


}
