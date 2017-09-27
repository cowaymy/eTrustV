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
import com.coway.trust.biz.payment.invoice.service.BillingVoidService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingVoidController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingVoidController.class);
	
	@Resource(name = "billingVoidService")
	private BillingVoidService billingVoidService;
	

	/**
	 * billInvoiceStatementVoid초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingVoid.do")
	public String initInvoiceAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/billInvoiceStatementVoid";
	}
	
	/**
	 * selectInvoiceInfo 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectInvoiceInfo.do")
	public ResponseEntity<ReturnMessage> selectInvoiceInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		ReturnMessage message = new ReturnMessage();
		EgovMap invoiceInfo = billingVoidService.selectStatementView(params);
		List<EgovMap> invoiceDetailList = null; 
		
		if(invoiceInfo != null){
			invoiceDetailList = billingVoidService.selectInvoiceDetailList(params);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("invoiceInfo", invoiceInfo);
		resultMap.put("invoiceDetailList", invoiceDetailList);
		
		message.setData(resultMap);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveInvoiceVoidResult
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveInvoiceVoidResult.do")
	public ResponseEntity<ReturnMessage> saveInvoiceVoidResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);
		billingVoidService.saveInvoiceVoidResult(params);
		
		return ResponseEntity.ok(message);
	}
	
}

	

