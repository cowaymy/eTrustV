package com.coway.trust.biz.eAccounting.expense;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ExpenseService {

	List<EgovMap> selectExpenseList( Map<String, Object> params) throws Exception;

	int insertExpenseInfo(List<Object> addList, Integer crtUserId) throws Exception;

	List<EgovMap> selectBudgetCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectGlCodeList( Map<String, Object> params) throws Exception;

	int updateExpenseInfo(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectExpenseCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodeListWO( Map<String, Object> params) throws Exception;

	List<EgovMap> selectExpenseListMain( Map<String, Object> params) throws Exception;

}
