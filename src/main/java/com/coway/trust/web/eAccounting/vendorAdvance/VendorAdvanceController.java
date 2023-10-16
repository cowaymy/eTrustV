package com.coway.trust.web.eAccounting.vendorAdvance;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.biz.eAccounting.vendorAdvance.VendorAdvanceService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/vendorAdvance")
public class VendorAdvanceController {

    private static final Logger LOGGER = LoggerFactory.getLogger(VendorAdvanceController.class);

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private VendorAdvanceService vendorAdvanceService;

    @Resource(name = "budgetService")
   	private BudgetService budgetService;


    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private WebInvoiceApplication webInvoiceApplication;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @RequestMapping(value = "/vendorAdvance.do")
    public String vendorAdvance(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        if(params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());

        if(sessionVO.getCostCentr() != null) {
            params.put("costCenter", sessionVO.getCostCentr());
            EgovMap costName = (EgovMap) webInvoiceService.getCostCenterName(params);

            model.addAttribute("costCentrNm", costName.get("costCenterName"));
        }

        return "eAccounting/vendorAdvance/vendorAdvance";
    }

    @RequestMapping(value = "/advanceListing.do")
    public ResponseEntity<List<EgovMap>> advanceListing(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.advanceListing ==========");
        LOGGER.debug("vendorAdvance.advanceListing :: params >>>>> ", params);

        List<EgovMap> list = vendorAdvanceService.selectAdvanceList(params, request, sessionVO);
        return ResponseEntity.ok(list);
    }

    @RequestMapping(value = "/reqAttachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> reqAttachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.reqAttachmentUpload ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendorAdvanceReq" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if(list.size() > 0) {
            webInvoiceApplication.insertWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/reqAttachmentUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> reqAttachmentUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.reqAttachmentUpdate ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendorAdvanceReq" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        String remove = (String) params.get("remove");

        if(list.size() > 0 || !StringUtils.isEmpty(remove)) {
            webInvoiceApplication.updateWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachment", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/insertVendorAdvReq.do")
    public ResponseEntity<ReturnMessage> insertVendorAdvReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.insertVendorAdvReq ==========");
        LOGGER.debug("params =====================================>>  " + params);

        String clmNo = vendorAdvanceService.insertVendorAdvReq(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(clmNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(clmNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }  else {
            message.setCode(AppConstants.FAIL);
            message.setData(clmNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/settlementAttachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> settlementAttachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.settlementAttachmentUpload ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendorAdvanceRef" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if(list.size() > 0) {
            webInvoiceApplication.insertWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/settlementAttachmentUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> settlementAttachmentUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.reqAttachmentUpdate ==========");

        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendorAdvanceRef" + File.separator + df.format(date),
                AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        String remove = (String) params.get("remove");

        if(list.size() > 0 || !StringUtils.isEmpty(remove)) {
            webInvoiceApplication.updateWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachment", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/insertVendorAdvSettlement.do")
    public ResponseEntity<ReturnMessage> insertVendorAdvSettlement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.insertVendorAdvSettlement ==========");
        LOGGER.debug("params =====================================>>  " + params);

        String clmNo = vendorAdvanceService.insertVendorAdvSettlement(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(!"".equals(clmNo)) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(clmNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }  else {
            message.setCode(AppConstants.FAIL);
            message.setData(clmNo);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/approveLineSubmit.do")
    public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.approveLineSubmit ==========");
        LOGGER.debug("params =====================================>>  " + params);

        int appIns = vendorAdvanceService.approveLineSubmit(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(appIns > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(params);
            message.setMessage(params.get("clmNo").toString().substring(0, 2) == "R4" ? "Request" : "Settlement");
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectVendorAdvanceDetails.do")
    public ResponseEntity<ReturnMessage> selectVendorAdvanceDetails(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.selectVendorAdvanceDetails ==========");
        LOGGER.debug("params =====================================>>  " + params);

        // FCM0027M, FCM0028D details
        EgovMap details = vendorAdvanceService.selectVendorAdvanceDetailItem(params.get("clmNo").toString()); //EgovMap details = vendorAdvanceService.selectVendorAdvanceDetails(params.get("clmNo").toString());
        if("5".equals(params.get("advType").toString())) {
            List<EgovMap> settlementItems = vendorAdvanceService.selectVendorAdvanceItems(params.get("clmNo").toString());
            details.put("cur", settlementItems.get(0).get("currency"));
        }
        else if("6".equals(params.get("advType").toString())) {
            List<EgovMap> settlementItems = vendorAdvanceService.selectVendorAdvanceItems(params.get("clmNo").toString());
            /*for (int i=0;i<settlementItems.size();i++){
            	SimpleDateFormat fixeddate=new SimpleDateFormat("yyyy/MM/dd");
				settlementItems.get(i).put("invcDt",fixeddate.format(settlementItems.get(i).get("invcDt")));
            }
            170423 */
            details.put("settlementItems", settlementItems);
        }

        List<EgovMap> approvalInfo = webInvoiceService.selectAppvInfo(params);
        details.put("approvalInfo", approvalInfo);

        // Retrieve Attachment details
        if("6".equals(params.get("advType").toString())) {
        	 List<EgovMap> atchInfo = webInvoiceService.selectAttachList(String.valueOf(params.get("fileAtchGrpId")));
             details.put("attachList", atchInfo);
        }else
        {
        	List<EgovMap> atchInfo = webInvoiceService.selectAttachList(String.valueOf(details.get("fileAtchGrpId")));
        	details.put("attachList", atchInfo);
        }


        // Not draft or empty approval status, retrieve from FCM0004M and FCM0005D
        //if("6".equals(params.get("advType").toString()) && (!"".equals(params.get("appvPrcssStus").toString()) && !"T".equals(params.get("appvPrcssStus").toString()))) {
        if(!"".equals(params.get("appvPrcssStus").toString()) && !"T".equals(params.get("appvPrcssStus").toString())) {
            List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);

            // Approval line + Approver's actions and date
            String appvPrcss = "";
            // Get requestUserId, requestDt - 1 line
            EgovMap appvInfo = vendorAdvanceService.getAppvInfo((String) params.get("appvPrcssNo"));
            appvPrcss += "- Request By " + (String) appvInfo.get("reqstUserId") + " [" + (String) appvInfo.get("reqstDt") + "] ";

            for(int i = 0; i < appvLineInfo.size(); i++) {
                EgovMap appvLine = appvLineInfo.get(i);
                String appvStus = (String) appvLine.get("appvStus");
                String appvLineUserName = (String) appvLine.get("appvLineUserName");
                String appvDt = (String) appvLine.get("appvDt");

                if("R".equals(appvStus) || "T".equals(appvStus)) {
                    appvPrcss += "<br> - Pending By " + appvLineUserName;
                } else if ("A".equals(appvStus)) {
                    appvPrcss += "<br> - Approval By " + appvLineUserName + " [" + appvDt + "]";
                } else if ("J".equals(appvStus)) {
                    appvPrcss += "<br> - Reject By " + appvLineUserName + " [" + appvDt + "]";
                }
            }
            details.put("appvPrcssStus", appvPrcss);
        }

        LOGGER.debug("========== selectVendorAdvanceDetails:endingParams ==========" + details);
        ReturnMessage message = new ReturnMessage();

        message.setCode(AppConstants.SUCCESS);
        message.setData(details);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectVendorAdvanceDetailsGrid.do" , method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectVendorAdvanceDetailsGrid(@RequestParam Map<String, Object> params, ModelMap model) {
//    public List<EgovMap> selectVendorAdvanceDetailsGrid(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {

    	LOGGER.debug("========== vendorAdvance.selectVendorAdvanceDetailsGrid ==========");
        LOGGER.debug("params =====================================>>  " + params);

        List<EgovMap> details = vendorAdvanceService.selectVendorAdvanceItems(params.get("clmNo").toString());

        LOGGER.debug("details =====================================>>  " + details);

        //Start : Add Sufficient Flag for checking before submission - nora
        Map<String, Object> itemMap = null;
        List<EgovMap> repList = new ArrayList<EgovMap>();
        float availableCm = 0;
		if(details.size() > 0){
			Map<String, Object> gridMap = null;

			Map<String, Float> availableMap = new HashMap();

			for(int i = 0; i < details.size(); i++){
				gridMap = (Map<String, Object>) details.get(i);

				float reqstAmt = Float.valueOf(gridMap.get("totalAmt").toString());
				itemMap = new HashMap<String, Object>();
				itemMap.put("stYearMonth", params.get("stYearMonth").toString().substring(3));
				itemMap.put("costCentr", params.get("costCentr").toString());
				itemMap.put("stBudgetCode", gridMap.get("budgetCode").toString());
				itemMap.put("stGlAccCode", gridMap.get("glAccCode").toString());
				String insuff = "";

				EgovMap cntrl = new EgovMap();
    			cntrl = (EgovMap) budgetService.checkBgtPlan(itemMap);
					if(cntrl.get("cntrlType").toString().equals("Y")){
						EgovMap item = new EgovMap();
        				item = (EgovMap) budgetService.availableAmtCp(itemMap);
        				LOGGER.debug("item {} " + item);

						if(item != null){
							float totalAvailable = Float.valueOf(item.get("availableAmt").toString());
        					float total =  Float.valueOf(item.get("total").toString());
        					float pending = Float.valueOf(item.get("pendAppvAmt").toString());
        					float consumed = Float.valueOf(item.get("consumAppvAmt").toString());

        					String key = item.get("budgetCode").toString() + item.get("glAccCode").toString();
        					LOGGER.debug("Key: " + key);
        					//availableMap.put(key, reqstAmt);
        					float availableAmount = total - pending - consumed;
        					LOGGER.debug("availableAmt: " + availableAmount);
							if(availableAmount < reqstAmt){
								insuff = "Y";
							}else{
								if(availableMap.containsKey(key)){
									float amt = availableMap.get(key);
									amt += reqstAmt;
									LOGGER.debug("Amt: " + amt);
									availableMap.replace(key, amt);
								}else{
									availableMap.put(key, reqstAmt);
								}

								if(availableMap.get(key) > totalAvailable){
									LOGGER.debug("Insufficient");
									insuff = "Y";
								}else{
									LOGGER.debug("Sufficient");
									insuff = "N";
								}

//								insuff = "N";
							}
						}
						else{
							insuff = "Y";
						}
					}else{
						insuff = "N";
					}

					gridMap.put("insufficient", insuff);
					LOGGER.debug("gridMap.insufficienrt <> "+ gridMap.get("insufficient"));
					LOGGER.debug("gridMap <> "+ gridMap);
					repList.add((EgovMap) gridMap);


			}
		}
		LOGGER.debug("repList {} " + repList);
		//End : Add Sufficient Flag for checking before submission - nora

        return ResponseEntity.ok(repList);
    }

    @RequestMapping(value = "/updateVendorAdvReq.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateVendorAdvReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.updateVendorAdvReq ==========");
        LOGGER.debug("params =====================================>>  " + params);

        int updCnt = vendorAdvanceService.updateVendorAdvReq(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(updCnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/updateVendorAdvSettlement.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateVendorAdvSettlement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== vendorAdvance.updateVendorAdvSettlement ==========");
        LOGGER.debug("params =====================================>>  " + params);

        int updCnt = vendorAdvanceService.updateVendorAdvSettlement(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(updCnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/manualVendorAdvReqSettlement.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> manualVendorAdvReqSettlement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== vendorAdvance.manualReqSettlement ==========");
        LOGGER.debug("params =====================================>>  " + params);

        int updCnt = vendorAdvanceService.manualVendorAdvReqSettlement(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(updCnt > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
            message.setCode(AppConstants.FAIL);
            message.setData(updCnt);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/vendorAdvanceApproveViewPop.do")
    public String vendorAdvanceApproveViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        int rejctSeq = 0;

        EgovMap advType = vendorAdvanceService.getAdvType(params);
        params.put("advType", advType.get("advType"));

        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        List<EgovMap> appvInfoAndItems = vendorAdvanceService.selectAppvInfoAndItems(params);
        List<EgovMap> approvalInfo = webInvoiceService.selectAppvInfo(params);

        String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
        memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
        params.put("memCode", memCode);
        EgovMap apprDtls = new EgovMap();
        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
        List<String> appvLineUserId = new ArrayList<>();
        for(int i = 0; i < appvLineInfo.size(); i++) {
            EgovMap info = appvLineInfo.get(i);
            appvLineUserId.add(info.get("appvLineUserId").toString());

            String appvPrcssResult = String.valueOf(info.get("appvStus"));
            model.addAttribute("appvPrcssResult", appvPrcssResult);
        }

        if(!appvLineUserId.contains(memCode) && apprDtls != null) {
            model.addAttribute("appvPrcssResult", "R");
        }

        // TODO appvPrcssStus 생성
        String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

        model.addAttribute("pageAuthFuncChange", params.get("pageAuthFuncChange"));
        model.addAttribute("appvPrcssStus", appvPrcssStus);
        model.addAttribute("approvalInfo", new Gson().toJson(approvalInfo));
        model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
        if(params.containsKey("type")) {
            model.addAttribute("type", params.get("type"));
        }

        return "eAccounting/vendorAdvance/vendorAdvanceApproveViewPop";
    }

    @RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        if(params.get("clmNo") != null && !params.get("clmNo").equals(""))
        {
        	String reqType = (String)params.get("clmNo");
        	reqType = reqType.substring(0, 2);
        	params.put("reqType", reqType);
        }
        String reqNo = vendorAdvanceService.selectNextReqNo(params);
        params.put("newClmNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        vendorAdvanceService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
}
