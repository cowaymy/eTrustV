package com.coway.trust.web.payment.invoice.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
	 *   AdjustmentCNDN
	 *****************************************************/	
	/**
	 * AdjustmentCNDN초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdjCnDn.do")
	public String initInvoiceAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/adjCnDn";
	}
	
	@RequestMapping(value = "/selectAdjustmentList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
		
		list = invoiceService.selectInvoiceAdj(params);
		
		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Company Statement
	 *****************************************************/	
	/**
	 * AdjustmentCNDN초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initNewAdj.do")
	public String initInvoiceNewAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} " , params);
		
		model.addAttribute("master", invoiceService.selectNewAdjMaster(params).get(0));
		LOGGER.debug("master : {} " , invoiceService.selectNewAdjMaster(params).get(0));

		model.addAttribute("refNo", params.get("refNo"));
		//		List<EgovMap> list = invoiceService.selectNewAdjDetailList(params);
//		for(int i=0; i<list.size(); i++)
//		LOGGER.debug("detail : {}", list.get(i));
//		model.addAttribute("detail", list);
//		
//		JSONArray arr = new JSONArray();
//		for(int i=0; i<list.size(); i++){
//			JSONObject obj = new JSONObject();
//			
//			obj.put("billitemtype", list.get(i).get("billitemtype"));
//			obj.put("memoItmTxs", "tmp");
//			arr.add(obj);
//		}
//		
//		model.addAttribute("sub", arr);
//		LOGGER.debug("arr : {}", arr);
		
		return "payment/invoice/newAdj";
	}
	
	@RequestMapping(value = "/selectNewAdjList.do")
	public ResponseEntity<HashMap<String,Object>> selectNewAdjList(@RequestParam Map<String, Object> params, ModelMap model) {	
		HashMap <String, Object> returnValue = new HashMap();
		List<EgovMap> detail = null;

		LOGGER.debug("refNo : {}", params.get("refNo"));
		
		EgovMap master = invoiceService.selectNewAdjMaster(params).get(0);
		detail = invoiceService.selectNewAdjDetailList(params);
		
		for(int i=0; i<detail.size(); i++)
			LOGGER.debug("detail : {}", detail.get(i));
		
		returnValue.put("master", master);
		returnValue.put("detail", detail);
		
		return ResponseEntity.ok(returnValue);
	}
	
}
