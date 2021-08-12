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
	List<EgovMap> selectSupplyCdcPop(Map<String, Object> params);
	List<EgovMap> selectPlanDatePlanByCdc(Map<String, Object> params);
	List<EgovMap> selectPlanIdByCdc(Map<String, Object> params);
	List<EgovMap> selectMonthPlanByCdc(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMstId(Map<String, Object> params);
	void updatePlanByCDC(Map<String, Object> params);
	void insertSalesPlanMstCdc(Map<String, Object> params);
	/*Stored-Procedure Call*/
	String callSpCreateSupplyPlanSummary(Map<String, Object> params);

    /*Supply_CORP */
	List<EgovMap> selectSupplyCorpList(Map<String, Object> params);

	/* SALES */
	List<EgovMap> selectCalendarHeader(Map<String, Object> params);
	List<EgovMap> selectExcuteYear(Map<String, Object> params);
	List<EgovMap> selectPeriodByYear(Map<String, Object> params);
	List<EgovMap> selectScmTeamCode(Map<String, Object> params);
	List<EgovMap> selectStockCategoryCode(Map<String, Object> params);
	List<EgovMap> selectStockCode(Map<String, Object> params);
	List<EgovMap> selectDefaultStockCode(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentList(Map<String, Object> params);
	List<EgovMap> selectSalesPlanMngmentGroupList(Map<String, Object> params);
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

	int updateSalesPlanUnConfirm(Map<String, Object> params);
	int updateSalesPlanConfirm(Map<String, Object> params);
	void updateScmPlanMaster(Map<String, Object> params);
	void insertSalesPlanDetail(Map<String, Object> params);
	int deleteStockCode(Map<String, Object> params);

	void insertSalesPlanMaster(Map<String, Object> params);
	void insertSalesCdcDetail(Map<String, Object> params);
	/* interface */
	String callSpCreateSalesPlanDetail(Map<String, Object> params);

	/* SALES PLAN ACCURACY */
	List<EgovMap> selectAccuracyWeeklyDetail(Map<String, Object> params);
	List<EgovMap> selectAccuracyMonthlyReport(Map<String, Object> params);
	String callSpCreateMonthlyAccuracy(Map<String, Object> params);

	/* Supply Plan */
	int selectCountasIn(Map<String, Object> params);
	int selectBeforeOrdCnt(Map<String, Object> params);
	int selectSafetyStock(Map<String, Object> params);
	int selectEndingInventory(Map<String, Object> params);
	int selectBeforePoCnt(Map<String, Object> params);
	int selectAfterPoCnt(Map<String, Object> params);
	int selectBeforeWeekYear(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanListByCdc(Map<String, Object> params);
	List<EgovMap> selectSalesPlanList(Map<String, Object> params);
	List<EgovMap> selectSalesPlanWeekCnt(Map<String, Object> params);
	List<EgovMap> selectSeperation2(Map<String, Object> params);
	List<EgovMap> selectSalesPlanByStockCode(Map<String, Object> params);
	List<EgovMap> selectLeadTimeByCdc(Map<String, Object> params);
	List<EgovMap> selectScmMonth(Map<String, Object> params);
	List<EgovMap> selectScmYearMonthWeek(Map<String, Object> params);

	void insertSalesCdcDetailNew(Map<String, Object> params);
	void updateSalesPlanDetailMonthly(Map<String, Object> params);

	void insConfirmPlanByCDC(Map<String, Object> params);
	
	void insertITF189(Map<String, Object> params);
	
	int selectCreateCount(Map<String, Object> params);
	
	int selectUnConfirmCnt(Map<String, Object> params);
	
	int supplyPlancheck(Map<String, Object> params);
	
	int SelectConfirmPlanCheck(Map<String, Object> params);
	
}
