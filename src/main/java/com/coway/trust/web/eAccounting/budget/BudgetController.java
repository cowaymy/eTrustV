package com.coway.trust.web.eAccounting.budget;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.eAccounting.expense.ExpenseController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/budget") 
public class BudgetController {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpenseController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "budgetService")
	private BudgetService budgetService;
	
	@RequestMapping(value = "/monthlyBudgetList.do")
	public String selectExpenseList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		String year = CommonUtils.getNowDate().substring(0,4);
		
		model.addAttribute("year", year);
		return "eAccounting/budget/monthlyBudgetList";
	}
	
	@RequestMapping(value = "/selectMonthlyBudgetList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectExpenseList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{	
		
		List<EgovMap> budgetList = null; 

		
		LOGGER.debug("groupCd =====================================>>  " + params);
		
		budgetList = budgetService.selectMonthlyBudgetList(params);
		
		return ResponseEntity.ok(budgetList);
		
	}	
	
	
		
/*	@RequestMapping(value = "/insertExpenseInfo", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> insertExpenseInfo (@RequestBody Map<String, ArrayList<Object>> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		int tmpCnt = 0;
		int totCnt = 0;
		
		if (addList.size() > 0) {
			tmpCnt = expenseService.insertExpenseInfo(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(totCnt);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
		
	}	
	
	
	@RequestMapping(value = "/updateExpenseInfo", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> updateExpenseInfo (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put("userId", sessionVO.getUserId());
		params.put("clmType", params.get("pClmType"));
		params.put("expType", params.get("pExpType"));
		
		int totCnt = expenseService.updateExpenseInfo(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(totCnt);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
		
	}		*/
}

