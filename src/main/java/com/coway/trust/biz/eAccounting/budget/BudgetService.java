package com.coway.trust.biz.eAccounting.budget;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BudgetService {

	List<EgovMap> selectMonthlyBudgetList( Map<String, Object> params) throws Exception;
	/*
	int insertExpenseInfo(List<Object> addList, Integer crtUserId) throws Exception;
	
	List<EgovMap> selectBudgetCodeList( Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectGlCodeList( Map<String, Object> params) throws Exception;

	int updateExpenseInfo(Map<String, Object> params) throws Exception;*/
}
