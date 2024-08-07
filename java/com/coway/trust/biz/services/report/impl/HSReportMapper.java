package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HSReportMapper")
public interface HSReportMapper {

  List<EgovMap> selectHSReportSingle(Map<String, Object> params);

  List<EgovMap> selectHSReportGroup(Map<String, Object> params);

  List<EgovMap> selectCMGroupList(Map<String, Object> params);

  List<EgovMap> selectCodyList(Map<String, Object> params);

  List<EgovMap> selectReportBranchCodeList(Map<String, Object> params);

  List<EgovMap> selectDeptCodeList(Map<String, Object> params);

  List<EgovMap> selectDscCodeList(Map<String, Object> params);

  List<EgovMap> selectInsStatusList(Map<String, Object> params);

  List<EgovMap> selectCodyCodeList(Map<String, Object> params);

  List<EgovMap> selectAreaCodeList(Map<String, Object> params);

  List<EgovMap> selectCodyCodeList_1(Map<String, Object> params);

  List<EgovMap> safetyLevelList(Map<String, Object> params);

  List<EgovMap> getCodyList2(Map<String, Object> params);

  List<EgovMap> getCdUpMem(Map<String, Object> params);

  List<EgovMap> selectCodyBranch(Map<String, Object> params);

  List<EgovMap> selectHSReportCustSign(Map<String, Object> params);

  // Added for HS Count Forecast Listing Enhancement. Hui Ding 2020-07-28
  List<EgovMap> safetyLevelQtyList(Map<String, Object> params);

  List<EgovMap> selectEVoucherList();

List<EgovMap> selectRegion();

}
