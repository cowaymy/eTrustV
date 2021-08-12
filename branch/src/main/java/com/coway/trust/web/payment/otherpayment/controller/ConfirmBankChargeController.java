package com.coway.trust.web.payment.otherpayment.controller;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import com.coway.trust.biz.payment.otherpayment.service.ConfirmBankChargeService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ConfirmBankChargeController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ConfirmBankChargeController.class);
	
	@Resource(name = "confirmBankChargeService")
	private ConfirmBankChargeService confirmBankChargeService;	
		
	/******************************************************
	 *  Confirm Bank Charge 
	 *****************************************************/	
	/**
	 * Confirm Bank Charge - 초기화
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmBankCharge.do")
	public String initConfirmBankCharge(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/confirmBankCharge";
	}
	
	/**
	 *  Confirm Bank Charge 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectBankChgMatchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectBankChgMatchList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//List<EgovMap> keyInList = confirmBankChargeService.selectNorKeyInList(params);
		List<EgovMap> stateList = confirmBankChargeService.selectBankStateMatchList(params);
		
		//resultMap.put("keyInList", keyInList);
		resultMap.put("stateList", stateList);
        
		// 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
	/**
	 * Confirm Bank Charge - Confrim 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveBankChgMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBankChgMapping(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);
		
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		
		// 저장
		confirmBankChargeService.saveBankChgConfirm(gridList, sessionVO);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
}
