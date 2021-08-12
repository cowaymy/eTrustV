package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplyPlanManagementMapper")
public interface SupplyPlanManagementMapper {
	//	Supply Plan by CDC
	List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanList(Map<String, Object> params);
	List<EgovMap> selectGetPoCntTargetCnt(Map<String, Object> params);
	void insertSupplyPlanMaster(Map<String, Object> params);
	int deleteSupplyPlanDetail(Map<String, Object> params);
	int deleteSupplyPlanMaster(Map<String, Object> params);
	List<EgovMap> selectGetSupplyPlanId(Map<String, Object> params);
	void insertSupplyPlanDetailPsi1(Map<String, Object> params);
	void insertSupplyPlanDetailPsi235(Map<String, Object> params);
	void insertSupplyPlanDetailPsi4(Map<String, Object> params);
	List<EgovMap> selectGetPoCntTarget(Map<String, Object> params);
	List<EgovMap> selectGetPoCnt(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanPsi1(Map<String, Object> params);
	
	void insertSupplyPlanDetail(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanMoq(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanMonth(Map<String, Object> params);
	int selectSupplyPlanBeforeYearsLastWeek(Map<String, Object> params);
	int selectBeforeOrdCnt(Map<String, Object> params);
	int selectSupplyPlanEndingInventory(Map<String, Object> params);
	int selectSupplyPlanWeekCnt(Map<String, Object> params);
	int selectBeforePoCnt(Map<String, Object> params);
	int selectAfterPoCnt(Map<String, Object> params);
	List<EgovMap> selectSalesPlanInSupplyPlan(Map<String, Object> params);
	List<EgovMap> selectInsertedSalesPlan(Map<String, Object> params);
	String callSpScmInsSupplyPlanDetail(Map<String, Object> params);
	//String callSpScmInsSalesPlanDetail(Map<String, Object> params);
	void updateSupplyPlanDetail(Map<String, Object> params);
	void updateSupplyPlanMaster(Map<String, Object> params);
	
	
	
	List<EgovMap> selectBefWeekInfo(Map<String, Object> params);
	List<EgovMap> selectPsi1(Map<String, Object> params);
	List<EgovMap> selectEachPsi(Map<String, Object> params);
	List<EgovMap> selectPoInLeadTm(Map<String, Object> params);
	List<EgovMap> selectTotalSplitInfo(Map<String, Object> params);
	void updateSupplyPlanDetailPsi1(Map<String, Object> params);
	void updateSupplyPlanDetailPsi23(Map<String, Object> params);
	void updateSupplyPlanDetailPsi5(Map<String, Object> params);
	
	List<EgovMap> selectSupplyPlanSummaryList(Map<String, Object> params);
}