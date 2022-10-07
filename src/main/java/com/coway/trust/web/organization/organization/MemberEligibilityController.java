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

    	EgovMap memberRejoinInfo = memberEligibilityService.getMemberRejoinInfo(params);
		EgovMap memberInfo = memberEligibilityService.getMemberInfo(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
    	String memMessage = "<span style='text-alig n:center;'><span style='color:#003eff;font-size:28px;'>Alert!</span></br>" +
                        				  "<span>Note: This key in NRIC had match with previous NRIC</span></br>" +
                        				  "<span>This candidate is </span>";

		String approveStatusId = params.get("approveStatusId").toString();
		// Check selected row approval status
		if(approveStatusId.equals("5")){ // Approved
			memMessage += "<span style='color:red;'>in approved approval status</span></br>" +
									 "<span style='font-weight:bold;'>Not allow to proceed</span></span>";
		} else if (approveStatusId.equals("6")){ // Rejected
			memMessage += "<span style='color:red;'>in rejected approval status</span></br>" +
									 "<span style='font-weight:bold;'>Not allow to proceed</span></span>";
		} else {
    		// if member's rejoin Approval status = null
    		if (memberRejoinInfo == null || !memberRejoinInfo.get("apprStus").toString().equals("44")) {
    			//Check for rejoin TNC
    			if(memberInfo.size() > 0) {
    				String memType = "";
    				String resignDt = "";
    				String resignDtFlg = "";
    				String status = "";
    				String lastRankChgDt = "";
    				String lastRankChgDtFlg = "";
    				String rank = "";

    				memType = memberInfo.get("memType").toString();
    				status = memberInfo.get("stus").toString();
    				rank = memberInfo.get("rank").toString();

    				//Resigned
    				if(status.equals("51")) {
    				    resignDt = memberInfo.get("resignDt").toString();
    		            try{
    		            	if(!resignDt.equals("-")){
        		                String strDt = CommonUtils.getNowDate().substring(0,6) + "01";

        		                // Current date - 12 months
        		                Date cDt = new SimpleDateFormat("yyyyMMdd").parse(strDt);
        		                Calendar cCal = Calendar.getInstance();
        		                cCal.setTime(cDt);
        		                cCal.add(Calendar.MONTH, -12);

        		                Date rDt = new SimpleDateFormat("yyyyMMdd").parse(resignDt);
        		                Calendar rCal = Calendar.getInstance();
        		                rCal.setTime(rDt);

        		                LOGGER.debug("Resign :: " + new SimpleDateFormat("dd-MMM-yyyy").format(rCal.getTime()));
        		                LOGGER.debug("Resign :: " + new SimpleDateFormat("dd-MMM-yyyy").format(cCal.getTime()));

        		                if(rCal.before(cCal)) {
        		                    // Resignation Date is before 12 months before current date
        		                    resignDtFlg = "Y";
        		                }
    		            	}else {
    		            		resignDtFlg = "N";
    		            	}
    		            } catch(Exception ex) {
    		                ex.printStackTrace();
    		                LOGGER.error(ex.toString());
    		            }

    		            if(resignDtFlg.equals("Y")) {
    	            	    message.setCode("pass");
    		               	memMessage +=  "<span style='color:red;'>Rejoin Salesperson!</span></br>" +
    	               								"<span style='font-weight:bold;'>Are you allow to proceed?</span></span>";
    	                } else {
    	                	memMessage += "<span style='color:red;'>Resign < 12 months</span></br>" +
        											 "<span style='font-weight:bold;'>Not allow to proceed</span></span>";
    	                }

    		            //Sleeping HP - 24 months
    				} else if(status.equals("1") && rank.equals("1366") && memType.equals("1")){
    					lastRankChgDt = memberInfo.get("lastRankChgDt").toString();
    					 try{
    						if(!lastRankChgDt.equals("-")){
         		                String strRankDt = CommonUtils.getNowDate().substring(0,6) + "01";

         		                // Current date - 24 months
         		                Date cRankDt = new SimpleDateFormat("yyyyMMdd").parse(strRankDt);
         		                Calendar cRankCal = Calendar.getInstance();
         		                cRankCal.setTime(cRankDt);
         		                cRankCal.add(Calendar.MONTH, -24);

         		                Date rRankDt = new SimpleDateFormat("yyyyMMdd").parse(lastRankChgDt);
         		                Calendar rRankCal = Calendar.getInstance();
         		                rRankCal.setTime(rRankDt);

         		                LOGGER.debug("Sleeping HP :: " + new SimpleDateFormat("dd-MMM-yyyy").format(rRankCal.getTime()));
         		                LOGGER.debug("Sleeping HP :: " + new SimpleDateFormat("dd-MMM-yyyy").format(cRankCal.getTime()));

         		                if(rRankCal.before(cRankCal)) {
         		                    // Last Rank Change Date is before 24 months before current date
         		                	lastRankChgDtFlg = "Y";
         		                }
     		                }else {
     		                	lastRankChgDtFlg = "N";
     		                }
     		            } catch(Exception ex) {
     		                ex.printStackTrace();
     		                LOGGER.error(ex.toString());
     		            }

     		            if(lastRankChgDtFlg.equals("Y")) {
     		            	message.setCode("pass");
     		               	memMessage +=  "<span style='color:red;'>Sleeping HP - 24 months</span></br>" +
        											  "<span style='font-weight:bold;'>Are you allow to proceed?</span></span>";
     	                } else {
     	                	memMessage += "<span style='color:red;'> < 24 months sleeping HP </span></br>" +
     												 "<span style='font-weight:bold;'>Not allow to proceed</span></span>";
     	                }

    		            // Other status (active / terminate / Inactive)
    				} else {
    			    	memMessage += "<span style='color:red;'>"+ memberInfo.get("statusName").toString() + " status</span></br>" +
    											 "<span style='font-weight:bold;'>Not allow to proceed</span></span>";
    				}
    			}
    		} else {
    			if(memberRejoinInfo.get("apprStus").toString().equals("44")) //Pending
    			{
    				memMessage += "<span style='color:red;'>in pending approval status</span></br>" +
    										"<span style='font-weight:bold;'>Not allow to proceed</span></span>";
    			}
    		}
		}

	   	message.setMessage(memMessage);
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
