package com.coway.trust.web.payment.billing.controller;


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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.BillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingController {

	private static final Logger logger = LoggerFactory.getLogger(BillingController.class);
	
	@Resource(name = "billingService")
	private BillingService billingService;
	
	
	/**
	 * Discount Mgmt 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initDiscountMgmt.do")
	public String initEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/discountMgmt";
	}
	
	/**
	 * selectBasicInfo 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBasicInfo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectBasicInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        
		EgovMap basicInfo = billingService.selectBasicInfo(params);
		List<EgovMap> discountList = billingService.selectDiscountList(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("basicInfo", basicInfo);
        resultMap.put("discountList", discountList);

        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * conversionSchemeId 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectSalesOrderMById.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSalesOrderMById(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        EgovMap conversionSchemeId = billingService.selectSalesOrderMById(params);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("conversionSchemeId", conversionSchemeId);
        
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * ContractServiceId 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectContractServiceId.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectContractServiceId(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        String cntractServiceId = billingService.selectContractServiceId(params);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("cntractServiceId", cntractServiceId);
        
        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveDiscount 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveDiscount.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveDiscount(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		EgovMap resultMap = billingService.saveAddDiscount(params, sessionVO);

        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveDisableDiscount 저장
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveDisableDiscount.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveDisableDiscount(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
        String errorMessage = billingService.updDiscountEntry(params);
        String resultMessage = "";
        EgovMap basicInfo = new EgovMap();
        List<EgovMap> discountList = new ArrayList<EgovMap>();
        
        if("".equals(errorMessage)){
        	basicInfo = billingService.selectBasicInfo(params);
        	discountList = billingService.selectDiscountList(params);
        	resultMessage = "Disabled Successfully.";
        	message.setCode(AppConstants.SUCCESS);
        }else{
        	resultMessage = "ERROR: " + errorMessage;
        	message.setCode(AppConstants.FAIL);
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("resultMessage", resultMessage);
        resultMap.put("discountList", discountList);
        resultMap.put("basicInfo", basicInfo);

        // 조회 결과 리턴.
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	
}
