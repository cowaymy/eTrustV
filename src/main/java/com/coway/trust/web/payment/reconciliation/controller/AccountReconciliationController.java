package com.coway.trust.web.payment.reconciliation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.reconciliation.service.AccountReconciliationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AccountReconciliationController {
	
	
	@Resource(name = "accountReconciliationService")
	private AccountReconciliationService accountReconciliationService;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CRCStatementController.class);
	/******************************************************
	 *  Bank Account Reconciliation
	 *****************************************************/	
	/**
	 *   Bank Account Reconciliation 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAccountReconciliation.do")
	public String initAccountReconciliation(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/accountReconciliation";
	}
	
	/******************************************************
	 *  Order Payment Listing 팝업
	 *****************************************************/	
	/**
	 * Order Payment Listing 팝업
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initOrderPaymentListingPop.do")
	public String orderPaymentListing(@RequestParam Map<String, Object>params, ModelMap model){
		model.put("orderId", params.get("ordId"));
		return "payment/reconciliation/orderPaymentListingPop";
	}
	
	/******************************************************
	 *  AS Listing 팝업
	 *****************************************************/	
	/**
	 * AS Listing 팝업
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initOrderASListingPop.do")
	public String initOrderASListingPop(@RequestParam Map<String, Object>params, ModelMap model){
		model.put("orderId", params.get("ordId"));
		return "payment/reconciliation/orderASListingPop";
	}
	
	/******************************************************
	 *  Order Summary View
	 *****************************************************/	
	/**
	 *   Order Summary View 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initOrderCombineLedgerPop.do")
	public String initOrderCombineLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/orderCombineLedgerPop";
	}
	
	
	
	/******************************************************
	 *  Bank Account Reconciliation Report
	 *****************************************************/	
	/**
	 *   Bank Account Reconciliation Report
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBankAccountReconciliation.do")
	public String initBankAccountReconciliation(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/bankAccountReconciliation_R";
	}
	
	
	/******************************************************
	 *  Branches Collection Report
	 *****************************************************/	
	/**
	 *   Branches Collection Report
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBranchesCollectionSummary.do")
	public String initBranchesCollectionSummary(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/branchesCollectionSummary_R";
	}
	
	/******************************************************
	 *  Reconciliation Statistic Report
	 *****************************************************/	
	/**
	 *   Reconciliation Statistic Report
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initReconciliationStatistic.do")
	public String initReconciliationStatistic(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/reconciliationStatistic_R";
	}
	
	/**
	 * selectJournalMasterList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectJournalMasterList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectJournalMasterList(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		String[] statusId = request.getParameterValues("statusId");
		params.put("statusId", statusId);
		
		List<EgovMap> watingList = accountReconciliationService.selectJournalMasterList(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(watingList);
	}
	
	/**
	 * selectJournalBasicInfo 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectJournalBasicInfo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectJournalBasicInfo(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		List<EgovMap> masterView = accountReconciliationService.selectJournalMasterView(params);
		
		List<EgovMap> detailList = accountReconciliationService.selectJournalDetailList(params);
		
		String grossTotal = accountReconciliationService.selectGrossTotal(params);
		
		String crcGrossTotal = accountReconciliationService.selectCRCStatementGrossTotal(params);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("masterView", masterView.get(0));
		resultMap.put("detailList", detailList);
		resultMap.put("grossTotal", grossTotal);
		resultMap.put("crcGrossTotal", crcGrossTotal);
		
        // 조회 결과 리턴.
		ReturnMessage message = new ReturnMessage();
		message.setData(resultMap);
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * updJournalPassEntry
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updJournalPassEntry.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updJournalPassEntry(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean isSuccess = accountReconciliationService.updJournalPassEntry(params, sessionVO);
		
		if(isSuccess){
			message.setMessage("* Update Success");
		}else{
			message.setMessage("* Failed to update. Please try again later.");
		}
		
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * updJournalExclude
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updJournalExclude.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updJournalExclude(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request, SessionVO sessionVO) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean isSuccess = accountReconciliationService.updJournalExclude(params, sessionVO);
		
		if(isSuccess){
			message.setMessage("* Update Success");
		}else{
			message.setMessage("* Failed to update. Please try again later.");
		}
		
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectOrderOutstandingView
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOrderOutstandingView.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectOrderOutstandingView(@RequestParam Map<String, Object> params, ModelMap model) {
		
		String orderId = accountReconciliationService.selectOrderIDByOrderNo(params);
		List<EgovMap> orderOutstandingView = new ArrayList<EgovMap>();
		
		if(orderId != null){
			params.put("orderId", orderId);
			accountReconciliationService.selectOutStandingView(params);
			
			orderOutstandingView= (List<EgovMap>) params.get("p1");
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("orderOutstandingView", orderOutstandingView);
		
		return ResponseEntity.ok(resultMap);
	}
	
	/**
	 * OrderASList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOrderASList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderASList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> resultList = accountReconciliationService.selectASInfoList(params);
		
		return ResponseEntity.ok(resultList);
	}
	
}
