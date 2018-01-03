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
import org.springframework.web.bind.annotation.RequestBody;
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
import com.google.gson.Gson;

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
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		int crditCardSeq = creditCardService.selectNextCrditCardSeq();
		params.put("crditCardSeq", crditCardSeq);
		
		// TODO insert
		creditCardApplication.insertCreditCardBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		
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
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO update
		creditCardApplication.updateCreditCardBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		
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
	
	@RequestMapping(value = "/creditCardReimbursement.do")
	public String creditCardReimbursement(ModelMap model) {
		return "eAccounting/creditCard/creditCardReimbursement";
	}
	
	@RequestMapping(value = "/selectReimbursementList.do")
	public ResponseEntity<List<EgovMap>> selectReimbursementList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("appvPrcssStus", appvPrcssStus);
		
		List<EgovMap> reimbursementList = creditCardService.selectReimbursementList(params);
		
		return ResponseEntity.ok(reimbursementList);
	}
	
	@RequestMapping(value = "/newReimbursementPop.do")
	public String newReimbursementPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeFlagList = creditCardService.selectTaxCodeCreditCardFlag();
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/creditCard/creditCardNewReimbursementPop";
	}
	
	@RequestMapping(value = "/selectTaxCodeCreditCardFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeCreditCardFlag(Model model) {
		
		List<EgovMap> taxCodeFlagList = creditCardService.selectTaxCodeCreditCardFlag();
		
		return ResponseEntity.ok(taxCodeFlagList);
	}
	
	@RequestMapping(value = "/selectCrditCardInfoByNo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCrditCardInfoByNo(@RequestParam Map<String, Object> params, Model model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap creditCardInfo = creditCardService.selectCrditCardInfoByNo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(creditCardInfo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		creditCardApplication.insertReimbursementAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertReimbursement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertReimbursement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		creditCardService.insertReimbursement(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectReimbursementItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReimbursementItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> itemList = creditCardService.selectReimbursementItems((String) params.get("clmNo"));
		
		return ResponseEntity.ok(itemList);
	}
	
	@RequestMapping(value = "/viewReimbursementPop.do")
	public String viewReimbursementPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		// TODO selectExpenseItems
		List<EgovMap> itemList = creditCardService.selectReimbursementItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = creditCardService.selectTaxCodeCreditCardFlag();
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("clmNo", (String) params.get("clmNo"));
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		if(itemList.size() > 0) {
			model.addAttribute("appvPrcssNo", itemList.get(0).get("appvPrcssNo"));
		}
		return "eAccounting/creditCard/creditCardViewReimbursementPop";
	}
	
	@RequestMapping(value = "/selectReimbursementInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectReimbursementInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap info = creditCardService.selectReimburesementInfo(params);
		List<EgovMap> itemGrp = creditCardService.selectReimbursementItemGrp(params);
		
		info.put("itemGrp", itemGrp);
		
		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = creditCardService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}
		
		return ResponseEntity.ok(info);
	}
	
	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "creditCard", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		creditCardApplication.updateReimbursementAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateReimbursement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateReimbursement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		creditCardService.updateReimbursement(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/creditCard/approveLinePop";
	}
	
	@RequestMapping(value = "/appvRegistrationMsgPop.do")
	public String appvRegistrationMsgPop(ModelMap model) {
		return "eAccounting/creditCard/appvRegistrationMsgPop";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO
		creditCardService.insertApproveManagement(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/appvCompletedMsgPop.do")
	public String expCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/creditCard/appvCompletedMsgPop";
	}
	
	@RequestMapping(value = "/deleteReimbursement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteReimbursement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		creditCardApplication.deleteReimbursementAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectCreditCardNoToMgmt.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCreditCardNoToMgmt(Model model) {
		
		List<EgovMap> creditCardNoList = creditCardService.selectCreditCardNoToMgmt();
		
		return ResponseEntity.ok(creditCardNoList);
	}
	
	@RequestMapping(value = "/getAppvItemOfClmUn.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getAppvItemOfClmUn(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap info = creditCardService.selectReimburesementInfoForAppv(params);
		List<EgovMap> itemGrp = creditCardService.selectReimbursementItemGrp(params);
		
		info.put("itemGrp", itemGrp);
		
		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = creditCardService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(info);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}

}
