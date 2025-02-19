package com.coway.trust.web.eAccounting.vendor;

import java.io.File;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.eAccounting.vendor.VendorApplication;
import com.coway.trust.biz.eAccounting.vendor.VendorService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/vendor")
public class VendorManagementController {

    private static final Logger LOGGER = LoggerFactory.getLogger(VendorManagementController.class);

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private VendorApplication vendorApplication;

    @Autowired
    private VendorService vendorService;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    // DataBase message accessor....
    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private SessionHandler sessionHandler;

    @RequestMapping(value = "/vendorManagement.do")
    public String vendorManagement(@RequestParam Map<String, Object> params, ModelMap model) {
        if (params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

        return "eAccounting/vendor/vendorManagement";
    }

    @RequestMapping(value = "/supplierSearchPop.do")
    public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params =====================================>>  " + params);

        model.addAttribute("pop", params.get("pop"));
        model.addAttribute("accGrp", params.get("accGrp"));
        model.addAttribute("entry", params.get("entry"));
        return "eAccounting/vendor/memberAccountSearchPop";
    }

    @RequestMapping(value = "/costCenterSearchPop.do")
    public String costCenterSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params =====================================>>  " + params);

        model.addAttribute("pop", params.get("pop"));
        model.addAttribute("call", params.get("call"));
        return "eAccounting/vendor/costCenterSearchPop";
    }

    @RequestMapping(value = "/approveLinePop.do")
    public String approveLinePop(@RequestParam Map<String, Object> params,ModelMap model) {
    	LOGGER.debug("approveLinePop =====================================>>  " + params);
        return "eAccounting/vendor/approveLinePop";
    }

    @RequestMapping(value = "/newRegistMsgPop.do")
    public String newRegistMsgPop(ModelMap model) {
        return "eAccounting/vendor/newVendorRegistMsgPop";
    }

    @RequestMapping(value = "/newCompletedMsgPop.do")
    public String newCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
        return "eAccounting/vendor/newVendorCompletedMsgPop";
    }

    @RequestMapping(value = "/newVendorPop.do")
    public String newVendor(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovMap> vendorGrp = vendorService.selectVendorGroup();
        List<EgovMap> bankList = vendorService.selectBank();
        List<EgovMap> countryList = vendorService.selectSAPCountry();

        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());
        model.addAttribute("callType", params.get("callType"));

        model.addAttribute("vendorGrp", vendorGrp);
        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);
        model.addAttribute("memCode", vendorService.selectMemberCode(sessionVO.getMemId()));

        if (sessionVO.getCostCentr() != null) {
            params.put("costCenter", sessionVO.getCostCentr());
            EgovMap costName = (EgovMap) webInvoiceService.getCostCenterName(params);

            model.addAttribute("costCentrNm", costName.get("costCenterName"));
        }

        return "eAccounting/vendor/newVendorPop";
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

    @RequestMapping(value = "/selectVendorList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectVendorList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();

        if (!"A1101".equals(costCentr)) {
            params.put("loginUserId", sessionVO.getUserId());
        }

        LOGGER.debug("params =====================================>>  " + params);

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
//        int countAppvPrcssStus = appvPrcssStus.length;
        int countAppvPrcssStus = (appvPrcssStus == null || appvPrcssStus.length == 0) ? 0 : appvPrcssStus.length;

        params.put("appvPrcssStus", appvPrcssStus);
        LOGGER.debug("countAppvPrcssStus =====================================>>  " + countAppvPrcssStus);
        params.put("countAppvPrcssStus", countAppvPrcssStus);

        String[] vendorTypeCmb = request.getParameterValues("vendorTypeCmb");
        params.put("vendorTypeCmb", vendorTypeCmb);

        List<EgovMap> list = vendorService.selectVendorList(params);

        LOGGER.debug("params =====================================>>  " + list.toString());

        return ResponseEntity.ok(list);
    }

    @RequestMapping(value = "/vendorValidation.do", method = RequestMethod.GET)
    public ResponseEntity<Map<String, Object>> vendorValidation(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();
        int regCompNoCount = vendorService.checkExistNo(params.get("regCompNo").toString());
        int paymentTypeCount = vendorService.checkExistPaymentType(params);
        int bankListCount = vendorService.checkExistBankListNo(params);
        int bankAccNoCount = vendorService.checkExistBankAccNo(params);
        String vendorAccId = vendorService.selectExistBankAccNo(params);
        String checkReqNo = vendorService.checkReqNo(params);
        int isReset = 1; // 1:false, 0:true;
        int isPass = 1; // 1:NotPass, 0:Pass;
        int sameReqNo = 1; // 1:NotSame, 0:Same;

        if (checkReqNo != null && !checkReqNo.equals("") && checkReqNo.equals(params.get("newReqNo").toString())) {
            sameReqNo = 0;
        }

        if (regCompNoCount == 0) {
            isPass = 0;
            params.put("isPass", isPass);
            params.put("isReset", isReset);

        } else {
            if (paymentTypeCount == 0) {
                isPass = 0;
                params.put("isPass", isPass);
                params.put("isReset", isReset);
            } else {
                if (bankListCount == 0) {
                    isPass = 0;
                    params.put("isPass", isPass);
                    params.put("isReset", isReset);
                } else {
                    if (bankAccNoCount == 0) {
                        isPass = 0;
                        params.put("isPass", isPass);
                        params.put("isReset", isReset);
                    } else {
                        if (vendorAccId != null && !vendorAccId.equals("")) {
                            isReset = 0;
                            isPass = 1;
                            params.put("isReset", isReset);
                            params.put("isPass", isPass);
                            params.put("vendorAccId", vendorAccId);
                            message.setCode(AppConstants.FAIL);
                            message.setData(params);
                            message.setMessage("Vendor Existed. Member Account ID: " + vendorAccId);
                        } else {
                            isReset = 0;
                            isPass = 1;
                            params.put("isReset", isReset);
                            params.put("isPass", isPass);
                            message.setCode(AppConstants.FAIL);
                            message.setData(params);
                            message.setMessage("Vendor existed in Pending stage.");
                        }
                    }
                }
            }
        }

        params.put("sameReqNo", sameReqNo);
        LOGGER.debug("params =====================================>>  " + params);
        return ResponseEntity.ok(params);

    }

    @RequestMapping(value = "/vendorValidation2.do", method = RequestMethod.GET)
    public ResponseEntity<Map<String, Object>> vendorValidation2(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();
        int regCompNoCount = vendorService.checkExistNo(params.get("regCompNo").toString());
        int paymentTypeCount = vendorService.checkExistPaymentType(params);
        int bankListCount = vendorService.checkExistBankListNo(params);
        int bankAccNoCount = vendorService.checkExistBankAccNo(params);
        String vendorAccId = vendorService.selectExistBankAccNo(params);
//        String checkReqNo = vendorService.checkReqNo(params);
        int isReset = 1; // 1:false, 0:true;
        int isPass = 1; // 1:NotPass, 0:Pass;
//        int sameReqNo = 1; // 1:NotSame, 0:Same;

//        if (checkReqNo != null && !checkReqNo.equals("") && checkReqNo.equals(params.get("newReqNo").toString())) {
//            sameReqNo = 0;
//        }

        if (regCompNoCount == 0) {
            isPass = 0;
            params.put("isPass", isPass);
            params.put("isReset", isReset);

            if (paymentTypeCount == 0) {
                isPass = 0;
                params.put("isPass", isPass);
                params.put("isReset", isReset);
            } else {
                if (bankListCount == 0) {
                    isPass = 0;
                    params.put("isPass", isPass);
                    params.put("isReset", isReset);
                } else {
                    if (bankAccNoCount == 0) {
                        isPass = 0;
                        params.put("isPass", isPass);
                        params.put("isReset", isReset);
                    } else {
                        if (vendorAccId != null && !vendorAccId.equals("")) {
                            isReset = 0;
                            isPass = 1;
                            params.put("isReset", isReset);
                            params.put("isPass", isPass);
                            params.put("vendorAccId", vendorAccId);
                            message.setCode(AppConstants.FAIL);
                            message.setData(params);
                            message.setMessage("Vendor Existed. Member Account ID: " + vendorAccId);
                        } else {
                            isReset = 0;
                            isPass = 1;
                            params.put("isReset", isReset);
                            params.put("isPass", isPass);
                            message.setCode(AppConstants.FAIL);
                            message.setData(params);
                            message.setMessage("Vendor existed in Pending stage.");
                        }
                    }
                }
            }

    } else {
                    isReset = 0;
                    isPass = 1;
                    params.put("isReset", isReset);
                    params.put("isPass", isPass);
                    params.put("vendorAccId", vendorAccId);
                    message.setCode(AppConstants.FAIL);
                    message.setData(params);
                    message.setMessage("Vendor Existed. Member Account ID: " + vendorAccId);
        }

//        params.put("sameReqNo", sameReqNo);
        LOGGER.debug("params =====================================>>  " + params);
        return ResponseEntity.ok(params);

    }

    @RequestMapping(value = "/insertVendorInfo.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> insertVendorInfo(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String reqNo = vendorService.selectNextReqNo();
        params.put("reqNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        // String appvPrcssNo = vendorService.selectNextAppvPrcssNo();
        // params.put("appvPrcssNo", appvPrcssNo);
        ReturnMessage message = new ReturnMessage();

        vendorService.insertVendorInfo(params);

        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        LOGGER.debug("params =====================================>>  " + params);
        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request,
            @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendor", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        LOGGER.debug("list.size : {}", list.size());

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        // serivce 에서 파일정보를 가지고, DB 처리.
        if (list.size() > 0) {
            vendorApplication.insertVendorAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachmentList", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model,
            SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String appvPrcssNo = vendorService.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        if(params.containsKey("newClmNo") && params.get("newClmNo").toString() != null && !params.get("newClmNo").toString().equals(""))
        {
        	params.put("newReqNo", params.get("newClmNo"));
        }

        // TODO appvLineMasterTable Insert
        vendorService.insertApproveManagement(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/budgetCheck.do", method = RequestMethod.POST)
    public ResponseEntity<List<Object>> budgetCheck(@RequestBody Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params =====================================>>  " + params);

        List<Object> result = vendorService.budgetCheck(params);

        LOGGER.debug("result =====================================>>  " + result);

        return ResponseEntity.ok(result);
    }

    @RequestMapping(value = "/checkFinAppr.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> checkFinAppr(@RequestBody Map<String, Object> params, ModelMap model,
            SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();

        int subCount;
        if(params.containsKey("newClmNo") && params.get("newClmNo").toString() != null && !params.get("newClmNo").toString().equals(""))
        {
        	subCount = vendorService.checkExistClmNo(params.get("newClmNo").toString());
        }
        else
        {
        	subCount = vendorService.checkExistClmNo(params.get("newReqNo").toString());
        }


        if (subCount > 0) {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage("Claim has been submitted.");
        } else {
            List<Object> apprGridList = (List<Object>) params.get("apprGridList");

            if (apprGridList.size() > 0) {
                Map hm = null;
                List<String> appvLineUserId = new ArrayList<>();

                for (Object map : apprGridList) {
                    hm = (HashMap<String, Object>) map;
                    appvLineUserId.add(hm.get("memCode").toString());
                }

                String finAppvLineUserId = appvLineUserId.get(appvLineUserId.size() - 1);

                params.put("clmType", params.get("newReqNo").toString().substring(0, 2));
                EgovMap hm2 = vendorService.getFinApprover(params);
                String memCode = hm2.get("apprMemCode").toString();
                LOGGER.debug("getFinApprover.memCode =====================================>>  " + memCode);

                memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
                if (!finAppvLineUserId.equals(memCode)) {
                    message.setCode(AppConstants.FAIL);
                    message.setData(params);
                    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
                } else {
                    message.setCode(AppConstants.SUCCESS);
                    message.setData(params);
                    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
                }
            }
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/editVendorPop.do")
    public String editVendorPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovMap> bankList = vendorService.selectBank();
        List<EgovMap> countryList = vendorService.selectSAPCountry();

        if(!params.get("flg").equals("M")){
        	String reqNo = (String) params.get("reqNo");
            EgovMap vendorInfo = vendorService.selectVendorInfo(reqNo);
            String atchFileGrpId = String.valueOf(vendorInfo.get("atchFileGrpId"));
            LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
            // atchFileGrpId db column type number -> null인 경우 nullPointExecption
            // (String.valueOf 처리)
            // file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
            if (atchFileGrpId != "null") {
                List<EgovMap> vendorAttachList = vendorService.selectAttachList(atchFileGrpId);
                model.addAttribute("attachmentList", vendorAttachList);
                LOGGER.debug("attachmentList =====================================>>  " + vendorAttachList);
            }
            model.addAttribute("vendorInfo", vendorInfo);
            model.addAttribute("flg", params.get("flg"));
            model.addAttribute("atchFileGrpId", atchFileGrpId);
            LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);
        }
        else{
        	String vendorAccId = (String)params.get("vendorAccId");
			EgovMap vendorInfo = vendorService.selectVendorInfoMaster(vendorAccId);
			model.addAttribute("vendorInfo", vendorInfo);
			model.addAttribute("flg", params.get("flg"));
			LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);
        }

        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("memCode", vendorService.selectMemberCode(sessionVO.getMemId()));
        model.addAttribute("callType", params.get("callType"));
        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);
        model.addAttribute("appvPrcssStusCode",params.get("appvPrcssStusCode"));
        model.addAttribute("vendorAccId",params.get("vendorAccId"));

        LOGGER.debug("params =====================================>>  " + params);

        return "eAccounting/vendor/editVendorPop";
    }

    @RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpdate(MultipartHttpServletRequest request,
            @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "vendor", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        String remove = (String) params.get("remove");

        LOGGER.debug("list.size : {}", list.size());
        LOGGER.debug("remove : {}", remove);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        // serivce 에서 파일정보를 가지고, DB 처리.
        if (list.size() > 0 || !StringUtils.isEmpty(remove)) {
            // TODO
            vendorApplication.updateVendorAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachment", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/updateVendorInfo.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateVendorInfo(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) throws Exception {

        LOGGER.debug("params =====================================>>  " + params);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        vendorService.updateVendorInfo(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/MvendorRqstViewPop.do")
    public String MvendorRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("params =====================================>>  " + params);
        String vendorAccId = (String) params.get("vendorAccId");
        EgovMap vendorInfo = vendorService.selectVendorInfoMaster(vendorAccId);

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);

        List<EgovMap> bankList = vendorService.selectBank();
        List<EgovMap> countryList = vendorService.selectSAPCountry();

        if (params.containsKey("costCenter")) {
            model.addAttribute("costCenterName", params.get("costCenterName").toString());
            model.addAttribute("costCenter", params.get("costCenter").toString());
        }

        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);

        model.addAttribute("vendorInfo", vendorInfo);

        if(vendorInfo.containsKey("emroUpdName")){
        	String syncToEmroUsername = "By " + vendorInfo.get("emroUpdName").toString() + " [" +vendorInfo.get("emroUpdDate") + "]";
            model.addAttribute("updateUserName", syncToEmroUsername);
        }

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);
        return "eAccounting/vendor/vendorRequestViewMasterPop";
    }

    @RequestMapping(value = "/vendorRqstViewPop.do")
    public String vendorRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        for (int i = 0; i < appvLineInfo.size(); i++) {
            EgovMap info = appvLineInfo.get(i);
            if ("J".equals(info.get("appvStus"))) {
                String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(info);
                model.addAttribute("rejctResn", rejctResn);
            }
        }
        List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(params);

        List<EgovMap> bankList = vendorService.selectBank();
        List<EgovMap> countryList = vendorService.selectSAPCountry();

        // Approval Status 생성
        String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

        // VANNIE ADD TO GET FILE GROUP ID, FILE ID AND FILE COUNT.
        List<EgovMap> atchFileData = webInvoiceService.selectAtchFileData(params);
        String reqNo = (String) params.get("reqNo");
        EgovMap vendorInfo = vendorService.selectVendorInfo(reqNo);

        if(atchFileData.isEmpty()) {
            model.addAttribute("atchFileCnt", 0);
        } else {
            model.addAttribute("atchFileCnt", atchFileData.get(0).get("fileCnt"));
        }

        String atchFileGrpId = String.valueOf(vendorInfo.get("atchFileGrpId"));
        if(atchFileGrpId != "null") {
            List<EgovMap> vendorAttachList = vendorService.selectAttachList(atchFileGrpId);
            model.addAttribute("attachmentList", vendorAttachList);
            LOGGER.debug("attachmentList =====================================>>  " + vendorAttachList);
        }

        model.addAttribute("appvPrcssStus", appvPrcssStus);
        model.addAttribute("appvPrcssResult", appvInfoAndItems.get(0).get("appvPrcssStus"));
        if(params.containsKey("costCenter")) {
            model.addAttribute("costCenterName", params.get("costCenterName").toString());
            model.addAttribute("costCenter", params.get("costCenter").toString());
        } else {
            model.addAttribute("costCenterName", vendorInfo.get("costCenterName").toString());
            model.addAttribute("costCenter", vendorInfo.get("costCenter").toString());
        }

        model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
        model.addAttribute("vendorInfo", vendorInfo);
        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);
        model.addAttribute("viewType", params.get("viewType").toString());
        if(vendorInfo.containsKey("emroUpdName")){
        	String syncToEmroUsername = "By " + vendorInfo.get("emroUpdName").toString() + " [" +vendorInfo.get("emroUpdDate") + "]";
            model.addAttribute("updateUserName", syncToEmroUsername);
        }

        if(params.containsKey("appvPrcssNo")) {
            model.addAttribute("appvPrcssNo", params.get("appvPrcssNo"));
        }

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);

        return "eAccounting/vendor/vendorRequestViewPop";
    }

    @RequestMapping(value = "/approveRegistPop.do")
    public String approveRegistPop(ModelMap model) {
        return "eAccounting/vendor/approvalOfVendorRegistMsgPop";
    }

    @RequestMapping(value = "/approveComplePop.do")
    public String approveComplePop(ModelMap model) {
        return "eAccounting/vendor/approvalOfVendorCompletedMsgPop";
    }

    @RequestMapping(value = "/rejectRegistPop.do")
    public String rejectRegistPop(ModelMap model) {
        return "eAccounting/vendor/rejectionOfVendorRegistMsgPop";
    }

    @RequestMapping(value = "/rejectComplePop.do")
    public String rejectComplePop(ModelMap model) {
        return "eAccounting/vendor/rejectionOfVendorCompletedMsgPop";
    }

    @RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String reqNo = vendorService.selectNextReqNo();
        params.put("newClmNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        vendorService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/editApproved.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editApproved(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        String reqNo = vendorService.selectNextReqNo();
        params.put("newClmNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        vendorService.editApproved(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/existingVendorValidation.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> existingVendorValidation(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    	LOGGER.debug("params =====================================>> " + params);

    	EgovMap existingVendor = vendorService.existingVendorValidation(params);
    	LOGGER.debug("existingVendor =====================================>> " + existingVendor);
        return ResponseEntity.ok(existingVendor);
    }

    @RequestMapping(value = "/selectVendorType.do")
    public ResponseEntity<List<EgovMap>> selectVendorType(@RequestParam Map<String, Object> params) throws Exception {

      List<EgovMap> vendorTypeList = null;

      vendorTypeList = vendorService.selectVendorType(params);

      return ResponseEntity.ok(vendorTypeList);

    }

    @RequestMapping(value = "/getAppvExcelInfo.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getAppvExcelInfo(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
        //int countAppvPrcssStus = appvPrcssStus.length;
		int countAppvPrcssStus = (appvPrcssStus == null || appvPrcssStus.length == 0) ? 0 : appvPrcssStus.length;

        params.put("appvPrcssStus", appvPrcssStus);
        LOGGER.debug("countAppvPrcssStus =====================================>>  " + countAppvPrcssStus);
        params.put("countAppvPrcssStus", countAppvPrcssStus);

        String[] vendorTypeCmb = request.getParameterValues("vendorTypeCmb");
        params.put("vendorTypeCmb", vendorTypeCmb);

		List<EgovMap> list = vendorService.getAppvExcelInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(list);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(list);
	}
}
