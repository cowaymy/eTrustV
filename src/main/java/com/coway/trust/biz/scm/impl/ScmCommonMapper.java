package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmCommonMapper")
public interface ScmCommonMapper {
	List<EgovMap> selectScmYear(Map<String, Object> params);
	List<EgovMap> selectScmWeek(Map<String, Object> params);
	List<EgovMap> selectScmTeam(Map<String, Object> params);
	List<EgovMap> selectScmCdc(Map<String, Object> params);
	List<EgovMap> selectScmStockCategory(Map<String, Object> params);
	List<EgovMap> selectScmStockType(Map<String, Object> params);
	List<EgovMap> selectScmStockCode(Map<String, Object> params);
}