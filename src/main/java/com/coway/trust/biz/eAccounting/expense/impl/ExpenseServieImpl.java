package com.coway.trust.biz.eAccounting.expense.impl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.expense.ExpenseService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("expenseService")
public class ExpenseServieImpl extends EgovAbstractServiceImpl implements ExpenseService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "expenseMapper")
	private ExpenseMapper expenseMapper;
	
	
	
}
