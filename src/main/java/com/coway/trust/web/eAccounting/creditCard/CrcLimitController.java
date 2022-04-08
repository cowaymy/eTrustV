package com.coway.trust.web.eAccounting.creditCard;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    @RequestMapping(value = "/crcAllowancePlan.do")
    public String crcAllowancePlan(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== crcAllowancePlan ==========");

        List<EgovMap> crcHolder = crcLimitService.selectAllowanceCardList();
        List<EgovMap> crcPic = crcLimitService.selectAllowanceCardPicList();

        model.addAttribute("crcHolder", crcHolder);
        model.addAttribute("crcPic", crcPic);

        return "eAccounting/creditCard/crcAllowancePlan";
    }

    @RequestMapping(value = "/selectAllowancePlan.do")
    public ResponseEntity<List<EgovMap>> selectAllowancePlan(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("========== crcAllowancePlan ==========");
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

        return "eAccounting/creditCard/crcAdjustmentRejectPop";
    }
}
