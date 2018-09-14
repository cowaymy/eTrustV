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
	List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params);
}