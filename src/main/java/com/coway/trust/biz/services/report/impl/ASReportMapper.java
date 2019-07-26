package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 26/07/2019    ONGHC      1.0.1       - Add Recall Status
 *********************************************************************************************/

@Mapper("ASReportMapper")
public interface ASReportMapper {

  List<EgovMap> selectMemberCodeList(Map<String, Object> params);

  EgovMap selectOrderNum();

  List<EgovMap> selectViewLedger(Map<String, Object> params);

  List<EgovMap> selectMemCodeList();

  List<EgovMap> selectAsLogBookTyp();

  List<EgovMap> selectAsLogBookGrp();

  List<EgovMap> selectAsSumTyp();

  List<EgovMap> selectAsSumStat();

  List<EgovMap> selectAsYsTyp();

  List<EgovMap> selectAsYsAge();
}
