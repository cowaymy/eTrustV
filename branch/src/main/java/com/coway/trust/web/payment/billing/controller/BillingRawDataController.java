package com.coway.trust.web.payment.billing.controller;

import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/payment")
public class BillingRawDataController {

	/**
	 * Billing Raw Data  초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingRawData.do")
	public String initBillingRawData(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billingRawData";
	}
}
