package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("salesPlanManagementMapper")
public interface SalesPlanManagementMapper {
	//	Sales Plan Manager
	List<EgovMap> selectSalesPlanSummaryHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSalesPlanList(Map<String, Object> params);
	List<EgovMap> selectSalesPlanListAll(Map<String, Object> params);
	void insertSalesPlanMaster(Map<String, Object> params);
	List<EgovMap> selectGetSalesPlanId(Map<String, Object> params);
	void insertSalesPlanDetail(Map<String, Object> params);
	List<EgovMap> selectSalesPlanForUpdate(Map<String, Object> params);
	List<EgovMap> selectThisMonthOrder(Map<String, Object> params);
	List<EgovMap> selectFilterPlan(Map<String, Object> params);
	int deleteSalesPlanDetail(Map<String, Object> params);
	int deleteSalesPlanMaster(Map<String, Object> params);
	void updateSalesPlanDetail(Map<String, Object> params);
	void updateSalesPlanMaster(Map<String, Object> params);
	
	List<EgovMap> selectSalesPlanSummaryList(Map<String, Object> params);
	
	//List<EgovMap> selectSalesPlanMonth(Map<String, Object> params);
	//List<EgovMap> selectSplitInfo(Map<String, Object> params);
	//List<EgovMap> selectChildField(Map<String, Object> params);
	//List<EgovMap> selectCreateCheck(Map<String, Object> params);
	//String callSpScmInsSalesPlanDetail(Map<String, Object> params);
	//List<EgovMap> selectSalesPlanDetailSum(Map<String, Object> params);
	//void updateSalesPlanDetailSum(Map<String, Object> params);
}
