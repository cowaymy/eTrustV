package com.coway.trust.web.organization.organization;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.organization.organization.ComplianceCallLogService;
import com.coway.trust.biz.organization.organization.GuardianOfComplianceService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization/compliance")
public class GuardianOfComplianceController {
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "guardianOfComplianceService")
	private GuardianOfComplianceService guardianOfComplianceService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	/**
	 * Organization Compliance Call Log
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/guardianofComplianceList.do")
	public String GuardianofComplianceList(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> caseCategoryCodeList = guardianOfComplianceService.selectReasonCodeList(params);
		model.put("caseCategoryCodeList", caseCategoryCodeList);

		// 호출될 화면
		return "organization/organization/guardianofComplianceList";
	}

	@RequestMapping(value = "/guardianofComplianceAddPop.do")
	public String GuardianofComplianceAddPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> caseCategoryCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		params.put("typeId", "1390");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> documentsCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		model.put("caseCategoryCodeList", caseCategoryCodeList);
		model.put("documentsCodeList", documentsCodeList);

		// 호출될 화면
		return "organization/organization/guardianofComplianceAddPop";
	}

	@RequestMapping(value = "/selectGuardianofComplianceList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGuardianofComplianceList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		String[] caseCategoryList = request.getParameterValues("caseCategory");
		params.put("caseCategoryList", caseCategoryList);

		String[] requestStatusIdList = request.getParameterValues("requestStatusId");
		params.put("requestStatusIdList", requestStatusIdList);


		//logger.debug("selectGuardianofComplianceList in.............");
		//logger.debug("params : {}", params);

		List<EgovMap> mList = guardianOfComplianceService.selectGuardianofComplianceList(params);


		//logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}

	@RequestMapping(value = "/selectGuardianofComplianceListCodyHP.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGuardianofComplianceListCodyHP(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String[] caseCategoryList = request.getParameterValues("caseCategory");
		params.put("caseCategoryList", caseCategoryList);

		String[] requestStatusIdList = request.getParameterValues("requestStatusId");
		params.put("requestStatusIdList", requestStatusIdList);


		logger.debug("selectGuardianofComplianceList in.............");
		logger.debug("params : {}", params);

		List<EgovMap> mList = guardianOfComplianceService.selectGuardianofComplianceListCodyHP(params, sessionVO);


		logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}

	@RequestMapping(value = "/selectGuardianofComplianceListSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGuardianofComplianceListSearch(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		//String[] caseCategoryList = request.getParameterValues("caseCategory");
		params.put("caseCategoryList", request.getParameterValues("caseCategory"));

		//String[] requestStatusIdList = request.getParameterValues("requestStatusId");
		params.put("requestStatusIdList", request.getParameterValues("requestStatusId"));

		List<EgovMap> mList = guardianOfComplianceService.selectGuardianofComplianceListSearch(params);

		return ResponseEntity.ok(mList);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/uploadGuardianAttachPop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String uploadAttachPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {

		return "organization/organization/guardianattAchmentFileUploadPop";
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateGuardianFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		logger.debug("in  updateReTrBook ");
		logger.debug("params =====================================>>  " + params);


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "Guardian" + File.separator + "Guardian", 1024 * 1024 * 6);

		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());

		params.put("list", list);

		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", params.get("fileName").toString());

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params.get("fileGroupKey"));
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	/**
	 * Compliance Call Log Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveGuardian.do", method = RequestMethod.POST)
	public ResponseEntity <EgovMap> saveGuardian(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVo) {

		logger.debug("saveGuardian in.............");
		logger.debug("params : {}", params);

		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		logger.debug("saveGuardian formMap in.............");
		logger.debug("formMap : {}", formMap);

		// params : {form={memberId=, hidFileName=, caseCategory=1, customerName=11, salesOrdNo=22222, reqstCntnt=3333, reqstRefDt=18/12/2017, reqstMemId=444, complianceRem=55555}}

		//String comPlianceNo = guardianOfComplianceService.insertCompliance(formMap,sessionVo);






		EgovMap resultValue = guardianOfComplianceService.saveGuardian(formMap, sessionVo);

		return ResponseEntity.ok(resultValue);

	}

	//selectSalesOrdNoInfo
	@RequestMapping(value = "/selectSalesOrdNoInfo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesOrdNoInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		logger.debug("selectSalesOrdNoInfo in.............");
		logger.debug("params : {}", params);

		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop params {} ==========================================", params.toString());
		logger.debug("======================================================================================");


		List<EgovMap> mList = guardianOfComplianceService.selectSalesOrdNoInfo(params);


		logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}



	@RequestMapping(value = "/guardianofComplianceViewPop.do")
	public String GuardianofComplianceViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> caseCategoryCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		params.put("typeId", "1390");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> documentsCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		model.put("caseCategoryCodeList", caseCategoryCodeList);
		model.put("documentsCodeList", documentsCodeList);

		EgovMap guardianofCompliance = guardianOfComplianceService.selectGuardianofComplianceInfo(params);

		model.put("guardianofCompliance", guardianofCompliance);

		// 호출될 화면
		return "organization/organization/guardianofComplianceViewPop";
	}

	@RequestMapping(value = "/guardianofComplianceViewLimitPop.do")
	public String GuardianofComplianceViewLimitPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> caseCategoryCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		params.put("typeId", "1390");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> documentsCodeList = guardianOfComplianceService.selectReasonCodeList(params);

		model.put("caseCategoryCodeList", caseCategoryCodeList);
		model.put("documentsCodeList", documentsCodeList);

		EgovMap guardianofCompliance = guardianOfComplianceService.selectGuardianofComplianceInfo(params);

		model.put("guardianofCompliance", guardianofCompliance);

		// 호출될 화면
		return "organization/organization/guardianofComplianceViewLimitPop";
	}

	@RequestMapping(value = "/guardianRemark.do", method = RequestMethod.GET)
	public ResponseEntity <List<EgovMap>> getGuardianRemark(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		List<EgovMap> guardianRemarkList = guardianOfComplianceService.selectGuardianRemark(params);
		logger.debug("guardianRemarkList : {}",guardianRemarkList);
		return ResponseEntity.ok(guardianRemarkList);
	}

	@RequestMapping(value = "/saveGuardianCompliance.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertGuardianCompliance(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVo) {
		boolean success = false;
		logger.debug("params : {}",params);
		success = guardianOfComplianceService.saveGuardianCompliance(params,sessionVo);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(success);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveGuardianCompliance2.do", method = RequestMethod.POST)
	public ResponseEntity <ReturnMessage> insertGuardianCompliance2(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request,
			ModelMap model, SessionVO sessionVo) throws Exception  {
		logger.debug("======start save====== " + params);
		String atchSubPath = generateAttchmtSubPath();

		List<EgovFormBasedFileVo> list;

		list = EgovFileUploadUtil.uploadFiles(request, uploadDir, atchSubPath, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

	    params.put(CommonConstants.USER_ID, sessionVo.getUserId());

	    if (list.size() > 0) {
	      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
	      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
	      params.put("fileId", fileGroupKey);
	    }

		String comPlianceNo = guardianOfComplianceService.insertGuardian(params,sessionVo);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(comPlianceNo);
		return ResponseEntity.ok(message);
	}

	 public String generateAttchmtSubPath(){
			Date today = new Date();
			SimpleDateFormat formatAttchtDt = new SimpleDateFormat("yyyyMMdd");
			String dt = formatAttchtDt.format(today);
			String subPath = File.separator + "GOC" + File.separator  + dt.substring(0, 4) + File.separator + dt.substring(0, 6);
			return subPath;
		}

	@RequestMapping(value = "/selectOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);

		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}

		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");

		List<EgovMap> orderList = guardianOfComplianceService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}

    @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params)
    {
    	EgovMap result = guardianOfComplianceService.selectMemberByMemberIDCode(params);
    	return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/guardianAttachDownload.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> guardianAttachDownload(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap fileDownload = guardianOfComplianceService.selectAttachDownload(params);
		logger.debug("fileDownload : {}",fileDownload);
		return ResponseEntity.ok(fileDownload);
	}

	@RequestMapping(value = "/updateGuardianCompliance.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateGuardianCompliance(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVo) {
		boolean success = false;
		logger.debug("params : {}",params);
		success = guardianOfComplianceService.updateGuardianCompliance(params,sessionVo);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(success);
		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

    	Map<String, Object> attachInfo = new HashMap<String, Object>();
		attachInfo.put("atchFileGrpId", params.get("atchFileGrpId"));
		attachInfo.put("atchFileId", params.get("atchFileId"));

		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(attachInfo);

		return ResponseEntity.ok(fileInfo);
	}
}
