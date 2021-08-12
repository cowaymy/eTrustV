package com.coway.trust.web.eAccounting.smGmClaim;

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
import com.coway.trust.biz.eAccounting.smGmClaim.SmGmClaimApplication;
import com.coway.trust.biz.eAccounting.smGmClaim.SmGmClaimService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/smGmClaim")
public class SmGmClaimController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SmGmClaimService smGmClaimService;
	
	@Autowired
	private SmGmClaimApplication smGmClaimApplication;
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@RequestMapping(value = "/smGmClaimMgmt.do")
	public String smGmClaimMgmt(ModelMap model) {
		return "eAccounting/smGmClaim/smGmClaim";
	}
	
	@RequestMapping(value = "/selectSmGmClaimList.do")
	public ResponseEntity<List<EgovMap>> selectSmGmClaimList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("appvPrcssStus", appvPrcssStus);
		
		List<EgovMap> claimList = smGmClaimService.selectSmGmClaimList(params);
		
		return ResponseEntity.ok(claimList);
	}
	
	@RequestMapping(value = "/newSmGmClaimPop.do")
	public String newSmGmClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeFlagList = smGmClaimService.selectTaxCodeSmGmClaimFlag();
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/smGmClaim/smGmClaimNewExpensesPop";
	}
	
	@RequestMapping(value = "/selectTaxCodeSmGmClaimFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeSmGmClaimFlag(Model model) {
		
		List<EgovMap> taxCodeFlagList = smGmClaimService.selectTaxCodeSmGmClaimFlag();
		
		return ResponseEntity.ok(taxCodeFlagList);
	}
	
	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "staffClaim", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		smGmClaimApplication.insertSmGmClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertSmGmClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSmGmClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		smGmClaimService.insertSmGmClaimExp(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectSmGmClaimItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSmGmClaimItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> itemList = smGmClaimService.selectSmGmClaimItems((String) params.get("clmNo"));
		
		return ResponseEntity.ok(itemList);
	}
	
	@RequestMapping(value = "/viewSmGmClaimPop.do")
	public String viewSmGmClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		// TODO selectExpenseItems
		List<EgovMap> itemList = smGmClaimService.selectSmGmClaimItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = smGmClaimService.selectTaxCodeSmGmClaimFlag();
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("clmNo", (String) params.get("clmNo"));
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		if(itemList.size() > 0) {
			model.addAttribute("expGrp", itemList.get(0).get("expGrp"));
			model.addAttribute("appvPrcssNo", itemList.get(0).get("appvPrcssNo"));
		}
		return "eAccounting/smGmClaim/smGmClaimViewExpensesPop";
	}
	
	@RequestMapping(value = "/selectSmGmClaimInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectSmGmClaimInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap info = smGmClaimService.selectSmGmClaimInfo(params);
		List<EgovMap> itemGrp = smGmClaimService.selectSmGmClaimItemGrp(params);
		
		info.put("itemGrp", itemGrp);
		
		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = smGmClaimService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}
		
		return ResponseEntity.ok(info);
	}
	
	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "staffClaim", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
		
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		smGmClaimApplication.updateSmGmClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateSmGmClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSmGmClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		smGmClaimService.updateSmGmClaimExp(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/smGmClaim/approveLinePop";
	}
	
	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(ModelMap model) {
		return "eAccounting/smGmClaim/registrationMsgPop";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO
		smGmClaimService.insertApproveManagement(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/completedMsgPop.do")
	public String completedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/smGmClaim/completedMsgPop";
	}
	
	@RequestMapping(value = "/deleteSmGmClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteSmGmClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		smGmClaimApplication.deleteSmGmClaimAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
}
