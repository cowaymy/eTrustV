package com.coway.trust.web.eAccounting.ctDutyAllowance;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
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
import com.coway.trust.biz.eAccounting.ctDutyAllowance.CtDutyAllowanceApplication;
import com.coway.trust.biz.eAccounting.ctDutyAllowance.CtDutyAllowanceService;
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
@RequestMapping(value = "/eAccounting/ctDutyAllowance")
public class CtDutyAllowanceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CtDutyAllowanceService ctDutyAllowanceService;

	@Autowired
	private CtDutyAllowanceApplication ctDutyAllowanceApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/ctDutyAllowanceMgmt.do")
	public String ctDutyAllowanceMgmt(ModelMap model) {
		return "eAccounting/ctDutyAllowance/ctDutyAllowance";
	}

	@RequestMapping(value = "/selectCtDutyAllowanceList.do")
	public ResponseEntity<List<EgovMap>> selectCtDutyAllowanceList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		/*String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
		if(!"A1101".equals(costCentr)) {
			params.put("loginUserId", sessionVO.getUserId());
		}*/

		/*if(sessionVO.getRoleId() == 127){
			params.put("loginUserId", sessionVO.getUserId());
		}*/
		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

		params.put("appvPrcssStus", appvPrcssStus);

		List<EgovMap> claimList = ctDutyAllowanceService.selectCtDutyAllowanceList(params);

		return ResponseEntity.ok(claimList);
	}

	@RequestMapping(value = "/newCtDutyAllowancePop.do")
	public String newCtDutyAllowancePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		//List<EgovMap> taxCodeFlagList = ctDutyAllowanceService.selectTaxCodeCtDutyAllowanceFlag();

		model.addAttribute("clmNo", params.get("clmNo")==null?"":params.get("clmNo"));
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		//model.addAttribute("costCentr", sessionVO.getCostCentr());
		//model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
		return "eAccounting/ctDutyAllowance/ctDutyAllowanceNewExpensesPop";
	}

	@RequestMapping(value = "/ctCodeSearchPop.do")
	public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("accGrp", params.get("accGrp"));
		model.addAttribute("entry", params.get("entry"));
		return "eAccounting/ctDutyAllowance/memberAccountSearchPop";
	}

	@RequestMapping(value = "/searchOrderNoPop.do")
	public String	searchOrderNoPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		model.addAttribute("paramsList", params);
		return "eAccounting/ctDutyAllowance/ctDutyAllowanceSearchOrderNoPop";
	}

	@RequestMapping(value = "/selectSearchOrderNo")
	public ResponseEntity<List<EgovMap>> selectSearchOrderNo (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{

		List<EgovMap> ordList = null;

		String appType [] = request.getParameterValues("searchOrdAppType");

		params.put("appType", appType);

		String insType = params.get("searchSvcType").toString();
		if(insType.equals("INS")){
			ordList = ctDutyAllowanceService.selectSearchInsOrderNo(params);
		}else if(insType.equals("AS")){
			ordList = ctDutyAllowanceService.selectSearchAsOrderNo(params);
		}else if(insType.equals("PR")){
			ordList = ctDutyAllowanceService.selectSearchPrOrderNo(params);
		}

		return ResponseEntity.ok(ordList);

	}

	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = ctDutyAllowanceService.selectSupplier(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "ctDutyAllowance", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		ctDutyAllowanceApplication.insertCtDutyAllowanceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());

		if(fileInfo != null){
			params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
		}
		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCtDutyAllowanceMainSeq.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCtDutyAllowanceMainSeq(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		String mainSeq = ctDutyAllowanceService.selectCtDutyAllowanceMainSeq(params);

		params.put("mainSeq", mainSeq);
		ctDutyAllowanceService.updateCtDutyAllowanceMainSeq(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCtDutyAllowanceSubSeq.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCtDutyAllowanceSubSeq(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		String subSeq = ctDutyAllowanceService.selectCtDutyAllowanceSubSeq(params);

		params.put("subSeq", subSeq);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertCtDutyAllowanceExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCtDutyAllowanceExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		ctDutyAllowanceService.insertCtDutyAllowanceExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/viewCtDutyAllowancePop.do")
	public String viewCtDutyAllowancePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		// TODO selectExpenseItems
		List<EgovMap> itemList = ctDutyAllowanceService.selectCtDutyAllowanceItems((String) params.get("clmNo"));
		List<EgovMap> taxCodeFlagList = ctDutyAllowanceService.selectTaxCodeCtDutyAllowanceFlag();

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
		return "eAccounting/ctDutyAllowance/ctDutyAllowanceViewExpensesPop";
	}

	@RequestMapping(value = "/selectCtDutyAllowanceItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCtDutyAllowanceItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = ctDutyAllowanceService.selectCtDutyAllowanceItems((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/deleteCtDutyAllowanceExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteCtDutyAllowanceExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		ctDutyAllowanceService.deleteCtDutyAllowanceItem(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateCtDutyAllowanceExp.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCtDutyAllowanceExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO insert
		ctDutyAllowanceService.updateCtDutyAllowanceExp(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkOnceAMonth.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkOnceAMonth(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

		int cnt = ctDutyAllowanceService.checkOnceAMonth(params);

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

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		model.addAttribute("clmNo", params.get("clmNo"));
		model.addAttribute("totAmt", params.get("totAmt"));
		model.addAttribute("memAccId", params.get("memAccId"));

		return "eAccounting/ctDutyAllowance/approveLinePop";
	}

	@RequestMapping(value = "/registrationMsgPop.do")
	public String registrationMsgPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "eAccounting/ctDutyAllowance/registrationMsgPop";
	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO
		ctDutyAllowanceService.insertApproveManagement(params);

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
		model.addAttribute("memAccId", params.get("memAccId"));
		return "eAccounting/ctDutyAllowance/completedMsgPop";
	}

	@RequestMapping(value = "/selectMemberViewByMemCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberViewByMemCode(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> item= ctDutyAllowanceService.selectMemberViewByMemCode(params);

		return ResponseEntity.ok(item);
	}

	@RequestMapping(value = "/webInvoiceRqstViewPop.do")
	  public String webInvoiceRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    LOGGER.debug("params =====================================>>  " + params);

	    String clmType = params.get("clmType").toString();

	    List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
	    for (int i = 0; i < appvLineInfo.size(); i++) {
	      EgovMap info = appvLineInfo.get(i);
	      if ("J".equals(info.get("appvStus"))) {
	        String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(info);
	        model.addAttribute("rejctResn", rejctResn);
	      }
	    }
	    List<EgovMap> appvInfoAndItems = ctDutyAllowanceService.selectAppvInfoAndItems(params);

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

	    return "eAccounting/ctDutyAllowance/webInvoiceRequestViewPop";

	  }

	@RequestMapping(value = "/getBch.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getBch(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {

	    List<EgovMap> bch = ctDutyAllowanceService.getBch(params);

	    return ResponseEntity.ok(bch);
	  }

	@RequestMapping(value = "/approvalSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		ctDutyAllowanceService.updateApprovalInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/rejectRegistPop.do")
	public String rejectRegistPop(ModelMap model) {
		return "eAccounting/ctDutyAllowance/rejectionOfWebInvoiceRegistMsgPop";
	}

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
			webInvoiceService.updateRejectionInfo(params);

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

	@RequestMapping(value = "/ctDutyRawPop.do")
	public String hiCareStockListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

// 		params.put("memberLevel", sessionVO.getMemberLevel());
// 	    params.put("userName", sessionVO.getUserName());
// 	    params.put("userType", sessionVO.getUserTypeId());
// 		List<EgovMap> branchList = hsManualService.selectBranchList(params);

 		//model.addAttribute("branchList", branchList);

 	    return "eAccounting/ctDutyAllowance/ctDutyRawPop";
	}

	/*	@RequestMapping(value = "/selectTaxCodeCtDutyAllowanceFlag.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTaxCodeCtDutyAllowanceFlag(Model model) {

		List<EgovMap> taxCodeFlagList = ctDutyAllowanceService.selectTaxCodeCtDutyAllowanceFlag();

		return ResponseEntity.ok(taxCodeFlagList);
	}



	@RequestMapping(value = "/selectCtDutyAllowanceInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectCtDutyAllowanceInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap info = ctDutyAllowanceService.selectCtDutyAllowanceInfo(params);
		List<EgovMap> itemGrp = ctDutyAllowanceService.selectCtDutyAllowanceItemGrp(params);

		info.put("itemGrp", itemGrp);

		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = ctDutyAllowanceService.selectAttachList(atchFileGrpId);
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
		ctDutyAllowanceApplication.updateCtDutyAllowanceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}



	*/
}
