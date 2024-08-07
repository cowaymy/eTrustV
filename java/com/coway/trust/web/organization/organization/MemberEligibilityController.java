package com.coway.trust.web.organization.organization;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.ctDutyAllowance.CtDutyAllowanceApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.organization.organization.HPMeetingPointUploadVO;
import com.coway.trust.biz.organization.organization.MemberEligibilityApplication;
import com.coway.trust.biz.organization.organization.MemberEligibilityService;
import com.coway.trust.biz.organization.organization.eHPmemberListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberEligibilityController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberEligibilityController.class);

	@Resource(name = "memberEligibilityService")
	private MemberEligibilityService memberEligibilityService;

	@Autowired
	private MemberEligibilityApplication memberEligibilityApplication;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Autowired
    private SessionHandler sessionHandler;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	/**
	 * Call member eligibility Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberEligibility.do")
	public String memberEligibility(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		// 호출될 화면
		return "organization/organization/memberEligibility";
	}

    @RequestMapping(value = "/memberEligibilitySearch", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> memberEligibilitySearch(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        List<EgovMap> memberList = null;

        LOGGER.debug("=============== memberEligibilitySearch ===============");
		LOGGER.debug("params =====================================>>  " + params);
        memberList = memberEligibilityService.selectMemberEligibility(params);

        // 데이터 리턴.
        return ResponseEntity.ok(memberList);
    }


    @RequestMapping(value = "/memberRejoinCheck.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> memberRejoinCheck(@RequestParam Map<String, Object> params, Model model) {
    	EgovMap result = memberEligibilityService.memberRejoinCheck(params);

		ReturnMessage message = new ReturnMessage();
	   	message.setMessage(result.get("message").toString());
		message.setCode(result.get("code").toString());

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/memberRejoinPop.do")
	public String memberRejoinPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		model.addAttribute("memId", params.get("memberID"));
		model.addAttribute("memName", params.get("memberName"));
		model.addAttribute("memCode", params.get("memberCode"));
		model.addAttribute("nric", params.get("nric"));

		// 호출될 화면
		return "organization/organization/memberRejoinPop";
	}

	@RequestMapping(value = "/attachTerminationFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachTerminationFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "organization" + File.separator + "memberEligibility", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		memberEligibilityApplication.insertMemberEligibilityAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());

 		if(fileInfo != null){
 			params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
		}
		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/submitMemberRejoinForm.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitMemberRejoin(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("=============== submitMemberRejoinForm.do ===============");
		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// TODO memberEligibility/Approval Insert
		memberEligibilityService.submitMemberRejoin(params);

		//Send email
		boolean isResult = false;
		isResult = memberEligibilityService.sendEmail(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();
		message.setData(params);

		if(isResult == true){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);
	}
}
