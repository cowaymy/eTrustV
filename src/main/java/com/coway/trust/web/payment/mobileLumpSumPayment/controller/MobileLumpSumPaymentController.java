package com.coway.trust.web.payment.mobileLumpSumPayment.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/mobileLumpSumPayment")
public class MobileLumpSumPaymentController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileLumpSumPaymentController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;


	  @Resource(name = "memberListService")
	  private MemberListService memberListService;

	  @Resource(name = "mobileLumpSumPaymentKeyInService")
	  private MobileLumpSumPaymentKeyInService mobileLumpSumPaymentKeyInService;


	  @Resource(name = "mobilePaymentKeyInService")
	  private MobilePaymentKeyInService mobilePaymentKeyInService;

	@RequestMapping(value = "/lumpSumEnrollmentList.do")
	public String lumpSumEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> userBranch = memberListService.selectUserBranch();

	    EgovMap memDetail = mobilePaymentKeyInService.selectMemDetails(sessionVO);
	    model.addAttribute("userBranch", userBranch);
	    model.addAttribute("memDetail", memDetail);
	    model.addAttribute("memLevel", sessionVO.getMemberLevel());
	    model.addAttribute("memCode", sessionVO.getUserName());
		return "payment/mobileLumpSumPayment/lumpSumEnrollmentList";
	}

	@RequestMapping(value = "/getlumpSumEnrollmentList.do")
	public ResponseEntity<List<EgovMap>> getlumpSumEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> resultList = mobileLumpSumPaymentKeyInService.getLumpSumEnrollmentList(params);
	    return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/saveNormalPayment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNormalPayment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Map<String,Object> result =mobileLumpSumPaymentKeyInService.saveNormalPayment(params,sessionVO);
		ReturnMessage message = new ReturnMessage();

		if(result != null){
		    message.setCode(AppConstants.SUCCESS);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		else{
		    message.setCode(AppConstants.FAIL);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveCardPayment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCardPayment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = mobileLumpSumPaymentKeyInService.savePaymentCard(params,sessionVO);
		ReturnMessage message = new ReturnMessage();

		if(result != null){
		    message.setCode(AppConstants.SUCCESS);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		else{
		    message.setCode(AppConstants.FAIL);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/rejectApproval.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectApproval(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = mobileLumpSumPaymentKeyInService.rejectApproval(params,sessionVO);
		ReturnMessage message = new ReturnMessage();

		if(result != null){
		    message.setCode(AppConstants.SUCCESS);
		    message.setData(result);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		else{
		    message.setCode(AppConstants.FAIL);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkBatchPaymentExist.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> checkBatchPaymentExist(@RequestBody Map<String, Object> params, ModelMap model)
	      throws Exception {
		List<EgovMap> result = mobileLumpSumPaymentKeyInService.checkBatchPaymentExist(params);
	    ReturnMessage message = new ReturnMessage();

		if(result != null && result.size()> 0){
		    message.setCode(AppConstants.FAIL);
		    message.setData(result);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		else{
		    message.setCode(AppConstants.SUCCESS);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/lumpSumReceiptPublic.do")
	public String lumpSumReceiptPublic(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		params.put("mobPayGroupNo", 87);
		EgovMap result = mobileLumpSumPaymentKeyInService.getLumpSumReceiptInfo(params);
		model.put("info", result);
		return "payment/mobileLumpSumPayment/lumpSumReceiptPublic";
	}
}
