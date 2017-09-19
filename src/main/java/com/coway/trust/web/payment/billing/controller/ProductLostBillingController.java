package com.coway.trust.web.payment.billing.controller;

import java.text.SimpleDateFormat;
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
import com.coway.trust.biz.payment.billing.service.EarlyTerminationBillingService;
import com.coway.trust.biz.payment.billing.service.ProductLostBillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/payment")
public class ProductLostBillingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProductLostBillingController.class);
	
	@Resource(name = "productLostService")
	private ProductLostBillingService productLostService;
	
	/**
	 * BillingMgnt 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initProductLost.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billProductLost";
	}
	
	@RequestMapping(value = "/selectRentalProductLostPenalty.do")
	public ResponseEntity<EgovMap> checkExistOrderCancellationList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		EgovMap result;
		
		LOGGER.debug("params : {}", params);
		
		result = productLostService.selectRentalProductLostPenalty(String.valueOf(params.get("orderId"))).get(0);
		System.out.println("#####result : " + result);
	
		return ResponseEntity.ok(result);
	}
	
}
