package com.coway.trust.biz.eAccounting.budget.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("budgetMapper")
public interface BudgetMapper {

	List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception;
	
	EgovMap selectAvailableBudgetAmt( Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAdjustmentAmount( Map<String, Object> params) throws Exception;

	List<EgovMap> selectPenConAmount(Map<String, Object> params) throws Exception;

	List<EgovMap> selectAdjustmentList(Map<String, Object> params) throws Exception;

	/*String selectMaxExpType(Map<String, Object> params) throws Exception;
	
	int insertExpenseInfo(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectBudgetCodeList( Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectGlCodeList( Map<String, Object> params) throws Exception;
	
	int updateExpenseInfo (Map<String, Object> params) throws Exception;*/
	
}
