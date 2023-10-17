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

    	List<EgovMap> bankName = staffAdvanceService.selectBank();
    	model.addAttribute("bankName", bankName);
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

    	staffAdvanceService.saveAdvReq(params, sessionVO);

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

        staffAdvanceService.submitAdvReq(params, sessionVO);

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

        staffAdvanceService.saveAdvRef(params, sessionVO);

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
        model.addAttribute("approvalInfo", new Gson().toJson(approvalInfo));
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

    @RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        if(params.get("clmNo") != null && !params.get("clmNo").equals(""))
        {
        	String reqType = (String)params.get("clmNo");
        	String clmType = "";
        	reqType = reqType.substring(0, 2);
        	params.put("reqType", reqType);

        	if("R2".equals(reqType)) {
        		clmType = "REQ";
            } else if("A1".equals(reqType)) {
            	clmType = "REF";
            }

        	params.put("clmType", clmType);
        }
        String reqNo = staffAdvanceService.selectNextClmNo(params);
        params.put("newClmNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        staffAdvanceService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
}
