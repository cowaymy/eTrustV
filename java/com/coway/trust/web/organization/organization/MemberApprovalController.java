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
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.organization.organization.HPMeetingPointUploadVO;
import com.coway.trust.biz.organization.organization.MemberApprovalService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.eHPmemberListService;
import com.coway.trust.biz.sales.common.SalesCommonService;
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
public class MemberApprovalController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberApprovalController.class);

	@Resource(name = "memberApprovalService")
	private MemberApprovalService memberApprovalService;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	/**
	 * Call member approval Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/memberApproval.do")
	public String memberApproval(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		// 호출될 화면
		return "organization/organization/memberApproval";
	}

	@RequestMapping(value = "/memberApprovalSearch", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> memberApprovalSearch(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        List<EgovMap> memberList = null;

        LOGGER.debug("=============== memberApprovalSearch ===============");
		LOGGER.debug("params =====================================>>  " + params);

        memberList = memberApprovalService.selectMemberApproval(params);

        // 데이터 리턴.
        return ResponseEntity.ok(memberList);
    }

	@RequestMapping(value = "/memberRejoinApprovalPop.do")
	public String memberRejoinApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("eligibleId", params.get("eligibleId"));
		model.addAttribute("selectApprStatusId", params.get("selectApprStatusId"));

		return "organization/organization/memberRejoinApprovalPop";
	}

	@RequestMapping(value = "/attachTerminationFileDownload.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> attachTerminationFileDownload(@RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		EgovMap fileDownload = memberApprovalService.selectAttachDownload(params);
		LOGGER.debug("fileDownload : {}",fileDownload);
		return ResponseEntity.ok(fileDownload);
	}

	@RequestMapping(value = "/submitMemberApproval.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitMemberApproval(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
        LOGGER.debug("=============== submitMemberApprovalForm.do ===============");
		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO memberEligibility/Approval Update
		memberApprovalService.submitMemberApproval(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
