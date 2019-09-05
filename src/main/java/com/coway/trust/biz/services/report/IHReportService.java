package com.coway.trust.biz.services.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/08/2019    ONGHC      1.0.0       - CREATE FOR IN HOUSE REPAIR
 *********************************************************************************************/

public interface IHReportService {

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
