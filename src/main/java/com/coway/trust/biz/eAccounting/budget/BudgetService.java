package com.coway.trust.biz.eAccounting.budget;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BudgetService {

	List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception; 
	
	EgovMap selectAvailableBudgetAmt ( Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentAmount(Map<String, Object> params) throws Exception; 
	
	List<EgovMap> selectPenConAmount(Map<String, Object> params) throws Exception; 
	
	List<EgovMap> selectAdjustmentList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectApprovalList(Map<String, Object> params) throws Exception;

	EgovMap saveAdjustmentInfo (Map<String, Object> params) throws Exception;
	
	EgovMap saveApprovalList (Map<String, Object> params) throws Exception;

	List<EgovMap> selectFileList(Map<String, Object> params) throws Exception;
	
	EgovMap getBudgetAmt(Map<String, Object> params) throws Exception;
	
	int selectPlanMaster(Map<String, Object> params) throws Exception;

}
