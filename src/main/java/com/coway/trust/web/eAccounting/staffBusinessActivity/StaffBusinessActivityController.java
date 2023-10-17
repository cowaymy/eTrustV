package com.coway.trust.web.eAccounting.staffBusinessActivity;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.eAccounting.staffBusinessActivity.staffBusinessActivityService;
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
@RequestMapping(value = "/eAccounting/staffBusinessActivity")
public class StaffBusinessActivityController {

    private static final Logger LOGGER = LoggerFactory.getLogger(StaffBusinessActivityController.class);

    @Autowired
    private staffBusinessActivityService staffBusinessActivityService;

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Resource(name = "budgetService")
	private BudgetService budgetService;

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

    @RequestMapping(value = "/staffBusinessActivity.do")
    public String staffBusinessActivity(@RequestParam Map<String, Object> params, ModelMap model,  SessionVO sessionVO) {

    	List<EgovMap> advOcc = staffBusinessActivityService.selectAdvOccasions(params);
    	model.addAttribute("costCentr", sessionVO.getCostCentr());

    	List<EgovMap> bankName = staffBusinessActivityService.selectBank();
    	model.addAttribute("bankName", bankName);

    	model.put("advOcc", advOcc);
        return "eAccounting/staffBusinessActivity/staffBusinessActivity";
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

        List<EgovMap> list = staffBusinessActivityService.selectAdvanceList(params);

        return ResponseEntity.ok(list);
    }

 // Advance Request - On load pop up obtain configuration
    @RequestMapping(value = "/busActReqPop.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> staffTravelReq(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== busActReqPop.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        EgovMap advInfo = staffBusinessActivityService.getAdvConfig(params);
        advInfo.put("userName", sessionVO.getUserName());
        advInfo.put("userId", sessionVO.getUserId());

        EgovMap rqstInfo = staffBusinessActivityService.getRqstInfo(advInfo);
        advInfo.put("rqstCode", rqstInfo.get("rqstCode"));
        advInfo.put("rqstName", rqstInfo.get("rqstName"));
        LOGGER.debug("advInfo ==============================>> " + advInfo);

        return ResponseEntity.ok(advInfo);
    }

    @RequestMapping(value = "/getAdvClmInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getAdvClmInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== getAdvClmInfo.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        EgovMap advClmInfo = staffBusinessActivityService.getAdvClmInfo(params);
        String atchFileGrpId = String.valueOf(advClmInfo.get("fileAtchGrpId"));
        LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
        if (atchFileGrpId != "null") {
            List<EgovMap> clmAttachList = staffBusinessActivityService.selectAttachList(atchFileGrpId);
            advClmInfo.put("attachmentList", clmAttachList);
            LOGGER.debug("attachmentList =====================================>>  " + clmAttachList);
        }

        LOGGER.debug("advClmInfo ==============================>>" + advClmInfo);
        return ResponseEntity.ok(advClmInfo);
    }

    @RequestMapping(value = "/getRefDtlsGrid.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getRefDtlsGrid(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = staffBusinessActivityService.getRefDtlsGrid((String) params.get("clmNo"));

		//Start : Add Sufficient Flag for checking before submission - nora
		Map<String, Object> itemMap = null;
        List<EgovMap> repList = new ArrayList<EgovMap>();
        float availableCm = 0;
		if(itemList.size() > 0){
			Map<String, Object> gridMap = null;

			Map<String, Float> availableMap = new HashMap();

			for(int i = 0; i < itemList.size(); i++){
				gridMap = (Map<String, Object>) itemList.get(i);

				float reqstAmt = Float.valueOf(gridMap.get("totAmt").toString());
				itemMap = new HashMap<String, Object>();
				itemMap.put("stYearMonth", params.get("entryDt").toString().substring(3));
				itemMap.put("costCentr", gridMap.get("costCenter").toString());
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
						}else{
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
		//End: Add Sufficient Flag for checking before submission - nora
		LOGGER.debug("repList {} " + repList);
		return ResponseEntity.ok(repList);
	}

    /* Attachment Functions
     * New Save - Attachment Upload
     */
    @RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("=============== advReqUpload.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "staffBusinessActivity", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

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
                File.separator + "eAccounting" + File.separator + "staffBusinessActivity", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

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
    /*@RequestMapping(value = "/saveAdvReq.do", method = RequestMethod.POST)
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
                    glAccNo = "12400200";
                }
            } else if("2".equals(params.get("reqAdvType")) || "4".equals(params.get("reqAdvType"))) {
                clmType = "REF";
                glAccNo = "22200400";
            }

            params.put("clmType", clmType);
            params.put("glAccNo", glAccNo);
            params.put("expType", params.get("advOcc"));

            String clmNo = staffBusinessActivityService.selectNextClmNo(params);
            params.put("clmNo", clmNo);
            params.put("userId", sessionVO.getUserId());

            staffBusinessActivityService.insertRequest(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", clmNo);

            if("3".equals(params.get("reqAdvType"))) {
                // Staff/Company Event Advance Request
            	if(Double.parseDouble(params.get("reqTotAmt").toString()) != 0.00) {
            		hmTrv.put("advType", params.get("reqAdvType"));
                    hmTrv.put("clmSeq", clmSeq);
                    hmTrv.put("expType", params.get("advOcc"));
                    hmTrv.put("expTypeNm", params.get("advOccDesc"));
                    hmTrv.put("dAmt", params.get("reqTotAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    hmTrv.put("glAccNo", glAccNo);
                    hmTrv.put("cur", "MYR");
                    staffBusinessActivityService.insertTrvDetail(hmTrv);
                    clmSeq++;
                }
            }

        } else {
        	params.put("advType", params.get("reqAdvType"));
        	staffBusinessActivityService.editDraftRequestM(params);

            Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
            hmTrv.put("clmNo", params.get("clmNo"));

            if("3".equals(params.get("reqAdvType"))) {

                hmTrv.put("advType", params.get("reqAdvType"));

                //Business Activity Request
                if(amountFormatRemover(params.get("reqTotAmt").toString()) != 0) {
                    hmTrv.put("expType", params.get("advOcc"));
                    hmTrv.put("expTypeNm", params.get("advOccDesc"));
                    hmTrv.put("dAmt",params.get("reqTotAmt"));
                    hmTrv.put("userId", sessionVO.getUserId());
                    staffBusinessActivityService.editDraftRequestD(hmTrv);
                }

                staffBusinessActivityService.updateTotal(hmTrv);
            }
        }

        LOGGER.debug("staffBusinessActivityAdvancecontroller :: saveAdvReq :: " + params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    } */

    /* Button Functions
     * Details Saving (FCM0027M + FCM0028D)
     */
    @RequestMapping(value = "/saveAdvReq.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveAdvReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
    	LOGGER.debug("=============== saveAdvReq.do ===============");
    	LOGGER.debug("params ==============================>> " + params);

    	int count =  staffBusinessActivityService.saveAdvReq(params, sessionVO);

    	LOGGER.debug("staffBusinessActivityAdvancecontroller :: saveAdvReq :: " + params);

    	ReturnMessage message = new ReturnMessage();
    	if(count > 0){
        	message.setCode(AppConstants.SUCCESS);
        	message.setData(params);
        	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	}
    	else {
        	message.setCode(AppConstants.FAIL);
        	message.setData(params);
        	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    	}

    	return ResponseEntity.ok(message);
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/submitAdvReq.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitAdvReq(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== submitAdvReq.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        params.put("userId", sessionVO.getUserId());
        params.put("userName", sessionVO.getUserName());

        int count = staffBusinessActivityService.submitAdvReq(params, sessionVO);

        ReturnMessage message = new ReturnMessage();
        if(count > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }  else {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    /*@SuppressWarnings("unchecked")
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
        staffBusinessActivityService.insertApproveManagement(params);
        LOGGER.debug("businessActivityAdvance :: insertApproveManagement");

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                staffBusinessActivityService.insertApproveLineDetail(hm);
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
                staffBusinessActivityService.insMissAppr(mAppr);
            }

            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            if(params.containsKey("clmNo")) {
                ntf.put("clmNo", params.get("clmNo"));
            } else if(params.containsKey("refClmNo")) {
                ntf.put("clmNo", params.get("refClmNo"));
            }

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) staffBusinessActivityService.getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) staffBusinessActivityService.getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");
            ntf.put("userId", sessionVO.getUserId());

            LOGGER.debug("ntf =====================================>>  " + ntf);

            staffBusinessActivityService.insertNotification(ntf);
        }

        LOGGER.debug("businessActivityAdvance :: insert approval details");
        // Insert Approval Details
        Map hm = new HashMap<String, Object>();
        params.put("appvPrcssNo", appvPrcssNo);
        String advType = "";
        if(params.containsKey("reqAdvType")) {
            advType = (String) params.get("reqAdvType");
        } else if(params.containsKey("refAdvType_h")) {
            advType = (String) params.get("refAdvType_h");
        }

        params.put("advType", advType);
        if("1".equals(advType) || "3".equals(advType)) {
            params.put("appvItmSeq", "1");
            params.put("memAccId", params.get("payeeCode"));
            params.put("payDueDt", params.get("refdDate"));
            params.put("expType", params.get("reqAdvType"));
            if("3".equals(advType)) {
            	params.put("expTypeNm", "Staff Business Activity Expenses");
            	params.put("glAccNo", "1240300"); //12400200
            	params.put("glAccNm", "Advances-Staff Travel Expenses");
            	params.put("billPeriodFr", params.get("trvPeriodFr"));
            	params.put("billPeriodTo", params.get("trvPeriodTo"));
            	params.put("clamUn", params.get("clamUn"));
            	params.put("budgetCode", params.get("budgetCode"));
            	params.put("budgetCodeName", params.get("budgetCodeName"));
            }
            params.put("costCenter", params.get("costCenterCode"));
            params.put("costCenterNm", params.get("costCenterName"));
            params.put("amt", params.get("reqTotAmt"));
            params.put("expDesc", params.get("busActReqRem"));
            params.put("atchFileGrpId", params.get("atchFileGrpId"));
            params.put("userId", sessionVO.getUserId());
            params.put("advCurr", "MYR");

            staffBusinessActivityService.insertAppvDetails(params);
            LOGGER.debug("businessActivityAdvance :: insertAppvDetails");

        } else if("2".equals(advType) || "4".equals(advType)) {

        	params.put("appvItmSeq", "1");
        	params.put("memAccId", params.get("refPayeeCode"));
        	params.put("invcNo", params.get("trvBankRefNo"));
        	params.put("invcDt", params.get("refAdvRepayDate"));
        	params.put("expType", params.get("refAdvType"));
            if("4".equals(advType)) {
            	params.put("expTypeNm", "Staff Business Activity Expenses Repayment");
            	params.put("glAccNo", "12400200");
            	params.put("glAccNm", "ADVANCES - STAFF (COMPANY EVENTS)");
            	params.put("budgetCode", params.get("budgetCode"));
            	params.put("budgetCodeName", params.get("budgetCodeName"));
            }
            params.put("costCenter", params.get("refCostCenterCode"));
            params.put("amt", params.get("refTotExp"));
            params.put("expDesc", params.get("trvRepayRem"));
            params.put("atchFileGrpId", params.get("refAtchFileGrpId"));
            params.put("userId", sessionVO.getUserId());

            staffBusinessActivityService.insertAppvDetails(params);
            LOGGER.debug("businessActivityAdvance :: insertAppvDetails");
        }

        staffBusinessActivityService.updateAdvanceReqInfo(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    } */

    @RequestMapping(value = "/getRefundDetails.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getRefundDetails(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== getRefundDetails.do ===============");
        LOGGER.debug("params ==============================>> " + params);

		EgovMap refDtls = staffBusinessActivityService.getRefDtls(params);

        LOGGER.debug("refDtls ==============================>> " + refDtls);
        return ResponseEntity.ok(refDtls);
    }

    @RequestMapping(value = "/selectStaffClaimItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStaffClaimItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = staffBusinessActivityService.getRefDtlsGrid((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

    @RequestMapping(value = "/selectClamUn.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectClamUn (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		EgovMap clamUn = staffBusinessActivityService.selectClamUn(params);
		clamUn.put("clmType", params.get("clmType"));

		staffBusinessActivityService.updateClamUn(clamUn);

		return ResponseEntity.ok(clamUn);

	}

    @RequestMapping(value = "/saveAdvRef.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveAdvRef(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("=============== saveAdvRef.do ===============");
        LOGGER.debug("params ==============================>> " + params);

        int count = staffBusinessActivityService.saveAdvRef(params, sessionVO);

        ReturnMessage message = new ReturnMessage();

        if(count > 0) {
            message.setCode(AppConstants.SUCCESS);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }  else {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }

        return ResponseEntity.ok(message);
    }

    /*@RequestMapping(value = "/saveAdvRef.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveAdvRef(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
    	LOGGER.debug("=============== saveAdvRef.do ===============");
    	LOGGER.debug("params ==============================>> " + params);

    	int clmSeq = 1;

    	params.put("clmType", "REF");
    	params.put("glAccNo", "22200400");
    	if(params.get("refAdvType_h") != "")
    	{
    		params.put("refAdvType", params.get("refAdvType_h"));
    	}

    	if(params.get("refAdvType_h") != "" && params.get("refAdvType_h").equals("4"))
    	{
    		if(params.get("refSubmitFlg") != null && params.get("refSubmitFlg").equals("1") && params.get("refClmNo") != null)
    			params.put("clmNo", params.get("refClmNo"));
    	}

    	String pClmNo = params.containsKey("clmNo") ? params.get("clmNo").toString() : "";

    	if(pClmNo.isEmpty()) {
    		// Refund New Save

    		String clmNo = staffBusinessActivityService.selectNextClmNo(params);
    		params.put("clmNo", clmNo);
    		params.put("userId", sessionVO.getUserId());

    		// Insert FCM0027M
    		//staffBusinessActivityService.insertRefund(params);

    		Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
    		hmTrv.put("clmNo", clmNo);

    		if("3".equals(params.get("refAdvType"))) {
    			// Advance Refund for Staff Travelling Advance
    			hmTrv.put("clmSeq", clmSeq);
    			hmTrv.put("invcNo", params.get("trvBankRefNo"));
    			hmTrv.put("invcDt", params.get("trvAdvRepayDate"));
    			hmTrv.put("expType", "AD101");
    			hmTrv.put("expTypeNm", "Refund Travel Advance");
    			hmTrv.put("dAmt", params.get("trvAdvRepayAmt"));
    			hmTrv.put("advType", params.get("reqAdvType"));
    			hmTrv.put("userId", sessionVO.getUserId());
    			staffBusinessActivityService.insertTrvDetail(params);

    		} else if("4".equals(params.get("refAdvType"))) {
    			// Staff/Company Event Advance Request
    			hmTrv.put("clmSeq", clmSeq);
    			hmTrv.put("invcNo", params.get("refBankRef"));
    			hmTrv.put("invcDt", params.get("refAdvRepayDate")); //CELESTE: grab from refund details TODO change
    			hmTrv.put("expType", params.get("expType"));
    			hmTrv.put("expTypeNm", params.get("expTypeNm"));
    			hmTrv.put("dAmt", params.get("refTotExp"));
    			hmTrv.put("userId", sessionVO.getUserId());
    			params.put("advType", params.get("refAdvType_h"));
    			params.put("hmTrv", hmTrv);
    			params.put("refAdvRepayDate", params.get("refAdvRepayDate"));
    			params.put("dAmt", params.get("refTotExp"));
    			// Details
    			LOGGER.debug("params ==============================>> " + params);
    			staffBusinessActivityService.insertTrvDetail(params);
    		}
    	} else { //Refund draft update
    		params.put("clmNo", pClmNo);
    		params.put("advType", params.get("refAdvType_h"));
    		params.put("costCenterCode", params.get("refCostCenterCode"));
    		params.put("payeeCode", params.get("refPayeeCode"));
    		params.put("bankAccNo", params.get("refBankAccNo"));
    		params.put("busActReqRem", params.get("trvRepayRem"));
    		params.put("refdDate", params.get("refAdvRepayDate"));
    		params.put("refBankRef", params.get("refBankRef"));
    		params.put("bankId", params.get("bankId"));
    		params.put("totAmt", params.get("refTotExp"));
    		staffBusinessActivityService.editDraftRequestM(params);

    		Map<String, Object> hmTrv = new LinkedHashMap<String, Object>();
    		hmTrv.put("clmNo", params.get("refClmNo"));

    		if("4".equals(params.get("refAdvType"))) {
    			// Advance Refund for Staff Travelling Advance
//            	params.put("invcNo", params.get("invcNo"));
//            	params.put("invcDt", params.get("invcDt"));
    			params.put("expType", params.get("expType"));
    			params.put("expTypeNm", params.get("expTypeNm"));
    			params.put("dAmt", params.get("refTotExp"));
    			params.put("userId", sessionVO.getUserId());
    			params.put("advType", params.get("refAdvType_h"));
    			LOGGER.debug("params ==============================>> " + params);
    			staffBusinessActivityService.editDraftRequestD(params);

    		}

    	}

    	staffBusinessActivityService.updateAdvRequest(params);

    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(params);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);
    } */

    @RequestMapping(value = "/staffBusActApproveViewPop.do")
    public String staffAdvanceAppvViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        int rejctSeq = 0;

        EgovMap advType = staffBusinessActivityService.getAdvType(params);
        params.put("advType", advType.get("advType"));

        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        List<EgovMap> appvInfoAndItems = staffBusinessActivityService.selectAppvInfoAndItems(params);
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

        List<EgovMap> advOcc = staffBusinessActivityService.selectAdvOccasions2(params);
        model.put("advOcc", advOcc);

        return "eAccounting/staffBusinessActivity/staffBusActApproveViewPop";
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
        String reqNo = staffBusinessActivityService.selectNextReqNo(params);
        params.put("newClmNo", reqNo);
        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        staffBusinessActivityService.editRejected(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/checkRefdDate.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> checkRefdDate(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== checkRefdDate ==========");
        LOGGER.debug("params :: {}", params);

        String chkRtn = "";
        chkRtn = staffBusinessActivityService.checkRefdDate(params);

        ReturnMessage rtn = new ReturnMessage();
        if(chkRtn.isEmpty()) {
            rtn.setCode(AppConstants.FAIL);
            rtn.setData(chkRtn);
            rtn.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        } else {
            rtn.setCode(AppConstants.SUCCESS);
            rtn.setData(chkRtn);
            rtn.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }

        return ResponseEntity.ok(rtn);
    }

    public int amountFormatRemover(String oriAmount)
    {
    	int formattedAmount = 0;

    	oriAmount =oriAmount.replace(",", "");
    	oriAmount = oriAmount.replace(".00", "");

    	formattedAmount = Integer.parseInt(oriAmount);
    	return formattedAmount;
    }

    @RequestMapping(value = "/manualStaffBusinessAdvReqSettlement.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> manualStaffBusinessAdvReqSettlement(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("========== staffBusinessActivity.manualStaffBusinessAdvReqSettlement ==========");
        LOGGER.debug("params =====================================>>  " + params);

        int updCnt = staffBusinessActivityService.manualStaffBusinessAdvReqSettlement(params, sessionVO);

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
}
