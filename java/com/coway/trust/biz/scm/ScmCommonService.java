package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmCommonService
{
	//	Scm Common
	List<EgovMap> selectScmTotalPeriod(Map<String, Object> params);
	List<EgovMap> selectScmYear(Map<String, Object> params);
	List<EgovMap> selectScmWeek(Map<String, Object> params);
	List<EgovMap> selectScmTeam(Map<String, Object> params);
	List<EgovMap> selectScmCdc(Map<String, Object> params);
	List<EgovMap> selectScmIfType(Map<String, Object> params);
	List<EgovMap> selectScmIfStatus(Map<String, Object> params);
	List<EgovMap> selectScmIfErrCode(Map<String, Object> params);
	List<EgovMap> selectScmStockCategory(Map<String, Object> params);
	List<EgovMap> selectScmStockType(Map<String, Object> params);
	List<EgovMap> selectScmStockCode(Map<String, Object> params);
	List<EgovMap> selectScmStockCodeForMulti(Map<String, Object> params);
	List<EgovMap> selectScmTotalInfo(Map<String, Object> params);
}