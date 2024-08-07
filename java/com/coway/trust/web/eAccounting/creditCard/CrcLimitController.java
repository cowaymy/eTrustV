package com.coway.trust.web.eAccounting.creditCard;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
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
import com.coway.trust.biz.eAccounting.creditCard.CrcLimitService;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardApplication;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/creditCard")
public class CrcLimitController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrcLimitController.class);

    @Value("${app.name}")
    private String appName;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @Autowired
    private CrcLimitService crcLimitService;

    @Autowired
    private CreditCardApplication creditCardApplication;

    @Autowired
    private CreditCardService creditCardService;

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @RequestMapping(value = "/crcAllowanceSummary.do")
    public String crcAllowancePlan(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== crcAllowanceSummary ==========");

        List<EgovMap> crcHolder = crcLimitService.selectAllowanceCardList();
        List<EgovMap> crcPic = crcLimitService.selectAllowanceCardPicList();

        model.addAttribute("crcHolder", crcHolder);
        model.addAttribute("crcPic", crcPic);

        return "eAccounting/creditCard/crcAllowanceSummary";
    }

    @RequestMapping(value = "/selectAllowanceSummary.do")
    public ResponseEntity<List<EgovMap>> selectAllowancePlan(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== crcAllowanceSummary ==========");
        LOGGER.debug("params ========== :: " + params);

        List<EgovMap> allowancePlanList = crcLimitService.selectAllowanceList(params, request, sessionVO);

        return ResponseEntity.ok(allowancePlanList);
    }

    @RequestMapping(value = "/monthlyAllowancePop.do")
    public String monthlyAllowancePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
        LOGGER.debug("========== monthlyAllowancePop ==========");
        LOGGER.debug("params ========== :: " + params);

        //Map result = crcLimitService.selectAvailableAllowanceAmt(params);
        List<EgovMap> result = creditCardService.selectAvailableAllowanceAmt(params);
        model.addAttribute("result", new Gson().toJson(result));
        LOGGER.debug("gsonToJSON result ========== :: " + result);
        LOGGER.debug("gsonToJSON result model ========== :: " + model);
        model.addAttribute("item", params);

        return "eAccounting/creditCard/monthlyAllowancePop";
    }

    @RequestMapping(value = "/crcAdjustment.do")
    public String crcAdjustment(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
        LOGGER.debug("========== crcAdjustment ==========");

        List<EgovMap> crcHolder = crcLimitService.selectAllowanceCardList();
        model.addAttribute("crcHolder", crcHolder);

        return "eAccounting/creditCard/crcAdjustment";
    }

    @RequestMapping(value = "/selectAdjustmentList.do")
    public ResponseEntity<List<EgovMap>> selectAdjustmentList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== monthlyAllowancePop ==========");

        List<EgovMap> adjustmentList = crcLimitService.selectAdjustmentList(params, request, sessionVO);

        return ResponseEntity.ok(adjustmentList);
    }

    @RequestMapping(value = "/crcAdjustmentPop.do")
    public String crcAdjustmentPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== crcAdjustmentPop ==========");
        LOGGER.debug("params ========== :: " + params);

//        List<EgovMap> attachList = new ArrayList<EgovMap>();

        params.put("userId", sessionVO.getUserId());
        EgovMap apprDtls = new EgovMap();
        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);

        // If apprGrp = "BUDGET"; allow to view/edit for all
        if(apprDtls != null) {
            params.put("apprGrp", apprDtls.get("apprGrp"));
        } else {
            params.put("apprGrp", "");
        }

        List<EgovMap> crcHolder = crcLimitService.selectAllowanceCardList();

        // View/Approval/Edit Mode
        if("V".equals(params.get("mode")) || "A".equals(params.get("mode")) || "E".equals(params.get("mode"))) {
            if(params.containsKey("docNo")) {
                // Query FCM0033D + SYS0070M + SYS0071D
                /*
                List<EgovMap> attachList = crcLimitService.selectAttachList((String) params.get("docNo"));
                model.addAttribute("attachList", attachList);
                */
                List<EgovMap> adjItems = crcLimitService.selectAdjItems(params);
                model.addAttribute("adjItems", new Gson().toJson(adjItems));

                List<EgovMap> approvalLineDescriptionInfo = crcLimitService.getApprovalLineDescriptionInfo(params);
                model.addAttribute("approvalLineDescriptionInfo", new Gson().toJson(approvalLineDescriptionInfo));

                if("V".equals(params.get("mode")) || "A".equals(params.get("mode"))){
                    int checkCurrAppvLineIsBudgetTeam = crcLimitService.checkCurrAppvLineIsBudgetTeam(params);
                    model.addAttribute("checkCurrAppvLineIsBudgetTeam", checkCurrAppvLineIsBudgetTeam);
                }
            }
        }

        model.addAttribute("crcHolder", crcHolder);
        model.addAttribute("item", params);

        return "eAccounting/creditCard/crcAdjustmentPop";
    }

    @RequestMapping(value = "/getCardInfo.do")
    public ResponseEntity<ReturnMessage> getCardInfo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== getCardInfo ==========");
        LOGGER.debug("params ========== :: " + params);

        ReturnMessage message = new ReturnMessage();

        EgovMap cInfo = new EgovMap();
        cInfo = (EgovMap) crcLimitService.getCardInfo(params);

        message.setData(cInfo);

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/adjFileUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> adjFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== adjFileUpload ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "crcAllowanceAdj" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if(list.size() > 0) {
            creditCardApplication.insertReimbursementAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);


    		List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());
    		if(fileInfo != null){
    			params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
    		}
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/adjFileUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> adjFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== adjFileUpdate ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "crcAllowanceAdj" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        String remove = (String) params.get("remove");

        if(list.size() > 0 || !StringUtils.isEmpty(remove)) {
            creditCardApplication.updateCreditCardBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachment", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/saveRequest.do")
    public ResponseEntity<ReturnMessage> saveRequest(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== saveRequest ==========");
        LOGGER.debug("params ========== :: " + params);

        String docNo = crcLimitService.saveRequest(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(docNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/editRequest.do")
    public ResponseEntity<ReturnMessage> editRequest(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== editRequest ==========");
        LOGGER.debug("params ========== :: " + params);

        String docNo = crcLimitService.editRequest(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(docNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/deleteRequest.do")
    public ResponseEntity<ReturnMessage> deleteRequest(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== deleteRequest ==========");
        LOGGER.debug("params ========== :: " + params);

        String docNo = crcLimitService.deleteRequest(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(docNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/submitAdjustment.do")
    public ResponseEntity<ReturnMessage> submitAdjustment(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== submitAdjustment ==========");
        LOGGER.debug("params ========== :: " + params);

        int submit = crcLimitService.submitAdjustment(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(submit > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/crcAdjustmentApproval.do")
    public String crcAdjustmentApproval(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
        LOGGER.debug("========== crcAdjustmentApproval ==========");

        List<EgovMap> crcHolder = crcLimitService.selectAllowanceCardList();
        model.addAttribute("crcHolder", crcHolder);

        return "eAccounting/creditCard/crcAdjustmentApproval";
    }

    @RequestMapping(value = "/selectAdjustmentAppvList.do")
    public ResponseEntity<List<EgovMap>> selectAdjustmentAppvList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== selectAdjustmentAppvList ==========");

        List<EgovMap> adjustmentList = crcLimitService.selectAdjustmentAppvList(params, request, sessionVO);

        return ResponseEntity.ok(adjustmentList);
    }

    @RequestMapping(value = "/approvalUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> approvalUpdate(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== approvalUpdate ==========");
        LOGGER.debug("params ========== :: " + params);

        int cnt = crcLimitService.approvalUpdate(params, sessionVO);

        ReturnMessage message = new ReturnMessage();

        if(cnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/crcAdjustmentRejectPop.do")
    public String crcAdjustmentRejectPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
        LOGGER.debug("========== crcAdjustmentRejectPop ==========");

        model.addAttribute("adjNo", params.get("adjNo"));
        model.addAttribute("appvLineSeq", params.get("appvLineSeq"));

        return "eAccounting/creditCard/crcAdjustmentRejectPop";
    }

    @RequestMapping(value = "/monthlyAllowanceDetailDisplayPop.do")
    public String monthlyAllowanceDetailDisplayPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
        LOGGER.debug("========== monthlyAllowanceDetailDisplayPop ==========");
        LOGGER.debug("params ========== :: " + params);

        List<EgovMap> result = null;
        String type = params.get("type").toString();
        if(type.equals("adjustment")){
        	result = crcLimitService.selectCardholderApprovedAdjustmentLimitList(params);
        }
        else if(type.equals("pending"))
        {
        	result = crcLimitService.selectCardholderPendingAmountList(params);
        }
        else if(type.equals("utilised")){
        	result = crcLimitService.selectCardholderUtilisedAmountList(params);
        }

        if(result != null){
            model.addAttribute("result", new Gson().toJson(result));
        }
        else{
            model.addAttribute("result", null);
        }
        model.addAttribute("item", params);

        return "eAccounting/creditCard/monthlyAllowanceDetailDisplayPop";
    }

	@RequestMapping(value = "/checkFinAppr.do")
	public ResponseEntity<ReturnMessage> checkFinAppr(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();

        //int subCount = crcLimitService.checkExistAdjNo(params.get("adjNo").toString());

//        if(subCount > 0) {
//            message.setCode(AppConstants.FAIL);
//            message.setData(params);
//            message.setMessage("Adjustment has been submitted.");
//        } else {
            List<Object> apprGridList = (List<Object>) params.get("apprGridList");

            if (apprGridList.size() > 0) {
                Map hm = null;
                List<String> appvLineUserId = new ArrayList<>();

                for (Object map : apprGridList) {
                    hm = (HashMap<String, Object>) map;
                    appvLineUserId.add(hm.get("memCode").toString());
                }

                String finAppvLineUserId = appvLineUserId.get(appvLineUserId.size() - 1);

                params.put("clmType", params.get("clmType").toString());
                EgovMap hm2 = webInvoiceService.getFinApprover(params);
                String memCode = "0";
                if(hm2 == null){
                	memCode = "0";
                }
                else{
                	memCode = hm2.get("apprMemCode").toString();
                }
                LOGGER.debug("getFinApprover.memCode =====================================>>  " + memCode);

                memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
                if(!finAppvLineUserId.equals(memCode)) {
                    message.setCode(AppConstants.FAIL);
                    message.setData(params);
                    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
                } else {
                    message.setCode(AppConstants.SUCCESS);
                    message.setData(params);
                }
            }
//        }

        return ResponseEntity.ok(message);
    }



    @RequestMapping(value = "/submitNewAdjustmentWithApprovalLine.do")
    public ResponseEntity<ReturnMessage> submitNewAdjustmentWithApprovalLine(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== submitAdjustment ==========");
        LOGGER.debug("params ========== :: " + params);

        String docNo = crcLimitService.submitNewAdjustmentWithApprovalLine(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(docNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(docNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

	 	@RequestMapping(value = "/saveRequestBulk.do")
	    public ResponseEntity<ReturnMessage> saveRequestBulk(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
	        LOGGER.debug("========== saveRequest ==========");
	        LOGGER.debug("params ========== :: " + params);

	        String docNo = crcLimitService.saveRequest(params, sessionVO);

	        ReturnMessage message = new ReturnMessage();
	        if(!"".equals(docNo)) {
	            message.setCode(AppConstants.SUCCESS);
	            message.setData(docNo);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        } else {
	            message.setCode(AppConstants.FAIL);
	            message.setData(docNo);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	        }

	        return ResponseEntity.ok(message);
	    }

	  @RequestMapping(value = "/crcApprovalLineCreatePop.do")
	    public String crcApprovalLineCreatePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
	        LOGGER.debug("========== crcApprovalLinePop ==========");

	        model.addAttribute("isNew", params.get("isNew"));
	        model.addAttribute("isBulk", params.get("isBulk"));
	        return "eAccounting/creditCard/crcApprovalLine/crcApprovalLineCreatePop";
	    }

	    @RequestMapping(value = "/submitEditAdjustmentWithApprovalLine.do")
	    public ResponseEntity<ReturnMessage> submitEditAdjustmentWithApprovalLine(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws JsonParseException, JsonMappingException, IOException {
	        LOGGER.debug("========== editRequest ==========");
	        LOGGER.debug("params ========== :: " + params);
	        ReturnMessage message = new ReturnMessage();

 	        ObjectMapper mapper = new ObjectMapper();
	        String value = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(params.get("editData"));

	        Map<String,Object> paramDataMapped = mapper.readValue(value, Map.class);

	        String docNo = crcLimitService.editRequest(paramDataMapped, sessionVO);
	    	List<String> documentNumberList = new ArrayList<String>();
	    	documentNumberList.add(docNo);
	    	if (documentNumberList.size() > 0) {
	    		params.put("documentNumberList", documentNumberList);
		        crcLimitService.saveApprovalLineBulk(params, sessionVO);
	    	}
	        if(!"".equals(docNo)) {
	            message.setCode(AppConstants.SUCCESS);
	            message.setData(docNo);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        } else {
	            message.setCode(AppConstants.FAIL);
	            message.setData(docNo);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	        }

	        return ResponseEntity.ok(message);
	    }

	    @RequestMapping(value = "/submitBulkAdjustmentWithApprovalLine.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> submitBulkAdjustmentWithApprovalLine(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws JsonParseException, JsonMappingException, IOException {
	        LOGGER.debug("========== editRequest ==========");
	        LOGGER.debug("params ========== :: " + params);
	        ReturnMessage message = new ReturnMessage();

 	        ObjectMapper mapper = new ObjectMapper();

	        //String value = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(params.get("adjGridList"));
	        List<Map<String, Object>> adjustmentGridList = Arrays.asList(mapper.readValue(params.get("adjGridList").toString(),Map[].class));
	        //List<Map<String, Object>> adjustmentGridList = mapper.readValue(params.get("adjGridList").toString(), new TypeReference<List<Map<String, Object>>>(){});

	    	List<String> documentNumberList = new ArrayList<String>();
	        if(adjustmentGridList.size() > 0){
	        	for(int i = 0; i < adjustmentGridList.size(); i++){
	    	    	documentNumberList.add(adjustmentGridList.get(i).get("adjNo").toString());
	        	}
		    	documentNumberList = documentNumberList.stream().distinct().collect(Collectors.toList());
	        }

	    	if (documentNumberList.size() > 0) {
	    		params.put("documentNumberList", documentNumberList);
		        crcLimitService.saveApprovalLineBulk(params, sessionVO);
	    	}
	        if(documentNumberList.size() > 0) {
	            message.setCode(AppConstants.SUCCESS);
	            message.setData(String.join(",", documentNumberList));
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        } else {
	            message.setCode(AppConstants.FAIL);
	            message.setData(String.join(",", documentNumberList));
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	        }

	        return ResponseEntity.ok(message);
	    }

	    @RequestMapping(value = "/crcApprovalLineEditPop.do")
	    public String crcApprovalLineEditPop(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
	        LOGGER.debug("========== selectApprovalLineForEdit ==========");

	        List<EgovMap> adjustmentApprovalLine = crcLimitService.selectApprovalLineForEdit(params);
	        model.addAttribute("result", new Gson().toJson(adjustmentApprovalLine));
	        model.addAttribute("docNo", params.get("docNo"));

	        return "eAccounting/creditCard/crcApprovalLine/crcApprovalLineEditPop";
	    }

	    @RequestMapping(value = "/editApprovalLineSubmit.do")
	    public ResponseEntity<ReturnMessage> editApprovalLineSubmit(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws JsonParseException, JsonMappingException, IOException {
	        LOGGER.debug("========== editApprovalLineSubmit ==========");
	        LOGGER.debug("params ========== :: " + params);
	        ReturnMessage message = new ReturnMessage();

	        int result = crcLimitService.editApprovalLineSubmit(params, sessionVO);

	        if(result == 1) {
	            message.setCode(AppConstants.SUCCESS);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        } else {
	            message.setCode(AppConstants.FAIL);
	            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	        }

	        return ResponseEntity.ok(message);
	    }
}
