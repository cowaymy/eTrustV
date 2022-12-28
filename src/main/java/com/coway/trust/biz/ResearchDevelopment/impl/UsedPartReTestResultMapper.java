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

	List<EgovMap> getTestResultInfo(Map<String, Object> params);

	EgovMap getAsEventInfo(Map<String, Object> params);

	String getSearchDtRange();

	List<EgovMap> asProd();

	List<EgovMap> selectAsCrtStat();

	List<EgovMap> selectTimePick();

	EgovMap isReTestAlreadyResult(Map<String, Object> mp);

	EgovMap getUsedPartReTestResultDocNo(Map<String, Object> params);

	EgovMap getUsedPartReTestResultId(Map<String, Object> params);

	int insertSVC0122D(Map<String, Object> params);

	int updateSVC0122D(Map<String, Object> params);

	int insertSVC0122D_notTested(Map<String, Object> params);

	List<EgovMap> selectCTList(Map<String, Object> params);

	List<EgovMap> getSpareFilterList(Map<String, Object> params);

	int isReTestAlreadyResult_2(Map<String, Object> mp);

}
