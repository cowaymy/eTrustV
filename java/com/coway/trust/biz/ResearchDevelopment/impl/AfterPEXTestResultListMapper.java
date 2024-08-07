package com.coway.trust.biz.ResearchDevelopment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AfterPEXTestResultListMapper")
public interface AfterPEXTestResultListMapper {

	  List<EgovMap> searchPEXTestResultList(Map<String, Object> params);

	  List<EgovMap> getAsDefectEntry(Map<String, Object> params);

	  EgovMap selectOrderBasicInfo(Map<String, Object> params);

	  int selRcdTms(Map<String, Object> params);

	  int chkRcdTms(Map<String, Object> params);

	  List<EgovMap> getDTAIL_DEFECT_List(Map<String, Object> params);

	  List<EgovMap> getDEFECT_PART_List(Map<String, Object> params);

	  List<EgovMap> getDEFECT_CODE_List(Map<String, Object> params);

	  List<EgovMap> getPEXTestResultInfo(Map<String, Object> params);

	  List<EgovMap> getPEXReasonCode2(Map<String, Object> params);

	  int isPEXAlreadyResult(Map<String, Object> params);

	  EgovMap PEXResult_Update(Map<String, Object> params);

	  void updatePEXTestResult(Map<String, Object> svc0125map);

	  List<EgovMap> selectAsCrtStat();

	  List<EgovMap> selectTimePick();

	  List<EgovMap> selectAsStat();

	  List<EgovMap> asProd();

	String getSearchDtRange();

}
