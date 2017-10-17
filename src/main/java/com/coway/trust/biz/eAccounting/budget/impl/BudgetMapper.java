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

	String insertAdjustmentM(Map<String, Object> params) throws Exception;
	
	int insertAdjustmentD(Map<String, Object> params) throws Exception;
	
	int updateAdjustmentInfo(Map<String, Object> params) throws Exception;
	
	int deleteAdjustmentInfo(Map<String, Object> params) throws Exception;
	
}
