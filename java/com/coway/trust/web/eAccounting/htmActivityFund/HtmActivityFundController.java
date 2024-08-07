package com.coway.trust.web.eAccounting.htmActivityFund;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import com.coway.trust.biz.eAccounting.htmActivityFund.HtmActivityFundService;
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/htmActivityFund")
public class HtmActivityFundController {

    private static final Logger LOGGER = LoggerFactory.getLogger(HtmActivityFundController.class);

    @Resource(name = "htmActivityFundService")
    private HtmActivityFundService htmActivityFundService;

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private StaffClaimApplication staffClaimApplication;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Value("${app.name}")
    private String appName;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @RequestMapping(value = "/htmActivityFund.do")
    public String htmActivityFund(Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        if(params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

        return "eAccounting/htmActivityFund/htmActivityFund";
    }

    @RequestMapping(value = "/newClaimPop.do")
    public String newClaimPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("htmActivityFund :: newClaimPop");

        model.addAttribute("callType", params.get("callType"));
        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());

        return "eAccounting/htmActivityFund/htmActFundNewExpensesPop";
    }

    @RequestMapping(value = "/selectHtmActFundClaimList.do")
    public ResponseEntity<List<EgovMap>> selectHtmActFundClaimList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();

        // Finance & Homecare able to view all
        if(!"A1101".equals(costCentr) && !"F1001".equals(costCentr)) {
            params.put("loginUserId", sessionVO.getUserId());
        }

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
        params.put("appvPrcssStus", appvPrcssStus);

        List<EgovMap> claimList = htmActivityFundService.selectHtmActFundClaimList(params);

        return ResponseEntity.ok(claimList);
    }

    @RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        Date dt = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String fMonth = sdf.format(dt);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "htmActFund" + File.separator + fMonth, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        LOGGER.debug("list.size : {}", list.size());

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        staffClaimApplication.insertStaffClaimAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

        params.put("attachFiles", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        Date dt = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String fMonth = sdf.format(dt);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "htmActFund" + File.separator + fMonth, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

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

    @RequestMapping(value = "/insertHtmActFundExp.do")
    public ResponseEntity<ReturnMessage> insertHtmActFundExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        htmActivityFundService.insertHtmActFundExp(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/viewHtmActFundPop.do")
    public String viewHtmActFundPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        List<EgovMap> itemList = htmActivityFundService.selectHtmActFundItems((String) params.get("clmNo"));

        model.addAttribute("callType", params.get("callType"));
        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("itemList", new Gson().toJson(itemList));
        model.addAttribute("clmNo", (String) params.get("clmNo"));
        if(itemList.size() > 0) {
            model.addAttribute("expGrp", itemList.get(0).get("expGrp"));
            model.addAttribute("appvPrcssNo", itemList.get(0).get("appvPrcssNo"));
        }
        return "eAccounting/htmActivityFund/htmActFundViewExpensesPop";
    }

    @RequestMapping(value = "/selectHtmActFundInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectHtmActFundInfo(@RequestParam Map<String, Object> params, ModelMap model) {
        EgovMap info = htmActivityFundService.selectHtmClaimInfo(params);
        List<EgovMap> itemGrp = htmActivityFundService.selectHtmActFundItemGrp(params);

        info.put("itemGrp", itemGrp);

        String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
        LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
        if(atchFileGrpId != "null") {
            List<EgovMap> attachList = htmActivityFundService.selectAttachList(atchFileGrpId);
            info.put("attachList", attachList);
        }

        return ResponseEntity.ok(info);
    }

    @RequestMapping(value = "/updateHtmActFundExp.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateStaffClaimExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        htmActivityFundService.updateHtmActFundExp(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectHtmActFundItemList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectHtmActFundItemList(@RequestParam Map<String, Object> params, ModelMap model) {
        List<EgovMap> itemList = htmActivityFundService.selectHtmActFundItemList((String) params.get("clmNo"));
        return ResponseEntity.ok(itemList);
    }

    @RequestMapping(value = "/deleteHtmActFundExp.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> deleteHtmActFundExp(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        staffClaimApplication.deleteStaffClaimAttachBiz(FileType.WEB_DIRECT_RESOURCE, params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/approveLinePop.do")
    public String approveLinePop(ModelMap model) {
        return "eAccounting/htmActivityFund/approveLinePop";
    }

    @RequestMapping(value = "/registrationMsgPop.do")
    public String registrationMsgPop(ModelMap model) {
        return "eAccounting/htmActivityFund/registrationMsgPop";
    }

    @RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
        params.put("appvPrcssNo", appvPrcssNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        htmActivityFundService.insertApproveManagement(params);

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
        return "eAccounting/htmActivityFund/completedMsgPop";
    }
}
