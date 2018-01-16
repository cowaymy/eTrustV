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
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class PaymentListController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListController.class);
	
	@Resource(name = "paymentListService")
	private PaymentListService paymentListService;	
		
	/******************************************************
	 *  Payment List  
	 *****************************************************/	
	/**
	 *  Payment List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initPaymentList.do")
	public String initPaymentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/paymentList";
	}
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectGroupPaymentList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectGroupPaymentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = paymentListService.selectGroupPaymentList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Payment List - Request DCF
	 *****************************************************/	
	/**
	 * Payment List - Request DCF 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRequestDCFPop.do")
	public String initRequestDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {		
		
		model.put("groupSeq", params.get("groupSeq"));		
		LOGGER.debug("payment List params : {} ", params);
		
        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);        
        //model.put("paymentList", resultList);        
        
		return "payment/otherpayment/requestDCFPop";
	}
	
	/**
	 * Payment List - Request DCF 대상 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentListByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectPaymentListByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Payment List - Request DCF 대상 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestDCFByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectRequestDCFByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestDCFByGroupSeq(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}	
	
	
	/**
	 * Payment List - Request DCF 정보 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReqDcfInfo.do")
	public ResponseEntity<EgovMap> selectReqDcfInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		EgovMap resultMap = paymentListService.selectReqDcfInfo(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	/**
	 * Payment List - Request DCF 대상 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/requestDCF.do", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);
		
		// 저장
		params.put("userId", sessionVO.getUserId());
    	EgovMap resultMap = paymentListService.requestDCF(params);
		
		// 조회 결과 리턴.
    	return ResponseEntity.ok(resultMap);
    	
	}
	
	/******************************************************
	 * Payment List - Confirm DCF
	 *****************************************************/	
	/**
	 * Payment List - Confirm DCF 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmDCF.do")
	public String initConfirmDCF(@RequestParam Map<String, Object> params, ModelMap model) {        
        
		return "payment/otherpayment/confirmDCF";
	}
	
	/**
	 * Payment List - Request DCF 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestDCFList.do")
	public ResponseEntity<List<EgovMap>> selectRequestDCFList(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestDCFList(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Payment List - Confirm DCF 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmDCFPop.do")
	public String initConfirmDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {		
		
		model.put("groupSeq", params.get("groupSeq"));
		model.put("reqNo", params.get("reqNo"));
		model.put("dcfStusId", params.get("dcfStusId"));
		
		LOGGER.debug("payment List params : {} ", params);       
        
		return "payment/otherpayment/confirmDCFPop";
	}
	
	/**
	 * Payment List - Reject DCF 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/rejectDCF.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);		
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.rejectDCF(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
	
	/**
	 * Payment List - Approval DCF 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/approvalDCF.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);
		
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.approvalDCF(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
	
	/**
	 * Payment List - Request FT 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/initRequestFTPop.do")
	public String initRequestFTPop(@RequestParam Map<String, Object> params, ModelMap model) {		
		
		model.put("groupSeq", params.get("groupSeq"));		
		model.put("payId", params.get("payId"));
		model.put("appTypeId", params.get("appTypeId"));
		LOGGER.debug("payment List params : {} ", params);
		
        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);        
        //model.put("paymentList", resultList);        
        
		return "payment/otherpayment/requestFTPop";
	}
	
	/**
	 * Payment List - Request FT 대상 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectFTOldData.do")
	public ResponseEntity<EgovMap> selectFTOldData(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		EgovMap returnMap = null;
		//조회.
		List<EgovMap> resultList = paymentListService.selectFTOldData(params);
		
		if (resultList != null && resultList.size() > 0) {
			returnMap = resultList.get(0);
		} else {
			returnMap = new EgovMap();
		}

		// 조회 결과 리턴.
		return ResponseEntity.ok(returnMap);
	}
	
	
	/**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/requestFT", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestFT(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		Map<String, Object> formInfo = new HashMap<String, Object> ();
		
		System.out.println("formList.size : " + formList.size());
		
		if(formList.size() > 0){
    		for(Object obj : formList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			System.out.println("VAlues : " + (String)map.get("name") + " / "+ map.get("value"));		
    			
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}		
		//User ID 세팅
		formInfo.put("userId", sessionVO.getUserId());		
		// 저장
		EgovMap resultMap = paymentListService.requestFT(formInfo,gridList);		
		// 조회 결과 리턴.
    	return ResponseEntity.ok(resultMap);	    	
	}	
	
	
	/******************************************************
	 * Payment List - Confirm Fund Transfer
	 *****************************************************/	
	/**
	 * Payment List - Confirm FT 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmFT.do")
	public String initConfirmFT(@RequestParam Map<String, Object> params, ModelMap model) {        
        
		return "payment/otherpayment/confirmFT";
	}
	
	/**
	 * Payment List - Request FT 리스트 조회 
	 * @param paramsinitConfirmFTPopinitConfirmFTPop
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestFTList.do")
	public ResponseEntity<List<EgovMap>> selectRequestFTList(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestFTList(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Payment List - Confirm FT 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmFTPop.do")
	public String initConfirmFTPop(@RequestParam Map<String, Object> params, ModelMap model) {		
		
		model.put("ftReqId", params.get("ftReqId"));
		model.put("ftStusId", params.get("ftStusId"));
		model.put("payId", params.get("payId"));
		model.put("groupSeq", params.get("groupSeq"));
		
		LOGGER.debug("payment List params : {} ", params);       
        
		return "payment/otherpayment/confirmFTPop";
	}
	
	/**
	 * Payment List - Request FT 상세정보 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReqFTInfo.do")
	public ResponseEntity<EgovMap> selectReqFTInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		
		//조회.
		EgovMap resultMap = paymentListService.selectReqFTInfo(params);
		
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}
	
	/**
	 * Payment List - Reject FT 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/rejectFT.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectFT(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);		
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.rejectFT(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
	
	/**
	 * Payment List - Approval FT 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/approvalFT.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalFT(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params : {} ", params);
		
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.approvalFT(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
    	
	}
	
}
