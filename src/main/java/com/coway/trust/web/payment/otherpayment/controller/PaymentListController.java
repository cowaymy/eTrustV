package com.coway.trust.web.payment.otherpayment.controller;

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

import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class PaymentListController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListController.class);
	
	@Resource(name = "paymentListService")
	private PaymentListService paymentListService;	
		
	/******************************************************
	 *  Payment List  
	 *****************************************************/	
	/**
	 *  Payment List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initPaymentList.do")
	public String initPaymentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/paymentList";
	}
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectPaymentList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectPaymentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = paymentListService.selectPaymentList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	
	
}
