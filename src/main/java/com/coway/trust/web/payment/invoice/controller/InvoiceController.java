package com.coway.trust.web.payment.invoice.controller;
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

import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceController.class);
	
	@Resource(name = "invoiceService")
	private InvoiceService invoiceService;
	
	/**
	 * BillingMgnt 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initInvoiceStatementManagement.do")
	public String initInvoiceStatementManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/statementManagement";
	}
	
	@RequestMapping(value = "/selectInvoiceStmtMgmtList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceStmtMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
		
		if( params.get("year") != null && !("".equals(String.valueOf(params.get("year")))) && params.get("month") != null && !("".equals(String.valueOf(params.get("month")))) ){
			list = invoiceService.selectInvoiceList(params);
		}
		return ResponseEntity.ok(list);
	}
		
	/**
	 * Billing Result 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingConfirmedResult.do")
	public String initBillingConfirmedResult(@RequestParam Map<String, Object> params, ModelMap model) {
		
		model.addAttribute("taskId", params.get("taskId"));
		
		return "payment/invoice/billingConfirmedResult";
	}
	
	@RequestMapping(value = "/selectInvoiceResultList.do")
	public ResponseEntity<Map<String, Object>> selectInvoiceResultList(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		EgovMap master = invoiceService.selectInvoiceMaster(params).get(0);	
		List<EgovMap> detail = invoiceService.selectInvoiceDetail(params);
		
		result.put("master", master);
		result.put("detail", detail);

		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/generateInvoice.do")
	public ResponseEntity<Boolean> generateInvoice(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		
		boolean result = false;
		int userId = sessionVO.getUserId();
		
//		if(userId > 0){
//			params.put("userId", userId);
//			invoiceService.createTaxInvoice(params);
//			int resVal = Integer.parseInt(String.valueOf(params.get("p1")));
//			
//			if(resVal == 1)
//				result = true;
//		}

		return ResponseEntity.ok(result);
	}
	
//	
//	@RequestMapping(value = "/createBills.do")
//	public ResponseEntity<ReturnMessage> createBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
//		c		
//		//System.out.println("today : " + curDate + ", curYear : " + curYear + ", curMonth : " + curMonth);
//		int result = 0;
//		if(curYear < year){
//			billingRentalService.callEaryBillProcedure(map);
//			result = Integer.parseInt(String.valueOf(map.get("p1")));
//		}else if(curYear == year){
//			if(curMonth < month){
//				billingRentalService.callEaryBillProcedure(map);
//				result = Integer.parseInt(String.valueOf(map.get("p1")));
//			}else{
//				billingRentalService.callBillProcedure(map);
//				result = Integer.parseInt(String.valueOf(map.get("p1")));
//			}
//		}
//		
//		System.out.println("result : " + result);
//		if(result < 1){
//			message="Stopped With Errors.";
//		}else{
//			message = "Billing Task Completed Successfully.";
//		}
//		msg.setMessage(message);
//		return ResponseEntity.ok(msg);
//	}
//	
//	@RequestMapping(value = "/getExistBill.do")
//	public ResponseEntity<Integer> getExistBill(@RequestParam Map<String, Object> params, ModelMap model) {	
//		int value= 0;
//		
//		LOGGER.debug("params : {}", params);
//		
//		value = billingRentalService.getExistBill(params);
//		
//		return ResponseEntity.ok(value);
//	}
//	
//	@RequestMapping(value = "/confirmAlltBill.do")
//	public ResponseEntity<Integer> confirmAllBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
//		int value= -1;
//		
//		params.put("userId", sessionVO.getUserId());
//		LOGGER.debug("params : {}", params);
//		
//		if(String.valueOf(params.get("type")).equals("EARLY BILL")){
//			billingRentalService.confirmEarlyBills(params);
//			value=Integer.parseInt(String.valueOf(params.get("p1")));
//		}else{
//			billingRentalService.confirmBills(params);
//			value=Integer.parseInt(String.valueOf(params.get("p1")));
//		}
//		
//		System.out.println("######value : " + value);
//		
//		return ResponseEntity.ok(value);
//	}
}
