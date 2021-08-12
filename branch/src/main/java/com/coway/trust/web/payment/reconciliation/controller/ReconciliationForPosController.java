package com.coway.trust.web.payment.reconciliation.controller;

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
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationForPosService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;
 
@Controller
@RequestMapping(value = "/payment")
public class ReconciliationForPosController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReconciliationForPosController.class);

	@Resource(name="ReconciliationForPosService")
	private ReconciliationForPosService  rService;
 
	
	
	@RequestMapping(value = "/reconciliationForPos.do")
	public String reconciliationForPosList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		return "payment/reconciliation/reconciliationForPosList";
	}
	
	
	
	/**
	 *  
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectReconciliationList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectReconciliationList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<EgovMap> keyInList = rService.selectPosKeyInList(params);
		List<EgovMap> stateList = rService.selectBankStateMatchList(params);
		
		
		resultMap.put("keyInList", keyInList);
		resultMap.put("stateList", stateList);
        
		// 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
	
	

	/**  
	 * Advance Payment Matching - Mapping 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/savePosKeyPaymentMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAdvPaymentMapping(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);
		
		String  seq  =(String) params.get("groupSeq");
		String[]  groupSeq =seq.split(",") ;
		
		
		// 저장
		params.put("groupSeq",groupSeq);
		params.put("userId", sessionVO.getUserId());
		
		LOGGER.debug("params==> : {} ", params);
		rService.savePosKeyPaymentMapping(params);
		 
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
	
}
