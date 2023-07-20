package com.coway.trust.biz.services.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 26/07/2019    ONGHC      1.0.1       - Add Recall Status
 *********************************************************************************************/

public interface ASReportService {

  List<EgovMap> selectMemberCodeList(Map<String, Object> params);

  List<EgovMap> selectMemberCodeList2(Map<String, Object> params);

  EgovMap selectOrderNum();

  List<EgovMap> selectViewLedger(Map<String, Object> params);

  List<EgovMap> selectMemCodeList();

  List<EgovMap> selectAsLogBookTyp();

  List<EgovMap> selectAsLogBookGrp();

  List<EgovMap> selectAsSumTyp();

  List<EgovMap> selectAsSumStat();

  List<EgovMap> selectAsYsTyp();

  List<EgovMap> selectAsYsAge();

  List<EgovMap> selectBranchList(Map<String, Object> params);

  List<EgovMap> selectProductList();

  List<EgovMap> selectHCProductList();

  List<EgovMap> selectDefectTypeList();

  List<EgovMap> selectDefectRmkList();

  List<EgovMap> selectDefectDescList();

  List<EgovMap> selectDefectDescSymptomList();

  List<EgovMap> selectHCDefectDescSymptomList();

  List<EgovMap> selectProductTypeList();

  List<EgovMap> selectHCProductCategory();

  List<EgovMap> selectHCDefectTypeList();

  List<EgovMap> selectHCDefectRmkList();

  List<EgovMap> selectHCDefectDescList();
}
