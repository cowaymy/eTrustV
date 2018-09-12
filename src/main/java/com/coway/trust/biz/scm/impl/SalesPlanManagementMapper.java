package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("salesPlanManagementMapper")
public interface SalesPlanManagementMapper {
	List<EgovMap> selectSalesPlanHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMonth(Map<String, Object> params);
	List<EgovMap> selectSalesPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSplitInfo(Map<String, Object> params);
	List<EgovMap> selectChildField(Map<String, Object> params);
	List<EgovMap> selectSalesPlanList(Map<String, Object> params);
	void insertSalesPlanMaster(Map<String, Object> params);
	String callSpScmInsSalesPlanDetail(Map<String, Object> params);
	void updateSalesPlanDetail(Map<String, Object> params);
	void updateSalesPlanMaster(Map<String, Object> params);
	//Map<String, Object> callSpScmInsSalesPlanDetail(Map<String, Object> params);
}
