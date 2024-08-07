package com.coway.trust.biz.sales.analysis.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("analysisMapper")
public interface AnalysisMapper {

	EgovMap maintanceSession();

	List<EgovMap> selectPltvProductCodeList(Map<String, Object> params);

	List<EgovMap> selectPltvProductCategoryList(Map<String, Object> params);

	String selectMaxAccYm();

}
