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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CardStatementController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CardStatementController.class);
	
	@Resource(name = "cardStatementService")
	private CardStatementService cardStatementService;	
		
	/******************************************************
	 *  Credit Card Statement List 
	 *****************************************************/	
	/**
	 *  Credit Card Statement List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initUploadCardStatementList.do")
	public String initUploadCardStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/cardpayment/uploadCardStatementList";
	}
	
	/**
	 * Credit Card Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectCardStatementMasterList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectCardStatementMasterList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = cardStatementService.selectCardStatementMasterList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Credit Card Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectCardStatementDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCardStatementDetailList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
        // 조회.
        List<EgovMap> resultList = cardStatementService.selectCardStatementDetailList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	* Credit Card Statement Upload
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/uploadCardStatement.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> uploadCardStatement(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {	
		
		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		//Item map
		Map<String, Object> itemMap = null;
		List<Object> itemList = new ArrayList<Object>();
		
		//등록 parameter 세팅 
		if (gridList.size() > 0) {
			Map<String, Object> gridMap = null;
			
			for (int i = 0; i < gridList.size(); i++) {
				
				gridMap = (Map<String, Object>) gridList.get(i);	
				
				//첫번째 값이 없으면 skip
				if(gridMap.get("0") == null || String.valueOf(gridMap.get("0")).equals("") || String.valueOf(gridMap.get("0")).trim().length() < 1 ){					
					continue;
				}
			
				itemMap = new HashMap<String, Object>();
				itemMap.put("crcTrnscDt", formData.get("uploadTranDt"));			
				itemMap.put("crcTrnscMid", String.valueOf(gridMap.get("0")));	// MID
				itemMap.put("crditCard", String.valueOf(gridMap.get("1")));	// Credit Card
				itemMap.put("crcTrnscNo", String.valueOf(gridMap.get("2")));		//Card Number
				itemMap.put("crcTrnscAppv", String.valueOf(gridMap.get("3")));		//Approval No
				itemMap.put("crcGrosAmt", String.valueOf(gridMap.get("4")));		//Gross
				itemMap.put("crcBcAmt", String.valueOf(gridMap.get("5")));		//Bank Charge
				itemMap.put("crcGstAmt", String.valueOf(gridMap.get("6")));		//GST
				itemMap.put("crcNetAmt", String.valueOf(gridMap.get("7")));		//Net
				itemMap.put("crcTotBcAmt", String.valueOf(gridMap.get("8")));	//Total Bank Charge
				itemMap.put("crcTotGstAmt", String.valueOf(gridMap.get("9")));	//Total GST
				itemMap.put("crcTotNetAmt", String.valueOf(gridMap.get("10")));	//Total Net
				itemMap.put("userId", sessionVO.getUserId());		
			
				itemList.add(itemMap);
			}
		}
		
		//마스터 정보 parameter 추가 세팅		
		formData.put("userId", sessionVO.getUserId());		
		
		//저장처리
		Map<String, Object> returnMap = cardStatementService.uploadCardStatement(formData,itemList);				

				
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
    	msg.setMessage("");
        return ResponseEntity.ok(returnMap);
	}
	
	/******************************************************
	 *  Credit Card Statement Confirm 
	 *****************************************************/	
	/**
	 *  Credit Card Statement Confirm 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmCardStatementList.do")
	public String initConfirmCardStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/cardpayment/confirmCardStatementList";
	}
	
	/**
	 * Credit Card Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectCRCConfirmMasterList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectCRCConfirmMasterList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = cardStatementService.selectCRCConfirmMasterList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Credit Card Statement Master Posting 처리
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/postCardStatement.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> postCardStatement(@RequestParam Map<String, Object> params,
    		Model model, SessionVO sessionVO) {
		
		params.put("userId", sessionVO.getUserId());
    	// 처리.
		cardStatementService.postCardStatement(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);    	
    	message.setMessage("Saved Successfully");
    	
    	return ResponseEntity.ok(message);
		
    }
	
}
