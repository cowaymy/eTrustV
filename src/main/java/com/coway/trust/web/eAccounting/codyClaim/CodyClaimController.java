package com.coway.trust.web.eAccounting.codyClaim;

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
import com.coway.trust.biz.eAccounting.codyClaim.CodyClaimApplication;
import com.coway.trust.biz.eAccounting.codyClaim.CodyClaimService;
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
@RequestMapping(value = "/eAccounting/codyClaim")
public class CodyClaimController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private CodyClaimService codyClaimService;
	
	@Autowired
	private CodyClaimApplication codyClaimApplication;
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@RequestMapping(value = "/codyClaimMgmt.do")
	public String codyClaimMgmt(ModelMap model) {
		return "eAccounting/codyClaim/codyClaim";
	}
	
	@RequestMapping(value = "/selectCodyClaimList.do")
	public ResponseEntity<List<EgovMap>> selectCodyClaimList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("appvPrcssStus", appvPrcssStus);
		
		List<EgovMap> claimList = codyClaimService.selectCodyClaimList(params);
		
		return ResponseEntity.ok(claimList);
	}
	
	@RequestMapping(value = "/newCodyClaimPop.do")
	public String newCodyClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeFlagList = codyClaimService.selectTaxCodeCodyClaimFlag();
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/codyClaim/codyClaimNewExpensesPop";
	}
	
	@RequestMapping(value = "/selectTaxCodeCodyClaimFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeCodyClaimFlag(Model model) {
		
		List<EgovMap> taxCodeFlagList = codyClaimService.selectTaxCodeCodyClaimFlag();
		
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
		codyClaimApplication.insertCodyClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertCodyClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCodyClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		codyClaimService.insertCodyClaimExp(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectCodyClaimItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodyClaimItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> itemList = codyClaimService.selectCodyClaimItems((String) params.get("clmNo"));
		
		return ResponseEntity.ok(itemList);
	}
	
	@RequestMapping(value = "/viewCodyClaimPop.do")
	public String viewCodyClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		// TODO selectExpenseItems
		List<EgovMap> itemList = codyClaimService.selectCodyClaimItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = codyClaimService.selectTaxCodeCodyClaimFlag();
		
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
		return "eAccounting/codyClaim/codyClaimViewExpensesPop";
	}
	
	@RequestMapping(value = "/selectCodyClaimInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectCodyClaimInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap info = codyClaimService.selectCodyClaimInfo(params);
		List<EgovMap> itemGrp = codyClaimService.selectCodyClaimItemGrp(params);
		
		info.put("itemGrp", itemGrp);
		
		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = codyClaimService.selectAttachList(atchFileGrpId);
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
		codyClaimApplication.updateCodyClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		
		params.put("attachFiles", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateCodyClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCodyClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		codyClaimService.updateCodyClaimExp(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/codyClaim/approveLinePop";
	}
	
	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(ModelMap model) {
		return "eAccounting/codyClaim/registrationMsgPop";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO
		codyClaimService.insertApproveManagement(params);
		
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
		return "eAccounting/codyClaim/completedMsgPop";
	}
	
	@RequestMapping(value = "/deleteCodyClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteCodyClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO insert
		codyClaimApplication.deleteCodyClaimAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectSchemaOfMemType.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSchemaOfMemType(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap result = codyClaimService.selectSchemaOfMemType(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
}
