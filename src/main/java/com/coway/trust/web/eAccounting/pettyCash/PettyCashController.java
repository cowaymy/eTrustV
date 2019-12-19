package com.coway.trust.web.eAccounting.pettyCash;

import java.io.File;
import java.util.ArrayList;
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
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashApplication;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/pettyCash")
public class PettyCashController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private PettyCashService pettyCashService;

	@Autowired
	private PettyCashApplication pettyCashApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/pettyCashCustodian.do")
	public String pettyCashCustodian(ModelMap model) {
		return "eAccounting/pettyCash/pettyCashCustodianManagement";
	}

	@RequestMapping(value = "/selectCustodianList.do")
	public ResponseEntity<List<EgovMap>> selectCustodianList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> custodianList = pettyCashService.selectCustodianList(params);

		return ResponseEntity.ok(custodianList);
	}

	@RequestMapping(value = "/newCustodianPop.do")
	public String newCustodianPop(ModelMap model, SessionVO sessionVO) {
		model.addAttribute("userId", sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		return "eAccounting/pettyCash/pettyCashNewCustodianPop";
	}

	@RequestMapping(value = "/selectUserNric.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectUserNric(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		String memAccId = (String) params.get("memAccId");

		String userNric = pettyCashService.selectUserNric(memAccId);

		params.put("userNric", userNric);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianRegistMsgPop";
	}

  @RequestMapping(value = "/insertCustodian.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertCustodian(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
    
    LOGGER.debug("params =====================================>>  " + params);
    
    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
        File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
    
    LOGGER.debug("list.size : {}", list.size());
    
    params.put("attachmentList", list);
    params.put(CommonConstants.USER_ID, sessionVO.getUserId());
    params.put("userName", sessionVO.getUserName());
    
    // TODO insert
    boolean custdnResult = pettyCashApplication.insertCustodianBiz(FileVO.createList(list),
        FileType.WEB_DIRECT_RESOURCE, params);
    
    ReturnMessage message = new ReturnMessage();
    
    if (custdnResult) {
      message.setCode(AppConstants.SUCCESS);
      message.setData(params);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setData(params);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    }
    
    return ResponseEntity.ok(message);
  }

	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianCompletedMsgPop";
	}

	@RequestMapping(value = "/viewCustodianPop.do")
	public String viewCustodianPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap custodianInfo = pettyCashService.selectCustodianInfo(params);

		String atchFileGrpId = String.valueOf(custodianInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> custodianAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", custodianAttachList);
		}
		model.addAttribute("custodianInfo", custodianInfo);
		return "eAccounting/pettyCash/pettyCashViewEditCustodianPop";
	}

	@RequestMapping(value = "/editRegistMsgPop.do")
	public String editRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/editCustodianRegistMsgPop";
	}

	@RequestMapping(value = "/updateCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCustodian(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO update
		pettyCashApplication.updateCustodianBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/viewCompletedMsgPop.do")
	public String viewCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/viewCustodianCompletedMsgPop";
	}

	@RequestMapping(value = "/removeRegistMsgPop.do")
	public String removeRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/removeCustodianRegistMsgPop";
	}

	@RequestMapping(value = "/deleteCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteCustodian(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO delete
		pettyCashApplication.deleteCustodianBiz(FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/removeCompletedMsgPop.do")
	public String deleteCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/removeCustodianCompletedMsgPop";
	}

	@RequestMapping(value = "/pettyCashRequest.do")
	public String pettyCashRequest(ModelMap model) {
		return "eAccounting/pettyCash/pettyCashRequest";
	}

	@RequestMapping(value = "/selectRequestList.do")
	public ResponseEntity<List<EgovMap>> selectRequestList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}

		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

		params.put("appvPrcssStus", appvPrcssStus);

		List<EgovMap> requestList = pettyCashService.selectRequestList(params);

		return ResponseEntity.ok(requestList);
	}

	@RequestMapping(value = "/newRequestPop.do")
	public String newRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		return "eAccounting/pettyCash/pettyCashNewRequestPop";
	}

	@RequestMapping(value = "/selectCustodianInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectCustodianInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap custodianInfo = pettyCashService.selectCustodianInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(custodianInfo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertPettyCashReqst.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertPettyCashReqst(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		pettyCashApplication.insertPettyCashReqstBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/viewRequestPop.do")
	public String viewRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap requestInfo = pettyCashService.selectRequestInfo(params);

		String atchFileGrpId = String.valueOf(requestInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> requestAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", requestAttachList);
		}
		model.addAttribute("requestInfo", requestInfo);
		model.addAttribute("callType", params.get("callType"));
		return "eAccounting/pettyCash/pettyCashViewEditRequestPop";
	}

	@RequestMapping(value = "/updatePettyCashReqst.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePettyCashReqst(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("updatePettyCashReqst ===============================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		params.put("attachmentList", list);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO update
		pettyCashApplication.updatePettyCashReqstBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/reqstApproveLinePop.do")
	public String reqstApproveLinePop(ModelMap model) {
		return "eAccounting/pettyCash/reqstApproveLinePop";
	}

  @RequestMapping(value = "/reqstApproveLineSubmit.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> reqstApproveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    
    // VANNIE ADD TO SELECT ATCH FILE GROUP ID FROM F12 TABLE.
    
    String atchFileGrpId = webInvoiceService.selectFCM12Data(params);
    String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
    params.put("appvPrcssNo", appvPrcssNo);
    params.put(CommonConstants.USER_ID, sessionVO.getUserId());
    params.put("userName", sessionVO.getUserName());
    params.put("atchFileGrpId", atchFileGrpId);
    
    LOGGER.debug("reqstApproveLineSubmit ==========================>>  " + params);
    
    // TODO
    pettyCashService.insertRqstApproveManagement(params);
    
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(params);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    return ResponseEntity.ok(message);
  }

	@RequestMapping(value = "/reqstRegistrationMsgPop.do")
	public String reqstRegistrationMsgPop(ModelMap model) {
		return "eAccounting/pettyCash/reqstRegistrationMsgPop";
	}

	@RequestMapping(value = "/reqstCompletedMsgPop.do")
	public String reqstCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/pettyCash/reqstCompletedMsgPop";
	}

	@RequestMapping(value = "/expenseMgmt.do")
	public String expenseMgmt(@RequestParam Map<String, Object> params, ModelMap model) {
	    if (params.get("clmNo") != null && params.get("period") != null) {
            String clmNo = (String) params.get("clmNo");
            String period = (String) params.get("period");

            model.addAttribute("clmNo", clmNo);
            model.addAttribute("period", period.substring(4) + "/" + period.substring(0, 4));
        }

		return "eAccounting/pettyCash/pettyCashExpense";
	}

	@RequestMapping(value = "/selectExpenseList.do")
	public ResponseEntity<List<EgovMap>> selectExpenseList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}

		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

		params.put("appvPrcssStus", appvPrcssStus);

		List<EgovMap> expenseList = pettyCashService.selectExpenseList(params);

		return ResponseEntity.ok(expenseList);
	}

	@RequestMapping(value = "/newExpensePop.do")
	public String newExpensePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeList = pettyCashService.selectTaxCodePettyCashFlag();

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		return "eAccounting/pettyCash/pettyCashNewExpensePop";
	}

	@RequestMapping(value = "/selectTaxCodePettyCashFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodePettyCashFlag(Model model) {

		List<EgovMap> taxCodeFlagList = pettyCashService.selectTaxCodePettyCashFlag();

		return ResponseEntity.ok(taxCodeFlagList);
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		pettyCashApplication.insertPettyCashAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertPettyCashExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertPettyCashExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		pettyCashService.insertPettyCashExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectExpenseItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectExpenseItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = pettyCashService.selectExpenseItems((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/selectExpenseInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectExpenseInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = pettyCashService.selectExpenseInfo(params);
		List<EgovMap> itemGrp = pettyCashService.selectExpenseItemGrp(params);

		info.put("itemGrp", itemGrp);

		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = pettyCashService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}

		return ResponseEntity.ok(info);
	}

	@RequestMapping(value = "/viewExpensePop.do")
	public String viewExpensePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		// TODO selectExpenseItems
		List<EgovMap> itemList = pettyCashService.selectExpenseItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeList = pettyCashService.selectTaxCodePettyCashFlag();

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("itemList", new Gson().toJson(itemList));
		model.addAttribute("clmNo", (String) params.get("clmNo"));
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("prevClmNo", (String) params.get("prevClmNo"));
		if(itemList.size() > 0) {
			model.addAttribute("appvPrcssNo", itemList.get(0).get("appvPrcssNo"));
		}
		return "eAccounting/pettyCash/pettyCashViewEditExpensePop";
	}

	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		pettyCashApplication.updatePettyCashAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updatePettyCashExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePettyCashExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		pettyCashService.updatePettyCashExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/expApproveLinePop.do")
	public String expApproveLinePop(ModelMap model) {
		return "eAccounting/pettyCash/expApproveLinePop";
	}

	@RequestMapping(value = "/expRegistrationMsgPop.do")
	public String expRegistrationMsgPop(ModelMap model) {
		return "eAccounting/pettyCash/expRegistrationMsgPop";
	}

	@RequestMapping(value = "/expApproveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> expApproveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO
		pettyCashService.insertExpApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/expCompletedMsgPop.do")
	public String expCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/pettyCash/expCompletedMsgPop";
	}

	@RequestMapping(value = "/deletePettyCashExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deletePettyCashExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		pettyCashApplication.deletePettyCashAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getAppvItemOfClmUn.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getAppvItemOfClmUn(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = pettyCashService.selectExpenseInfoForAppv(params);
		List<EgovMap> itemGrp = pettyCashService.selectExpenseItemGrpForAppv(params);

		info.put("itemGrp", itemGrp);

		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = pettyCashService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(info);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String clmNo = pettyCashService.selectNextExpClmNo();
        params.put("newClmNo", clmNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        pettyCashService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
}
