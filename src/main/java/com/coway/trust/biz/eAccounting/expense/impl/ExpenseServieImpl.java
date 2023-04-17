package com.coway.trust.biz.eAccounting.expense.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.expense.ExpenseService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("expenseService")
public class ExpenseServieImpl extends EgovAbstractServiceImpl implements ExpenseService {

	private static final Logger Logger = LoggerFactory.getLogger(CcpAgreementServieImpl.class);

	@Resource(name = "expenseMapper")
	private ExpenseMapper expenseMapper;

	@Override
	public List<EgovMap> selectExpenseList( Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectExpenseList(params);
	}

	@Override
	public List<EgovMap> selectExpenseListMain (Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectExpenseListMain(params);
	}


	@Override
	public int insertExpenseInfo(List<Object> addList, Integer crtUserId) throws Exception {

		int saveCnt = 0;

		for (Object obj : addList)
		{
			((Map<String, Object>) obj).put("userId", crtUserId);

			Logger.debug(" >>>>> InsertPgmId ");
			Logger.debug(" clmType : {}", ((Map<String, Object>) obj).get("clmType"));
			Logger.debug(" expType : {}", ((Map<String, Object>) obj).get("expType"));
			Logger.debug(" budgetCode : {}", ((Map<String, Object>) obj).get("budgetCode"));
			Logger.debug(" glAccountCode : {}", ((Map<String, Object>) obj).get("glAccountCode"));
			Logger.debug(" cntrlExp : {}", ((Map<String, Object>) obj).get("cntrlExp"));

			saveCnt++;

			String expType = expenseMapper.selectMaxExpType((Map<String, Object>) obj);

			((Map<String, Object>) obj).put("expType", expType);

			expenseMapper.insertExpenseInfo((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@Override
	public List<EgovMap> selectBudgetCodeList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectBudgetCodeList(params);
	}

	@Override
	public List<EgovMap> selectCodeListWO(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectCodeListAll(params);
	}

	public List<EgovMap> selectExpenseCodeList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectExpenseCodeList(params);
	}

	@Override
	public List<EgovMap> selectGlCodeList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectGlCodeList(params);
	}

	@Override
	public int updateExpenseInfo(Map<String, Object> params) throws Exception {

		return expenseMapper.updateExpenseInfo(params);
	}

	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return expenseMapper.selectCodeList(params);
	}

}
