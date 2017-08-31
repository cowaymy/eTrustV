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
		
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String status = String.valueOf(params.get("status"));
		String invoiceNo = String.valueOf(params.get("invoiceNo")).trim();
		String adjNo = String.valueOf(params.get("adjNo")).trim();
		String reportNo = String.valueOf(params.get("reportNo")).trim();
		String creator = String.valueOf(params.get("creator"));
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orderNo", orderNo);
		map.put("status", status);
		map.put("invoiceNo", invoiceNo);
		map.put("adjNo", adjNo);
		map.put("reportNo", reportNo);
		map.put("creator", creator);
		
		list = invoiceService.selectInvoiceAdj(map);
		
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

		model.addAttribute("refNo", params.get("refNo"));
		
		return "payment/invoice/newAdj";
	}
	
	@RequestMapping(value = "/selectNewAdjList.do")
	public ResponseEntity<HashMap<String,Object>> selectNewAdjList(@RequestParam Map<String, Object> params, ModelMap model) {	
		HashMap <String, Object> returnValue = new HashMap();
		List<EgovMap> detail = null;

		LOGGER.debug("refNo : {}", params.get("refNo"));
		
		String refNo = String.valueOf(params.get("refNo")).trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("refNo", refNo);
		
		EgovMap master = invoiceService.selectNewAdjMaster(map).get(0);
		detail = invoiceService.selectNewAdjDetailList(map);
		
		for(int i=0; i<detail.size(); i++)
			LOGGER.debug("detail : {}", detail.get(i));
		
		returnValue.put("master", master);
		returnValue.put("detail", detail);
		
		return ResponseEntity.ok(returnValue);
	}
	
}
