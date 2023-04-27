package com.coway.trust.web.eAccounting.staffClaim;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimApplication;
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimService;
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
@RequestMapping(value = "/eAccounting/staffClaim")
public class StaffClaimController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private StaffClaimService staffClaimService;

	@Autowired
	private StaffClaimApplication staffClaimApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/staffClaimMgmt.do")
    public String staffClaimMgmt(@RequestParam Map<String, Object> params, ModelMap model) {
        if (params.get("clmNo") != null && params.get("period") != null) {
            String clmNo = (String) params.get("clmNo");
            String period = (String) params.get("period");

            model.addAttribute("clmNo", clmNo);
            model.addAttribute("period", period.substring(4) + "/" + period.substring(0, 4));
        }

        return "eAccounting/staffClaim/staffClaim";
    }

	@RequestMapping(value = "/selectStaffClaimList.do")
	public ResponseEntity<List<EgovMap>> selectStaffClaimList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr) && !params.get("pageAuthFuncUserDefine1").equals("Y")) {
			 params.put("loginUserId", sessionVO.getUserId());
		}

		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

		params.put("appvPrcssStus", appvPrcssStus);

		List<EgovMap> claimList = staffClaimService.selectStaffClaimList(params);

		return ResponseEntity.ok(claimList);
	}

	@RequestMapping(value = "/newStaffClaimPop.do")
	public String newStaffClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/staffClaim/staffClaimNewExpensesPop";
	}

	 @RequestMapping(value = "/staffClaimExcelDownloadPop.do")
		public String staffClaimExcelDownloadPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
			return "eAccounting/staffClaim/staffClaimExcelDownloadPop";
	 }

	@RequestMapping(value = "/selectTaxCodeStaffClaimFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeStaffClaimFlag(Model model) {

		List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

		return ResponseEntity.ok(taxCodeFlagList);
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "staffClaim", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		if(list.size() > 0){
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			// serivce 에서 파일정보를 가지고, DB 처리.
			staffClaimApplication.insertStaffClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

			params.put("attachFiles", list);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertStaffClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertStaffClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		staffClaimService.insertStaffClaimExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectStaffClaimItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStaffClaimItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = staffClaimService.selectStaffClaimItems((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/viewStaffClaimPop.do")
	public String viewStaffClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		// TODO selectExpenseItems
		List<EgovMap> itemList = staffClaimService.selectStaffClaimItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

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
		return "eAccounting/staffClaim/staffClaimViewExpensesPop";
	}

	@RequestMapping(value = "/selectStaffClaimInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectStaffClaimInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = staffClaimService.selectStaffClaimInfo(params);
		List<EgovMap> itemGrp = staffClaimService.selectStaffClaimItemGrp(params);

		for(int i=0;i < itemGrp.size();i++)
		{
			if(itemGrp.get(i).get("atchFileGrpId") != null && itemGrp.get(i).get("atchFileGrpId").toString() != ""){
				List<EgovMap> attachList = staffClaimService.selectAttachList(itemGrp.get(i).get("atchFileGrpId").toString());
				itemGrp.get(i).put("attachList", attachList);
			}
		}

		info.put("itemGrp", itemGrp);
		return ResponseEntity.ok(info);
	}

	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "staffClaim", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		staffClaimApplication.updateStaffClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateStaffClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateStaffClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		staffClaimService.updateStaffClaimExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(@RequestParam Map<String, Object> params,ModelMap model) {
		//For RequestGroup Staff Claim enhancement, get user's cost center and put into requestGroup param
		//Task on hold until further request. Start here

		model.put("clmType", params.get("clmType").toString());
		model.put("memAccId", params.get("memAccId").toString());
		model.put("clmMonth", params.get("clmMonth").toString());
		return "eAccounting/staffClaim/approveLinePop";
	}

	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(@RequestParam Map<String, Object> params,ModelMap model) {
//		model.put("requestGroup", params.get("requestGroup").toString());
		return "eAccounting/staffClaim/registrationMsgPop";
	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO
		staffClaimService.insertApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/completedMsgPop.do", method = RequestMethod.POST)
	public String completedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/staffClaim/completedMsgPop";
	}

	@RequestMapping(value = "/deleteStaffClaimExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteStaffClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		staffClaimApplication.deleteStaffClaimAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getAppvItemOfClmUn.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getAppvItemOfClmUn(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = staffClaimService.selectStaffClaimInfoForAppv(params);
		List<EgovMap> itemGrp = staffClaimService.selectStaffClaimItemGrpForAppv(params);

		List<String> atchFileGrpIds = new ArrayList<String>();

		if(itemGrp.size() > 0){
			List<String> atchFileGrpIdsTemp = new ArrayList<String>();
			for(int i = 0; i < itemGrp.size(); i++){
				EgovMap itemInfo = itemGrp.get(i);
				if(itemInfo.get("atchFileGrpId") != null){
					String atchFileGrpId = String.valueOf(itemInfo.get("atchFileGrpId"));
					atchFileGrpIdsTemp.add(atchFileGrpId);
				}
			}

			if(atchFileGrpIdsTemp.size() >0){
				atchFileGrpIds = atchFileGrpIdsTemp.stream().distinct().collect(Collectors.toList());
			}
		}


		info.put("itemGrp", itemGrp);

		if(atchFileGrpIds.size() > 0) {
			List<EgovMap> attachList = new ArrayList();
			for(int i = 0; i < atchFileGrpIds.size(); i++){
				attachList.addAll(staffClaimService.selectAttachList(atchFileGrpIds.get(i)));
			}
			info.put("attachList", attachList);
		}

//		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
//		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
//		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
//		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
//		if(atchFileGrpId != "null") {
//			List<EgovMap> attachList = staffClaimService.selectAttachList(atchFileGrpId);
//			info.put("attachList", attachList);
//		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(info);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkOnceAMonth.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkOnceAMonth(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

		int cnt = staffClaimService.checkOnceAMonth(params);

		ReturnMessage message = new ReturnMessage();

		if(cnt > 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage("You can only request once a month.");
		} else {
			message.setCode(AppConstants.SUCCESS);
		}
		message.setData(cnt);

		return ResponseEntity.ok(message);
	}

	 @RequestMapping(value = "/editRejectedClaim.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> editRejectedClaim(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

	        LOGGER.debug("params =====================================>>  " + params);

	        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

	        ReturnMessage message = new ReturnMessage();
	        message = staffClaimService.editRejectedClaimExp(params);

	        return ResponseEntity.ok(message);
	 }

	 @RequestMapping(value = "/selectExcelListNew.do")
		public ResponseEntity<List<EgovMap>> selectExcelListNew(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

			String[] status = request.getParameterValues("status");
			params.put("status", status);

			if(params.get("staffMemAccId") != null && params.get("staffMemAccId") != ""){
				String[] memAccIdList = params.get("staffMemAccId").toString().split(",");
				params.put("staffMemAccId", memAccIdList);
			}
			else{
				params.put("staffMemAccId", null);
			}

			if(params.get("costCenter") != null && params.get("costCenter") != ""){
				String[] costCenterList = params.get("costCenter").toString().split(",");
				List<String> costCenterFinal = new ArrayList<String>();
				for(int i = 0; i<costCenterList.length;i++){
					if(!costCenterList[i].trim().equals("")){
						costCenterFinal.add(costCenterList[i]);
					}
				}
				if(costCenterFinal.size() > 0){
					params.put("costCentr", costCenterFinal.toArray());
				}
				else{
					params.put("costCentr", null);
				}
			}
			else{
				params.put("costCentr", null);
			}
			LOGGER.debug("params =====================================>>  " + params);

			List<EgovMap> excelList = staffClaimService.selectExcelListNew(params);

			return ResponseEntity.ok(excelList);
		}
}
