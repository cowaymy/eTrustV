package com.coway.trust.web.eAccounting.creditCard;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardApplication;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/creditCard")
public class CreditCardController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private CreditCardService creditCardService;
	
	@Autowired
	private CreditCardApplication creditCardApplication;
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@RequestMapping(value = "/creditCardMgmt.do")
	public String creditCardMgmt(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagement";
	}
	
	@RequestMapping(value = "/selectCrditCardMgmtList.do")
	public ResponseEntity<List<EgovMap>> selectCrditCardMgmtList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] crditCardStus = request.getParameterValues("crditCardStus");
		
		params.put("crditCardStus", crditCardStus);
		
		List<EgovMap> mgmtList = creditCardService.selectCrditCardMgmtList(params);
		
		return ResponseEntity.ok(mgmtList);
	}
	
	@RequestMapping(value = "/newMgmtPop.do")
	public String newMgmtPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		return "eAccounting/creditCard/creditCardManagementNewPop";
	}
	
	@RequestMapping(value = "/selectBankCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBankCode(Model model) {
		
		List<EgovMap> bankCodeList = creditCardService.selectBankCode();
		
		return ResponseEntity.ok(bankCodeList);
	}
	
	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementNewRgistPop";
	}
	
	@RequestMapping(value = "/insertCreditCard.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCreditCard(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		int crditCardSeq = creditCardService.selectNextCrditCardSeq();
		params.put("crditCardSeq", crditCardSeq);
		
		// TODO insert
		creditCardApplication.insertCreditCardBiz(FileVO.createList(list), FileType.WEB, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementNewCompltedPop";
	}
	
	@RequestMapping(value = "/viewMgmtPop.do")
	public String viewMgmtPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap crditCardInfo = creditCardService.selectCrditCardInfo(params);
		
		String atchFileGrpId = String.valueOf(crditCardInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> crditCardAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", crditCardAttachList);
		}
		
		model.addAttribute("crditCardInfo", crditCardInfo);
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		return "eAccounting/creditCard/creditCardManagementViewPop";
	}
	
	@RequestMapping(value = "/viewRegistMsgPop.do")
	public String viewRegistMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementViewRgistPop";
	}
	
	@RequestMapping(value = "/updateCreditCard.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCreditCard(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO update
		creditCardApplication.updateCreditCardBiz(FileVO.createList(list), FileType.WEB, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/viewCompletedMsgPop.do")
	public String viewCompletedMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementViewCompltedPop";
	}
	
	@RequestMapping(value = "/removeRegistMsgPop.do")
	public String removeRegistMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementRemoveRgistPop";
	}
	
	@RequestMapping(value = "/removeCreditCard.do")
	public ResponseEntity<ReturnMessage> removeCreditCard(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		EgovMap crditCardInfo = creditCardService.selectCrditCardInfo(params);
		
		params.put("crditCardNo", crditCardInfo.get("crditCardNo"));
		params.put("crditCardUserId", crditCardInfo.get("crditCardUserId"));
		params.put("costCentr", crditCardInfo.get("costCentr"));
		params.put("bankCode", crditCardInfo.get("bankCode"));
		
		creditCardApplication.removeCreditCardBiz(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/removeCompletedMsgPop.do")
	public String removeCompletedMsgPop(ModelMap model) {
		return "eAccounting/creditCard/creditCardManagementRemoveCompltedPop";
	}

}
