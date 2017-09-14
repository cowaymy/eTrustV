package com.coway.trust.web.payment.billing.controller;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingMgmtController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingMgmtController.class);
	
	@Resource(name = "billingRantalService")
	private BillingMgmtService billingRantalService;
	
	/**
	 * BillingMgnt 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingMgnt.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billingMgnt";
	}
	
	@RequestMapping(value = "/selectBillingMgntList.do")
	public ResponseEntity<List<EgovMap>> selectBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
	
		String year = String.valueOf(params.get("year"));
		String month = String.valueOf(params.get("month"));

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("year", year);
		map.put("month", month);
		
		if( year != "null" && year != "" && month != "null" && month != "" ){
			list = billingRantalService.selectBillingMgnt(map);
		}
		return ResponseEntity.ok(list);
	}
		
	/**
	 * Billing Result 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingResult.do")
	public String initBillingResult(@RequestParam Map<String, Object> params, ModelMap model) {
		
		model.addAttribute("taskId", params.get("taskId"));
		
		return "payment/billing/billingResult";
	}
	
	@RequestMapping(value = "/selectBillingResultList.do")
	public ResponseEntity<Map<String, Object>> selectBillingResult(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		LOGGER.debug("params_#### : {}", params);
	
		String orderNo = String.valueOf(params.get("orderNo"));
		String billNo = String.valueOf(params.get("billNo"));
		String custName = String.valueOf(params.get("custName"));
		String group = String.valueOf(params.get("group"));
		String taskId = String.valueOf(params.get("taskId"));

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orderNo", orderNo);
		map.put("billNo", billNo);
		map.put("custName", custName);
		map.put("group", group);
		map.put("taskId", taskId);
		
		EgovMap master = billingRantalService.selectBillingMaster(map);
		System.out.println("master : " + master);
		List<EgovMap> detail = billingRantalService.selectBillingDetail(map);
		System.out.println("detail.size : " + detail.size());                                                     
		
		if(detail.size() > 0){
		result.put("master", master);
		result.put("detail", detail);
		}
		
		return ResponseEntity.ok(result);
	}
	
	/**
	 * MonthlyRawDatat초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initMonthlyRawData.do")
	public String initBillingRawData(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/monthlyBillRawData";
	}
	
	@RequestMapping(value = "/createBills.do")
	public ResponseEntity<ReturnMessage> createBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		
		LOGGER.debug("params_#### : {}", params);
		
		String message = "";
		
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int year = Integer.parseInt(String.valueOf(params.get("year")));
		int month = Integer.parseInt(String.valueOf(params.get("month")));
		int userId = sessionVO.getUserId();
		
		Calendar curDate = Calendar.getInstance();
		int curYear = curDate.get(curDate.YEAR);
		int curMonth = curDate.get(curDate.MONTH) + 1;
		
		map.put("year", year);
		map.put("month", month);
		map.put("userId", userId);
		
		
		//System.out.println("today : " + curDate + ", curYear : " + curYear + ", curMonth : " + curMonth);
		int result = 0;
		if(curYear < year){
			billingRantalService.callEaryBillProcedure(map);
			result = Integer.parseInt(String.valueOf(map.get("p1")));
		}else if(curYear == year){
			if(curMonth < month){
				billingRantalService.callEaryBillProcedure(map);
				result = Integer.parseInt(String.valueOf(map.get("p1")));
			}else{
				billingRantalService.callBillProcedure(map);
				result = Integer.parseInt(String.valueOf(map.get("p1")));
			}
		}
		
		System.out.println("result : " + result);
		if(result < 1){
			message="Stopped With Errors.";
		}else{
			message = "Billing Task Completed Successfully.";
		}
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}
}
