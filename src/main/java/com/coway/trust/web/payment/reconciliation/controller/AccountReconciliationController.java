package com.coway.trust.web.payment.reconciliation.controller;

import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.reconciliation.service.AccountReconciliationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.text.SimpleDateFormat;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AccountReconciliationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AccountReconciliationController.class);
	
	@Resource(name = "accountReconciliationService")
	private AccountReconciliationService accountReconciliationService;
	
	
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
		
		LOGGER.debug("params : {}", params);
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
		
		LOGGER.debug("params : {}", params);
		
		List<EgovMap> masterView = accountReconciliationService.selectJournalMasterView(params);
		
		List<EgovMap> detailList = accountReconciliationService.selectJournalDetailList(params);
		
		String grossTotal = accountReconciliationService.selectGrossTotal(params);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("masterView", masterView.get(0));
		resultMap.put("detailList", detailList);
		resultMap.put("grossTotal", grossTotal);
		
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
			HttpServletRequest request) {
		
		ReturnMessage message = new ReturnMessage();
		LOGGER.debug("params : {}", params);
		
		boolean isSuccess = accountReconciliationService.updJournalPassEntry(params);
		
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
			HttpServletRequest request) {
		
		ReturnMessage message = new ReturnMessage();
		LOGGER.debug("params : {}", params);
		
		boolean isSuccess = accountReconciliationService.updJournalExclude(params);
		
		if(isSuccess){
			message.setMessage("* Update Success");
		}else{
			message.setMessage("* Failed to update. Please try again later.");
		}
		
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
}
