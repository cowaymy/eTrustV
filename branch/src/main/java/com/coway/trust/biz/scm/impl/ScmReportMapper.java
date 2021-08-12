package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmReportMapper")
public interface ScmReportMapper {
	
	//	Business Plan Report
	List<EgovMap> selectPlanVer(Map<String, Object> params);
	List<EgovMap> selectBusinessPlanSummary(Map<String, Object> params);
	List<EgovMap> selectBusinessPlanDetail(Map<String, Object> params);
	List<EgovMap> selectBusinessPlanDetail1(Map<String, Object> params);
	void updateBusinessPlan(Map<String, Object> params);
	void deleteBusinessPlan(Map<String, Object> params);
	void insertBusinessPlan(Map<String, Object> params);
	
	//	Sales Plan Accuracy
	List<EgovMap> selectSalesPlanAccuracyWeeklyDetailHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyMonthlyDetailHeader(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyWeeklySummary(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyMonthlySummary(Map<String, Object> params);
	List<EgovMap> selectWeekly16Week(Map<String, Object> params);
	List<EgovMap> selectWeeklyStartEnd(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyWeeklyDetail(Map<String, Object> params);
	List<EgovMap> selectMonthly16Week(Map<String, Object> params);
	List<EgovMap> selectMonthlyStartEnd(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyMonthlyDetail(Map<String, Object> params);
	List<EgovMap> selectSalesPlanAccuracyMaster(Map<String, Object> params);
	void insertSalesPlanAccuracyMaster(Map<String, Object> params);
	void deleteSalesPlanAccuracyMaster(Map<String, Object> params);
	void executeSalesPlanAccuracy(Map<String, Object> params);
	
	//	Ontime Delivery Report
	List<EgovMap> selectOntimeDeliverySummary(Map<String, Object> params);
	List<EgovMap> selectOntimeDeliveryDetail(Map<String, Object> params);
	List<EgovMap> selectOntimeDeliveryPopup(Map<String, Object> params);
	
	//	Inventory Report
	List<EgovMap> selectInventoryReportTotalHeader(Map<String, Object> params);
	List<EgovMap> selectInventoryReportDetailHeader(Map<String, Object> params);
	List<EgovMap> selectInventoryReportTotal(Map<String, Object> params);
	List<EgovMap> selectInventoryReportDetail(Map<String, Object> params);
	List<EgovMap> selectScmCurrency(Map<String, Object> params);
	void updateScmCurrency(Map<String, Object> params);
	void executeScmInventory(Map<String, Object> params);
	void executeScmDaysInInventory(Map<String, Object> params);
	
	//	Aging Report
	List<EgovMap> selectAgingInventoryHeader(Map<String, Object> params);
	List<EgovMap> selectAgingInventory(Map<String, Object> params);
}