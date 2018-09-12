package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplyPlanManagementService
{
	/*
	 * Supply Plan Management
	 */
	List<EgovMap> selectScmYear(Map<String, Object> params);
	List<EgovMap> selectScmWeekByYear(Map<String, Object> params);
	List<EgovMap> selectScmCdc(Map<String, Object> params);
	List<EgovMap> selectScmStockType(Map<String, Object> params);
	List<EgovMap> selectScmStockCode(Map<String, Object> params);
}