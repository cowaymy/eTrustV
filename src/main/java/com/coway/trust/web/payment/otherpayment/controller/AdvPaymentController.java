package com.coway.trust.web.payment.otherpayment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentService;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AdvPaymentController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentController.class);
	
	@Resource(name = "advPaymentService")
	private AdvPaymentService advPaymentService;	
		
	/******************************************************
	 *  
	 *****************************************************/	
	/**
	 *  
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdvPayment.do")
	public String initUploadBankStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/advPayment";
	}
	
}
