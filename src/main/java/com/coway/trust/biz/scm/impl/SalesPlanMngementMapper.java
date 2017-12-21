package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("salesPlanMngementMapper")
public interface SalesPlanMngementMapper {
	/*Supply_CDC */
	List<EgovMap> selectSupplyPlanMaster(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMaster(Map<String, Object> params);
	List<EgovMap> selectSupplyCDC(Map<String, Object> params);
	List<EgovMap> selectComboSupplyCDC(Map<String, Object> params);
	List<EgovMap> selectSupplyCdcSaveFlag(Map<String, Object> params);
	List<EgovMap> selectSupplyCdcMainList(Map<String, Object> params);  
	void updatePlanByCDC(Map<String, Object> params);
	
    /*Supply_CORP */
	List<EgovMap> selectSupplyCorpList(Map<String, Object> params);
	
	/* SALES */
	List<EgovMap> selectCalendarHeader(Map<String, Object> params);
	List<EgovMap> selectExcuteYear(Map<String, Object> params);
	List<EgovMap> selectPeriodByYear(Map<String, Object> params);
	List<EgovMap> selectScmTeamCode(Map<String, Object> params);
	List<EgovMap> selectStockCategoryCode(Map<String, Object> params);
	List<EgovMap> selectStockCode(Map<String, Object> params);
	List<EgovMap> selectStockCode_TEMP(Map<String, Object> params);
	List<EgovMap> selectDefaultStockCode(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentList(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentPeriod(Map<String, Object> params);
	List<EgovMap> selectPlanId(Map<String, Object> params);
	List<EgovMap> selectSalesCnt(Map<String, Object> params);
	List<EgovMap> selectSeperation(Map<String, Object> params);
	List<EgovMap> selectChildField(Map<String, Object> params);
	List<EgovMap> selectWeekThSn(Map<String, Object> params);
	List<EgovMap> selectAccuracyMonthlyHeaderList(Map<String, Object> params);
	List<EgovMap> selectRemainWeekTh(Map<String, Object> params);
	List<EgovMap> selectMonthCombo(Map<String, Object> params);
	
	List<EgovMap> selectStockCtgrySummary(Map<String, Object> params);
	List<EgovMap> selectPlanDetailIdSeq(Map<String, Object> params);
	List<EgovMap> selectPlanMasterId(Map<String, Object> params);
	List<EgovMap> selectStockIdByStCode(Map<String, Object> params);
	
	void updateScmPlanMaster(Map<String, Object> params);
	void insertSalesPlanDetail(Map<String, Object> params);
	
	void insertSalesPlanMaster(Map<String, Object> params);
	/* interface */
	String callSpCreateSalesPlanDetail(Map<String, Object> params);
	
	/* SALES PLAN ACCURACY */
	List<EgovMap> selectAccuracyWeeklyDetail(Map<String, Object> params);
	
}
