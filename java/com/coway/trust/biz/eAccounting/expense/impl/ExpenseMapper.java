package com.coway.trust.biz.eAccounting.expense.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("expenseMapper")
public interface ExpenseMapper {

	List<EgovMap> selectExpenseList( Map<String, Object> params) throws Exception;

	String selectMaxExpType(Map<String, Object> params) throws Exception;

	int insertExpenseInfo(Map<String, Object> params) throws Exception;

	List<EgovMap> selectBudgetCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodeListAll( Map<String, Object> params) throws Exception;

	List<EgovMap> selectExpenseCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectGlCodeList( Map<String, Object> params) throws Exception;

	int updateExpenseInfo (Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectExpenseListMain( Map<String, Object> params) throws Exception;


}
