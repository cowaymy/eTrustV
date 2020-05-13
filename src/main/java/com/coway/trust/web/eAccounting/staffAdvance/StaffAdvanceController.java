package com.coway.trust.web.eAccounting.staffAdvance;

import java.io.File;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.coway.trust.biz.eAccounting.staffAdvance.staffAdvanceService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceApplication;
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
@RequestMapping(value = "/eAccounting/staffAdvance")
public class StaffAdvanceController {

    private static final Logger LOGGER = LoggerFactory.getLogger(StaffAdvanceController.class);

    @Autowired
    private staffAdvanceService staffAdvanceService;

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private WebInvoiceApplication webInvoiceApplication;

    @Value("${app.name}")
    private String appName;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private SessionHandler sessionHandler;

    @RequestMapping(value = "/staffAdvance.do")
    public String staffAdvance(@RequestParam Map<String, Object> params, ModelMap model) {

        return "eAccounting/staffAdvance/staffAdvance";
    }

    // Main Menu Search Button Grid Listing
    @RequestMapping(value = "/advanceListing.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> advanceListing (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== advanceListing.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        params.put("userId", sessionVO.getUserId());

        if(!"A1101".equals(costCentr)) {
            params.put("loginUserId", sessionVO.getUserId());
        }

        String[] advType = request.getParameterValues("advType");
        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
        String[] refundStus = request.getParameterValues("refundStus");

        params.put("advType", advType);
        params.put("appvPrcssStus", appvPrcssStus);
        params.put("refundStus", refundStus);

        List<EgovMap> list = staffAdvanceService.selectAdvanceList(params);

        return ResponseEntity.ok(list);
    }

    // Advance Request - On load pop up obtain configuration
    @RequestMapping(value = "/advReqPop.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> staffTravelReq(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== advReqPop.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        EgovMap advInfo = staffAdvanceService.getAdvConfig(params);
        advInfo.put("userName", sessionVO.getUserName());
        advInfo.put("userId", sessionVO.getUserId());

        EgovMap rqstInfo = staffAdvanceService.getRqstInfo(advInfo);
        advInfo.put("rqstCode", rqstInfo.get("rqstCode"));
        advInfo.put("rqstName", rqstInfo.get("rqstName"));

        return ResponseEntity.ok(advInfo);
    }

    /* Attachment Functions
     * New Save - Attachment Upload
     */
    @RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("=============== advReqUpload.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "staffAdvance", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        LOGGER.debug("list.size : {}", list.size());

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if (list.size() > 0) {
            webInvoiceApplication.insertWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachmentList", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    /* Attachment Functions
     * Edit Save - Attachment Update
     */
    @RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> advReqAtchUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "staffAdvance", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        String remove = (String) params.get("remove");

        LOGGER.debug("list.size : {}", list.size());
        LOGGER.debug("remove : {}", remove);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        // serivce 에서 파일정보를 가지고, DB 처리.
        if (list.size() > 0 || !StringUtils.isEmpty(remove)) {
            // TODO
            webInvoiceApplication.updateWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachment", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    /* Button Functions
     * Details Saving (FCM0027M + FCM0028D)
     */
    @RequestMapping(value = "/saveAdvReq.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveAdvReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("=============== saveAdvReq.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        String pClmNo = params.get("clmNo").toString();

        if(pClmNo.isEmpty()) {
            String clmType = "";
            String glAccNo = "";
            int clmSeq = 1;

            if("1".equals(params.get("reqAdvType")) || "3".equals(params.get("reqAdvType"))) {
                clmType = "REQ";
                if("1".equals(params.get("reqAdvType"))) {
                    glAccNo = "1240300";
                } else {
                    glAccNo = "1240200";
                }
            } else if("2".equals(params.get("reqAdvType")) || "4".equals(params.get("reqAdvType"))) {
                clmType = "REF";
                glAccNo = "22200400";
            }

            params.put("clmType", clmType);
            params.put("glAccNo", glAccNo);

            String clmNo = staffAdvanceService.selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            staffAdvanceService.insertRequest(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("1".equals(params.get("reqAdvType"))) {
                // Staff Travel Request
                if(Double.parseDouble(params.get("accmdtAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD001");
                    hmTrv.put("expTypeNm", "Accommodation");
                    hmTrv.put("dAmt", params.get("accmdtAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.insertTrvDetail(hmTrv);
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("mileageAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD002");
                    hmTrv.put("expTypeNm", "Mileage");
                    hmTrv.put("mileage", params.get("mileage"));
                    hmTrv.put("dAmt", params.get("mileageAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.insertTrvDetail(hmTrv);
                    hmTrv.put("mileage", "");
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("tollAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD003");
                    hmTrv.put("expTypeNm", "Toll");
                    hmTrv.put("dAmt", params.get("tollAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.insertTrvDetail(hmTrv);
                    clmSeq++;
                }

                if(Double.parseDouble(params.get("othTrsptAmt").toString()) != 0.00) {
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", "AD004");
                    hmTrv.put("expTypeNm", "Other Transportation");
                    hmTrv.put("dAmt", params.get("othTrsptAmt"));
                    hmTrv.put("rem", params.get("trsptMode"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.insertTrvDetail(hmTrv);
                    clmSeq++;
                }
            } else if("3".equals(params.get("reqAdvType"))) {
                // Staff/Company Event Advance Request
            }

        } else {
            staffAdvanceService.editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("clmNo"));

            if("1".equals(params.get("reqAdvType"))) {

                hmTrv.put("advType", params.get("reqAdvType"));

                // Staff Travel Request
                if(Double.parseDouble(params.get("accmdtAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD001");
                    hmTrv.put("expTypeNm", "Accommodation");
                    hmTrv.put("dAmt", params.get("accmdtAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.editDraftRequestD(hmTrv);
                }

                if(Double.parseDouble(params.get("mileageAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD002");
                    hmTrv.put("expTypeNm", "Mileage");
                    hmTrv.put("mileage", params.get("mileage"));
                    hmTrv.put("dAmt", params.get("mileageAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.editDraftRequestD(hmTrv);
                    hmTrv.put("mileage", "");
                }

                if(Double.parseDouble(params.get("tollAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD003");
                    hmTrv.put("expTypeNm", "Toll");
                    hmTrv.put("dAmt", params.get("tollAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.editDraftRequestD(hmTrv);
                }

                if(Double.parseDouble(params.get("othTrsptAmt").toString()) != 0.00) {
                    hmTrv.put("expType", "AD004");
                    hmTrv.put("expTypeNm", "Other Transportation");
                    hmTrv.put("dAmt", params.get("othTrsptAmt"));
                    hmTrv.put("rem", params.get("trsptMode"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffAdvanceService.editDraftRequestD(hmTrv);
                }

                staffAdvanceService.updateTotal(hmTrv);
            }
        }

        LOGGER.debug("staffadvancecontroller :: saveAdvReq :: " + params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/submitAdvReq.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitAdvReq(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== submitAdvReq.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        params.put("userId", sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        if(params.containsKey("refClmNo")) {
            params.put("clmNo", params.get("refClmNo"));
            params.put("appvPrcssDesc", params.get("trvRepayRem"));
        }

        String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);

        List<Object> apprGridList = (List<Object>) params.get("apprLineGrid");
        params.put("appvLineCnt", apprGridList.size());

        // Insert FCM0004M
        staffAdvanceService.insertApproveManagement(params);
        LOGGER.debug("staffAdvance :: insertApproveManagement");

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                staffAdvanceService.insertApproveLineDetail(hm);
            }

            if(params.containsKey("clmNo")) {
                params.put("clmType", params.get("clmNo").toString().substring(0, 2));
            } else if(params.containsKey("refClmNo")) {
                params.put("clmType", params.get("refClmNo").toString().substring(0, 2));
                params.put("clmNo", params.get("refClmNo"));
            }

            // Insert missed out final designated approver
            EgovMap e1 = webInvoiceService.getFinApprover(params);
            String memCode = e1.get("apprMemCode").toString();
            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
            if(!appvLineUserId.contains(memCode)) {
                Map mAppr = new HashMap<String, Object>();
                mAppr.put("appvPrcssNo", params.get("appvPrcssNo"));
                mAppr.put("userId", params.get("userId"));
                mAppr.put("memCode", memCode);
                staffAdvanceService.insMissAppr(mAppr);
            }

            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            if(params.containsKey("clmNo")) {
                ntf.put("clmNo", params.get("clmNo"));
            } else if(params.containsKey("refClmNo")) {
                ntf.put("clmNo", params.get("refClmNo"));
            }

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) staffAdvanceService.getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) staffAdvanceService.getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");

            LOGGER.debug("ntf =====================================>>  " + ntf);

            staffAdvanceService.insertNotification(ntf);
        }

        LOGGER.debug("staffAdvance :: insert approval details");
        // Insert Approval Details
        Map hm = new HashMap<String, Object>();
        hm.put("appvPrcssNo", appvPrcssNo);
        String advType = "";
        if(params.containsKey("reqAdvType")) {
            advType = (String) params.get("reqAdvType");
        } else if(params.containsKey("refAdvType")) {
            advType = (String) params.get("refAdvType");
        }

        if("1".equals(advType) || "3".equals(advType)) {
            hm.put("appvItmSeq", "1");
            hm.put("memAccId", params.get("payeeCode"));
            hm.put("payDueDt", params.get("refdDate"));
            hm.put("expType", params.get("reqAdvType"));
            if("1".equals(advType)) {
                hm.put("expTypeNm", "Staff Travel Expenses");
                hm.put("glAccNo", "1240300");
                hm.put("glAccNm", "Advances-Staff Travel Expenses");
                hm.put("billPeriodFr", params.get("trvPeriodFr"));
                hm.put("billPeriodTo", params.get("trvPeriodTo"));
            } /*else {
                hm.put("expTypeNm", "Staff/Company Events");
                hm.put("glAccNo", "1240200");
                hm.put("glAccNm", "Advances-Staff(Company/Events)");
                //hm.put("billPeriodFr", params.get(key));
                //hm.put("billPeriodTo", params.get(key));
            }*/
            hm.put("costCenter", params.get("costCenterCode"));
            hm.put("costCenterNm", params.get("costCenterName"));
            hm.put("amt", params.get("reqTotAmt"));
            hm.put("expDesc", params.get("trvReqRem"));
            hm.put("atchFileGrpId", params.get("atchFileGrpId"));
            hm.put("userId", sessionVO.getUserId());

            staffAdvanceService.insertAppvDetails(hm);
            LOGGER.debug("staffAdvance :: insertAppvDetails");

        } else if("2".equals(advType) || "4".equals(advType)) {

            hm.put("appvItmSeq", "1");
            hm.put("memAccId", params.get("refPayeeCode"));
            hm.put("invcNo", params.get("trvBankRefNo"));
            hm.put("invcDt", params.get("trvAdvRepayDate"));
            hm.put("expType", params.get("refAdvType"));
            if("2".equals(advType)) {
                hm.put("expTypeNm", "Staff Travel Expenses Repayment");
                hm.put("glAccNo", "12510100");
                hm.put("glAccNm", "CIMB Bhd 8000 58 6175");
            } /*else {
                hm.put("expTypeNm", "Staff/Company Events");
                hm.put("glAccNo", "1240200");
                hm.put("glAccNm", "Advances-Staff(Company/Events) Repayment");
                //hm.put("billPeriodFr", params.get(key));
                //hm.put("billPeriodTo", params.get(key));
            }*/
            hm.put("costCenter", params.get("refCostCenterCode"));
            hm.put("amt", params.get("trvAdvRepayAmt"));
            hm.put("expDesc", params.get("trvRepayRem"));
            hm.put("atchFileGrpId", params.get("refAtchFileGrpId"));
            hm.put("userId", sessionVO.getUserId());

            staffAdvanceService.insertAppvDetails(hm);

        }

        staffAdvanceService.updateAdvanceReqInfo(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/getRefundDetails.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getRefundDetails(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== getRefundDetails.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        EgovMap refDtls = staffAdvanceService.getRefDtls(params);

        return ResponseEntity.ok(refDtls);
    }

    @RequestMapping(value = "/saveAdvRef.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveAdvRef(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("=============== saveAdvRef.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        int clmSeq = 1;

        params.put("clmType", "REF");
        params.put("glAccNo", "22200400");

        String pClmNo = params.containsKey("clmNo") ? params.get("clmNo").toString() : "";

        if(pClmNo.isEmpty()) {
            // Refund New Save

            String clmNo = staffAdvanceService.selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            // Insert FCM0027M
            staffAdvanceService.insertRefund(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("2".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
                hmTrv.put("clmSeq", clmSeq);
                hmTrv.put("invcNo", params.get("trvBankRefNo"));
                hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
                hmTrv.put("expType", "AD101");
                hmTrv.put("expTypeNm", "Refund Travel Advance");
                hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
                hmTrv.put("userId", sessionVO.getUserId());
                staffAdvanceService.insertTrvDetail(hmTrv);

            } else if("4".equals(params.get("reqAdvType"))) {
                // Advance Refund for Staff/Company Event
            }
        } else {
            staffAdvanceService.editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("clmNo"));

            if("2".equals(params.get("refAdvType"))) {
                // Advance Refund for Staff Travelling Advance
                hmTrv.put("invcNo", params.get("trvBankRefNo"));
                hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
                hmTrv.put("expType", "AD101");
                hmTrv.put("expTypeNm", "Refund Travel Advance");
                hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
                hmTrv.put("userId", sessionVO.getUserId());
                staffAdvanceService.editDraftRequestD(hmTrv);

            }

        }

        staffAdvanceService.updateAdvRequest(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/staffAdvanceAppvViewPop.do")
    public String staffAdvanceAppvViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        int rejctSeq = 0;

        EgovMap advType = staffAdvanceService.getAdvType(params);
        params.put("advType", advType.get("advType"));

        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        List<EgovMap> appvInfoAndItems = staffAdvanceService.selectAppvInfoAndItems(params);

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

            if("J".equals(info.get("appvStus"))) {
                rejctSeq = Integer.parseInt(info.get("appvLineSeq").toString());
            }
        }

        if(!appvLineUserId.contains(memCode) && apprDtls != null) {
            model.addAttribute("appvPrcssResult", "R");
        }

        // TODO appvPrcssStus 생성
        String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

        Map<String, Object> m1 = new HashMap<String, Object>();
        m1.put("appvPrcssNo", params.get("appvPrcssNo"));
        m1.put("appvLineSeq", rejctSeq);
        if(rejctSeq != 0) {
            String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(m1);
            model.addAttribute("rejctResn", rejctResn);
        }

        model.addAttribute("pageAuthFuncChange", params.get("pageAuthFuncChange"));
        model.addAttribute("appvPrcssStus", appvPrcssStus);
        model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
        if(params.containsKey("type")) {
            model.addAttribute("type", params.get("type"));
        }

        return "eAccounting/staffAdvance/staffAdvApproveViewPop";
    }

    @RequestMapping(value = "/getAdvClmInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getAdvClmInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== getAdvClmInfo.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        EgovMap advClmInfo = staffAdvanceService.getAdvClmInfo(params);

        return ResponseEntity.ok(advClmInfo);
    }
}
