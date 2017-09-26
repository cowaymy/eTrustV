package com.coway.trust.web.eAccounting.expense;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/eAccounting/expense") 
public class ExpenseController {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpenseController.class);
	
	/*@Resource(name = "expenseService")
	private CcpAgreementService ccpAgreementService;*/
	
	@RequestMapping(value = "/selectExpenseList.do")
	public String selectExpenseList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		
		
		return "eAccounting/expense/expenseManagement";
	}

}

