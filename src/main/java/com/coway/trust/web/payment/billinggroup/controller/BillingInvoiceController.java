package com.coway.trust.web.payment.billinggroup.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.payment.billinggroup.service.BillingInvoiceService;
import com.coway.trust.biz.payment.billinggroup.service.impl.ProformaSearchVO;
import com.coway.trust.biz.payment.billinggroup.service.impl.SearchVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingInvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingInvoiceController.class);
	
	@Resource(name = "billingInvoiceService")
	private BillingInvoiceService invoiceService;
	
	/******************************************************
	 *   Company Statement
	 *****************************************************/	
	/**
	 * Company Statement초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCompanyInvoice.do")
	public String initCompanyInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billinggroup/companyInvoice";
	}
	
	@RequestMapping(value = "/selectInvoiceList")
	public ResponseEntity<List<EgovMap>> searchReconciliationList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
	
		String brNumber = String.valueOf(params.get("brNumber")).trim();
		String period = String.valueOf(params.get("period")).trim();
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String customerName = String.valueOf(params.get("customerName")).trim();
		String custNRIC = String.valueOf(params.get("customerNRIC")).trim();
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("billNo", brNumber);
		map.put("orderNo", orderNo);
		map.put("custName", customerName);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		map.put("custNRIC", custNRIC);
		
		list = invoiceService.selectCompanyInvoice(map);
		
		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Individual Statement
	 *****************************************************/	
	/**
	 * Individual Statement초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	
	@RequestMapping(value = "/initIndividualRentalStatement.do")
	public String initIndividualRentalStatement(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/individualRentalStatement";
	}
	
	@RequestMapping(value = "/selectRentalList")
	public ResponseEntity<List<EgovMap>> searchRentalList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		String brNumber = String.valueOf(params.get("brNumber")).trim();
		String period = String.valueOf(params.get("period")).trim();
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String customerName = String.valueOf(params.get("customerName")).trim();
		String custNRIC = String.valueOf(params.get("customerNRIC")).trim();
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("billNo", brNumber);
		map.put("orderNo", orderNo);
		map.put("custName", customerName);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		map.put("custNRIC", custNRIC);
		
		list = invoiceService.selectRentalStatementList(map);
		
		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Membership Invoice
	 *****************************************************/	
	/**
	 * Membership Invoice초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	
	@RequestMapping(value = "/initMembershipInvoice.do")
	public String initMembershipInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/membershipInvoice";
	}
	
	@RequestMapping(value = "/selectMembershipList")
	public ResponseEntity<List<EgovMap>> searchMembershipList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		String invoiceNo = String.valueOf(params.get("invoiceNo")).trim();
		String period = String.valueOf(params.get("period")).trim();
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String custName = String.valueOf(params.get("custName")).trim();
		String custNRIC = String.valueOf(params.get("custNRIC")).trim();
		String quotationNo = String.valueOf(params.get("quotationNo")).trim();
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("invoiceNo", invoiceNo);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		map.put("orderNo", orderNo);
		map.put("custName", custName);
		map.put("custNRIC", custNRIC);
		map.put("quotationNo", quotationNo);
		
		list = invoiceService.selectMembershipInvoiceList(map);
		
		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Outright Invoice
	 *****************************************************/	
	/**
	 * Outright Invoice초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	
	@RequestMapping(value = "/initOutrightInvoice.do")
	public String initOutrightInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/outrightInvoice";
	}
	
	@RequestMapping(value = "/selectOutrightInvoiceList")
	public ResponseEntity<List<EgovMap>> searchOutrightInvoiceList(@ModelAttribute("searchForm")SearchVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orcCode","");
		map.put("grpCode", "");
		map.put("deptCode", "");
		map.put("memberId", 0);
		map.put("memberLvl", 0);
		map.put("memberTypeId",0);
		map.put("orderNo", searchVO.getOrderNo());
		map.put("custName", searchVO.getCustName());
		map.put("appType", searchVO.getAppType());
		
		list = invoiceService.selectOutrightInvoiceList(map);
		
		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Proforma Invoice
	 *****************************************************/	
	/**
	 * Proforma Invoice초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	
	@RequestMapping(value = "/initProformaInvoice.do")
	public String initProformaInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/proformaInvoice";
	}
	
	@RequestMapping(value = "/selectProformaInvoiceList")
	public ResponseEntity<List<EgovMap>> searchOutrightInvoiceList(@ModelAttribute("searchForm")ProformaSearchVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("orderNo", searchVO.getOrderNo().trim());
		map.put("appTypeList", searchVO.getAppType());
		map.put("orderStatusList", searchVO.getOrderStatus());
		map.put("keyInBranchList", searchVO.getKeyBranch());
		map.put("dscBranchList", searchVO.getDscBranch());
		map.put("custId", searchVO.getCustId().trim());
		map.put("custName", searchVO.getCustName().trim());
		map.put("custIC", searchVO.getCustIc().trim());
		map.put("productId", searchVO.getProduct());
		map.put("memberCode", searchVO.getMemberCode().trim());
		map.put("rentStatus", searchVO.getRentalStatus());
		map.put("refNo", searchVO.getRefNo().trim());
		map.put("poNo", searchVO.getPoNo().trim());
		map.put("contactNo", searchVO.getContactNo());
		
		String orderDtFr = "";
		String orderDtTo = "";
		if(searchVO.getOrderDt1() != null && !searchVO.getOrderDt1().equals("")){
			String tempOrderDtFr[] = searchVO.getOrderDt1().split("/");
			orderDtFr = tempOrderDtFr[2] + "-" + tempOrderDtFr[1] + "-" + tempOrderDtFr[0] + " 00:00:00";
		}
		if(searchVO.getOrderDt2() != null && !searchVO.getOrderDt2().equals("")){
			String tempOrderDtTo[] = searchVO.getOrderDt2().split("/");
			orderDtTo = tempOrderDtTo[2] + "-" + tempOrderDtTo[1] + "-" + tempOrderDtTo[0] + " 00:00:00";
		}
		
		map.put("orderDateFrom", orderDtFr);
		map.put("orderDateTo", orderDtTo);
		
		list = invoiceService.selectProformaInvoiceList(map);

		return ResponseEntity.ok(list);
	}
	
	/******************************************************
	 *   Company Statement
	 *****************************************************/	
	/**
	 * Company Statement초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	
	@RequestMapping(value = "/initCompanyStatement.do")
	public String initCompanyStatement(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/companyStatement";
	}
	

	@RequestMapping(value = "/selectCompStatementList")
	public ResponseEntity<List<EgovMap>> selectCompStatementList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;

		
		String brNumber = String.valueOf(params.get("brNumber")).trim();
		String period = String.valueOf(params.get("period")).trim();
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String customerName = String.valueOf(params.get("customerName")).trim();
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("billNo", brNumber);
		map.put("orderNo", orderNo);
		map.put("custName", customerName);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		
		list = invoiceService.selectCompanyStatementList(map);
		
		return ResponseEntity.ok(list);
	}
}
