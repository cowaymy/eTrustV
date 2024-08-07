package com.coway.trust.web.payment.document.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.document.service.FinanceMgmtService;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.payment.service.CommDeductionVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class FinanceMgmtController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FinanceMgmtController.class);
	
	@Resource(name = "financeMgmtService")
	private FinanceMgmtService financeMgmtService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "customerService")
	private CustomerService customerService;

	
	/******************************************************
	 * FinanceManagement
	 *****************************************************/	
	/**
	 * Finance Management초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initFinanceMgmt.do")
	public String initFinanceMgmt(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("groupCode", "CRC");
		List<EgovMap> cardComboList = commonService.getAccountList(param);

		List<EgovMap> issueBankList = customerService.selectAccBank(params);
		
		param.put("groupCode", "1");
		param.put("separator", "-");
		List<EgovMap> branchList = commonService.selectBranchList(param);
				
		model.addAttribute("cardComboList", cardComboList);	
		model.addAttribute("issueBank", issueBankList);
		model.addAttribute("branchList", branchList);
		return "payment/document/financeMgmt";
	}
	
	/**
	 * Finance Management Receive List 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReceiveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReceiveList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {

       
        String[] online = request.getParameterValues("rOnline");
        String[] batchStatus = request.getParameterValues("rBatchStatus");
        String[] itemStatus = request.getParameterValues("rItemStatus");
        params.put("rOnline", online);
        params.put("rBatchStatus", batchStatus);
        params.put("rItemStatus", itemStatus);
        
        LOGGER.debug("----params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectReceiveList(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCreditCardList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCreditCardList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		 String[] online = request.getParameterValues("cOnline");
		 params.put("cOnline", online);
        LOGGER.debug("---------params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectCreditCardList(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPaymentItem.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPaymentItem(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectDocItemPaymentItem(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Log 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectLogItemPaymentItem.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLogItemPaymentItem(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectLogItemPaymentItem(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Doc Batch 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPayDocBatchById.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPayDocBatchById(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectPayDocBatchById(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPaymentItem2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPaymentItem2(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params2 : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectDocItemPaymentItem2(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveReceiveList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveReceiveList(@RequestBody Map<String, Object> params, ModelMap model, 
			HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("##params : {}", params);
        ReturnMessage mes = new ReturnMessage();
        
        int userId = sessionVO.getUserId();
        System.out.println("userId : " + userId);
        String message = "";
        if(userId > 0){
            List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
            List<Object> formList = (List<Object>) params.get(AppConstants.AUIGRID_FORM);
            
            List<Map<String, Object>> payDocList = new ArrayList<Map<String, Object>>();
            if(checkList.size() > 0){
            	Map<String, Object> formMap = (Map<String, Object>)formList.get(0); 
            	payDocList = this.setPayDocList(checkList, userId, String.valueOf(formMap.get("statusId")));
            }
            
            if(payDocList.size() > 0){
            	Map tmp = (Map)formList.get(0);
            	Map<String, Object> reValue = financeMgmtService.savePayDoc(payDocList, String.valueOf(tmp.get("remark")));
            	
            	if(String.valueOf(reValue.get("success")).equals("true")){
            		message = "Document(s) status have been updated.<br />" + "Batch closed : " +reValue.get("count") ;
            	}else{
            		message = "Failed to save. Please try again later.";
            	}
            }
        }else{
        	message = "Your login session was expired. Please relogin to our system.";
        }

        mes.setCode(AppConstants.SUCCESS);
    	mes.setMessage(message);

        return ResponseEntity.ok(mes);
	}
	
	private List<Map<String,Object>> setPayDocList(List checkList, int userId, String statusId){
		List<Map<String, Object>> payDocList = new ArrayList<Map<String, Object>>();
		
		Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String today = sdf.format(curdate);
		
		for(Object param : checkList){
			Map <String, Object> payDocDetail = new HashMap<String, Object>();
			Map<String, Object> checkMap = (Map<String, Object>) param;
			Map<String, Object> item = (Map<String,Object>)checkMap.get("item");
			System.out.println("####item : " + item);
			
			payDocDetail.put("itemId", item.get("itmId"));
			payDocDetail.put("batchId", item.get("batchId"));
			payDocDetail.put("itemStatusId", statusId);
			payDocDetail.put("trxId", 0);
			payDocDetail.put("amount", 0);
			payDocDetail.put("paymodeId", 0);
			payDocDetail.put("isOnline", false);
			payDocDetail.put("oriCcNo", "");
			payDocDetail.put("ccTypeId", 0);
			payDocDetail.put("ccHolderName", "");
			payDocDetail.put("ccExpiry", "");
			payDocDetail.put("bankId", 0);
			payDocDetail.put("refDate", "1900-01-01 00:00:00");
			payDocDetail.put("AppvNo", "");
			payDocDetail.put("refNo", "");
			payDocDetail.put("created", today);
			payDocDetail.put("creator", userId);
			payDocDetail.put("updated", today);
			payDocDetail.put("updator", userId);
			payDocDetail.put("mid", "");
			payDocDetail.put("branchId", 0);
			payDocDetail.put("payDate", "1900-01-01 00:00:00");
			payDocDetail.put("accId", 0);
			
			payDocList.add(payDocDetail);
		}
		
		return payDocList;
	}
	
	/**
	 * Submission List초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSubmissionList.do")
	public String initSubmissionList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/document/submissionList";
	}
}
