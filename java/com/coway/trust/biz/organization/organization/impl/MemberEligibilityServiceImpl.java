package com.coway.trust.biz.organization.organization.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.joda.time.LocalDate;
import org.joda.time.Months;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.CommonConstants;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.api.project.LMS.LMSApiRespForm;
import com.coway.trust.api.project.LMS.LMSMemApiForm;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.MemberEligibilityService;
import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.google.gson.Gson;
import com.ibm.icu.util.Calendar;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberEligibilityService")
public class MemberEligibilityServiceImpl extends EgovAbstractServiceImpl implements MemberEligibilityService{
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberEligibilityServiceImpl.class);

	@Resource(name = "memberEligibilityMapper")
	private MemberEligibilityMapper memberEligibilityMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Override
	public List<EgovMap> selectMemberEligibility(Map<String, Object> params) {
		return memberEligibilityMapper.selectMemberEligibility(params);
	}

	@Override
	public void submitMemberRejoin(Map<String, Object> params) {
		memberEligibilityMapper.submitMemberRejoin(params);
	}

	@Override
	public boolean sendEmail(Map<String, Object> params) {

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		//params

		//subject and contents
		String subject  = "";
		String content = "";

		List<EgovMap> picEmail = memberEligibilityMapper.getPICEmail(params);

		//List
		for(int i = 0; i < picEmail.size(); i++){
			toList.add(picEmail.get(i).get("paramVal").toString());
		}

		subject = "Member Rejoin Approval";
		content = "Dear PIC,<br /><br/>" +
                "Please proceed to Member Module (System) for Member Rejoin Approval.<br /><br/>" +
                "Kindly checking on <strong>member working history</strong> & <strong>rejoin member documents submission</strong> for your references.<br /><br />" +
                "Thank you.";


		email.setTo(toList);
		email.setHtml(true);
		email.setSubject(subject);
		email.setText(content);

		boolean isSuccess = adaptorService.sendEmail(email, false);

		return isSuccess;
	}

	@Override
	public EgovMap memberRejoinCheck(Map<String, Object> params){
		EgovMap memberRejoinInfo = memberEligibilityMapper.getMemberRejoinInfo(params);
		EgovMap memberInfo = memberEligibilityMapper.getMemberInfo(params);

		String code = "";
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
    		            		// Today
    		        			LocalDate now = LocalDate.now();

    		        			// Current Date - 12 months
    		        			LocalDate resignDate = LocalDate.parse(resignDt);
    		        			int resignDt_MonthsBetween = Months.monthsBetween(resignDate, now).getMonths();

    		        			if(resignDt_MonthsBetween >= 12){
    		        		          resignDtFlg = "Y";
    							}else{
    								resignDtFlg = "N";
    							}
    		            	}

    		            } catch(Exception ex) {
    		                ex.printStackTrace();
    		                LOGGER.error(ex.toString());
    		            }

    		            if(resignDtFlg.equals("Y")) {
    		            	code = "pass";
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
    			          		// Today
    		        			LocalDate now = LocalDate.now();

    		        			// Current Date - 24 months
    		        			LocalDate lastRankChgDate = LocalDate.parse(lastRankChgDt);
    		        			LocalDate eligibleToRejoinDt = lastRankChgDate.plusMonths(1).plusYears(2);

    		        			if( now.isEqual(eligibleToRejoinDt) || now.isAfter(eligibleToRejoinDt)){
    		        				lastRankChgDtFlg = "Y";
    							}else{
    								lastRankChgDtFlg = "N";
    							}
    						}

     		            } catch(Exception ex) {
     		                ex.printStackTrace();
     		                LOGGER.error(ex.toString());
     		            }

     		            if(lastRankChgDtFlg.equals("Y")) {
     		             	code = "pass";
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

		EgovMap result = new EgovMap();
		result.put("code", code);
		result.put("message", memMessage);

		return result;
	}
}
