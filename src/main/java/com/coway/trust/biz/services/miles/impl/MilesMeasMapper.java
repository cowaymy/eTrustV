package com.coway.trust.biz.services.miles.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 15/08/2023    ONGHC      1.0.1          - INITIAL MilesMeasMapper
 *********************************************************************************************/

@Mapper("milesMeasMapper")
public interface MilesMeasMapper {
  List<EgovMap> getMilesMeasMasterList(Map<String, Object> params);

  List<EgovMap> getMilesMeasList(Map<String, Object> params);

  List<EgovMap> getMilesMeasDetailList(Map<String, Object> params);

  List<EgovMap> getMilesMeasRaw(Map<String, Object> params);

  List<EgovMap> selectSrvStat();

  List<EgovMap> selectSrvFailInst();

}
