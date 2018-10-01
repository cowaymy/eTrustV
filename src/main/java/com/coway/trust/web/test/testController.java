package com.coway.trust.web.test;

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
import com.coway.trust.biz.test.TestService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/test")
public class testController {

    private static final Logger logger = LoggerFactory.getLogger(testController.class);

    @Autowired
    private StaffClaimService staffClaimService;

    @Autowired
    private TestService testService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @RequestMapping(value = "/testList.do")
    public String testList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("testList.do :: start");

        return "test/testList";
    }

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
        return "test/newExpensePop";
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
        // return "test/staffClaimNewExpensesPop";
        logger.debug("newDtlsPop.do :: end");
        return "test/newExpenseDetailsPop";
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
        return "test/viewExpenseDetailsPop";
    }

    @RequestMapping(value = "/approveLinePop.do")
    public String approveLinePop(@RequestParam Map<String, Object> params, ModelMap model) {
        logger.debug("approveLinePop.do");
        logger.debug("params :: " + params);

        model.addAttribute("claimNo", params.get("claimNo"));
        return "test/approveLinePop";
    }

    @RequestMapping(value = "/registrationMsgPop.do")
    public String registrationMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
        logger.debug("registrationMsgPop.do");
        logger.debug("params :: " + params);

        model.addAttribute("claimNo", params.get("claimNo"));
        return "test/registrationMsgPop";
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
        item = (EgovMap) testService.getClaimNo();

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
        costCtr = (EgovMap) testService.getCostCenter(params);

        // Prepare param insert FCM0019M
        params.put("costCenterNm", costCtr.get("costctr"));
        params.put("userId", sessionVO.getUserId());
        params.put("clmFlg", "N");

        testService.insertClaimMaster(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    // Save claim details per invoice (FCM0020D)
    @RequestMapping(value = "/saveClaimDtls.do")
    public ResponseEntity<List<EgovMap>> saveClaimDtls(@RequestBody Map<String, Object> params, Model model,
            SessionVO sessionVO) {


        logger.debug("saveClaimDtls.do :: start");
        logger.debug("params :: " + params);

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        // Insert into FCM0020D + FCM0021D
        testService.saveClaimDtls(params);

        // Update FCM0019M
        testService.updateMasterClaim(params);

        List<EgovMap> dtlClaimList = testService.getSummary(params);

        logger.debug("saveClaimDtls.do :: end");

        return ResponseEntity.ok(dtlClaimList);
    }

    @RequestMapping(value = "/getSummary.do")
    public ResponseEntity<List<EgovMap>> getSummary(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("getSummary.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> dtlClaimList = testService.getSummary(params);

        logger.debug("getSummary.do :: end");
        return ResponseEntity.ok(dtlClaimList);
    }

    @RequestMapping(value = "/getHList.do")
    public ResponseEntity<List<EgovMap>> getHList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("getHList.do :: start");
        logger.debug("params :: " + params);

        List<EgovMap> dtlClaimList = staffClaimService.selectStaffClaimItems((String) params.get("clmNo"));

        logger.debug("getHList.do :: end");
        return ResponseEntity.ok(dtlClaimList);
    }

    @RequestMapping(value = "/getTotal.do")
    public ResponseEntity<Map> getTotal(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        logger.debug("dtlsFileUpload.do :: start");

        EgovMap item = new EgovMap();
        item = (EgovMap) testService.getTotAmt(params);

        Map<String, Object> claimTotal = new HashMap();
        claimTotal.put("total", item.get("totAmt"));

        return ResponseEntity.ok(claimTotal);
    }

    @RequestMapping(value = "/selectStaffClaimInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectStaffClaimInfo(@RequestParam Map<String, Object> params, ModelMap model) {

        logger.debug("params =====================================>>  " + params);

        EgovMap info = testService.selectStaffClaimInfo(params);
        List<EgovMap> itemGrp = testService.selectStaffClaimItemGrp(params);

        info.put("itemGrp", itemGrp);

        String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
        logger.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
        if(atchFileGrpId != "null") {
            List<EgovMap> attachList = testService.selectAttachList(atchFileGrpId);
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

        String clmType = params.get("clmType").toString();

        String clamUn = params.get("clamUn").toString();

        if("-".equals(clamUn)) {
            testService.deleteMasterClaim(params);
            params.put("clamUn", "");
        }

        /*
         * Get list of attached file group ID Loop list delete from SYS0070M, SYS0071D
         */
       /*
        List<EgovMap> attachGrpList = testService.getAttachGrpList(params);
        logger.debug("attachGrpList :: " + attachGrpList.toString());
        for (int i = 0; i < attachGrpList.size(); i++) {

            Map<String, Object> attachMap = (Map<String, Object>) attachGrpList.get(i);
            String atchInfo = attachMap.get("atchinfo").toString();

            String[] arrAtchInfo = atchInfo.split("-");

            Map<String, Object> atchInfoMap = new HashMap<String, Object>();
            atchInfoMap.put("atchFileGrpId", arrAtchInfo[0]);
            atchInfoMap.put("atchFileId", arrAtchInfo[1]);

            //testService.deleteFileMaster(atchInfoMap);
            //testService.deleteFileDtls(atchInfoMap);
        }*/

        testService.deleteNCDtls(params); // Normal Claim Details Delete
        if("CM".equals(clmType)) {
            testService.deleteCMDtls(params); // Car Mileage Details Delete
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

        testService.insertNormalClaim(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }
    // File uploading functions - End
}
