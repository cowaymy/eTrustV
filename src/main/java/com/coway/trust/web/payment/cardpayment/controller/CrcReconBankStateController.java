package com.coway.trust.web.payment.cardpayment.controller;

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
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;
import com.coway.trust.biz.payment.cardpayment.service.CrcReconBankStateService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CrcReconBankStateController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CrcReconBankStateController.class);
	
	@Resource(name = "crcReconBankStateService")
	private CrcReconBankStateService crcReconBankStateService;	
		
	/******************************************************
	 *  Card Key-IN Payment 
	 *****************************************************/	
	/**
	 *  Credit Card Key-IN Payment 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCrcReconBankState.do")
	public String initCardKeyInPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/cardpayment/crcReconBankState";
	}
	
	/**
	 * Credit Card Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectCrcBnkMappingList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCRCConfirmMasterList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> mappingList = crcReconBankStateService.selectMappingList(params);		
        /*for(int i=0; i<resultList.size(); i++){
        	System.out.println(resultList.get(i));
        }*/
        List<EgovMap> crcUnMppingList = crcReconBankStateService.selectUnMappedCrc(params);		
        
        List<EgovMap> bankMappingList = crcReconBankStateService.selectUnMappedBank(params);
        
        Map <String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("mappingList", mappingList);
        resultMap.put("crcUnMappingList", crcUnMppingList);
        resultMap.put("bankUnMappingList", bankMappingList);
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
	
	@RequestMapping(value = "/updateMappingData.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateMappingData(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
    	
		String message = "";
		
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL);
		int userId = sessionVO.getUserId();
		
		int result = crcReconBankStateService.updateMappingData(gridList, userId);
		
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
    	msg.setMessage(message);
    	
    	if(result == 1)
    		message = "This Payment form has successfully been approved.";
    	
		return ResponseEntity.ok(msg);
	}
}
