package com.coway.trust.web.payment.refund.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.businessobjects.report.web.event.ba;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.refund.service.BatchRefundService;
import com.coway.trust.biz.payment.refund.service.BatchRefundVO;
import com.coway.trust.biz.payment.refund.service.RefundApplication;
import com.coway.trust.biz.payment.refund.service.RefundService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class RefundController {
	
private static final Logger LOGGER = LoggerFactory.getLogger(RefundController.class);
	
	@Resource(name = "refundService")
	private RefundService refundService;
	
	@Autowired
	private BatchRefundService batchRefundService;
	
	@Autowired
	private RefundApplication refundApplication;
	
	@RequestMapping(value = "/refund.do")
	public String initSearchPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/refund/refund";
	}
	
	@RequestMapping(value = "/selectRefundList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRefundList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] cancelMode = request.getParameterValues("cancelMode");
		String[] payMode = request.getParameterValues("payMode");
		
		params.put("cancelMode", cancelMode);
		params.put("payMode", payMode);
		
		List<EgovMap> list = refundService.selectRefundList(params);
		
		LOGGER.debug("list =====================================>>  " + list.toString());
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/refundConfirmPop.do")
	public String refundConfirmPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/refund/refundConfirmPop";
	}
	
	@RequestMapping(value = "/checkRefundValid.do", method = RequestMethod.POST)	
	public ResponseEntity<ReturnMessage> checkRefundValid(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params =====================================>>  " + params);
		ReturnMessage message = new ReturnMessage();
		//Grid Select Row Get
		List<Object> gridDataList = (List<Object>) params.get("gridDataList");
		
		List<Integer> resultList = new ArrayList();
		for(int i = 0; i < gridDataList.size(); i ++) {
			int result = 0;
			List<Object> gridData = (List<Object>) gridDataList.get(i);
			if(gridData.size() > 0) {
				result = refundApplication.refundValidChecking(gridData, sessionVO);
				if(result > 0) {
					resultList.add(result);
				}
			}
		}
		
		if(resultList.size() > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);
			String batchId = "";
			for(int x = 0; x < resultList.size(); x++) {
				if(x == 0) {
					batchId = String.valueOf(resultList.get(x));
				} else {
					batchId += ", " + String.valueOf(resultList.get(x));
				}
			}
    		
    		message.setMessage("Refund item(s) successfully uploaded.<br />Batch ID : "+ batchId);
    		message.setData(resultList);
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to upload refund item(s). Please try again later.");
			message.setCode(AppConstants.FAIL);
		}
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/getConfirmRefund.do", method = RequestMethod.POST)	
	public ResponseEntity<EgovMap> getConfirmRefund(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap bRefundInfo = refundService.selectRefundInfo(params);
		
		return ResponseEntity.ok(bRefundInfo);
	}
	
	@RequestMapping(value = "/refundInfoKeyInPop.do")
	public String refundInfoKeyInPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("creditCardNo", params.get("creditCardNo"));
		model.addAttribute("creditCardHolder", params.get("creditCardHolder"));
		return "payment/refund/refundInfoKeyInPop";
	}
	
	@RequestMapping(value = "/refundConfirm.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> refundConfirm(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		LOGGER.debug("params =====================================>>  " + params);
		
		ReturnMessage message = new ReturnMessage();
		
		List<Object> batchIdList = (List<Object>) params.get("batchIdList");
		
		int result = refundApplication.refundConfirm(batchIdList, sessionVO);
		if(result > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);
    		
    		message.setMessage("Refund has been confirmed.");
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to confirm this refund. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}
		

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/refundItemDisab.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> refundItemDisab(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> master = new HashMap<String, Object>();
		String detId = String.valueOf(params.get("detId"));
		
		master.put("detId", detId);
		master.put("disabled", 1);
		master.put("updator", sessionVO.getUserId());
		
		int result = batchRefundService.batchRefundItemDisab(master);
		if(result > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);
			
			EgovMap bRefundInfo = refundService.selectRefundInfo(params);
    		
    		message.setMessage("Refund item has been removed.");
    		message.setData(bRefundInfo);
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to remove refund item. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}
		

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)	
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> codeList = refundService.selectCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/selectBankCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBankCode(Model model) {
		
		List<EgovMap> bankCodeList = refundService.selectBankCode();
		
		return ResponseEntity.ok(bankCodeList);
	}
	

}
