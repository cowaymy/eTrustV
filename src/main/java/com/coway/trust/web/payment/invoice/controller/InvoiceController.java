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
	@RequestMapping(value = "/initBillingConfirmedResultPop.do")
	public String initBillingConfirmedResult(@RequestParam Map<String, Object> params, ModelMap model) {
		
		model.addAttribute("taskId", params.get("taskId"));
		
		//return "payment/invoice/billingConfirmedResult";
		return "payment/invoice/billingConfirmedResultPop";
	}
	
	@RequestMapping(value = "/selectInvoiceResultList.do")
	public ResponseEntity<Map<String, Object>> selectInvoiceResultList(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		EgovMap master = invoiceService.selectInvoiceMaster(params).get(0);	
		List<EgovMap> detail = invoiceService.selectInvoiceDetail(params);
		
		for(int i=0; i<detail.size(); i++)
			System.out.println("###detail : " + detail.get(i));
		
		result.put("master", master);
		result.put("detail", detail);

		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/generateInvoice.do")
	public ResponseEntity<Boolean> generateInvoice(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		
		boolean result = false;
		int userId = sessionVO.getUserId();
		
		if(userId > 0){
			params.put("userId", userId);
			invoiceService.createTaxInvoice(params);
			int resVal = Integer.parseInt(String.valueOf(params.get("p1")));
			
			if(resVal == 1)
				result = true;
		}

		return ResponseEntity.ok(result);
	}
	

}
