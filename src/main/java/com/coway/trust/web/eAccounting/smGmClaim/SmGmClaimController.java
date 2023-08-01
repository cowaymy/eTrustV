package com.coway.trust.web.eAccounting.smGmClaim;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import org.springframework.web.multipart.MultipartFile;
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
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.commission.CommissionConstants;
import com.coway.trust.web.commission.csv.NonIncentiveDataVO;
import com.coway.trust.web.eAccounting.csv.SmGmEntitlementVO;
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
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/smGmClaimMgmt.do")
	public String smGmClaimMgmt(ModelMap model) {
		return "eAccounting/smGmClaim/smGmClaim";
	}

	@RequestMapping(value = "/entitlementMgmt.do")
	public String smGmEntitlementMgmt(ModelMap model) {
		return "eAccounting/smGmClaim/entitlementMgmt";
	}

	@RequestMapping(value = "/entitlementNewPop.do")
	public String smGmEntitlementNewPop(ModelMap model) {
		return "eAccounting/smGmClaim/entitlementNewPop";
	}

	@RequestMapping(value = "/rawDataPop.do")
	public String smGmRawDataPop(ModelMap model) {
		return "eAccounting/smGmClaim/rawDataPop";
	}

	@RequestMapping(value = "/selectSmGmClaimList.do")
	public ResponseEntity<List<EgovMap>> selectSmGmClaimList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

//		String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
//		if(!"A1101".equals(costCentr)) {
//			params.put("loginUserId", sessionVO.getUserId());
//		}

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

	@RequestMapping(value = "/selectSubClaimNo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectSubClaimNo (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		EgovMap clamUn = new EgovMap();
		String subClaimNo = smGmClaimService.selectNextSubClmNo(params);
		clamUn.put("subClaimNo", subClaimNo);

		return ResponseEntity.ok(clamUn);

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
				File.separator + "eAccounting" + File.separator + "smGmClaim", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

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

	@RequestMapping(value = "/updateSmGmClaimExpMain.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSmGmClaimExpMain(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		smGmClaimService.updateSmGmClaimExpMain(params);

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

	@RequestMapping(value = "/approvalSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		smGmClaimService.updateApprovalInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	/*@RequestMapping(value = "/rejectRegistPop.do")
	public String rejectRegistPop(ModelMap model) {
		return "eAccounting/ctDutyAllowance/rejectionOfWebInvoiceRegistMsgPop";
	}*/

	@RequestMapping(value = "/rejectionSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectionSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		List<String> clmNoArray = new ArrayList<String>();
		boolean result = true;

		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
		memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
		params.put("memCode", memCode);

		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("appvPrcssNo", appvPrcssNo);
			param.put("memCode", memCode);

			EgovMap apprDtls = new EgovMap();
            apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
            List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(param);
            List<String> appvLineUserId = new ArrayList<>();
            for(int a = 0; a < appvLineInfo.size(); a++) {
                EgovMap info = appvLineInfo.get(a);
                appvLineUserId.add(info.get("appvLineUserId").toString());
            }

            if(!appvLineUserId.contains(memCode)) {
                param.put("apprGrp", apprDtls.get("apprGrp"));
            }

			int returnData = webInvoiceService.selectAppvStus(param);

			if(returnData > 0) {
				result = false;
				clmNoArray.add(String.valueOf(invoAppvInfo.get("clmNo")));
			}
		}

		ReturnMessage message = new ReturnMessage();

		if(result) {
			smGmClaimService.updateRejectionInfo(params);

			message.setCode(AppConstants.SUCCESS);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			String linesArr = "";
			int count = 0;
			for (String clmNoArr : clmNoArray) {
				linesArr = clmNoArr + ", ";
				count++;
				if(count%3 == 0) {
					linesArr += "<br>";
				}
			}
			linesArr = linesArr.substring(0, linesArr.lastIndexOf(", "));

			params.put("clmNoArr", linesArr);

			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/uploadEntitlement", method = RequestMethod.POST)
	public ResponseEntity<String> readEntitlementExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<SmGmEntitlementVO> vos = csvReadComponent.readCsvToList(multipartFile, true, SmGmEntitlementVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", loginId);
		params.put("excelFile", vos);

		Map<String, Object> result = smGmClaimService.insertEntitlementDetail(params);
		//master
//		Map mMap = new HashMap();
//		mMap.put("uploadID",request.getParameter("type"));
//		mMap.put("statusID","1");
//		if((CommissionConstants.COMIS_NONMON_INCENTIVE).equals(request.getParameter("type"))){
//			String dt = CommonUtils.getCalMonth(-1);
//			mMap.put("actionDate",dt.substring(0,6));
//		}
//		mMap.put("creator",loginId);
//		mMap.put("updator",loginId);
//		mMap.put("memberTypeID",request.getParameter("memberType"));
//
//		smGmClaimService.insertNonIncentiveMaster(mMap);
//		String entId = smGmClaimService.selectEntId(mMap);
//
//		for (SmGmEntitlementVO vo : vos) {
//			Map map = new HashMap();
//
//			//detail
//			map.put("entId",entId);
//			map.put("clmMonth",vo.getMonth());
//			map.put("level",vo.getLevel());
//			map.put("modCode",vo.getManagerCode());
//			map.put("memCode",vo.getHpCode());
//			map.put("crtUser",loginId);
//			map.put("stus","1");
//
//			smGmClaimService.insertEntitlementDetail(map);
//		}
		//smGmClaimService.callNonIncentiveDetail(Integer.parseInt(uploadId));

		return ResponseEntity.ok(result.get("entId").toString());
	}

	@RequestMapping(value = "/selectSmGmEntitlementList.do")
	public ResponseEntity<List<EgovMap>> selectSmGmEntitlementList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String[] entitlementAmt = request.getParameterValues("entAmt");
		String[] memType = request.getParameterValues("memberType");
		String[] entAmt = request.getParameterValues("entAmt");
		//String entMonth = params.get("entMonth").toString().replace("/", "");

		params.put("entitlementAmt", entitlementAmt);
		params.put("memType", memType);
		params.put("entAmt", entAmt);
		//params.put("entMonth", entMonth);

		List<EgovMap> claimList = smGmClaimService.selectSmGmEntitlementList(params);

		return ResponseEntity.ok(claimList);
	}

	@RequestMapping(value = "/selectEntitlement.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectEntitlement(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap detail = smGmClaimService.selectMemberEntitlement(params);

		return ResponseEntity.ok(detail);
	}

	  @RequestMapping(value = "/webInvoiceRqstViewPop.do")
	  public String webInvoiceRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    LOGGER.debug("params =====================================>>  " + params);

	    String clmType = params.get("clmType").toString();

	    List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
	    List<String>rejectReasonList = new ArrayList<String>();
	    for (int i = 0; i < appvLineInfo.size(); i++) {
	      EgovMap info = appvLineInfo.get(i);
//	      if ("J".equals(info.get("appvStus"))) {
	      String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(info);

	      if(rejctResn == null || rejctResn.isEmpty())
	      {
	      }
	      else{
	    	  rejectReasonList.add("-" + rejctResn);
	      }
//	      }
	    }
	    model.addAttribute("rejctResn", String.join("<br/>", rejectReasonList));
	    List<EgovMap> appvInfoAndItems = smGmClaimService.selectAppvInfoAndItems(params);

	    // TODO appvPrcssStus 생성
	    String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

	    // VANNIE ADD TO GET FILE GROUP ID, FILE ID AND FILE COUNT.
	    List<EgovMap> atchFileData = webInvoiceService.selectAtchFileData(params);

	    if (atchFileData.isEmpty()) {
	      model.addAttribute("atchFileCnt", 0);
	    } else {
	      model.addAttribute("atchFileCnt", atchFileData.get(0).get("fileCnt"));
	    }

	    model.addAttribute("appvPrcssStus", appvPrcssStus);
	    model.addAttribute("appvPrcssResult", appvInfoAndItems.get(0).get("appvPrcssStus"));
	    model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));

	    return "eAccounting/webInvoice/webInvoiceRequestViewPop";
	  }

	  @RequestMapping(value = "/getAppvItemOfClmUn.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> getAppvItemOfClmUn(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

			LOGGER.debug("params =====================================>>  " + params);

			EgovMap info = smGmClaimService.selectClaimInfoForAppv(params);
			List<EgovMap> itemGrp = smGmClaimService.selectClaimItemGrpForAppv(params);

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
					attachList.addAll(smGmClaimService.selectAttachList(atchFileGrpIds.get(i)));
				}
				info.put("attachList", attachList);
			}

//			String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
//			LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
//			// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
//			// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
//			if(atchFileGrpId != "null") {
//				List<EgovMap> attachList = staffClaimService.selectAttachList(atchFileGrpId);
//				info.put("attachList", attachList);
//			}

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData(info);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}

	  @RequestMapping(value = "/checkOnceAMonth.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> checkOnceAMonth(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

	        LOGGER.debug("params =====================================>>  " + params);

			int cnt = smGmClaimService.checkOnceAMonth(params);

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
}
