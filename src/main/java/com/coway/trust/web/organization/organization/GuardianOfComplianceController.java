package com.coway.trust.web.organization.organization;

import java.io.File;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.ComplianceCallLogService;
import com.coway.trust.biz.organization.organization.GuardianOfComplianceService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;

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
	
	@Value("${com.file.upload.path}")
	private String uploadDir;
	
	@Autowired
	private FileApplication fileApplication;
	
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
		
		List<EgovMap> caseCategoryCodeList = commonService.selectReasonCodeList(params);
		model.put("caseCategoryCodeList", caseCategoryCodeList);

		// 호출될 화면
		return "organization/organization/guardianofComplianceList";
	}
	 
	@RequestMapping(value = "/guardianofComplianceAddPop.do")
	public String GuardianofComplianceAddPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");
		
		List<EgovMap> caseCategoryCodeList = commonService.selectReasonCodeList(params);
		
		params.put("typeId", "1390");
		params.put("inputId", "1");
		params.put("separator", "-");
		
		List<EgovMap> documentsCodeList = commonService.selectReasonCodeList(params);
		
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
		
		
		logger.debug("selectGuardianofComplianceList in.............");
		logger.debug("params : {}", params);
		
		List<EgovMap> mList = guardianOfComplianceService.selectGuardianofComplianceList(params);
		
	
		logger.debug("mList : {}", mList);
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
		
		formMap.put("reqstCrtUserId", sessionVo.getUserId());

		
		EgovMap resultValue = guardianOfComplianceService.saveGuardian(formMap);
		 
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
		
		List<EgovMap> caseCategoryCodeList = commonService.selectReasonCodeList(params);
		
		params.put("typeId", "1390");
		params.put("inputId", "1");
		params.put("separator", "-");
		
		List<EgovMap> documentsCodeList = commonService.selectReasonCodeList(params);
		
		model.put("caseCategoryCodeList", caseCategoryCodeList);
		model.put("documentsCodeList", documentsCodeList);
		
		EgovMap guardianofCompliance = guardianOfComplianceService.selectGuardianofComplianceInfo(params);
		
		model.put("guardianofCompliance", guardianofCompliance);
		
		// 호출될 화면
		return "organization/organization/guardianofComplianceViewPop";
	}		
}
