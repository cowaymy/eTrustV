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
import com.coway.trust.biz.payment.common.service.CommonPopupPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;




@Controller
@RequestMapping(value = "/payment/common")
public class CommonPopupPaymentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPopupPaymentController.class);

	@Resource(name = "commonPopupPaymentService")
	private CommonPopupPaymentService commonPopupPaymentService;

	
	/******************************************************
	 * Payment - Invoice Search Pop-up
	 *****************************************************/	
	/**
	 * Payment - Invoice Search Pop-up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCommonSearchInvoicePop.do")
	public String initCommonSearchInvoicePop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/common/searchInvoicePop";
	}
	
	/******************************************************
	 * Payment - Rental Membership Search
	 *****************************************************/	
	/**
	 * Payment - Rental Membership Search Pop-up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCommonServiceContractSearchPop.do")
	public String initCommonServiceContractSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		return "payment/common/serviceContractSearchPop";
	}
	
	/******************************************************
	 * Payment - Bank Account Reconciliation Report
	 *****************************************************/	
	/**
	 * Payment - Bank Account Reconciliation Report Pop-up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCommonBankAccRclReportPop.do")
	public String initCommonBankAccRclReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		return "payment/common/bankAccRclReportPop";
	}
	
	/******************************************************
	 * Payment - Reconciliation Statistic Report
	 *****************************************************/	
	/**
	 * Payment - Reconciliation Statistic Report Pop-up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCommonRclStatisticReportPop.do")
	public String initCommonRclStatisticReport(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		return "payment/common/rclStatisticReportPop";
	}
	
	/**
	 * Payment - Invoice Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCommonSearchInvoicePop.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectCommonSearchInvoicePop(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
			, @RequestBody Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : {} ", params);	
		
		if(params.get("invoicePeriod") != null && !"".equals(String.valueOf(params.get("invoicePeriod")))){
			params.put("month",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(0, 2)));
			params.put("year",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(3, 7)));
		}
		
		// 조회.
		List<EgovMap> resultList = commonPopupPaymentService.selectCommonSearchInvoicePop(params);		
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Payment - Rental Membership Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCommonContractSearchPop.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommonContractSearchPop(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
			, @RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		String[] contractStatusType = request.getParameterValues("contractStatusType");
		params.put("contractStatusType", contractStatusType);
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPopupPaymentService.selectCommonContractSearchPop(params);
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Payment - Outright Membership Search
	 *****************************************************/	
	/**
	 * Payment - Outright Membership Search Pop-up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCommonQuotationSearchPop.do")
	public String initCommonQuotationSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("callPrgm", params.get("callPrgm"));
		return "payment/common/quotationSearchPop";
	}
	
	/**
	 * Payment - Outright Membership Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCommonQuotationSearchPop.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCommonQuotationSearchPop(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
			, @RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPopupPaymentService.selectCommonQuotationSearchPop(params);
		int totalRowCount = commonPopupPaymentService.countCommonQuotationSearchPop(params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("resultList", resultList);
		result.put("totalRowCount", totalRowCount);

		return ResponseEntity.ok(result);
		
		
	}
	
	
	/**
	 * Payment - Outright Membership Search Pop-up 페이지 이동
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCommonQuotationSearchPagingPop.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCommonQuotationSearchPagingPop(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
			, @RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = commonPopupPaymentService.selectCommonQuotationSearchPop(params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("resultList", resultList);

		return ResponseEntity.ok(result);
	}
	
	
	/******************************************************
	 * Payment - Fund Transfer New Order Search Pop-up
	 *****************************************************/	
	/**
	 * Payment - Fund Transfer New Order Search Pop-Up 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initNewOrderSearchPop.do")
	public String initNewOrderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("appTypeId", params.get("appTypeId"));
		return "payment/common/newOrderSearchPop";
	}
}