package com.coway.trust.web.payment.cardpayment.controller;

import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;

@Controller
@RequestMapping(value = "/payment")
public class CrcReconBankStateController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CrcReconBankStateController.class);
	
	//@Resource(name = "cardStatementService")
	//private CardStatementService cardStatementService;	
		
	/******************************************************
	 *  Card Key-IN Payment 
	 *****************************************************/	
	/**
	 *  Credit Card Key-IN Payment 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCrcReconBankState.do")
	public String initCardKeyInPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/cardpayment/crcReconBankState";
	}
	
	
	
	
}
