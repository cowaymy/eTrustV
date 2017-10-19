package com.coway.trust.web.eAccounting.invoice;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.common.type.FileType;
import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/webInvoice")
public class WebInvoiceController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(WebInvoiceController.class);
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/webInvoice.do")
	public String webInvoice(ModelMap model) {
		return "eAccounting/webInvoice/webInvoice";
	}
	
	@RequestMapping(value = "/supplierSearchPop.do")
	public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("params", params);
		return "eAccounting/webInvoice/memberAccountSearchPop";
	}
	
	@RequestMapping(value = "/costCenterSearchPop.do")
	public String costCenterSearchPop(ModelMap model) {
		return "eAccounting/webInvoice/costCenterSearchPop";
	}
	
	@RequestMapping(value = "/newWebInvoicePop.do")
	public String newWebInvoice(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));
		
		return "eAccounting/webInvoice/newWebInvoicePop";
	}
	
	@RequestMapping(value = "/viewEditWebInvoicePop.do")
	public String viewEditWebInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		String clmNo = (String)params.get("clmNo");
		EgovMap webInvoiceInfo = webInvoiceService.selectWebInvoiceInfo(clmNo);
		List<EgovMap> webInvoiceItems = webInvoiceService.selectWebInvoiceItems(clmNo);
		LOGGER.debug("webInvoiceItems =====================================>>  " + webInvoiceItems);
		String atchFileGrpId = String.valueOf(webInvoiceInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> webInvoiceAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", webInvoiceAttachList);
		}
		
		model.addAttribute("webInvoiceInfo", webInvoiceInfo);
		model.addAttribute("gridDataList", webInvoiceItems);
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));
		
		return "eAccounting/webInvoice/viewEditWebInvoicePop";
	}
	
	@RequestMapping(value = "/webInvoiceAppvViewPop.do")
	public String webInvoiceAppvViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = (String)params.get("appvPrcssNo");
		
		List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(appvPrcssNo);
		
		// TODO appvPrcssStus 생성
		String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvInfoAndItems);
		
		model.addAttribute("appvPrcssStus", appvPrcssStus);
		model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
		
		return "eAccounting/webInvoice/webInvoiceApproveViewPop";
	}
	
	@RequestMapping(value = "/fileListPop.do")
	public String fileListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String atchFileGrpId = (String) params.get("atchFileGrpId");
		List<EgovMap> attachList = webInvoiceService.selectAttachList(atchFileGrpId);
		
		model.addAttribute("attachList", attachList);
		
		return "eAccounting/webInvoice/attachmentFileViewPop";
	}
	
	@RequestMapping(value = "/approveRegistPop.do")
	public String approveRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/approvalOfWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/approveComplePop.do")
	public String approveComplePop(ModelMap model) {
		return "eAccounting/webInvoice/approvalOfWebInvoiceCompletedMsgPop";
	}
	
	@RequestMapping(value = "/rejectRegistPop.do")
	public String rejectRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/rejectionOfWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/rejectComplePop.do")
	public String rejectComplePop(ModelMap model) {
		return "eAccounting/webInvoice/rejectionOfWebInvoiceCompletedMsgPop";
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/webInvoice/approveLinePop";
	}
	
	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model) {
		return "eAccounting/webInvoice/newWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model) {
		return "eAccounting/webInvoice/newWebInvoiceCompletedMsgPop";
	}
	
	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectSupplier(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectCostCenter.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectcostCenter(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> list = webInvoiceService.selectCostCenter(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectWebInvoiceList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWebInvoiceList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("appvPrcssStus", appvPrcssStus);
		
		List<EgovMap> list = webInvoiceService.selectWebInvoiceList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectApproveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectApproveList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] clmType = request.getParameterValues("clmType");
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("clmType", clmType);
		params.put("appvPrcssStus", appvPrcssStus);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		List<EgovMap> list = webInvoiceService.selectApproveList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(params);
		
		return ResponseEntity.ok(fileInfo);
	}
	
	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		params.put("attachmentList", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertWebInvoiceInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String clmNo = webInvoiceService.selectNextClmNo();
		params.put("clmNo", clmNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		webInvoiceService.insertWebInvoiceInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateWebInvoiceInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		webInvoiceService.updateWebInvoiceInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			// TODO
			// add는 formData로 인해 따로 구현 필요  (file upload 구현 참고) 
			// update or delete file 처리
			// 공통 코드에 현재 미구현으로 불가
			//fileApplication.businessAttach(AppConstants.FILE_WEB, FileVO.createList(list), params);
		}
		
		params.put("attachment", list);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/webInvoiceApprove.do")
	public String approve(ModelMap model) {
		return "eAccounting/webInvoice/webInvoiceApprove";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		String clmNo = (String) params.get("clmNo");
		// 신규 상태에서 submit이면 clmNo = null or ""
		if(StringUtils.isEmpty(clmNo)) {
			clmNo = webInvoiceService.selectNextClmNo();
			params.put("clmNo", clmNo);
		}
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO appvLineMasterTable Insert
		webInvoiceService.insertApproveManagement(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/approvalSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		webInvoiceService.updateApprovalInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/rejectionSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectionSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		webInvoiceService.updateRejectionInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/budgetCheck.do", method = RequestMethod.POST)
	public ResponseEntity<List<Object>> budgetCheck(@RequestBody Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> result = webInvoiceService.budgetCheck(params);
		
		LOGGER.debug("result =====================================>>  " + result);
		
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/selectWebInvoiceItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWebInvoiceItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> itemList = webInvoiceService.selectWebInvoiceItems((String) params.get("clmNo"));
		
		return ResponseEntity.ok(itemList);
	}
}
