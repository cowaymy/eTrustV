package com.coway.trust.web.eAccounting.staffClaim;

import java.io.File;
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
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimService;
import com.coway.trust.biz.eAccounting.staffClaim.NewStaffClaimService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.staffClaim.NewStaffClaimController;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/newStaffClaim")
public class NewStaffClaimController {
    private static final Logger logger = LoggerFactory.getLogger(NewStaffClaimController.class);

    @Autowired
    private StaffClaimService staffClaimService;

    @Autowired
    private NewStaffClaimService newStaffClaimService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @RequestMapping(value = "/newPop.do")
    public String newPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("newPop.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

        model.addAttribute("callType", params.get("callType"));
        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());
        model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
        // return "test/staffClaimNewExpensesPop";
        logger.debug("newPop.do :: end");
        return "eAccounting/staffClaim/newStaffClaim/newExpensePop";
    }

    @RequestMapping(value = "/newDtlsPop.do")
    public String newDtlsPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("newDtlsPop.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

        model.addAttribute("callType", params.get("callType"));
        model.addAttribute("claimNo", params.get("claimNo"));
        model.addAttribute("claimType", params.get("type"));
        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());
        model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));

        if(params.containsKey("clamUn")) {
            model.addAttribute("clamUn", params.get("clamUn"));
        }
        // return "test/staffClaimNewExpensesPop";
        logger.debug("newDtlsPop.do :: end");
        return "eAccounting/staffClaim/newStaffClaim/newExpenseDetailsPop";
    }

    @RequestMapping(value = "/viewDtlsPop.do")
    public String viewDtlsPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("viewDtlsPop.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> taxCodeFlagList = staffClaimService.selectTaxCodeStaffClaimFlag();

        model.addAttribute("claimNo", params.get("claimNo"));
        model.addAttribute("claimType", params.get("claimType"));
        model.addAttribute("clmUn", params.get("clmUn"));
        model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("costCentr", sessionVO.getCostCentr());
        model.addAttribute("taxCodeList", new Gson().toJson(taxCodeFlagList));
        // return "test/staffClaimNewExpensesPop";
        logger.debug("viewDtlsPop.do :: end");
        return "eAccounting/staffClaim/newStaffClaim/viewExpenseDetailsPop";
    }

    @RequestMapping(value = "/approveLinePop.do")
    public String approveLinePop(@RequestParam Map<String, Object> params, ModelMap model) {
        logger.debug("approveLinePop.do");
        logger.debug("params :: " + params);

        model.addAttribute("claimNo", params.get("claimNo"));
        return "eAccounting/staffClaim/newStaffClaim/approveLinePop";
    }

    @RequestMapping(value = "/registrationMsgPop.do")
    public String registrationMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
        logger.debug("registrationMsgPop.do");
        logger.debug("params :: " + params);

        model.addAttribute("claimNo", params.get("claimNo"));
        return "eAccounting/staffClaim/newStaffClaim/registrationMsgPop";
    }

    /*
     * ========= FUNCTIONS =========
     */

    // Get Claim number upon initial key in of cost center, member code and claim month
    @RequestMapping(value = "/getClaimNo.do", method = RequestMethod.GET)
    public ResponseEntity<Map> getClaimNo(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model) {

        logger.debug("dtlsFileUpload.do :: start");

        EgovMap item = new EgovMap();
        item = (EgovMap) newStaffClaimService.getClaimNo();

        Map<String, Object> claimNo = new HashMap();
        claimNo.put("claimNo", item.get("clmNo"));

        return ResponseEntity.ok(claimNo);
    }

    // Initial save general claim details
    @RequestMapping(value = "/saveClaim.do")
    public ResponseEntity<ReturnMessage> saveClaim(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) {

        logger.debug("saveClaimDtls.do :: start");
        logger.debug("params :: " + params);

        // Get Cost Center description
        EgovMap costCtr = new EgovMap();
        costCtr = (EgovMap) newStaffClaimService.getCostCenter(params);

        // Prepare param insert FCM0019M
        params.put("costCenterNm", costCtr.get("costctr"));
        params.put("userId", sessionVO.getUserId());
        params.put("clmFlg", "N");

        newStaffClaimService.insertClaimMaster(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    // Save claim details per invoice (FCM0020D)
    @RequestMapping(value = "/saveClaimDtls.do")
    public ResponseEntity<EgovMap> saveClaimDtls(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) {


        logger.debug("saveClaimDtls.do :: start");
        logger.debug("params :: " + params);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        if("CM".equals(params.get("clmType"))) {
            newStaffClaimService.deleteNCDtls(params); // Normal Claim Details Delete
            newStaffClaimService.deleteCMDtls(params); // Car Mileage Details Delete
        }

        // Insert into FCM0020D + FCM0021D
        newStaffClaimService.saveClaimDtls(params);

        // Update FCM0019M
        newStaffClaimService.updateMasterClaim(params);

        EgovMap gridInfo = new EgovMap();

        List<EgovMap> summaryGrid = newStaffClaimService.getSummary(params);
        List<EgovMap> hiddenGrid = newStaffClaimService.selectStaffClaimItems((String) params.get("claimNo"));

        gridInfo.put("summaryGrid", summaryGrid);
        gridInfo.put("hiddenGrid", hiddenGrid);

        logger.debug("saveClaimDtls.do :: end");

        return ResponseEntity.ok(gridInfo);
    }

    @RequestMapping(value = "/getSummary.do")
    public ResponseEntity<List<EgovMap>> getSummary(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("getSummary.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> dtlClaimList = newStaffClaimService.getSummary(params);

        logger.debug("getSummary.do :: end");
        return ResponseEntity.ok(dtlClaimList);
    }

    @RequestMapping(value = "/getHList.do")
    public ResponseEntity<List<EgovMap>> getHList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("getHList.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> dtlClaimList = newStaffClaimService.selectStaffClaimItems((String) params.get("clmNo"));

        logger.debug("getHList.do :: end");
        return ResponseEntity.ok(dtlClaimList);
    }

    @RequestMapping(value = "/getTotal.do")
    public ResponseEntity<Map> getTotal(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("dtlsFileUpload.do :: start");

        EgovMap item = new EgovMap();
        item = (EgovMap) newStaffClaimService.getTotAmt(params);

        Map<String, Object> claimTotal = new HashMap();
        claimTotal.put("total", item.get("totAmt"));

        return ResponseEntity.ok(claimTotal);
    }

    @RequestMapping(value = "/selectStaffClaimInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectStaffClaimInfo(@RequestParam Map<String, Object> params, ModelMap model) {

        logger.debug("params =====================================>>  " + params);

        EgovMap info = newStaffClaimService.selectStaffClaimInfo(params);
        List<EgovMap> itemGrp = newStaffClaimService.selectStaffClaimItemGrp(params);

        info.put("itemGrp", itemGrp);

        String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
        logger.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
        if(atchFileGrpId != "null") {
            List<EgovMap> attachList = newStaffClaimService.selectAttachList(atchFileGrpId);
            info.put("attachList", attachList);
        }

        return ResponseEntity.ok(info);
    }

    /*
     * Delete claim master and details when expenses main pop closed TODO - Delete claim details when double click
     * select summarized claim based on invoice number grouping
     */
    @RequestMapping(value = "/removeClaim.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> removeClaim(@RequestParam Map<String, Object> params, Model model,
            SessionVO sessionVO) throws Exception {

        logger.debug("removeClaim.do :: start");
        logger.debug("params :: " + params);

        String clmType = "";
        if(params.containsKey("clmType")) {
            clmType = params.get("clmType").toString();
        }

        String clamUn = params.get("clamUn").toString();

        if("".equals(clamUn)) {
            newStaffClaimService.deleteMasterClaim(params);
            newStaffClaimService.deleteDtlsClaim(params); // Normal Claim Details Delete
        } else {
            newStaffClaimService.deleteNCDtls(params); // Normal Claim Details Delete
            if("CM".equals(clmType)) {
                newStaffClaimService.deleteCMDtls(params); // Car Mileage Details Delete
            }
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        logger.debug("removeClaim.do :: end");

        return ResponseEntity.ok(message);
    }

    // File uploading functions - Start
    // Normal Claim File Upload
    @RequestMapping(value = "/ncFileUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> ncFileUpload(MultipartHttpServletRequest request,
            @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        logger.debug("dtlsFileUpload.do :: start");
        logger.debug("params :: " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "staffClaim", AppConstants.UPLOAD_MAX_FILE_SIZE,
                true);

        logger.debug("list.size : {}", list.size());

        newStaffClaimService.insertNormalClaim(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
    // File uploading functions - End

    @RequestMapping(value = "/checkCM.do", method = RequestMethod.GET)
    public ResponseEntity<Map> checkCM(@RequestParam Map<String, Object> params, HttpServletRequest request,
            ModelMap model) {

        logger.debug("checkCM.do :: start");
        logger.debug("params :: " + params);

        EgovMap item = new EgovMap();
        item = (EgovMap) newStaffClaimService.checkCM(params);

        Map<String, Object> cmDtls = new HashMap();

        if(item != null) {
            cmDtls.put("clamUn", item.get("clamUn"));
            cmDtls.put("cnt", "1");
        } else {
            cmDtls.put("cnt", "0");
        }

        return ResponseEntity.ok(cmDtls);
    }
}
