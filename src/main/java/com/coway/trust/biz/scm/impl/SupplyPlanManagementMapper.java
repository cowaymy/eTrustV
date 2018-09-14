package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplyPlanManagementMapper")
public interface SupplyPlanManagementMapper {
	/*
	 * Supply Plan Management
	 */
	List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params);
}