package com.coway.trust.web.payment.billinggroup.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.payment.billinggroup.service.BillingInvoiceService;
import com.coway.trust.biz.payment.billinggroup.service.impl.ProformaSearchVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingInvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingInvoiceController.class);

	@Resource(name = "billingInvoiceService")
	private BillingInvoiceService invoiceService;

	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;

	@Autowired
	private SessionHandler sessionHandler;

	/******************************************************
	 *   Company Statement
	 *****************************************************/
	/**
	 * Company Statement초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCompanyInvoicePop.do")
	public String initCompanyInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/companyInvoicePop";
	}

	@RequestMapping(value = "/selectInvoiceList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {
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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));
		
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

	@RequestMapping(value = "/initIndividualRentalStatementPop.do")
	public String initIndividualRentalStatement(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/individualRentalStatementPop";
	}

	@RequestMapping(value = "/selectRentalList.do")
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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));
		
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

	@RequestMapping(value = "/initMembershipInvoicePop.do")
	public String initMembershipInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/membershipInvoicePop";
	}

	@RequestMapping(value = "/selectMembershipList.do")
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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));
		
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
	@RequestMapping(value = "/initOutrightInvoicePop.do")
	public String initOutrightInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/outrightInvoicePop";
	}

	/**
	 * Outright Invoice조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOutrightInvoiceList.do")
	public ResponseEntity<Map<String, Object>> searchOutrightInvoiceList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<EgovMap> list = null;
		String[] appType = request.getParameterValues("appType");
		params.put("appType", appType);
		list = invoiceService.selectOutrightInvoiceList(params);
		int totalRowCount = invoiceService.selectOutrightInvoiceListCount(params);

		resultMap.put("list", list);
		resultMap.put("totalRowCount", totalRowCount);

		return ResponseEntity.ok(resultMap);
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

	@RequestMapping(value = "/initProformaInvoicePop.do")
	public String initProformaInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/proformaInvoicePop";
	}

	@RequestMapping(value = "/initAdvancedInvoiceQuotationRentalPop.do")
	public String initAdvancedInvoiceQuotationRentalPop(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/advancedInvoiceQuotationRentalPop";
	}

	@RequestMapping(value = "/selectProformaInvoiceList.do")
	public ResponseEntity<List<EgovMap>> searchOutrightInvoiceList(@ModelAttribute("searchForm")ProformaSearchVO searchVO, @RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
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
		
		if(sessionVO.getUserTypeId() == 2) {
		    map.put("userTypeId", sessionVO.getUserTypeId());
		    map.put("memLevel", sessionVO.getMemberLevel());
		    map.put("deptCode", sessionVO.getDeptCode());
		    map.put("grpCode", sessionVO.getGroupCode());
		    map.put("orgCode", sessionVO.getOrgCode());
		}

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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));

		list = invoiceService.selectProformaInvoiceList(map);

		return ResponseEntity.ok(list);
	}

	/******************************************************
	 *   Advanced Invoice Quotation(Rental)
	 *****************************************************/
	/**
	 * Company Statement초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */


	@RequestMapping(value = "/selectAdvancedRentalInvoiceList.do")
	public ResponseEntity<List<EgovMap>> searchAdvancedRentalInvoiceList(@ModelAttribute("searchForm")ProformaSearchVO searchVO, @RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> list = null;

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("orderNo", searchVO.getOrderNo().trim());
//		map.put("appTypeList", searchVO.getAppType());
//		map.put("orderStatusList", searchVO.getOrderStatus());
		map.put("keyInBranchList", searchVO.getKeyBranch());
//		map.put("dscBranchList", searchVO.getDscBranch());
		map.put("custId", searchVO.getCustId().trim());
		map.put("custName", searchVO.getCustName().trim());
		map.put("custIC", searchVO.getCustIc().trim());
		map.put("productId", searchVO.getProduct());
		map.put("memberCode", searchVO.getMemberCode().trim());
		map.put("rentStatus", searchVO.getRentalStatus());
//		map.put("refNo", searchVO.getRefNo().trim());
//		map.put("poNo", searchVO.getPoNo().trim());
//		map.put("contactNo", searchVO.getContactNo());
		
		if(sessionVO.getUserTypeId() == 2) {
		    map.put("userTypeId", sessionVO.getUserTypeId());
		    map.put("memId", sessionVO.getMemId());
		    map.put("memLevel", sessionVO.getMemberLevel());
		    map.put("deptCode", sessionVO.getDeptCode());
		    map.put("grpCode", sessionVO.getGroupCode());
		    map.put("orgCode", sessionVO.getOrgCode());
		}

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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));
		
		list = invoiceService.selectAdvancedRentalInvoiceList(map);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectProductUsageMonth.do")
	public ResponseEntity<List<EgovMap>> selectProductUsageMonth(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		List<EgovMap> list = null;

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("salesOrderId", params.get("salesOrderId"));

		list = invoiceService.selectProductUsageMonth(map);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectProductBasicInfo.do")
	public ResponseEntity<List<EgovMap>> selectProductAdvancedDisc(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		List<EgovMap> list = null;

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("salesOrderId", params.get("salesOrderId"));

		list = invoiceService.selectProductBasicInfo(map);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getOderOutsInfo.do")
	public ResponseEntity<List<EgovMap>>  getOderOutsInfo(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("params ======================================>>> " + params);

		if(CommonUtils.isEmpty(params.get("CutOffDate"))){
			params.put("CutOffDate", "01/01/1900");
		}

		EgovMap orderInfo = orderLedgerService.selectOrderLedgerView(params);
		model.addAttribute("orderInfo", orderInfo);

		EgovMap insInfo = orderLedgerService.selectInsInfo(params);
		model.addAttribute("insInfo", insInfo);

		EgovMap mailInfo = orderLedgerService.selectMailInfo(params);
		model.addAttribute("mailInfo", mailInfo);

		EgovMap salesInfo = orderLedgerService.selectSalesInfo(params);
		model.addAttribute("salesInfo", salesInfo);

		List<EgovMap> orderLdgrList = orderLedgerService.getOderLdgr(params);

		double balance = 0;
		for(int i = 0; i < orderLdgrList.size(); i++){
			EgovMap result = orderLdgrList.get(i);

			 if (result.get("docType") == "B/F")
             {
					balance = Double.parseDouble(result.get("balanceamt").toString());
             }
             else
             {
                 balance = balance + Double.parseDouble(result.get("debitamt").toString()) + Double.parseDouble(result.get("creditamt").toString());
             }

			 result.put("balanceamt", balance);

		}

		model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));

		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));

		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);

		EgovMap ordOutInfo = ordOutInfoList.get(0);

		LOGGER.debug("ordOutInfo =====================>>> " + ordOutInfo);

		model.addAttribute("ordOutInfo", ordOutInfo);
		List<EgovMap> list = ordOutInfoList;

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

	@RequestMapping(value = "/initCompanyStatementPop.do")
	public String initCompanyStatement(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/companyStatementPop";
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
		if(params.get("pdpaMonth") != null)
			map.put("pdpaMonth", params.get("pdpaMonth"));
		
		list = invoiceService.selectCompanyStatementList(map);

		return ResponseEntity.ok(list);
	}

	/******************************************************
	 *   Penalty Invoice
	 *****************************************************/
	/**
	 * Penalty Invoice초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */

	@RequestMapping(value = "/initPenaltyInvoicePop.do")
	public String initPenaltyInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/penaltyInvoicePop";
	}

	/**
	 * Penalty Invoice - Bill Date 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPenaltyBillDate.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectPenaltyBillDate(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = invoiceService.selectPenaltyBillDate(params);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	/******************************************************
	 *   Invoice Issue
	 *****************************************************/
	/**
	 * Company Statement초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */

	@RequestMapping(value = "/initInvoiceIssue.do")
	public String initInvoiceIssue(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO session = sessionHandler.getCurrentSessionInfo();
		model.addAttribute("sessionRoleId", session.getRoleId());

		return "payment/billinggroup/invoiceIssue";
	}

	/******************************************************
	 *   Summary Invoice
	 *****************************************************/
	/**
	 * Summary Invoice초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */

	@RequestMapping(value = "/initSummaryOfInvoicePop.do")
	public String initSummaryInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/summaryInvoicePop";
	}


	@RequestMapping(value = "/selectSummaryInvoiceList.do")
	public ResponseEntity<List<EgovMap>> searchSummaryInvoiceList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {


		List<EgovMap> searchSummaryInvoiceList = invoiceService.searchSummaryInvoiceList(params);

		return ResponseEntity.ok(searchSummaryInvoiceList);

	}


	@RequestMapping(value = "/initSummaryOfAccountPop.do")
	public String initSummaryAccount(@RequestParam Map<String, Object> params, ModelMap model) {
		if(params.get("pdpaMonth") != null)
			model.addAttribute("pdpaMonth", params.get("pdpaMonth"));
		return "payment/billinggroup/summaryAccountPop";
	}

	@RequestMapping(value = "/selectSummaryAccountList.do")
	public ResponseEntity<List<EgovMap>> searchSummaryAccountList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {


		List<EgovMap> searchSummaryAccountList = invoiceService.searchSummaryAccountList(params);

		return ResponseEntity.ok(searchSummaryAccountList);

	}

}
