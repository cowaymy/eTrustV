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

import com.coway.trust.biz.payment.billinggroup.service.BillingInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceAdjController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceAdjController.class);
	
	@Resource(name = "invoiceAdjService")
	private InvoiceAdjService invoiceService;
	
	/******************************************************
	 *   Company Statement
	 *****************************************************/	
	/**
	 * AdjustmentCNDN초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdjCnDn.do")
	public String initCompanyInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/adjCnDn";
	}
	
	@RequestMapping(value = "/selectAdjustmentList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
		
		list = invoiceService.selectInvoiceAdj(params);
		
		return ResponseEntity.ok(list);
	}
}
