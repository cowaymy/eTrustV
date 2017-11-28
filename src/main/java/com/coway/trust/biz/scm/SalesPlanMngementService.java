package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesPlanMngementService 
{
	//Supply-CDC
	List<EgovMap> selectSupplyCDC(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanMaster(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMaster(Map<String, Object> params);
	List<EgovMap> selectComboSupplyCDC(Map<String, Object> params);
	List<EgovMap> selectSupplyCdcMainList(Map<String, Object> params);
	List<EgovMap> selectSupplyCdcSaveFlag(Map<String, Object> params);
	
	
	//Supply-Corp
	List<EgovMap> selectSupplyCorpList(Map<String, Object> params);
	
	//Sales
	List<EgovMap> selectExcuteYear(Map<String, Object> params);
	List<EgovMap> selectPeriodByYear(Map<String, Object> params);
	List<EgovMap> selectScmTeamCode(Map<String, Object> params);
	List<EgovMap> selectStockCategoryCode(Map<String, Object> params);
	List<EgovMap> selectStockCode(Map<String, Object> params);
	List<EgovMap> selectDefaultStockCode(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentList(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentPeriod(Map<String, Object> params);
	List<EgovMap> selectCalendarHeader(Map<String, Object> params);
	List<EgovMap> selectPlanId(Map<String, Object> params);
	List<EgovMap> selectSalesCnt(Map<String, Object> params);
	List<EgovMap> selectSeperation(Map<String, Object> params);
	List<EgovMap> selectChildField(Map<String, Object> params);
	List<EgovMap> selectRemainWeekTh(Map<String, Object> params);
	List<EgovMap> selectMonthCombo(Map<String, Object> params);
	List<EgovMap> selectPlanDetailIdSeq(Map<String, Object> params);
	List<EgovMap> selectPlanMasterId(Map<String, Object> params);
	List<EgovMap> selectStockIdByStCode(Map<String, Object> params);
	
	List<EgovMap> selectStockCtgrySummary(Map<String, Object> params);	 
	
	int updateSCMPlanMaster(List<Object> addList, Integer updUserId);
	int insertSalesPlanDetail(List<Object> addList, Integer updUserId);
	
}
