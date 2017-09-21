package com.coway.trust.web.payment.billing.controller;

import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequestMapping(value = "/payment")
public class SrvMembershipBillingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SrvMembershipBillingController.class);
	
	/**
	 * Manual Billing - Membership 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSrvMembershipBilling.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/srvMembershipBilling";
	}
	
			
	
}
