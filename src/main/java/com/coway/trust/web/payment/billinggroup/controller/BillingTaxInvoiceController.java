package com.coway.trust.web.payment.billinggroup.controller;

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
import com.coway.trust.biz.payment.billinggroup.service.BillingTaxInvoiceService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingTaxInvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingTaxInvoiceController.class);

	@Resource(name = "billingTaxInvoiceService")
	private BillingTaxInvoiceService billingTaxInvoiceService;

	
	/******************************************************
	 * Tax Invoice - Rental   
	 *****************************************************/	
	/**
	 * Tax Invoice - Rental 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initTaxInvoiceRentalPop.do")
	public String initTaxInvoiceRental(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/taxInvoiceRentalPop";
	}
	
	/**
	 * Tax Invoice - Rental 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectTaxInvoiceRentalList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTaxInvoiceRentalList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
		
		if(params.get("invoicePeriod") != null && !"".equals(String.valueOf(params.get("invoicePeriod")))){
			params.put("month",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(0, 2)));
			params.put("year",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(3, 7)));
		}
        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectTaxInvoiceRentalList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Tax Invoice - Outright   
	 *****************************************************/	
	/**
	 * Tax Invoice - Outright 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initTaxInvoiceOutrightPop.do")
	public String initTaxInvoiceOutright(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/taxInvoiceOutrightPop";
	}
	
	/**
	 * Tax Invoice - Outright 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectTaxInvoiceOutrightList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTaxInvoiceOutrightList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {		

        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectTaxInvoiceOutrightList(params);		
		//List<EgovMap> resultList = new ArrayList<EgovMap>();
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Tax Invoice - Membership   
	 *****************************************************/	
	/**
	 * Tax Invoice - Membership 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initTaxInvoiceMembershipPop.do")
	public String initTaxInvoiceMembership(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		model.addAttribute("isHc", params.get("isHc"));
		return "payment/billinggroup/taxInvoiceMembershipPop";
	}
	
	/**
	 * Tax Invoice - Membership 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectTaxInvoiceMembershipList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTaxInvoiceMembershipList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {		

        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectTaxInvoiceMembershipList(params);		
		//List<EgovMap> resultList = new ArrayList<EgovMap>();
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Tax Invoice - Rental Membership   
	 *****************************************************/	
	/**
	 * Tax Invoice - Rental Membership 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initTaxInvoiceRenMembershipPop.do")
	public String initTaxInvoiceRenMembership(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/taxInvoiceRenMembershipPop";
	}
	
	/**
	 * Tax Invoice - Rental Membership 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectTaxInvoiceRenMembershipList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTaxInvoiceRenMembershipList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {	
		
		if(params.get("invoicePeriod") != null && !"".equals(String.valueOf(params.get("invoicePeriod")))){
			params.put("month",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(0, 2)));
			params.put("year",Integer.parseInt((String.valueOf(params.get("invoicePeriod"))).substring(3, 7)));
		}
        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectTaxInvoiceRenMembershipList(params);		
		//List<EgovMap> resultList = new ArrayList<EgovMap>();
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Tax Invoice - Miscellaneous 
	 *****************************************************/	
	/**
	 * Tax Invoice - Miscellaneous 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initTaxInvoiceMiscellaneousPop.do")
	public String initTaxInvoiceMiscellaneous(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/taxInvoiceMiscellaneousPop";
	}
	
	/**
	 * Tax Invoice - Miscellaneous 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectTaxInvoiceMiscellaneousList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTaxInvoiceMiscellaneousList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {	
		
        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectTaxInvoiceMiscellaneousList(params);		
		//List<EgovMap> resultList = new ArrayList<EgovMap>();
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Statement Company Rental  
	 *****************************************************/	
	/**
	 * Statement Company Rental 초기화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initStatementCompanyRentalPop.do")
	public String initStatementCompanyRental(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/statementCompanyRentalPop";
	}
	
	/**
	 * Statement Company Rental 그리드 조회 
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectStatementCompanyRental.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectStatementCompanyRental(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {	
		
		if(params.get("statementPeriod") != null && !"".equals(String.valueOf(params.get("statementPeriod")))){
			params.put("month",Integer.parseInt((String.valueOf(params.get("statementPeriod"))).substring(0, 2)));
			params.put("year",Integer.parseInt((String.valueOf(params.get("statementPeriod"))).substring(3, 7)));
		}
        // 조회.
        List<EgovMap> resultList = billingTaxInvoiceService.selectStatementCompanyRental(params);		
		//List<EgovMap> resultList = new ArrayList<EgovMap>();
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	

}
