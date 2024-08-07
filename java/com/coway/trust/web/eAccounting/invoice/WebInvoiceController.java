package com.coway.trust.web.eAccounting.invoice;

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
import com.coway.trust.biz.eAccounting.budget.BudgetService;
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
@RequestMapping(value = "/eAccounting/webInvoice")
public class WebInvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(WebInvoiceController.class);

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Resource(name = "budgetService")
	private BudgetService budgetService;

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private WebInvoiceApplication webInvoiceApplication;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/webInvoice.do")
	public String webInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
	    if(params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

		return "eAccounting/webInvoice/webInvoice";
	}

	@RequestMapping(value = "/supplierSearchPop.do")
	public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("accGrp", params.get("accGrp"));
		model.addAttribute("entry", params.get("entry"));
		model.addAttribute("levelChk", params.get("levelChk"));
		return "eAccounting/webInvoice/memberAccountSearchPop";
	}

	@RequestMapping(value = "/costCenterSearchPop.do")
	public String costCenterSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("call", params.get("call"));
		return "eAccounting/webInvoice/costCenterSearchPop";
	}

	@RequestMapping(value = "/newWebInvoicePop.do")
	public String newWebInvoice(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();

		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));

		if(sessionVO.getCostCentr() != null) {
		    params.put("costCenter", sessionVO.getCostCentr());
	        EgovMap costName = (EgovMap) webInvoiceService.getCostCenterName(params);

	        model.addAttribute("costCentrNm", costName.get("costCenterName"));
		}

		return "eAccounting/webInvoice/newWebInvoicePop";
	}

	@RequestMapping(value = "/viewEditWebInvoicePop.do")
	public String viewEditWebInvoice(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		String clmNo = (String)params.get("clmNo");
		EgovMap webInvoiceInfo = webInvoiceService.selectWebInvoiceInfo(clmNo);
		List<EgovMap> webInvoiceItems = webInvoiceService.selectWebInvoiceItems(clmNo);
		LOGGER.debug("webInvoiceItems =====================================>>  " + webInvoiceItems);
		String atchFileGrpId = String.valueOf(webInvoiceInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> webInvoiceAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", webInvoiceAttachList);
		}

		model.addAttribute("webInvoiceInfo", webInvoiceInfo);
		model.addAttribute("gridDataList", webInvoiceItems);
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));

		return "eAccounting/webInvoice/viewEditWebInvoicePop";
	}

	@RequestMapping(value = "/webInvoiceAppvViewPop.do")
	public String webInvoiceAppvViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
		List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(params);

		String clmType = appvInfoAndItems.get(0).get("clmNo").toString().substring(0, 2);
		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
        memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
        params.put("memCode", memCode);
        EgovMap apprDtls = new EgovMap();
        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
        List<String> appvLineUserId = new ArrayList<>();
        for(int i = 0; i < appvLineInfo.size(); i++) {
            EgovMap info = appvLineInfo.get(i);
            appvLineUserId.add(info.get("appvLineUserId").toString());
            if(memCode.equals(info.get("appvLineUserId"))) {
                String appvPrcssResult = String.valueOf(info.get("appvStus"));
                model.addAttribute("appvPrcssResult", appvPrcssResult);
            }
        }

        if(!appvLineUserId.contains(memCode) && apprDtls != null) {
            model.addAttribute("appvPrcssResult", "R");
        }

		// TODO appvPrcssStus 생성
		String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

		// VANNIE ADD TO GET FILE GROUP ID, FILE ID AND FILE COUNT.
		if("R1".equals(clmType)) {
            List<EgovMap> atchFileData = webInvoiceService.selectAtchFileData(params);

            if(atchFileData.isEmpty()){
                model.addAttribute("atchFileCnt", 0);
            } else {
                model.addAttribute("atchFileCnt", atchFileData.get(0).get("fileCnt"));
            }
        }

		model.addAttribute("pageAuthFuncChange", params.get("pageAuthFuncChange"));
		model.addAttribute("appvPrcssStus", appvPrcssStus);
		model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));

		if(clmType.equalsIgnoreCase("R1")){
		  return "eAccounting/webInvoice/webInvoiceApproveViewR1Pop";
		} else {
		  return "eAccounting/webInvoice/webInvoiceApproveViewPop";
		}


	}

  @RequestMapping(value = "/webInvoiceRqstViewPop.do")
  public String webInvoiceRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params =====================================>>  " + params);

    String clmType = params.get("clmType").toString();

    List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
    List<String>rejectReasonList = new ArrayList<String>();
    for (int i = 0; i < appvLineInfo.size(); i++) {
      EgovMap info = appvLineInfo.get(i);
//      if ("J".equals(info.get("appvStus"))) {
      String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(info);

      if(rejctResn == null || rejctResn.isEmpty())
      {
      }
      else{
    	  rejectReasonList.add("-" + rejctResn);
      }
//      }
    }
    model.addAttribute("rejctResn", String.join("<br/>", rejectReasonList));
    List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(params);

    // TODO appvPrcssStus 생성
    String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

    // VANNIE ADD TO GET FILE GROUP ID, FILE ID AND FILE COUNT.
    List<EgovMap> atchFileData = webInvoiceService.selectAtchFileData(params);

    if (atchFileData.isEmpty()) {
      model.addAttribute("atchFileCnt", 0);
    } else {
      model.addAttribute("atchFileCnt", atchFileData.get(0).get("fileCnt"));
    }

    model.addAttribute("appvPrcssStus", appvPrcssStus);
    model.addAttribute("appvPrcssResult", appvInfoAndItems.get(0).get("appvPrcssStus"));
    model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));

    if (clmType.equalsIgnoreCase("R1")) {
      return "eAccounting/webInvoice/webInvoiceRequestViewR1Pop";
    } else {
      return "eAccounting/webInvoice/webInvoiceRequestViewPop";
    }
  }

	@RequestMapping(value = "/fileListOfAppvPrcssNoPop.do")
	public String fileListOfAppvPrcssNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = (String) params.get("appvPrcssNo");
		List<EgovMap> attachList = webInvoiceService.selectAttachListOfAppvPrcssNo(appvPrcssNo);

		model.addAttribute("attachList", attachList);

		return "eAccounting/webInvoice/attachmentFileViewPop";
	}

	@RequestMapping(value = "/fileListPop.do")
	public String fileListPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		String atchFileGrpId = (String) params.get("atchFileGrpId");
		List<EgovMap> attachList = webInvoiceService.selectAttachList(atchFileGrpId);

		model.addAttribute("attachList", attachList);

		return "eAccounting/webInvoice/attachmentFileViewPop";
	}

	@RequestMapping(value = "/approveRegistPop.do")
	public String approveRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/approvalOfWebInvoiceRegistMsgPop";
	}

	@RequestMapping(value = "/approveComplePop.do")
	public String approveComplePop(ModelMap model) {
		return "eAccounting/webInvoice/approvalOfWebInvoiceCompletedMsgPop";
	}

	@RequestMapping(value = "/rejectRegistPop.do")
	public String rejectRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/rejectionOfWebInvoiceRegistMsgPop";
	}

	@RequestMapping(value = "/rejectComplePop.do")
	public String rejectComplePop(ModelMap model) {
		return "eAccounting/webInvoice/rejectionOfWebInvoiceCompletedMsgPop";
	}

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/webInvoice/approveLinePop";
	}

	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model) {
		return "eAccounting/webInvoice/newWebInvoiceRegistMsgPop";
	}

	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/webInvoice/newWebInvoiceCompletedMsgPop";
	}

	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		List<EgovMap> list = webInvoiceService.selectSupplier(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectCostCenter.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectcostCenter(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> list = webInvoiceService.selectCostCenter(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectWebInvoiceList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectWebInvoiceList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        params.put("userId", sessionVO.getUserId());
        if (!"A1101".equals(costCentr)) {
            /*if("A1401".equals(costCentr)) {
                params.put("loginUserId", sessionVO.getUserId());
            }*/

            params.put("loginUserId", sessionVO.getUserId());

            /*EgovMap dtls = new EgovMap();
            dtls = (EgovMap) webInvoiceService.getDtls(params);

            String brnchId = "";
            String deptId = "";
            if(dtls.containsKey("userBrnchId")) {
                brnchId = dtls.get("userBrnchId").toString();
            }

            if(dtls.containsKey("userDeptId")) {
                deptId = dtls.get("userDeptId").toString();
            }

            LOGGER.debug("brnchId :: " + brnchId);
            LOGGER.debug("deptId :: " + deptId);

            params.put("brnchId", brnchId);
            params.put("deptId", deptId);*/
        }

        LOGGER.debug("params =====================================>>  " + params);

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

        params.put("appvPrcssStus", appvPrcssStus);

        List<EgovMap> list = webInvoiceService.selectWebInvoiceList(params);

        LOGGER.debug("params =====================================>>  " + list.toString());

        return ResponseEntity.ok(list);
    }

	@RequestMapping(value = "/selectApproveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectApproveList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
		params.put("memCode", memCode);

		LOGGER.debug("params =====================================>>  " + params);

		EgovMap apprDtls = new EgovMap();
		apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
		if(apprDtls != null) {
		    params.put("apprGrp", apprDtls.get("apprGrp"));
		}

		String[] pClmType = request.getParameterValues("clmType");
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		String[] vendorGrp = request.getParameterValues("vendorGrp");

		params.put("clmType", pClmType);
		params.put("appvPrcssStus", appvPrcssStus);
		params.put("vendorGrp", vendorGrp);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		List<EgovMap> list = null;

		// Temporary disable to allow HTM Activity fund to go live first
		// To remove outer most if statement
		if(params.containsKey("appvType")) {
		    if("0".equals(params.get("appvType").toString())) {
	            list = webInvoiceService.selectApproveList(params);
	        } else {
	            list = webInvoiceService.selectVendorApproveList(params);
	        }
		} else {
		    list = webInvoiceService.selectApproveList(params);
		}

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(params);

		return ResponseEntity.ok(fileInfo);
	}

	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
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

	@RequestMapping(value = "/insertWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertWebInvoiceInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String clmNo = webInvoiceService.selectNextClmNo();
		params.put("clmNo", clmNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		EgovMap dtls = new EgovMap();
		dtls = (EgovMap) webInvoiceService.getDtls(params);

		params.put("brnchId", dtls.get("userBrnchId"));
		params.put("deptId", dtls.get("userDeptId"));

		webInvoiceService.insertWebInvoiceInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateWebInvoiceInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {


		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		webInvoiceService.updateWebInvoiceInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

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

	@RequestMapping(value = "/webInvoiceApprove.do")
	public String approve(@RequestParam Map<String, Object> params, ModelMap model) {
	    if(params != null) {
	        String clmNo = (String) params.get("clmNo");
	        model.addAttribute("clmNo", clmNo);
	    }

		return "eAccounting/webInvoice/webInvoiceApprove";
	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO appvLineMasterTable Insert
		webInvoiceService.insertApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/approvalSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		List<String> clmNoArray = new ArrayList<String>();
		boolean result = true;

		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
		memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
        params.put("memCode", memCode);

		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("appvPrcssNo", appvPrcssNo);
			param.put("memCode", memCode);

			EgovMap apprDtls = new EgovMap();
            apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
			List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(param);
			List<String> appvLineUserId = new ArrayList<>();
			for(int a = 0; a < appvLineInfo.size(); a++) {
			    EgovMap info = appvLineInfo.get(a);
			    appvLineUserId.add(info.get("appvLineUserId").toString());
			}

			if(!appvLineUserId.contains(memCode)) {
			    param.put("apprGrp", apprDtls.get("apprGrp"));
			}

			int returnData = webInvoiceService.selectAppvStus(param);

			if(returnData > 0) {
				result = false;
				clmNoArray.add(String.valueOf(invoAppvInfo.get("clmNo")));
			}
		}

		ReturnMessage message = new ReturnMessage();

		if(result) {
			webInvoiceService.updateApprovalInfo(params);

			message.setCode(AppConstants.SUCCESS);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			String linesArr = "<br><br>";
			int count = 0;
			for (String clmNoArr : clmNoArray) {
				linesArr += clmNoArr + ", ";
				count++;
				if(count%3 == 0) {
					linesArr += "<br>";
				}
			}
			linesArr = linesArr.substring(0, linesArr.lastIndexOf(", "));

			params.put("clmNoArr", linesArr);

			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/rejectionSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectionSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		List<String> clmNoArray = new ArrayList<String>();
		boolean result = true;

		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
		memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
		params.put("memCode", memCode);

		List<Object> invoAppvGridList = (List<Object>) params.get("invoAppvGridList");
		for (int i = 0; i < invoAppvGridList.size(); i++) {
			Map<String, Object> invoAppvInfo = (Map<String, Object>) invoAppvGridList.get(i);
			String appvPrcssNo = (String) invoAppvInfo.get("appvPrcssNo");

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("appvPrcssNo", appvPrcssNo);
			param.put("memCode", memCode);

			EgovMap apprDtls = new EgovMap();
            apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
            List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(param);
            List<String> appvLineUserId = new ArrayList<>();
            for(int a = 0; a < appvLineInfo.size(); a++) {
                EgovMap info = appvLineInfo.get(a);
                appvLineUserId.add(info.get("appvLineUserId").toString());
            }

            if(!appvLineUserId.contains(memCode)) {
                param.put("apprGrp", apprDtls.get("apprGrp"));
            }

			int returnData = webInvoiceService.selectAppvStus(param);

			if(returnData > 0) {
				result = false;
				clmNoArray.add(String.valueOf(invoAppvInfo.get("clmNo")));
			}
		}

		ReturnMessage message = new ReturnMessage();

		if(result) {
			webInvoiceService.updateRejectionInfo(params);

			message.setCode(AppConstants.SUCCESS);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			String linesArr = "";
			int count = 0;
			for (String clmNoArr : clmNoArray) {
				linesArr = clmNoArr + ", ";
				count++;
				if(count%3 == 0) {
					linesArr += "<br>";
				}
			}
			linesArr = linesArr.substring(0, linesArr.lastIndexOf(", "));

			params.put("clmNoArr", linesArr);

			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/budgetCheck.do", method = RequestMethod.POST)
	public ResponseEntity<List<Object>> budgetCheck(@RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<Object> result = webInvoiceService.budgetCheck(params);

		LOGGER.debug("result =====================================>>  " + result);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectWebInvoiceItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWebInvoiceItemList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> itemList = webInvoiceService.selectWebInvoiceItems((String) params.get("clmNo"));

		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/budgetCodeSearchPop.do")
	public String budgetCodeSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("rowIndex", params.get("rowIndex"));
		model.addAttribute("costCentr", params.get("costCentr"));
		model.addAttribute("costCentrName", params.get("costCentrName"));
		return "eAccounting/webInvoice/budgetCodeSearch_webInvoicePop";
	}

	@RequestMapping(value = "/glAccountSearchPop.do")
	public String glAccountSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("rowIndex", params.get("rowIndex"));
		model.addAttribute("costCentr", params.get("costCentr"));
		model.addAttribute("costCentrName", params.get("costCentrName"));
		model.addAttribute("budgetCode", params.get("budgetCode"));
		model.addAttribute("budgetCodeName", params.get("budgetCodeName"));
		return "eAccounting/webInvoice/glAccountSearch_webInvoicePop";
	}

	@RequestMapping(value = "/selectBudgetCodeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBudgetCodeList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> budgetCodeList = null;

		LOGGER.debug("Params =====================================>>  " + params);

		budgetCodeList = webInvoiceService.selectBudgetCodeList(params);

		return ResponseEntity.ok(budgetCodeList);

	}

	@RequestMapping(value = "/selectGlCodeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGlCodeList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> glCodeList = null;

		LOGGER.debug("Params =====================================>>  " + params);

		glCodeList = webInvoiceService.selectGlCodeList(params);

		return ResponseEntity.ok(glCodeList);

	}

	@RequestMapping(value = "/selectTaxRate.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectTaxRate (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		EgovMap taxRate = webInvoiceService.selectTaxRate(params);

		return ResponseEntity.ok(taxRate);

	}

	@RequestMapping(value = "/selectClamUn.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectClamUn (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		EgovMap clamUn = webInvoiceService.selectClamUn(params);
		clamUn.put("clmType", params.get("clmType"));

		webInvoiceService.updateClamUn(clamUn);

		return ResponseEntity.ok(clamUn);

	}

	@RequestMapping(value = "/selectSameVender.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSameVender (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		String clmNo = webInvoiceService.selectSameVender(params);

		LOGGER.debug("clmNo =====================================>>  " + clmNo);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(clmNo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/getAppvItemOfClmUn.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getAppvItemOfClmUn(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		String clmNo = (String)params.get("clmNo");
		EgovMap webInvoiceInfo = webInvoiceService.selectWebInvoiceInfoForAppv(clmNo);
		List<EgovMap> webInvoiceItems = webInvoiceService.selectWebInvoiceItemsForAppv(clmNo);
		LOGGER.debug("webInvoiceItems =====================================>>  " + webInvoiceItems);
		String atchFileGrpId = String.valueOf(webInvoiceInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> webInvoiceAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			webInvoiceInfo.put("attachList", webInvoiceAttachList);
		}

		webInvoiceInfo.put("itemGrp", webInvoiceItems);
		webInvoiceInfo.put("expGrp", "0");

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(webInvoiceInfo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectWebInvoiceInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectWebInvoiceInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		String clmNo = (String)params.get("clmNo");

		EgovMap info = webInvoiceService.selectWebInvoiceInfo(clmNo);
		List<EgovMap> itemGrp = webInvoiceService.selectWebInvoiceItems(clmNo);

		info.put("itemGrp", itemGrp);

		String atchFileGrpId = String.valueOf(info.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> attachList = webInvoiceService.selectAttachList(atchFileGrpId);
			info.put("attachList", attachList);
		}

		return ResponseEntity.ok(info);
	}

	@RequestMapping(value = "/getAppvExcelInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getAppvExcelInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> list = webInvoiceService.getAppvExcelInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(list);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/availableAmtCp.do", method = RequestMethod.GET)
	public ResponseEntity<Map> availableAmtCp(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("============= availableAmtCp =============");
		LOGGER.debug("params =====================================>>  " + params);

		EgovMap item = new EgovMap();
		item = (EgovMap) budgetService.availableAmtCp(params);

		Map<String, Object> budgetInfo = new HashMap();
		if(item != null) {
			budgetInfo.put("totalAvailable", item.get("availableAmt"));
			budgetInfo.put("totalAvilableAdj", item.get("total"));
			budgetInfo.put("totalPending", item.get("pendAppvAmt"));
			budgetInfo.put("totalUtilized", item.get("consumAppvAmt"));
		}
		else {
			budgetInfo.put("totalAvailable", "0");
			budgetInfo.put("totalAvilableAdj", "0");
			budgetInfo.put("totalPending", "0");
			budgetInfo.put("totalUtilized", "0");
		}

		return ResponseEntity.ok(budgetInfo);
	}

	//checkBgtPlan
	@RequestMapping(value = "/checkBgtPlan.do", method = RequestMethod.GET)
	public ResponseEntity<Map> checkBgtPlan(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("============= checkBgtPlan =============");
		LOGGER.debug("params =====================================>>  " + params);

		EgovMap item = new EgovMap();
		item = (EgovMap) budgetService.checkBgtPlan(params);

		Map<String, Object> budgetInfo = new HashMap();
		budgetInfo.put("ctrlType", item.get("cntrlType"));

		return ResponseEntity.ok(budgetInfo);
	}

	   @RequestMapping(value = "/editRejected.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> editRejected(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

	        LOGGER.debug("params =====================================>>  " + params);

	        String clmNo = webInvoiceService.selectNextClmNo();
	        params.put("newClmNo", clmNo);
	        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

	        webInvoiceService.editRejected(params);

	        ReturnMessage message = new ReturnMessage();
	        message.setCode(AppConstants.SUCCESS);
	        message.setData(params);
	        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	        return ResponseEntity.ok(message);
	    }

	   @RequestMapping(value = "/getFinalApprAct.do", method = RequestMethod.GET)
	   public ResponseEntity<Map<String, Object>>  getFinalApprAct(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

	       LOGGER.debug("params =====================================>>  " + params);

	       Map<String, Object> trInfo = new HashMap();
	       EgovMap apprDtls = new EgovMap();
	       apprDtls = (EgovMap) webInvoiceService.getFinalApprAct(params);
	       trInfo.put("finalAppr", apprDtls.get("finalAppr"));
	       return ResponseEntity.ok(trInfo);
	   }

	   @RequestMapping(value = "/checkFinAppr.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> checkFinAppr(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

	        LOGGER.debug("params =====================================>>  " + params);

	        ReturnMessage message = new ReturnMessage();

	        int subCount = webInvoiceService.checkExistClmNo(params.get("clmNo").toString());

	        if(subCount > 0) {
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

	                params.put("clmType", params.get("clmNo").toString().substring(0, 2));
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
	        }

	        return ResponseEntity.ok(message);
	    }
}
