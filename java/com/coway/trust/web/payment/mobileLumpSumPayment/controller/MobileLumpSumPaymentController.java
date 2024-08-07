package com.coway.trust.web.payment.mobileLumpSumPayment.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.biz.sales.common.SalesCommonService;
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

    @Resource(name = "encryptionDecryptionService")
    private EncryptionDecryptionService encryptionDecryptionService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/lumpSumEnrollmentList.do")
	public String lumpSumEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> userBranch = memberListService.selectUserBranch();

	    model.addAttribute("userBranch", userBranch);
	    model.addAttribute("memLevel", sessionVO.getMemberLevel());

	    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
		    	sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){
	    		Map<String,Object> userParam = new HashMap();
	    		userParam.put("userId", sessionVO.getUserId());
	    	    EgovMap result =  salesCommonService.getUserInfo(userParam);

	    	    model.addAttribute("orgCode", result.get("orgCode"));
	    	    model.addAttribute("grpCode", result.get("grpCode"));
	    	    model.addAttribute("deptCode", result.get("deptCode"));
	    	    model.addAttribute("memCode", result.get("memCode"));
		}
		return "payment/mobileLumpSumPayment/lumpSumEnrollmentList";
	}

	@RequestMapping(value = "/getlumpSumEnrollmentList.do")
	public ResponseEntity<List<EgovMap>> getlumpSumEnrollmentList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		 String[] statusIdList = request.getParameterValues("ticketStatus");
		 String[] branchIdList = request.getParameterValues("branchCode");
		 String[] regionIdList = request.getParameterValues("cmbRegion");
		 String[] payModeIdList = request.getParameterValues("payMode");

		 params.put("statusIdList",statusIdList);
		 params.put("branchIdList",branchIdList);
		 params.put("regionIdList",regionIdList);
		 params.put("payModeIdList",payModeIdList);

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
		    message.setData(result);
		}
		else{
		    message.setCode(AppConstants.FAIL);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		    message.setData(result);
		}
	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveCardPayment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCardPayment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = mobileLumpSumPaymentKeyInService.savePaymentCard(params,sessionVO);
		ReturnMessage message = new ReturnMessage();

		if(result != null && result.size() > 0){
		    message.setCode(AppConstants.SUCCESS);
		    message.setData(result);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		else{
		    message.setCode(AppConstants.FAIL);
		    message.setData(result);
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
		    message.setData(result);
		    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/lumpSumReceiptPublic.do")
	public String lumpSumReceiptPublic(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Map<String, Object> result = new HashMap<String,Object>();
		String encryptedString = params.get("key").toString().replaceAll(" ", "+");
		String decryptedString = "";
		List<String> splitStringArr = new ArrayList<String>();
		try {
			decryptedString = encryptionDecryptionService.decrypt(encryptedString,"lumpsum");
			LOGGER.debug("decryptedLumpSumId: =====================>> " + decryptedString);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if(decryptedString != null && decryptedString != ""){
	    		params.put("mobPayGroupNo", decryptedString);
	    		EgovMap info = mobileLumpSumPaymentKeyInService.getLumpSumReceiptInfo(params);
	    		model.put("info", info);
			}
		}
		return "payment/mobileLumpSumPayment/lumpSumReceiptPublic";
	}
}
