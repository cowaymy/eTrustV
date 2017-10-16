package com.coway.trust.web.eAccounting.budget;

import java.util.HashMap;
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
	
	@RequestMapping(value = "/availableBudgetDisplayPop.do")
	public String availableBudgetDisplay (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);
						
		params.put("budgetPlanYear",  params.get("item[budgetPlanYear]"));
		params.put("budgetPlanMonth",  params.get("month"));
		
		if(params.get("month").toString().length() == 1){

			params.put("month", "0"+ params.get("month"));
		}
		
		params.put("costCentr",  params.get("item[costCentr]"));
		
		if( !CommonUtils.isEmpty(params.get("item[costCenterText]")) ){
			params.put("costCenterText", params.get("item[costCenterText]"));
		}
		
		params.put("glAccCode",  params.get("item[glAccCode]"));
		
		if( !CommonUtils.isEmpty(params.get("item[glAccDesc]")) ){
			params.put("glAccDesc", params.get("item[glAccDesc]"));
		}
		
		params.put("budgetCode",  params.get("item[budgetCode]"));
		
		if( !CommonUtils.isEmpty(params.get("item[budgetCodeText]")) ){
			params.put("glAccDesc", params.get("item[budgetCodeText]"));
		}
		
		LOGGER.debug("item =====================================>>  " + params);
		
		Map result = budgetService.selectAvailableBudgetAmt(params);
		
		 
		model.addAttribute("result", result);
		model.addAttribute("item", params);
		return "eAccounting/budget/availableBudgetDisplayPop";
	}
		

	@RequestMapping(value = "/adjustmentAmountPop.do")
	public String adjustmentAmountPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("item", params);
		return "eAccounting/budget/adjustmentAmountPop";
	}
	
	@RequestMapping(value = "/selectAdjustmentAmountList")
	public ResponseEntity<List<EgovMap>>  selectAdjustmentAmountList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> adjustmentList = null; 
		
		adjustmentList= budgetService.selectAdjustmentAmount(params);
		
		return ResponseEntity.ok(adjustmentList);
	}
		
	@RequestMapping(value = "/pendingConsumedAmountPop.do")
	public String pendingConsumedAmountPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);		
		model.addAttribute("item", params);
		return "eAccounting/budget/pendingConsumedAmountPop";
	}
	
	@RequestMapping(value = "/selectPenConAmountList")
	public ResponseEntity<List<EgovMap>>  selectPenConAmountList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> adjustmentList = null; 
		
		adjustmentList= budgetService.selectPenConAmount(params);
		
		return ResponseEntity.ok(adjustmentList);
	}
	
	@RequestMapping(value = "/budgetAdjustmentList.do")
	public String budgetAdjustmentList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		String yearMonth =  CommonUtils.getNowDate().substring(4,6) +"/" +CommonUtils.getNowDate().substring(0,4);
		
		model.addAttribute("yearMonth",  yearMonth );	 
		return "eAccounting/budget/budgetAdjustmentList";
	}
	
	@RequestMapping(value = "/selectAdjustmentList")
	public ResponseEntity<List<EgovMap>>  selectAdjustmentList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);

		String[] budgetAdjType = request.getParameterValues("budgetAdjType");

		params.put("budgetAdjType", budgetAdjType);
		
		List<EgovMap> adjustmentList = null; 
		
		adjustmentList= budgetService.selectAdjustmentList(params);
		
		return ResponseEntity.ok(adjustmentList);
	}
		
	@RequestMapping(value = "/budgetAdjustmentPop.do")
	public String budgetAdjustment (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "eAccounting/budget/budgetAdjustmentPop";
	}
}

