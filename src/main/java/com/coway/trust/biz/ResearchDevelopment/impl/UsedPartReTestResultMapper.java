package com.coway.trust.biz.ResearchDevelopment.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("UsedPartReTestResultMapper")
public interface UsedPartReTestResultMapper {


	 List<EgovMap> selectUsedPartReList(Map<String, Object> params);

	  EgovMap selectOrderBasicInfo(Map<String, Object> params);

	  List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params);

	  List<EgovMap> getTestResultInfo(Map<String, Object> params);

	  EgovMap getAsEventInfo(Map<String, Object> params);

	  String getSearchDtRange();

	  List<EgovMap> asProd();

	  List<EgovMap> selectAsCrtStat();

	  List<EgovMap> selectTimePick();

	  int isReTestAlreadyResult(HashMap<String, Object> mp);

}
