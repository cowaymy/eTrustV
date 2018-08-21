package com.coway.trust.biz.eAccounting.budget.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("budgetMapper")
public interface BudgetMapper {

	List<EgovMap> selectBudgetControlList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectBudgetSysMaintenanceList(Map<String, Object> params) throws Exception;

	int addBudgetSysMaintGrid(Map<String, Object> params);

	int udtBudgetSysMaintGrid(Map<String, Object> params);

	List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentCBG( Map<String, Object> params) throws Exception;

	EgovMap selectAvailableBudgetAmt( Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentAmount( Map<String, Object> params) throws Exception;

	List<EgovMap> selectPenConAmount(Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentList(Map<String, Object> params) throws Exception;

	void insertAdjustmentM(Map<String, Object> params) throws Exception;

	void insertAdjustmentD(Map<String, Object> params) throws Exception;

	void updateAdjustmentM(Map<String, Object> params) throws Exception;

	void updateAdjustmentD(Map<String, Object> params) throws Exception;

	void deleteAdjustmentM(Map<String, Object> params) throws Exception;

	void deleteAdjustmentD(Map<String, Object> params) throws Exception;

	void insertApprove(Map<String, Object> params) throws Exception;

	void deleteApprove(Map<String, Object> params) throws Exception;

	String selectBudgetDocNo(Map<String, Object> params) throws Exception;

	List<EgovMap> selectFileList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectAvailableAmtList(Map<String, Object> params) throws Exception;

	EgovMap getBudgetAmt( Map<String, Object> params) throws Exception;

	List<EgovMap> selectApprovalList(Map<String, Object> params) throws Exception;

	int selectPlanMaster(Map<String, Object> params) throws Exception;

	String selectCostCenterName(Map<String, Object> params);

	String selectBudgetCodeName(Map<String, Object> params);

	String selectGlAccCodeName(Map<String, Object> params);

	void deleteAdjustmentDByDocNo(Map<String, Object> params) throws Exception;

	String selectCloseMonth(Map<String, Object> params);

	List<EgovMap> selectAvailableBudgetList(Map<String, Object> params);

	EgovMap availableAmtCp(Map<String, Object> params);
	
	EgovMap checkBgtPlan(Map<String, Object> params);
}
