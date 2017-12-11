package com.coway.trust.web.payment.reconciliation.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.reconciliation.service.PaymentReconciliationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class PaymentReconciliationController {
	
	
	@Resource(name = "paymentReconciliationService")
	private PaymentReconciliationService paymentReconciliationService;
	
	
	/******************************************************
	 *  Reconciliation Search
	 *****************************************************/	
	/**
	 *   Reconciliation Search 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initPaymentReconciliation.do")
	public String initAccountReconciliation(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/reconciliation/paymentReconciliation";
	}
	
	/**
	 * selectReconciliationMasterList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReconciliationMasterList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectReconciliationMasterList(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		String[] statusId = request.getParameterValues("statusId");
		params.put("statusId", statusId);
		
		List<EgovMap> masterList = paymentReconciliationService.selectReconciliationMasterList(params);
		int totalRowCount = paymentReconciliationService.selectReconciliationMasterListCount(params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("masterList", masterList);
		result.put("totalRowCount", totalRowCount);
		
        // 조회 결과 리턴.
		return ResponseEntity.ok(result);
	}
	
	/**
	 * selectLoadReconciliation
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectLoadReconciliation.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectLoadReconciliation(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		List<EgovMap> depositView = paymentReconciliationService.selectDepositView(params);
		
		List<EgovMap> depositList = paymentReconciliationService.selectDepositList(params);
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("depositList", depositList);
		resultMap.put("depositView", depositView.get(0));
		
        // 조회 결과 리턴.
		ReturnMessage message = new ReturnMessage();
		message.setData(resultMap);
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
	/**
	 * updDepositItem
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updDepositItem.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updDepositItem(@RequestParam Map<String, Object> params, ModelMap model) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean isSuccess = paymentReconciliationService.updDepositItem(params);
		
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
	 * saveExcludeDepositItem
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveExcludeDepositItem.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveExcludeDepositItem(@RequestParam Map<String, Object> params, ModelMap model) {
		
		ReturnMessage message = new ReturnMessage();
		
		boolean isSuccess = paymentReconciliationService.saveExcludeDepositItem(params);
		
		if(isSuccess){
			message.setMessage("* Exclude Success");
		}else{
			message.setMessage("* Failed to update. Please try again later.");
		}
		
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}
	
	
	
}
