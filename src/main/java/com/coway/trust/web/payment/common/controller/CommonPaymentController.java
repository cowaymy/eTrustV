package com.coway.trust.web.payment.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpRequest;
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
import com.coway.trust.biz.payment.billinggroup.service.BillingTaxInvoiceService;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.CommonPopupPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/common")
public class CommonPaymentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPaymentController.class);

	@Resource(name = "commonPaymentService")
	private CommonPaymentService commonPaymentService;
	
	
	/**
	 * Payment - Order Info 조회 : order No로 Order ID 조회하기 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */	
	@RequestMapping(value = "/selectOrdIdByNo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectOrdIdByNo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}

	
	/******************************************************
	 * Payment - Order Info Rental
	 *****************************************************/	
	/**
	 * Payment - Order Info Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetRentalOrders(int orderId, bool getBillingGroup)
	 */	
	@RequestMapping(value = "/selectOrderInfoRental.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderInfoRental(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPaymentService.selectOrderInfoRental(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Payment - Bill Info Rental
	 *****************************************************/	
	/**
	 * Payment - Bill Info Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */	
	@RequestMapping(value = "/selectBillInfoRental.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBillInfoRental(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPaymentService.selectBillInfoRental(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Payment - Order Info Non - Rental
	 *****************************************************/	
	/**
	 * Payment - Order Info Non - Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetOutInstOrders(int orderId)
	 */	
	@RequestMapping(value = "/selectOrderInfoNonRental.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderInfoNonRental(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPaymentService.selectOrderInfoNonRental(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Payment - Order Info Membership Service
	 *****************************************************/	
	/**
	 * Payment - Order Info Membership Service  조회 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */	
	@RequestMapping(value = "/selectOrderInfoSVM.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderInfoSVM(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		commonPaymentService.selectOrderInfoSVM(params);
    	List<EgovMap> resultMapList = (List<EgovMap>)params.get("resultMemSvm");         	//결과 뿌려보기 : 프로시저에서 resultMemSvm 이란 key값으로 객체를 반환한다.
    	
    	System.out.println("#################### 결과값 : " + resultMapList.size());
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMapList);
	}
	
	
	/******************************************************
	 * Payment - Order Info Rental Membership 
	 *****************************************************/	
	/**
	 * Payment - Order Info Rental Membership 조회 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */	
	@RequestMapping(value = "/selectOrderInfoSrvc.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderInfoSrvc(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPaymentService.selectOrderInfoSrvc(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
}