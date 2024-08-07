package com.coway.trust.web.payment.document.controller;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.document.service.AdminMgmtService;
import com.coway.trust.biz.payment.document.service.FinanceMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.text.SimpleDateFormat;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AdminMgmtController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminMgmtController.class);
	
	@Resource(name = "adminMgmtService")
	private AdminMgmtService adminMgmtService;
	
	@Resource(name = "financeMgmtService")
	private FinanceMgmtService financeMgmtService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	
	/******************************************************
	 *  Admin Management
	 *****************************************************/	
	/**
	 *  Admin Management 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdminMgmt.do")
	public String initDailyCollection(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		params.put("separator", "-");
		params.put("groupCode", 1);
		List<EgovMap> codeList = commonService.selectBranchList(params);
		
		model.addAttribute("codeList", codeList);
		model.addAttribute("userBranchId", sessionVO.getUserBranchId());
		return "payment/document/adminMgmt";
	}
	
	/**
	 * selectWatingLoadInfo 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectWatingLoadInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWatingLoadInfo(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		LOGGER.debug("params : {}", params);
		
		String[] isOnlineWaiting = request.getParameterValues("isOnlineWaiting");
		
		params.put("isOnlineWaiting", isOnlineWaiting);
		
		//WATING LIST
		List<EgovMap> watingList = adminMgmtService.selectWaitingItemList(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(watingList);
	}
	
	/**
	 * selectReviewLoadInfo 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReviewLoadInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReviewLoadInfo(@RequestParam Map<String, Object> params, ModelMap model, 
			HttpServletRequest request) {
		
		LOGGER.debug("params : {}", params);
		String[] isOnlineReview = request.getParameterValues("isOnlineReview");
		params.put("isOnlineReview", isOnlineReview);
		//REVIEW LIST
		List<EgovMap> reviewList = adminMgmtService.selectReviewItemList(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(reviewList);
	}
	
	/**
	 * selectDocItemPayDetailList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPayDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPayDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> watingPopDetList = adminMgmtService.selectDocItemPayDetailList(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(watingPopDetList);
	}
	
	/**
	 * saveConfirmSendWating
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveConfirmSendWating", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveConfirmSendWating(@RequestBody Map<String, Object> params, ModelMap model, 
			HttpServletRequest request, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK); // 그리드 데이터 가져오기
		List<Object> formList = (List<Object>) params.get(AppConstants.AUIGRID_FORM);
		
		String saveResult = adminMgmtService.saveConfirmSendWating(checkList, sessionVO, formList);
		
		if(!saveResult.equals("")){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("Document(s) have been sent.<br />" + "Batch Number : " + saveResult);
		}else{
			
			message.setMessage("Failed to save. Please try again later.");
		}
		
    	return ResponseEntity.ok(message);
	}
	
	
	/**
	 * selectDocItemPayReviewDetailList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPayReviewDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPayReviewDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> watingPopDetList = adminMgmtService.selectDocItemPayReviewDetailList(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(watingPopDetList);
	}
	
	/**
	 * selectLoadItemLog 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return 
	 * @return
	 */
	@RequestMapping(value = "/selectLoadItemLog", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoadItemLog(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> logList = adminMgmtService.selectLoadItemLog(params);
		//Map<String, Object> logMap = logList.get(0);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(logList);
	}
	
	
	/**
	 * selectPaymentDocMs 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return 
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentDocMs", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectPaymentDocMs(@RequestParam Map<String, Object> params, ModelMap model) {
		
		EgovMap paymentDocMs = adminMgmtService.selectPaymentDocMs(params);
		
        // 조회 결과 리턴.
        return ResponseEntity.ok(paymentDocMs);
	}
	
	@RequestMapping(value = "/saveConfirmResendReview", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveConfirmResendReview(@RequestBody Map<String, Object> params, ModelMap model, 
			HttpServletRequest request, SessionVO sessionVO) {
		
        ReturnMessage mes = new ReturnMessage();
        String message = "";
        
        Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String today = sdf.format(curdate);
        int userId = sessionVO.getUserId();
        
        
        List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
        List<Object> formList = (List<Object>) params.get(AppConstants.AUIGRID_FORM);
        List<Map<String, Object>> payDocList = new ArrayList<Map<String, Object>>();
        Map<String, Object> formMap = (Map<String, Object>)formList.get(0);
        Map <String, Object> payDocDetail = null;
        
        if(checkList.size() > 0){
        	
        	for(Object param : checkList){
        		payDocDetail = new HashMap<String, Object>();
    			
    			Map<String, Object> checkMap = (Map<String, Object>) param;
    			Map<String, Object> item = (Map<String,Object>)checkMap.get("item");
    			
    			payDocDetail.put("itemId", item.get("itmId"));
    			payDocDetail.put("batchId", item.get("batchId"));
    			payDocDetail.put("itemStatusId", 79);
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
        }
        
        if(payDocList.size() > 0){
        	
        	Map<String, Object> reValue = financeMgmtService.savePayDoc(payDocList, String.valueOf(formMap.get("remark")));
        	boolean isSuccess = (boolean) reValue.get("success");
        	
        	if(isSuccess){
        		message = "Document(s) have been resent.";
        	}else{
        		message = "Failed to resend document. Please try again later.";
        	}
        }
        
        mes.setCode(AppConstants.SUCCESS);
    	mes.setMessage(message);

        return ResponseEntity.ok(mes);
        
	}
	
}
