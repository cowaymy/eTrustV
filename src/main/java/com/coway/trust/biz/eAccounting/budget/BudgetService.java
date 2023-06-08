package com.coway.trust.biz.eAccounting.budget;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BudgetService {

	List<EgovMap> selectBudgetControlList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectBudgetSysMaintenanceList(Map<String, Object> params) throws Exception;

    int addBudgetSysMaintGrid(List<Object> updateList , String loginId);

    int udtBudgetSysMaintGrid(List<Object> addList, String loginId);

	List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentCBG( Map<String, Object> params) throws Exception;

	EgovMap selectAvailableBudgetAmt ( Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentAmount(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPenConAmount(Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectApprovalList(Map<String, Object> params) throws Exception;

	EgovMap saveAdjustmentInfo (Map<String, Object> params) throws Exception;

	Map<String, Object> uploadBudgetAdjustment (Map<String, Object> params, List<Object> list) throws Exception;

	EgovMap saveApprovalList (Map<String, Object> params) throws Exception;

	List<EgovMap> selectFileList(Map<String, Object> params) throws Exception;

	EgovMap getBudgetAmt(Map<String, Object> params) throws Exception;

	int selectPlanMaster(Map<String, Object> params) throws Exception;

	String selectCostCenterName(Map<String, Object> params);

	String selectBudgetCodeName(Map<String, Object> params);

	String selectGlAccCodeName(Map<String, Object> params);

	EgovMap deleteAdjustmentInfo (Map<String, Object> params) throws Exception;

	void saveApproval(Map<String, Object> params) throws Exception;

	String selectCloseMonth(Map<String, Object> params);

	List<EgovMap> getPermRole();

	List<EgovMap> getListPerm(Map<String, Object> params);

	List<EgovMap> selectAvailableBudgetList(Map<String, Object> params) throws Exception;

	EgovMap availableAmtCp(Map<String, Object> params);

	EgovMap checkBgtPlan(Map<String, Object> params);

	EgovMap getAdjInfo(Map<String, Object> params);

	EgovMap getBgtApprList(Map<String, Object> params);

	List<EgovMap> getListPermAppr(Map<String, Object> params);

	String selectAdjType(String params);

	List<EgovMap> selectBudgetCodeList(Map<String, Object> params) throws Exception;

	int updateBudgetCode(List<Object> updList, SessionVO sessionVO);

	List<EgovMap> selectStatusList();

	List<EgovMap> selectExpenseTyp();

	List<EgovMap> selectAdjustmentCBGCostCenter( Map<String, Object> params) throws Exception;

}
