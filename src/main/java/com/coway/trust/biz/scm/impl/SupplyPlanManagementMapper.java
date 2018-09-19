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
	List<EgovMap> selectSupplyPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanList(Map<String, Object> params);
	void insertSupplyPlanMaster(Map<String, Object> params);
	void insertSupplyPlanDetail(Map<String, Object> params);
	String callSpScmInsSupplyPlanDetail(Map<String, Object> params);
	//String callSpScmInsSalesPlanDetail(Map<String, Object> params);
	void updateSupplyPlanDetail(Map<String, Object> params);
	void updateSupplyPlanMaster(Map<String, Object> params);
}