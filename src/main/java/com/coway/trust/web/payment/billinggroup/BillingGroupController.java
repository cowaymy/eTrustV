package com.coway.trust.web.payment.billinggroup;

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

import com.coway.trust.biz.payment.billinggroup.InvoiceService;
import com.coway.trust.biz.payment.billinggroup.impl.SearchVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingGroupController {

	private static final Logger logger = LoggerFactory.getLogger(BillingGroupController.class);
	
	@Resource(name = "invoiceService")
	private InvoiceService invoiceService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/******************************************************
	 * Search Payment  
	 *****************************************************/	
	/**
	 * SearchPayment초기화 화면 
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

		System.out.println("params : " + params);
		
		String brNumber = String.valueOf(params.get("brNumber"));
		String period = String.valueOf(params.get("period"));
		String orderNo = String.valueOf(params.get("orderNo"));
		String customerName = String.valueOf(params.get("customerName"));
		String custNRIC = String.valueOf(params.get("customerNRIC"));
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map map = new HashMap();
		
		map.put("billNo", brNumber);
		map.put("orderNo", orderNo);
		map.put("custName", customerName);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		map.put("custNRIC", custNRIC);
		
		list = invoiceService.selectCompanyInvoice(map);
		
		if(list != null  && list.size() > 0){
    		for(int i =0; i<list.size(); i++){
    			System.out.println(list.get(i));
    		}
		}
		
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/initIndividualRentalStatement.do")
	public String initIndividualRentalStatement(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/individualRentalStatement";
	}
	
	@RequestMapping(value = "/selectRentalList")
	public ResponseEntity<List<EgovMap>> searchRentalList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;

		System.out.println("params : " + params);
		
		String brNumber = String.valueOf(params.get("brNumber"));
		String period = String.valueOf(params.get("period"));
		String orderNo = String.valueOf(params.get("orderNo"));
		String customerName = String.valueOf(params.get("customerName"));
		String custNRIC = String.valueOf(params.get("customerNRIC"));
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map map = new HashMap();
		
		map.put("billNo", brNumber);
		map.put("orderNo", orderNo);
		map.put("custName", customerName);
		map.put("sMonth", sMonth);
		map.put("sYear", sYear);
		map.put("custNRIC", custNRIC);
		
		list = invoiceService.selectRentalStatementList(map);
		
		if(list != null  && list.size() > 0){
    		for(int i =0; i<list.size(); i++){
    			System.out.println(list.get(i));
    		}
		}
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/initMembershipInvoice.do")
	public String initMembershipInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/membershipInvoice";
	}
	
	@RequestMapping(value = "/selectMembershipList")
	public ResponseEntity<List<EgovMap>> searchMembershipList(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		System.out.println("params : " + params);
		
		String invoiceNo = String.valueOf(params.get("invoiceNo"));
		String period = String.valueOf(params.get("period"));
		String orderNo = String.valueOf(params.get("orderNo"));
		String custName = String.valueOf(params.get("custName"));
		String custNRIC = String.valueOf(params.get("custNRIC"));
		String quotationNo = String.valueOf(params.get("quotationNo"));
		
		int sMonth = 0;
		int sYear = 0;
		
		if((!period.equals("null")) && (!period.equals(""))){
			String tmp[] = period.split("/");
			sMonth = Integer.parseInt(tmp[0]);
			sYear = Integer.parseInt(tmp[1]);
		}
		
		Map map = new HashMap();
		
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
	
	@RequestMapping(value = "/initOutrightInvoice.do")
	public String initOutrightInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/outrightInvoice";
	}
	
	@RequestMapping(value = "/selectOutrightInvoiceList")
	public ResponseEntity<List<EgovMap>> searchOutrightInvoiceList(@ModelAttribute("searchForm")SearchVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		Map map = new HashMap();
		
		map.put("orcGode","");
		map.put("grpCode", "");
		map.put("deptCode", "");
		map.put("memberId", 0);
		map.put("memberLvl", 0);
		map.put("memberTypeId",0);
		map.put("orderNo", searchVO.getOrderNo());
		map.put("custName", searchVO.getCustName());
		map.put("appType", searchVO.getAppType());
		
		System.out.println(map);
		
		list = invoiceService.selectOutrightInvoiceList(map);
		
		for(EgovMap em : list){
				System.out.print(em);
		}
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/initProformaInvoice.do")
	public String initProformaInvoice(@RequestParam Map<String, Object> params, ModelMap model) {	
	
		return "payment/billinggroup/proformaInvoice";
	}
	
	
}
