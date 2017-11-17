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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

@Controller
@RequestMapping(value = "/payment")
public class AdvPaymentController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentController.class);
	
	@Resource(name = "advPaymentService")
	private AdvPaymentService advPaymentService;	
		
	/******************************************************
	 *  
	 *****************************************************/	
	/**
	 *  
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdvPayment.do")
	public String initUploadBankStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/advPayment";
	}
	
	/**
	 * Advance Payment 처리
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveAdvPayment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savePayment(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		LOGGER.debug("params {}"+params);
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	
    	Map<String, Object> formInfo = new HashMap<String, Object> ();
    	if(formList.size() > 0){
    		for(Object obj : formList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}
    	
    	formInfo.put("userid", sessionVO.getUserId());
    	formInfo.put("keyInIsLock",  0);
		formInfo.put("keyInIsThirdParty",  0);
		formInfo.put("keyInStatusId",  1);
		formInfo.put("keyInIsFundTransfer",  0);
		formInfo.put("keyInSkipRecon",  0);
		formInfo.put("keyInPayItmCardType",  0);
    	
		//Cash
    	if("105".equals(String.valueOf(formInfo.get("keyInPayCashType")))){
    		formInfo.put("keyInPayType", 105);
    		formInfo.put("keyInTransDate", String.valueOf(formInfo.get("cashTransDate")));
        	formInfo.put("keyInAmount",  String.valueOf(formInfo.get("cashAmount")));
    		formInfo.put("keyInBankAcc",  String.valueOf(formInfo.get("cashBankAcc")));
    		formInfo.put("keyInSlipNo",  String.valueOf(formInfo.get("cashSlipNo")));
    		formInfo.put("keyInRemark",  String.valueOf(formInfo.get("cashRemark")));
    		//formInfo.put("keyInBankType",  String.valueOf(formInfo.get("cashBankType")));
    		//formInfo.put("keyVAAccount",  String.valueOf(formInfo.get("cashVAAccount")));
    	}
    	
    	//Cheque
    	if("106".equals(String.valueOf(formInfo.get("keyInPayChequeType")))){
    		formInfo.put("keyInPayType", 106);
    		formInfo.put("keyInTransDate", String.valueOf(formInfo.get("chequeTransDate")));
        	formInfo.put("keyInAmount",  String.valueOf(formInfo.get("chequeAmount")));
    		formInfo.put("keyInBankAcc",  String.valueOf(formInfo.get("chequeBankAcc")));
    		formInfo.put("keyInSlipNo",  String.valueOf(formInfo.get("chequeSlipNo")));
    		formInfo.put("keyInRemark",  String.valueOf(formInfo.get("chequeRemark")));
    		//formInfo.put("keyInBankType",  String.valueOf(formInfo.get("chequeBankType")));
    		//formInfo.put("keyVAAccount",  String.valueOf(formInfo.get("chequeVAAccount")));
    	}
    	
    	//Online
    	if("108".equals(String.valueOf(formInfo.get("keyInPayOnlineType")))){
    		formInfo.put("keyInPayType", 108);
    		formInfo.put("keyInTransDate", String.valueOf(formInfo.get("onlineTransDate")));
        	formInfo.put("keyInAmount",  String.valueOf(formInfo.get("onlineAmount")));
    		formInfo.put("keyInBankAcc",  String.valueOf(formInfo.get("onlineBankAcc")));
    		formInfo.put("keyInSlipNo",  String.valueOf(formInfo.get("onlineSlipNo")));
    		formInfo.put("keyInRemark",  String.valueOf(formInfo.get("onlineRemark")));
    		formInfo.put("keyInBankChrgAmt",  formInfo.get("onlineBankChgAmt") != null ? String.valueOf(formInfo.get("onlineBankChgAmt")) : 0);
    		formInfo.put("keyInEftNo",  String.valueOf(formInfo.get("onlineEft")));
    		//formInfo.put("keyInBankType",  String.valueOf(formInfo.get("onlineBankType")));
    		//formInfo.put("keyVAAccount",  String.valueOf(formInfo.get("onlineVAAccount")));
    	}
		
		// 저장
    	advPaymentService.saveAdvPayment(formInfo,gridList);
		
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
    	msg.setMessage(message);
        return ResponseEntity.ok(msg);
	}
	
}
