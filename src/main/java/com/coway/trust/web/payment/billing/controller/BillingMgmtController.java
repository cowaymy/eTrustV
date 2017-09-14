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
	
	@Resource(name = "billingRentalService")
	private BillingMgmtService billingRentalService;
	
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
		
		if( !("".equals(String.valueOf(params.get("year")))) && !("".equals(String.valueOf(params.get("month")))) ){
			list = billingRentalService.selectBillingMgnt(params);
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
		
		EgovMap master = billingRentalService.selectBillingMaster(params);
		System.out.println("master : " + master);
		List<EgovMap> detail = billingRentalService.selectBillingDetail(params);
		System.out.println("detail.size : " + detail.size());                                                     
		
		result.put("master", master);
		result.put("detail", detail);

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
			billingRentalService.callEaryBillProcedure(map);
			result = Integer.parseInt(String.valueOf(map.get("p1")));
		}else if(curYear == year){
			if(curMonth < month){
				billingRentalService.callEaryBillProcedure(map);
				result = Integer.parseInt(String.valueOf(map.get("p1")));
			}else{
				billingRentalService.callBillProcedure(map);
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
	
	@RequestMapping(value = "/getExistBill.do")
	public ResponseEntity<Integer> getExistBill(@RequestParam Map<String, Object> params, ModelMap model) {	
		int value= 0;
		
		LOGGER.debug("params : {}", params);
		
		value = billingRentalService.getExistBill(params);
		
		return ResponseEntity.ok(value);
	}
	
	@RequestMapping(value = "/confirmAlltBill.do")
	public ResponseEntity<Integer> confirmAllBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		int value= -1;
		
		params.put("userId", sessionVO.getUserId());
		LOGGER.debug("params : {}", params);
		
		if(String.valueOf(params.get("type")).equals("EARLY BILL")){
			billingRentalService.confirmEarlyBills(params);
			value=Integer.parseInt(String.valueOf(params.get("p1")));
		}else{
			billingRentalService.confirmBills(params);
			value=Integer.parseInt(String.valueOf(params.get("p1")));
		}
		
		System.out.println("######value : " + value);
		
		return ResponseEntity.ok(value);
	}
}
