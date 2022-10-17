package com.coway.trust.web.sales.ownershipTransfer;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.ownershipTransfer.OwnershipTransferApplication;
import com.coway.trust.biz.sales.ownershipTransfer.OwnershipTransferService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ownershipTransfer")
public class OwnershipTransferController {

	private static final Logger LOGGER = LoggerFactory.getLogger(OwnershipTransferController.class);

	@Resource(name = "ownershipTransferService")
	private OwnershipTransferService ownershipTransferService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "ccpCalculateService")
	private CcpCalculateService ccpCalculateService;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private OwnershipTransferApplication ownershipTransferApplication;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/rootList.do")
	public String rootList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.info("===== rootList.do =====");


		params.put("Mem_code",sessionVO.getUserName());
		params.put("User_Role", sessionVO.getRoleId());
		model.addAttribute("user_info", params);

		return "sales/ownershipTransfer/rootList";

	}

	@RequestMapping(value = "/selectStatusCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStatusCode(@RequestParam Map<String, Object> params) {
		return ResponseEntity.ok(ownershipTransferService.selectStatusCode());
	}

	@RequestMapping(value = "/selectRootList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRootList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		LOGGER.info("params : {}", params);

		String rotAppType[] = request.getParameterValues("rotAppType");
		String rotStus[] = request.getParameterValues("rotStus");
		String rotReqBrnch[] = request.getParameterValues("rotReqBrnch");
		String rotFeedbackCode[] = request.getParameterValues("rotFeedbackCode");

		params.put("rotAppType", rotAppType);
		params.put("rotStus", rotStus);
		params.put("rotReqBrnch", rotReqBrnch);
		params.put("rotFeedbackCode", rotFeedbackCode);

		List<EgovMap> list = ownershipTransferService.selectRootList(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/requestROTSearchOrder.do")
	public String requestROTSearchOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.info("ownershipTransferController :: requestROTSearchOrder");
		LOGGER.info("params : {}", params);

		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "sales/ownershipTransfer/rootRequestOrderSearchPop";

	}

	@RequestMapping(value = "/getOrdId.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getOrdId(@RequestParam Map<String, Object> params, ModelMap model,
			SessionVO sessionVO) throws Exception {
		LOGGER.info("params : {}", params);

		ReturnMessage message = new ReturnMessage();

		List<EgovMap> ordDtls = ownershipTransferService.getSalesOrdId((String) params.get("sOrdNo"));

		if (!ordDtls.isEmpty()) {
			message.setData(ordDtls);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkActRot.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkActRot(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		LOGGER.info("params : {}", params);

		ReturnMessage message = new ReturnMessage();

		EgovMap ordDtls = ownershipTransferService.checkActRot(params);

		LOGGER.info("checkActRot ordDtls : {}", ordDtls);

		if (!ordDtls.isEmpty()) {
			message.setData(ordDtls);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/requestROT.do")
	public String requestROT(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		LOGGER.info("ownershipTransferController :: requestROT");
		LOGGER.info("params : {}", params);

		String callCenterYn = "N";
		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}

		// Retrive ROOT Request reasons
		params.put("typeId", "6241");
		List<EgovMap> requestCodeList = ownershipTransferService.rootCodeList(params);

		// Retrieve order information
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		// Retrieve Requestor Branch
		//List<EgovMap> RequestorBranch = ownershipTransferService.getRequestorBranch();


		model.put("requestReasonList", requestCodeList);
		//model.put("RequestorBranch", RequestorBranch);
		model.put("orderDetail", orderDetail);
		model.put("callCenterYn", callCenterYn);

		return "sales/ownershipTransfer/rootRequestPop";
	}

	// TODO
	// Remove
	@RequestMapping(value = "/requestROT_d.do")
	public String requestROT_d(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		LOGGER.info("ownershipTransferController :: requestROT");
		LOGGER.info("params : {}", params);

		String callCenterYn = "N";
		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}

		// Retrive ROOT Request reasons
		params.put("typeId", "6241");
		List<EgovMap> requestCodeList = ownershipTransferService.rootCodeList(params);

		// Retrieve order information
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		model.put("requestReasonList", requestCodeList);
		model.put("orderDetail", orderDetail);
		model.put("callCenterYn", callCenterYn);

		return "sales/ownershipTransfer/rootRequestPop_d";
	}

	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		LOGGER.info("ownershipTransferController :: attachmentUpload");
		LOGGER.info("params : {}", params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "sales" + File.separator + "ownershipTransfer", AppConstants.UPLOAD_MAX_FILE_SIZE,
				true);

		LOGGER.debug("attachment size ::", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		if (list.size() > 0) {
			ownershipTransferApplication.insertOwnershipTransferAttach(FileVO.createList(list),
					FileType.WEB_DIRECT_RESOURCE, params);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpdate(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		LOGGER.info("ownershipTransferController :: attachmentUpdate");
		LOGGER.info("params : {}", params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "sales" + File.separator + "ownershipTransfer", AppConstants.UPLOAD_MAX_FILE_SIZE,
				true);

		LOGGER.debug("attachment size ::", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		if (list.size() > 0) {
			ownershipTransferApplication.updateOwnershipTransferAttach(FileVO.createList(list),
					FileType.WEB_DIRECT_RESOURCE, params);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@Transactional
	@RequestMapping(value = "/saveRequest.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveRequest(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		LOGGER.info("ownershipTransferController :: saveRequest");
		LOGGER.info("params : {}", params);
		ReturnMessage message = new ReturnMessage();
		int cnt=0, cnt2=0, rotGrpId = 0, updResult=0;

		try{
    			cnt = ownershipTransferService.saveRequest(params, sessionVO);

    			EgovMap checkBundleInfo = ownershipTransferService.checkBundleInfo(params);

    			 if(checkBundleInfo != null){

    				 rotGrpId = ownershipTransferService.getRootGrpID();
    				 params.put("rotId", cnt);
    				 params.put("grpId", rotGrpId);

    				 updResult = ownershipTransferService.updRootGrpId(params);

    				 params.put("salesOrdId",  checkBundleInfo.get("salesOrdId").toString());
    				 params.put("salesOrdNo", checkBundleInfo.get("salesOrdNo").toString());

    				 cnt2 = ownershipTransferService.saveRequest(params, sessionVO);

    				 params.put("rotId", cnt2);
    				 updResult = ownershipTransferService.updRootGrpId(params);

    				 if(cnt2 < 0 || updResult < 0){
    					 throw new Error("Error");
    				 }
    			 }


    		     if(cnt > 0){
					message.setCode(AppConstants.SUCCESS);
	     	    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
				 }
				 else{
    					 throw new Error("Error");
    			 }
		}
		catch(Exception e){
			throw e;
		}

		return ResponseEntity.ok(message);
	}

	/*
	 * @RequestMapping(value = "/getOrdDetails.do", method = RequestMethod.GET) public ResponseEntity<ReturnMessage>
	 * getOrdDetails(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
	 *
	 * LOGGER.info("params : {}", params);
	 *
	 * ReturnMessage message = new ReturnMessage();
	 *
	 * int ordId = 0; ordId = ownershipTransferService.getSalesOrdId((String) params.get("sOrdNo"));
	 *
	 * EgovMap orderDetail = new EgovMap(); if(ordId != 0) { params.put("salesOrderId", ordId); orderDetail =
	 * orderDetailService.selectOrderBasicInfo(params, sessionVO);
	 *
	 * message.setData(orderDetail); message.setCode(AppConstants.SUCCESS);
	 * message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS)); } else {
	 * message.setCode(AppConstants.FAIL); message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL)); }
	 *
	 * return ResponseEntity.ok(message); }
	 */

	@RequestMapping(value = "/updateROT.do")
	public String updateROT(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		LOGGER.info("ownershipTransferController :: updateROT");
		LOGGER.info("params : {}", params);

		params.put("salesOrderId", params.get("salesOrdId"));

		String callCenterYn = "N";
		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}

		// Retrive ROOT Request reasons
		params.put("typeId", "6242");
		List<EgovMap> remarkList = ownershipTransferService.rootCodeList(params);
		params.put("typeId", "6241");
		List<EgovMap> rotReasonList = ownershipTransferService.rootCodeList(params);

		// Retrieve order information
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		// CCP Data Retrieve - Start
		EgovMap prgMap = null;
		BigDecimal prgDecimal = null;
		int resultVal = 0;
		prgMap = ccpCalculateService.getLatestOrderLogByOrderID(params);
		prgDecimal = (BigDecimal) prgMap.get("prgrsId");
		resultVal = prgDecimal.intValue();

		params.put("prgrsId", resultVal);
		EgovMap salesMan = ccpCalculateService.selectSalesManViewByOrdId(params);

		EgovMap tempMap = null;
		tempMap = (EgovMap) orderDetail.get("basicInfo");

		BigDecimal tempIntval = (BigDecimal) tempMap.get("custTypeId");

		if (tempIntval.intValue() == 965) {
			// Company
			model.addAttribute("ccpMasterId", "1");
			// Master ID for order unit
			params.put("ccpMasterId", "1");
		} else {
			// Individual1
			model.addAttribute("ccpMasterId", "0");
			// Master ID for order unit
			params.put("ccpMasterId", "2");
		}

		EgovMap fieldMap = null;
		params.put("custId", tempMap.get("custId"));

		fieldMap = ccpCalculateService.getCalViewEditField(params);

		Map<String, Object> incomMap = new HashMap<String, Object>();
		incomMap = ownershipTransferService.selectLoadIncomeRange(params);

		params.put("groupCode", params.get("ccpId"));
		EgovMap ccpInfoMap = null;
		ccpInfoMap = ownershipTransferService.selectCcpInfoByCcpId(params);
		// CCP Data Retrieve - End

		// ROT Data Retrieve - Start
		EgovMap rotInfoMap = null;
		rotInfoMap = ownershipTransferService.selectRootDetails(params);
		// ROT Data Retrieve - End

		System.out.print("HEREZ");
		System.out.println(params);
		// ROT Requestor Retrieve - Start
		EgovMap rotRequestorInfoMap = null;
		rotRequestorInfoMap = ownershipTransferService.selectRequestorInfo(params);
		System.out.println(rotRequestorInfoMap);
		// ROT Requestor Retrieve - End


		// Get ROT CCP Attachment
		if (ccpInfoMap.containsKey("ccpAtchGrpId")) {
			params.put("attachId", ccpInfoMap.get("ccpAtchGrpId"));
			List<EgovMap> atchFileData = ownershipTransferService.getAttachments(params);
			model.addAttribute("ccpAttachment", atchFileData);
		}

		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		model.addAttribute("rotId", params.get("rotId"));
		model.addAttribute("ccpId", params.get("ccpId"));
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("fieldMap", fieldMap);
		model.addAttribute("incomMap", incomMap);
		model.addAttribute("ccpInfoMap", ccpInfoMap);
		model.addAttribute("salesMan", salesMan);
		model.addAttribute("remarkList", remarkList);
		model.addAttribute("rotReasonList", rotReasonList);
		model.addAttribute("callCenterYn", callCenterYn);
		model.addAttribute("rotInfoMap", rotInfoMap);
		model.addAttribute("rotRequestorInfoMap", rotRequestorInfoMap);

		return "sales/ownershipTransfer/rootUpdatePop";
	}

	@RequestMapping(value = "/selectRotCallLog.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRotCallLog(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {
		LOGGER.info("params : {}", params);
		List<EgovMap> list = ownershipTransferService.selectRotCallLog(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectRotHistory.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRotHistory(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {
		LOGGER.info("params : {}", params);
		List<EgovMap> list = ownershipTransferService.selectRotHistory(params);
		return ResponseEntity.ok(list);
	}

	@Transactional
	@RequestMapping(value = "/saveRotCallLog.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMeetingPointGrid(@RequestBody Map<String, ArrayList<Object>> params,
			Model model, SessionVO sessionVO) {

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD);
		String userId = Integer.toString(sessionVO.getUserId());
		ReturnMessage message = new ReturnMessage();

		  try{
        		if (addList.size() > 0) {

        			int cnt = ownershipTransferService.insCallLog(addList, userId);

        			message.setCode(AppConstants.SUCCESS);
        			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        		}
        		else{
        			message.setCode(AppConstants.FAIL);
        			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        		}
		  }
		  catch (Exception e){
    		  	    throw e;
    	  }

		return ResponseEntity.ok(message);
	}

	@Transactional
	@RequestMapping(value = "/saveRotCCP.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveRotCCP(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		LOGGER.info("saveRotCCP saveRotCCP : {}", params);
    	  ReturnMessage message = new ReturnMessage();

		  try{

				int cnt = ownershipTransferService.saveRotCCP(params, sessionVO);
				EgovMap checkRootGrpId = ownershipTransferService.checkRootGrpId(params);

				if(checkRootGrpId != null){
						 params.put("editCcpId",  checkRootGrpId.get("ccpId").toString());
						 params.put("editOrdId", checkRootGrpId.get("rotOrdId").toString());
						 params.put("editAppTypeCode",  checkRootGrpId.get("appTypeCode").toString());
						 params.put("ccpRotId", checkRootGrpId.get("rotId").toString());
						 params.put("saveCcpId",  checkRootGrpId.get("ccpId").toString());
						 params.put("saveOrdId", checkRootGrpId.get("rotOrdId").toString());

						 LOGGER.info("saveRotCCP checkRootGrpId params: {}", params);

						 int cnt2 = ownershipTransferService.saveRotCCP(params, sessionVO);
				}
    	  }
		  catch (Exception e){
    		  	  throw e;
    	  }

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/getFicoScoreByAjax")
	public ResponseEntity<EgovMap> getFicoScoreByAjax(@RequestParam Map<String, Object> params) throws Exception {
		LOGGER.info("ownershipTransferController :: getFicoScoreByAjax");
		LOGGER.info("params : {}", params);

		EgovMap ccpInfoMap = null;
		ccpInfoMap = ownershipTransferService.selectCcpInfoByCcpId(params);

		return ResponseEntity.ok(ccpInfoMap);
	}

	@RequestMapping(value = "/getAttachments.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getAttachments(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception {
		LOGGER.info("ownershipTransferController :: getAttachments");
		LOGGER.info("params : {}", params);

		List<EgovMap> atchFileData = ownershipTransferService.getAttachments(params);

		ReturnMessage message = new ReturnMessage();
		message.setData(atchFileData);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params,
			ModelMap model) {
		LOGGER.info("ownershipTransferController :: getAttachmentInfo");
		LOGGER.info("params : {}", params);

		Map<String, Object> fileInfo = ownershipTransferService.getAttachmentInfo(params);

		return ResponseEntity.ok(fileInfo);
	}

	@RequestMapping(value = "/selectMemberByMemberIDCode1.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params) {
	    EgovMap result = ownershipTransferService.selectMemberByMemberIDCode(params);
	    return ResponseEntity.ok(result);
	  }

//	until here
	@Transactional
	@RequestMapping(value = "/saveRotDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveRotDetail(@RequestBody Map<String, Object> params, Model model, //for rot reason after validation
			SessionVO sessionVO) {
		LOGGER.info("ownershipTransferController :: saveRotDetail");
		LOGGER.info("params : {}", params);
		ReturnMessage message = new ReturnMessage();

		 try{

			    int cnt = ownershipTransferService.saveRotDetail(params, sessionVO);

				EgovMap checkRootGrpId = ownershipTransferService.checkRootGrpId(params);

				if(checkRootGrpId != null){
					params.put("ccpRotId",  checkRootGrpId.get("rotId").toString());
					int cnt2 = ownershipTransferService.saveRotDetail(params, sessionVO);

					if (cnt2 < 0) {
						throw new Error("Error.");
					}
				}

				if (cnt >0) {
					message.setCode(AppConstants.SUCCESS);
        			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
				}
				else{
					throw new Error("Error.");
				}
         }
         catch (Exception e){
         		  	throw e;
         }

		return ResponseEntity.ok(message);
	}


	//add in date filter for raw data - Gen Liang
	@RequestMapping(value="/rootRawDataPop.do")
	public String rootSearchRawDataPop(@RequestParam Map<String, Object> params) throws Exception{
		return "/sales/ownershipTransfer/rootRawDataPop";
	}

	//add in date filter for performance data - Gen Liang
		@RequestMapping(value="/rootPerformanceReportPop.do")
		public String rootSearchPerformanceDataPop(@RequestParam Map<String, Object> params) throws Exception{
			return "/sales/ownershipTransfer/rootPerformanceReportPop";
		}




}
