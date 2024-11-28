package com.coway.trust.biz.organization.organization.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.math.BigDecimal;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.google.gson.Gson;
import com.ibm.icu.util.Calendar;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.WhatappsApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberListService")

public class MemberListServiceImpl extends EgovAbstractServiceImpl implements MemberListService{
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;

	@Resource(name = "commonApiService")
	  private CommonApiService commonApiService;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
    private LMSApiService lmsApiService;

	@Resource(name = "ssoLoginService")
	  private SsoLoginService ssoLoginService;

	@Value("${sso.use.flag}")
	private int ssoLoginFlag;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private WhatappsApiService whatappsApiService;

	@Value("${watapps.api.button.ehp.agreement.template}")
	 private String waApiBtnEhpAgreementTemplate;

	/*@Value("${lms.api.username}")
	private String LMSApiUser;

	@Value("${lms.api.password}")
	private String LMSApiPassword;*/

	//private SessionHandler sessionHandler;
	/**
	 * search Organization Gruop List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> nationality() {
		return memberListMapper.nationality();
	}

	public List<EgovMap> selectStatus() {
		return memberListMapper.selectStatus();
	}

	/*By KV start Position */
	public List<EgovMap> selectPosition(Map<String, Object> params) {
		return memberListMapper.selectPosition(params);
	}
	/*By KV end Position */

	/*By KV start ListReplacementCT */
	public List<EgovMap> selectReplaceCTList(Map<String, Object> params) {
		return memberListMapper.selectReplaceCTList(params);
	}
	/*By KV end ListReplacementCT */

	public List<EgovMap> selectUserBranch() {
		return memberListMapper.selectUserBranch();
	}

	public List<EgovMap> selectUser() {
		return memberListMapper.selectUser();
	}

	public List<EgovMap> selectMemberList(Map<String, Object> params) {
		return memberListMapper.selectMemberList(params);
	}

	public List<EgovMap> selectHPApplicantList(Map<String, Object> params) {
		return memberListMapper.selectHPApplicantList(params);
	}

	public String selectLastGroupCode(Map<String,Object> params){
		return memberListMapper.selectLastGroupCode(params);
	}
	@Override
	public EgovMap selectMemberListView(Map<String, Object> params) {
		return memberListMapper.selectMemberListView(params);
	}

	@Override
	public List<EgovMap> selectDocSubmission(Map<String, Object> params) {
		return memberListMapper.selectDocSubmission(params);
	}
	@Override
	public List<EgovMap> selectPromote(Map<String, Object> params) {
		return memberListMapper.selectPromote(params);
	}

	@Override
	public List<EgovMap> selectPaymentHistory(Map<String, Object> params) {
		return memberListMapper.selectPaymentHistory(params);
	}

	@Override
	public List<EgovMap> selectRenewalHistory(Map<String, Object> params) {
		return memberListMapper.selectRenewalHistory(params);
	}

	@Override
	public List<EgovMap> selectDocSubmission2(Map<String, Object> params) {
		return memberListMapper.selectDocSubmission2(params);
	}

	@Override
	public List<EgovMap> selectIssuedBank() {
		return memberListMapper.selectIssuedBank();
	}

	@Override
	public EgovMap selectApplicantConfirm(Map<String, Object> params) {
		return memberListMapper.selectApplicantConfirm(params);
	}

	@Override
	public EgovMap selectCodyPAExpired(Map<String, Object> params) {
		return memberListMapper.selectCodyPAExpired(params);
	}

	@Override
	public List<EgovMap>  selectCodyDocSubmission(Map<String, Object> params) {
		return memberListMapper.selectCodyDocSubmission(params);
	}

	@Override
	public List<EgovMap>  selectHpDocSubmission(Map<String, Object> params) {
		return memberListMapper.selectHpDocSubmission(params);
	}


	@Transactional
    @Override
    public String saveMember(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws Exception{

        String appId = "";
        String memCode = "";

        logger.debug("params : {}", params);
        // 2018-06-18 - LaiKW - Added trainee record to be inserted into applicant table
        // If HP Applicant or Trainee
        if (Integer.parseInt((String) params.get("memberType")) == 2803) {
            return insertApplicant(params, sessionVO);
        } else {

            // Mirror params value for applicant table insertion
            Map<String, Object> paramM = new HashMap<String, Object> ();
            paramM.putAll(params);

            int rank = 0;
            if (params.get("memberType").equals("1")) {
                rank = 433;
            }
            if (params.get("memberType").equals("2") || params.get("memberType").equals("3")) {
                rank = 53;
            }
            if (params.get("memberType").equals("4")) {
                rank = 427;
            }

            params.put("memberID", 0);
            params.put("memberCode", "");
            params.put("memberType", Integer.parseInt((String) params.get("memberType")));
            params.put("memberNm", params.get("memberNm").toString().trim().toUpperCase());
            params.put("fulllName", params.get("memberNm").toString().trim().toUpperCase());
            params.put("password", params.get("nric").toString().trim().substring(((String) params.get("nric")).trim().length() - 6, 6));
            params.put("nric", params.get("nric").toString().trim().toUpperCase());
            // params.put("address1", params.get("address1").toString().trim()!=null ?
            // params.get("address1").toString().trim() : "");
            // params.put("address2", params.get("address2").toString().trim()!=null ?
            // params.get("address2").toString().trim() : "");
            // params.put("address3", params.get("address3").toString().trim()!=null ?
            // params.get("address3").toString().trim() : "");
            // params.put("address4", "");
            // params.put("area", params.get("area")!=null ? Integer.parseInt(params.get("area").toString().trim()) : 0);
            // params.put("postCode", params.get("postCode")!=null ?
            // Integer.parseInt(params.get("postCode").toString().trim()) : 0);
            params.put("race", Integer.parseInt((String) params.get("cmbRace")));
            params.put("nation", Integer.parseInt((String) params.get("national")));
            params.put("marrital", Integer.parseInt((String) params.get("marrital")));
            // params.put("state", params.get("state") !=null ? Integer.parseInt(params.get("state").toString().trim()) : 0);
            params.put("country", params.get("country") != null ? Integer.parseInt(params.get("country").toString().trim()) : 0);
            params.put("mobileNo", params.get("mobileNo").toString().trim() != null ? params.get("mobileNo").toString().trim() : "");
            params.put("officeNo", params.get("officeNo").toString().trim() != null ? params.get("officeNo").toString().trim() : "");
            params.put("residenceNo", params.get("residenceNo").toString().trim() != null ? params.get("residenceNo").toString().trim() : "");
            params.put("email", params.get("email").toString().trim() != null ? params.get("email").toString().trim() : "");
            params.put("educationLvl", params.get("educationLvl") != null && params.get("educationLvl") != "" ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
            params.put("language", params.get("language") != null && params.get("language") != "" ? Integer.parseInt(params.get("language").toString().trim()) : 0);
            params.put("issuedBank", params.get("issuedBank") != null ? params.get("issuedBank").toString().trim() : "");
            params.put("bankAccNo", params.get("bankAccNo").toString().trim() != null ? params.get("bankAccNo").toString().trim() : "");
            params.put("sponsorCd", params.get("sponsorCd").toString().trim() != null ? params.get("sponsorCd").toString().trim() : "");
            params.put("reSignDate", "01/01/1900");
            params.put("termDate", "01/01/1900");
            params.put("RenewDate", params.get("joinDate"));
            params.put("AgrmntNo", "");
            params.put("branch", params.get("branch") != null && params.get("branch") != "" ? Integer.parseInt(params.get("branch").toString().trim()) : 0);
            params.put("status", "1");
            params.put("SyncCheck", 0);
            params.put("rank", rank);
            params.put("transportCd", params.get("transportCd") != null && params.get("transportCd") != "" ? Integer.parseInt(params.get("transportCd").toString().trim()) : 0);
            params.put("promoteDate", "01/01/1900");
            params.put("trNo", params.get("trNo") != null ? params.get("trNo").toString().trim() : "");
            params.put("created", new Date());
            // params.put("creator",52366); sessionVO.getUserId()
            params.put("creator", sessionVO.getUserId());
            params.put("updated", new Date());
            // params.put("updator",52366);
            params.put("updator", sessionVO.getUserId());
            params.put("memIsOutSource", 0);
            params.put("applicantID", appId != null ? appId : 0);
            params.put("BusinessesType", 1375);
            params.put("Hospitalization", 0);
            params.put("deptCode", params.get("deptCd") != null ? params.get("deptCd").toString().trim() : "");
            params.put("codyPaExpr", params.get("codyPaExpr") != null ? params.get("codyPaExpr").toString().trim() : "");
            params.put("religion", params.get("religion") != null ? params.get("religion") : "");
            // params.put("traineeType",Integer.parseInt(params.get("traineeType").toString()));

            // addr 가져오기
            params.put("areaId", params.get("areaId").toString());
            params.put("streetDtl", params.get("streetDtl") != null ? params.get("streetDtl").toString() : "");
            params.put("addrDtl", params.get("addrDtl") != null ? params.get("addrDtl").toString() : "");

            // Department
            //params.put("searchdepartment", params.get("searchdepartment").toString().trim() != null ? params.get("searchdepartment").toString().trim() : "");
            //params.put("searchSubDept", params.get("subDept").toString().trim() != null ? params.get("subDept").toString().trim() : "");
            params.put("searchdepartment", params.get("searchdepartment"));
            params.put("searchSubDept", params.get("subDept"));

            // 두번째 탭 text 가져오기
            params.put("spouseCode", params.get("spouseCode").toString().trim() != null ? params.get("spouseCode").toString().trim() : "");
            params.put("spouseName", params.get("spouseName").toString().trim() != null ? params.get("spouseName").toString().trim() : "");
            params.put("spouseNric", params.get("spouseNric").toString().trim() != null ? params.get("spouseNric").toString().trim() : "");
            params.put("spouseOcc", params.get("spouseOcc").toString().trim() != null ? params.get("spouseOcc").toString().trim() : "");
            params.put("spouseDob", params.get("spouseDob").toString().equals("") ? "01/01/1900" : params.get("spouseDob").toString().trim());
            params.put("spouseContat", params.get("spouseContat").toString().trim() != null ? params.get("spouseContat").toString().trim() : "");

            // Member UniformSize
            params.put("uniformSize", params.get("uniformSize") != null ? params.get("uniformSize").toString() : "");
            params.put("muslimahScarft", params.get("muslimahScarft") != null ? params.get("muslimahScarft").toString() : "");
            params.put("innerType", params.get("innerType") != null ? params.get("innerType").toString() : "");

            // Emergency Contact
            params.put("emergencyCntcNm", params.get("emergencyCntcNm") != null ? params.get("emergencyCntcNm").toString() : "");
            params.put("emergencyCntcNo", params.get("emergencyCntcNo") != null ? params.get("emergencyCntcNo").toString() : "");
            params.put("cmbInitials", params.get("cmbInitials") != null ? params.get("cmbInitials").toString() : "");
            params.put("cmbInitials", params.get("cmbInitials") != null ? params.get("cmbInitials").toString() : "");

            // Attach File
            params.put("atchFileGrpId", params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString() : "");
            params.put("atchFileId", params.get("atchFileId") != null ? params.get("atchFileId").toString() : "");

            Boolean success = false;

            if (params != null) {
                memCode = doSaveMember(params, docType);

            }

            //202210 - hltang - SSO Login
            // SP_DAY_USER_CRT 프로시저 호출
            if(ssoLoginFlag > 0){
                Map<String, Object> userPram = new HashMap<String, Object>();
                userPram.put("IN_MEMCODE", memCode);
                userPram.put("IN_TRAINTYPE", params.get("memberType"));
                logger.debug("SP_DAY_USER_CRT 프로시저 호출 PRAM ===>" + userPram.toString());
                memberListMapper.SP_DAY_USER_CRT(userPram);
                userPram.put("P_STATUS", userPram.get("p1"));
                logger.debug("SP_DAY_USER_CRT 프로시저 호출 결과 ===>" + userPram);
            }

            if(memCode !=null && !memCode.isEmpty()){
            	String memid = memberListMapper.getUserID(memCode);
            	Map<String, Object> memMap = new HashMap<String, Object>();
            	memMap.put("MemberID", memid);

            	//call LMS API create user --
            	// DO NOT REMOVE/ COMMENT THIS CODE WHEN COMMITTING CODE INTO SVN -- HUI DING
				Map<String, Object> returnVal = lmsApiService.lmsMemberListInsert(memMap);
				if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
					Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
					throw new RuntimeException(e1);
				}
            	//lmsMemberListInsert(memMap);
            }

            return memCode;
        }

    }

    public String insertApplicant(Map<String, Object> params, SessionVO sessionVO) {

        logger.debug("params : {}", params);

        String appId = "";

        Map<String, Object> MemApp = new HashMap<String, Object>();
        Map<String, Object> codeMap1 = new HashMap<String, Object>();

        MemApp.put("applicationID", 0);
        MemApp.put("applicantCode", "");
        MemApp.put("applicantType", Integer.parseInt((String) params.get("memberType")));
        MemApp.put("applicantName", params.get("memberNm").toString());
        MemApp.put("applicantFullName", params.get("memberNm").toString());
        MemApp.put("applicantIdentification", getRandomNumber(5));
        MemApp.put("applicantNRIC", params.get("nric").toString());
        MemApp.put("applicantDOB", params.get("Birth").toString());
        MemApp.put("applicantGender", params.get("gender"));
        MemApp.put("applicantRace", Integer.parseInt((String) params.get("cmbRace")));
        MemApp.put("applicantMarital", Integer.parseInt((String) params.get("marrital")));
        MemApp.put("applicantNationality", Integer.parseInt((String) params.get("national")));
        // MemApp.put("applicantAdd1", params.get("address1").toString().trim()!=null ?
        // params.get("address1").toString().trim() : "");
        // MemApp.put("applicantAdd2", params.get("address2").toString().trim()!=null ?
        // params.get("address2").toString().trim() : "");
        // MemApp.put("applicantAdd3", params.get("address3").toString().trim()!=null ?
        // params.get("address3").toString().trim() : "");
        // MemApp.put("applicantAdd4","");
        // MemApp.put("applicantAreald",params.get("area")!=null ?
        // Integer.parseInt(params.get("area").toString().trim()) : 0);
        // MemApp.put("applicantPostCodeId",params.get("postCode")!=null ?
        // Integer.parseInt(params.get("postCode").toString().trim()) : 0);
        // MemApp.put("applicantStateId",params.get("state") !=null ?
        // Integer.parseInt(params.get("state").toString().trim()) : 0);
        // MemApp.put("applicantCountryId",params.get("country")!=null ?
        // Integer.parseInt(params.get("country").toString().trim()) : 0);
        MemApp.put("applicantTelOffice", params.get("officeNo").toString().trim() != null ? params.get("officeNo").toString().trim() : "");
        MemApp.put("applicantTelHouse", params.get("residenceNo").toString().trim() != null ? params.get("residenceNo").toString().trim() : "");
        MemApp.put("applicantTelMobile", params.get("mobileNo").toString().trim() != null ? params.get("mobileNo").toString().trim() : "");
        MemApp.put("applicantEmail", params.get("email").toString().trim() != null ? params.get("email").toString().trim() : "");

        MemApp.put("applicantSpouseCode", params.get("spouseCode").toString().trim() != null ? params.get("spouseCode").toString().trim() : "");
        MemApp.put("applicantSpouseName", params.get("spouseName").toString().trim() != null ? params.get("spouseName").toString().trim() : "");
        MemApp.put("applicantSpouseNRIC", params.get("spouseNric").toString().trim() != null ? params.get("spouseNric").toString().trim() : "");
        MemApp.put("applicantSpouseOccupation", params.get("spouseOcc").toString().trim() != null ? params.get("spouseOcc").toString().trim() : "");
        MemApp.put("applicantSpouseTelContact", params.get("spouseContat").toString().trim() != null ? params.get("spouseContat").toString().trim() : "");
        MemApp.put("applicantSpouseDOB", params.get("spouseDob").toString().trim() != null ? params.get("spouseDob").toString().trim() : "01/01/1900");
        MemApp.put("applicantEduLevel", params.get("educationLvl") != null && params.get("educationLvl") != "" ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
        MemApp.put("applicantLanguage", params.get("language") != "" && params.get("language") != null ? Integer.parseInt(params.get("language").toString().trim()) : 0);
        MemApp.put("applicantBankID", Integer.parseInt(params.get("issuedBank").toString()));
        MemApp.put("applicantBankAccNo", params.get("bankAccNo").toString().trim());
        MemApp.put("applicantSponsorCode", params.get("sponsorCd").toString().trim() != null ? params.get("sponsorCd").toString().trim() : "");
        MemApp.put("applicantTransport", 0);
        MemApp.put("remark", "");
        MemApp.put("statusId", 44);
        MemApp.put("created", new Date());
        // MemApp.put("creator",52366);
        MemApp.put("creator", sessionVO.getUserId());
        MemApp.put("updated", new Date());
        // MemApp.put("updator",52366);
        MemApp.put("updator", sessionVO.getUserId());
        MemApp.put("confirmation", false);
        MemApp.put("confirmDate", "01/01/1900");
        MemApp.put("deptCode", params.get("deptCd").toString());
        // addr 주소 가져오기
        // MemApp.put("areaId",params.get("searchSt1").toString());
        MemApp.put("areaId", params.get("areaId").toString());
        MemApp.put("streetDtl", params.get("streetDtl") != null ? params.get("streetDtl").toString() : "");
        MemApp.put("addrDtl", params.get("addrDtl") != null ? params.get("addrDtl").toString() : "");

        // Department
        // MemApp.put("searchdepartment", params.get("searchdepartment").toString().trim()!=null ?
        // params.get("searchdepartment").toString().trim() : "");
        MemApp.put("searchdepartment", "");
        MemApp.put("searchSubDept", "");

        // 2018-07-26 - LaiKW - HP Branch and Meeting Point
        MemApp.put("meetingPoint", params.get("meetingPoint").toString());
        //MemApp.put("memBranch", params.get("branch").toString());

        if (Integer.parseInt((String) params.get("memberType")) == 2803) {
            logger.debug("MemApp : {}", MemApp);
            EgovMap appNo = getDocNo("145");
            MemApp.put("applicantCode", appNo.get("docNo"));
            logger.debug("appNo : {}", appNo);
            updateDocNoNumber("145");
        } else {
            MemApp.put("applicantCode", params.get("applicantCode"));
        }

        // insert HP applicant
        memberListMapper.insertMemApp(MemApp);
        codeMap1.put("code", "memApp");
        appId = memberListMapper.selectMemberId(codeMap1);

        /*
         * if(success){ if(Integer.parseInt((String) params.get("memberType")) == 2){ if(MemApp != null){
         * //sendSMS(params); } } }
         */

        return MemApp.get("applicantCode").toString();
    }



	public String getRandomNumber(int a){
		Random random = new Random();
		char[] chars = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
		StringBuilder sb = new StringBuilder();

		for(int i=0; i<a; i++){
			int num = random.nextInt(a);
			sb.append(chars[num]);
		}

		return sb.toString();
	}


	public void sendSMS(Map<String, Object> params){
		String phoneNumber = params.get("mobileNo").toString();

		String msg = "RM0.00 Your Cody application is successful. Cody Code: " +//MemberCode +
                ". Password: 6 digit at the back from your NRIC no. Kindly login Cody Web for activation in 2 day.";
		//PhoneNumber, Message, li.UserID, 1, 1, 975, "", 1, 0,success,,2
		//string MobileNo, string Message, int SenderUserID,
       // int Priority, int ExpireDayAdd, int SMSType, string Remark, int StatusID,
       // int RetryNo

		Map<String, Object> smsEntry =new HashMap<String, Object>();

		smsEntry.put("smsId", 0);
		smsEntry.put("SMSMessage", "");
		smsEntry.put("SMSMSISDN", phoneNumber);
		smsEntry.put("SMSTypeID", 1);
		smsEntry.put("SMSPriority", 1);
		smsEntry.put("SMSReferenceNo", "");
		smsEntry.put("SMSBatchUploadID", 0);
		smsEntry.put("SMSRemark", "");
		smsEntry.put("SMSStartAt", new Date());
		smsEntry.put("SMSExpiredAt","");
		smsEntry.put("SMSStatusID",1);
		smsEntry.put("SMSRetry",1);
		smsEntry.put("SMSCreateAt",params.get("creator"));
		smsEntry.put("SMSCreateBy",1);
		smsEntry.put("SMSUpdateAt",params.get("creator"));
		smsEntry.put("SMSUpdateBy",1);
		smsEntry.put("SMSVendorID",1);

		logger.debug("smsEntry : {}",smsEntry);
		//memberListMapper.insertSmsEntry(smsEntry);

		Map<String, Object> smsReply =new HashMap<String, Object>();

		smsReply.put("replyID", 0);
		smsReply.put("SMSID", 0);
		smsReply.put("replyCode", 0);
		smsReply.put("replyRemark", 0);
		smsReply.put("replyCreateAt", new Date());
		smsReply.put("replyCreateBy", params.get("Creator"));
		smsReply.put("replyFeedbackID", "");

		logger.debug("smsReply : {}",smsReply);
		//memberListMapper.insertSmsReply(smsReply);

	}
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	public EgovMap getDocNoNumber(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);

		if(docNoId.equals("130") && Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
			docNo = (String) selectDocNo.get("c2")+(String) selectDocNo.get("c1");
			logger.debug("docNo : {}",docNo);
			selectDocNo.put("docNo", docNo);
		}
		return selectDocNo;
	}
	public void updateDocNoNumber(String docNoId){//코드값에 따라 자리수 다르게
		EgovMap selectDocNoNumber = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNoNumber : {}",selectDocNoNumber);
		int nextDocNoNumber = Integer.parseInt((String)selectDocNoNumber.get("c1")) + 1;
		String nextDocNo="";
		if(docNoId.equals("145") || docNoId.equals("12")){
			nextDocNo = String.format("%07d", nextDocNoNumber);
		}else{//130일때,120일때,119일때
		nextDocNo = String.format("%08d", nextDocNoNumber);
		}
		selectDocNoNumber.put("nextDocNo", nextDocNo);
		logger.debug("selectDocNoNumber last : {}",selectDocNoNumber);
		memberListMapper.updateDocNo(selectDocNoNumber);
	}

	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			System.out.println("들어오면안됨");
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			System.out.println("들어와얗ㅁ");
			docNoLength = docNo.length();

			if ( prefixNo.equals("TR")) {
				docNo = docNo.replace(prefixNo, "");

				docNo.substring(2);
				logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo );
				logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo.substring(2) );
			}
		}

		logger.debug(">>>>>>>>>docNo >>>>>>>>>>>>>>>>>>>>>>>>" +docNo );

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}

	@Transactional
	public String doSaveMember(Map<String, Object> params,List<Object> docType) {
			Boolean success = false;
			String memberCode = "";
			int ID = 0;
			String nextDocNo= "";
			EgovMap selectMemberCode = null; // 각가 docNo, docNoId, prefix구함
			Map<String, Object> CodeMap = new HashMap<String, Object>();

			switch(Integer.parseInt(params.get("memberType").toString())){

			case 1:
				selectMemberCode = getDocNo("1");
				memberCode = selectMemberCode.get("docNo").toString();
				params.put("memberCode", memberCode);
				ID=1;
				nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
				logger.debug("nextDocNo : {}",nextDocNo);
				selectMemberCode.put("nextDocNo", nextDocNo);
				break;

			case 2:
				logger.debug("코디로 insert");
        		selectMemberCode = getDocNo("6");
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);
        		ID=6;
        		nextDocNo = getNextDocNo("CD",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);
        		break;

			case 3:
				logger.debug("tchenici로 insert");
        		selectMemberCode = getDocNo("7");
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);
        		ID=7;
        		nextDocNo = getNextDocNo("CT",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);
        		break;

			case 4:
				logger.debug("staff insert");
        		selectMemberCode = getDocNo("8");
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);
        		ID=8;
        		nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);
        		break;

			case 5:
				logger.debug("코디로 insert");

				/*Map<String,Object>  p = new HashMap<String,Object>();
				p.put("docNo", "155");
				ID=155;
        		selectMemberCode =   memberListMapper.getDocNo(p);
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);
        		nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);*/
				selectMemberCode = getDocNo("155");
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);

        		params.put("traineeType", params.get("traineeType1").toString());

        		ID=155;
        		nextDocNo = getNextDocNo("TR",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);
        		break;

			case 6:
				selectMemberCode = getDocNo("145");
        		memberCode = selectMemberCode.get("docNo").toString();
        		params.put("memberCode", memberCode);
        		ID=145;
        		nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
        		logger.debug("nextDocNo : {}",nextDocNo);
        		selectMemberCode.put("nextDocNo", nextDocNo);
        		break;
        		}

			logger.debug("selectMemberCode : {}",selectMemberCode);
			if(Integer.parseInt(selectMemberCode.get("docNoId").toString()) == ID){
				logger.debug("update 문 탈 예정");
				memberListMapper.updateDocNo(selectMemberCode);
			}

			//Member Save
			memberListMapper.insertMember(params);

			logger.debug("params : {}",params);


			//MemberOrganization save
			EgovMap selectOrganization = null;
			selectOrganization = memberListMapper.selectOranization(params);//deptCode 가져가서 select
			logger.debug("selectOrganization : {}",selectOrganization);
			String deptParentID="", lastGroupCode="", lastOrgCode = "";
					if(params.get("deptCode").toString() == null){
						deptParentID = params.get("deptCode").toString();
					}else
						if(selectOrganization.get("memLvl").toString().equals("3") && selectOrganization.get("deptCode").toString().equals(params.get("deptCode").toString())){
							deptParentID = selectOrganization.get("memId").toString();
							lastGroupCode = selectOrganization.get("lastGrpCode").toString();
							lastOrgCode = selectOrganization.get("lastOrgCode").toString();
							//Map<String, Object> groupMap = new HashMap<String, Object>();

							//groupMap.put("memberUpId", deptParentID);

							//groupMap.put("divParam", "1");
							//lastGroupCode = memberListMapper.selectLastGroupCode(groupMap);//select Last_group_code

							//groupMap.put("memberUpId", lastGroupCode);
							//groupMap.put("divParam", "2");
							//lastOrgCode = memberListMapper.selectLastGroupCode(groupMap);//select Last_org_code
						}
			Map<String, Object> memOrg = new HashMap<String, Object>();
			CodeMap.put("code", "mem");
			//CodeMap.put("nric", params.get("nric"));
			String MemberId = memberListMapper.selectMemberId(CodeMap);//asis 어떻게 가져오는지 확인 다시해봐

			if(params.get("deptCode").toString() != null){

				memOrg.put("memberId",MemberId);
				memOrg.put("memberUpID",Integer.parseInt((deptParentID)));
				memOrg.put("memberLvl", 4);
				memOrg.put("deptCode",params.get("deptCode"));
				memOrg.put("orgUpdateBy",params.get("creator"));
				memOrg.put("orgUpdateAt",new Date());
				memOrg.put("prevDeptCode","");
				memOrg.put("prevGroupCode","");
				memOrg.put("prevMemberUpId",0);
				memOrg.put("prevMemberLvl",0);
				memOrg.put("orgStatusCodeId",1);
				memOrg.put("prCode","");
				memOrg.put("prMemberId",0);
				memOrg.put("grandPrCode","");
				memOrg.put("grandPrMemberId",0);
				memOrg.put("lastDeptCode",params.get("deptCode"));
				memOrg.put("lastGrpCode",lastGroupCode);
				memOrg.put("lastOrgCode",lastOrgCode);
				memOrg.put("lastTopOrgCode","");
				memOrg.put("branchId",0);


				logger.debug("memOrg : {}",memOrg);

				memberListMapper.insertOrganization(memOrg);

			}else{
				if(params.get("memberType").toString().equals("4")){

					memOrg.put("memberId", MemberId);
					memOrg.put("MemberUpID",0);
					memOrg.put("memberLvl", 4);
					memOrg.put("deptCode","");
					memOrg.put("orgUpdateBy",params.get("creator"));
					memOrg.put("orgUpdateAt",new Date());
					memOrg.put("prevDeptCode","");
					memOrg.put("prevGroupCode","");
					memOrg.put("prevMemberUpId",0);
					memOrg.put("prevMemberLvl",0);
					memOrg.put("orgStatusCodeId",1);
					memOrg.put("prCode","");
					memOrg.put("prMemberId",0);
					memOrg.put("grandPrCode","");
					memOrg.put("grandPrMemberId",0);
					memOrg.put("lastDeptCode","");
					memOrg.put("lastGrpCode","");
					memOrg.put("lastOrgCode","");
					memOrg.put("lastTopOrgCode","");
					memOrg.put("branchId",0);

					logger.debug("memOrg : {}",memOrg);

					memberListMapper.insertOrganization(memOrg);
				}
			}

			// change to receive LMS training result just concert HP to real HP. Hui Ding, 2021-10-10
			/*EgovMap selectHpBillNo = null;
			String hpBillNo="";
			EgovMap selectInvoiceNo = null;
			//AcBilling Save (for Hp)

			if(params.get("memberType").toString().equals("1")){

				selectHpBillNo = getDocNo("5");
				logger.debug("selectHpBillNo : {}",selectHpBillNo);
				hpBillNo=(String)selectHpBillNo.get("docNo");
				int hPBillID=5;
				nextDocNo = getNextDocNo("HPB", selectHpBillNo.get("c1").toString());
				logger.debug("nextDocNo : {}",nextDocNo);
				selectHpBillNo.put("nextDocNo", nextDocNo);
				logger.debug("selectHpBillNo : {}",selectHpBillNo);
				if(Integer.parseInt(selectHpBillNo.get("docNoId").toString()) == hPBillID){
					logger.debug("update 문 탈 예정");
					memberListMapper.updateDocNo(selectHpBillNo);
				}
				params.put("hpBillNo", hpBillNo);

				Map<String, Object> accBill = new HashMap<String, Object>();
				accBill.put("billId", 0);
				accBill.put("billINo", hpBillNo);
				accBill.put("billTypeId", 222);
				accBill.put("billSOID", 0);
				accBill.put("billMemId", MemberId);
				accBill.put("billASID", 0);
				accBill.put("billPayTypeId", 224);
				accBill.put("billMemberShipNo", "");
				accBill.put("billDate", new Date());
				accBill.put("billAmt", 100);
				accBill.put("billRemark", "");
				accBill.put("billIsPaid", false);
				accBill.put("billIsComm", true);
				accBill.put("updator", params.get("updator"));
				accBill.put("updated", new Date());
				accBill.put("syncCheck", true);
				accBill.put("courseId", 0);
				accBill.put("statusId", 1);

				logger.debug("accBill : {}",accBill);
				memberListMapper.insertAccBill(accBill);


    			//AccOrderBill Save
    			Map<String, Object> accOrderBill = new HashMap<String, Object>();
    			accOrderBill.put("accBillTaskId", 0);
    			accOrderBill.put("accBillRefDate", new Date());
    			accOrderBill.put("accBillRefNo", "1000");
    			accOrderBill.put("accBillOrderId", 0);
    			accOrderBill.put("accBillOrderNo", "");
    			accOrderBill.put("accBillTypeId", 1159);
    			accOrderBill.put("accBillModeId", 1171);
    			accOrderBill.put("accBillScheduleId", 0);
    			accOrderBill.put("accBillSchedulePeriod", 0);
    			accOrderBill.put("accBillAdjustmentId", 0);
    			accOrderBill.put("accBillScheduleAmount", 100);
    			accOrderBill.put("accBillAdjustmentAmount", 0);
    			accOrderBill.put("accBillTaxesAmount",String.format("%.2f", 100 - ((100) * 100 / (double)106)));
    			accOrderBill.put("accBillNetAmount", String.format("%.2f",(double)100));
    			accOrderBill.put("accBillStatus", 1);
    			accOrderBill.put("accBillRemark",memberCode);
    			accOrderBill.put("accBillCreateAt", new Date());
    			accOrderBill.put("accBillCreateBy", params.get("creator"));
    			accOrderBill.put("accBillGroupId", 0);
    			accOrderBill.put("accBillTaxCodeId", 32);
    			accOrderBill.put("accBillTaxRate", 6);
    			accOrderBill.put("accBillAcctConversion", 0);
    			accOrderBill.put("accBillContractId", 0);

    			logger.debug("accOrderBill : {}",accOrderBill);
    			 memberListMapper.insertAccOrderBill(accOrderBill);

    			//GST 2015-01-06
    			selectInvoiceNo = getDocNoNumber("130");
    			updateDocNoNumber("130");

    			Map<String, Object> selectMiscValue = new HashMap<String, Object>();
    			selectMiscValue.put("memberId", MemberId);
    			selectMiscValue.put("memberName", params.get("memberNm"));
    			selectMiscValue.put("membetFullName", params.get("fulllName"));
    			selectMiscValue.put("address1", params.get("address1"));
    			selectMiscValue.put("address2", params.get("address2"));
    			selectMiscValue.put("address3", params.get("address3"));
    			selectMiscValue.put("address4", params.get("address4"));
    			selectMiscValue.put("memberNirc", params.get("nric"));


    			EgovMap selectMiscList = null;
    			selectMiscList = memberListMapper.selectMiscList(selectMiscValue) ;

    			if(selectMiscList != null){
    				Map<String, Object>  InvMISC = new HashMap<String, Object>();

    				InvMISC.put("taxInvoiceRefNo", selectInvoiceNo.get("docNo"));
    				InvMISC.put("taxInvoiceRefDate", new Date());
    				InvMISC.put("taxInvoiceServiceNo",memberCode);
    				InvMISC.put("taxInvoiceType", 117);
    				InvMISC.put("taxInvoiceCustName",selectMiscList.get("c2"));
    				InvMISC.put("taxInvoiceContactPerson",selectMiscList.get("c1"));
    				InvMISC.put("taxInvoiceAddress1",selectMiscList.get("c3"));
    				InvMISC.put("taxInvoiceAddress2",selectMiscList.get("c4"));
    				InvMISC.put("taxInvoiceAddress3",selectMiscList.get("c5"));
    				InvMISC.put("taxInvoiceAddress4",selectMiscList.get("c6"));
    				InvMISC.put("taxInvoicePostCode",selectMiscList.get("postCode"));
    				InvMISC.put("taxInvoiceStateName",selectMiscList.get("name"));
    				InvMISC.put("taxInvoiceCountry",selectMiscList.get("name1"));
    				InvMISC.put("taxInvoiceTaskID",0);
    				InvMISC.put("taxInvoiceRemark","");
    				InvMISC.put("taxInvoiceCharges",String.format("%.2f",(double)100.00 * 100 / 106));
    				InvMISC.put("taxInvoiceTaxes",String.format("%.2f",(100 - ((double)100.00 * 100 / 106))));
    				InvMISC.put("taxInvoiceAmountDue",String.format("%.2f",(double)100));
    				InvMISC.put("taxInvoiceCreated",new Date());
    				InvMISC.put("taxInvoiceCreator",Integer.parseInt(params.get("creator").toString()));

    				logger.debug("InvMISC : {}",InvMISC);
    				memberListMapper.insertInvMISC(InvMISC);

    				CodeMap.put("code", "tax");
    				String taxInvId = memberListMapper.selectMemberId(CodeMap);
    				Map<String, Object>  InvMISCD = new HashMap<String, Object>();
    				InvMISCD.put("taxInvoiceID",taxInvId );//위에 insert할때 값 가져와서 넣어줘야함
    				InvMISCD.put("invoiceItemType",  1260);
    				InvMISCD.put("invoiceItemOrderNo", "");
    				InvMISCD.put("invoiceItemPONo", "");
    				InvMISCD.put("invoiceItemCode", params.get("deptCode"));
    				InvMISCD.put("invoiceItemDescription1",selectMiscList.get("c2"));
    				InvMISCD.put("invoiceItemDescription2",selectMiscList.get("c7"));
    				InvMISCD.put("invoiceItemSerialNo","");
    				InvMISCD.put("invoiceItemQuantity",1);
    				InvMISCD.put("invoiceItemGSTRate",6);
    				InvMISCD.put("invoiceItemGSTTaxes",String.format("%.2f",(100 - ((double)100.00 * 100 / 106))));
    				InvMISCD.put("invoiceItemCharges",String.format("%.2f",((double)100.00) * 100 / 106));
    				InvMISCD.put("invoiceItemAmountDue",String.format("%.2f",(double)100));
    				InvMISCD.put("invoiceItemAdd1","");
    				InvMISCD.put("invoiceItemAdd2","");
    				InvMISCD.put("invoiceItemAdd3","");
    				InvMISCD.put("invoiceItemPostCode","");
    				InvMISCD.put("invoiceItemStateName","");
    				InvMISCD.put("invoiceItemCountry","");

    				logger.debug("InvMISCD : {}",InvMISCD);
    				memberListMapper.insertInvMISCD(InvMISCD);


    				accOrderBill.put("accBillRemark",selectInvoiceNo.get("docNo"));
    				memberListMapper.updateBillRem(accOrderBill);
    			}

			}*/ // end of amendment for convert HP to Real HP. Hui Ding, 2021-10-10

			//Save DocSubmission (For HP)
			if(params.get("memberType").toString().equals("1") && docType.size() > 0){
				for(int i=0; i< docType.size(); i++){
					Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
					docSub.put("docSubId", 0);
					docSub.put("docSubTypeId", 247);
					docSub.put("docTypeID", docSub.get("typeId"));
					docSub.put("docSOID", 0);
					docSub.put("docMemId", MemberId);
					docSub.put("docSubDate", new Date());
					docSub.put("docCopyQty", docSub.get("c1"));
					docSub.put("statusID", 1);
					docSub.put("creator", params.get("creator"));
					docSub.put("Created",  new Date());
					docSub.put("Updator", params.get("creator"));
					docSub.put("Updated",  new Date());
					docSub.put("docSubBatchId",  0);

					logger.debug("docSub : {}",docSub);
					memberListMapper.insertDocSubmission(docSub);
				}
			}

			//Save DocSubmission( For Cody)

			if(params.get("memberType").toString().equals("2") && docType.size() > 0){
				for(int i=0; i< docType.size(); i++){
					Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
					docSub.put("docSubId", 0);
					docSub.put("docSubTypeId", 1417);
					docSub.put("docTypeID", docSub.get("typeId"));
					docSub.put("docSOID", 0);
					docSub.put("docMemId", MemberId);
					docSub.put("docSubDate", new Date());
					docSub.put("docCopyQty", docSub.get("c1"));
					docSub.put("statusID", 1);
					docSub.put("creator", params.get("creator"));
					docSub.put("Created",  new Date());
					docSub.put("Updator", params.get("creator"));
					docSub.put("Updated",  new Date());
					docSub.put("docSubBatchId",  0);

					logger.debug("docSub : {}",docSub);
					memberListMapper.insertDocSubmission(docSub);
				}
			}

			//Save MemberAgreement
			if(! params.get("codyPaExpr").toString().equals(null) &&! params.get("codyPaExpr").toString().equals("")){
				Map<String, Object>  MA = new HashMap<String, Object>();
				MA.put("agreementID", 0);
				MA.put("agreementRefNo", "");
				MA.put("memberID", MemberId);
				MA.put("agreementTypeID", 1416);
				MA.put("agreementStatusID", 1);
				MA.put("agreementRemark", "");
				MA.put("agreementStartDate", "01/01/1900");
				MA.put("agreementExpiryDate", params.get("codyPaExpr"));
				MA.put("agreementCreator", params.get("creator"));
				MA.put("agreementCreated", new Date());
				MA.put("AgreementUpdator", null);
				MA.put("AgreementUpdated", null);

				logger.debug("MA : {}",MA);
				memberListMapper.insertMemberAgr(MA);
			}

			//Save User(for HP & CD& CT)
			if(!params.get("memberType").toString().equals("4")){
				Map<String, Object>  user = new HashMap<String, Object>();
				user.put("userID", 0);
				user.put("userName", memberCode);
				user.put("password", params.get("password"));
				user.put("userFullName", params.get("fulllName"));
				user.put("userEmail", params.get("email"));
				user.put("userStatusID",1);
				user.put("userBranchID",0);
				user.put("userDeptID",0);
				user.put("userUpdateBy",params.get("creator"));
				user.put("userUpdateAt",new Date());
				user.put("userSyncCheck",0);
				user.put("userNRIC",params.get("nric"));
				user.put("userDateJoin",params.get("joinDate"));
				user.put("userGsecSynCheck",Integer.parseInt(params.get("memberType").toString()) == 1 ? 1: 0);
				user.put("userPasswdLastUpdateAt",new Date());
				user.put("userTypeID",Integer.parseInt(params.get("memberType").toString()));
				user.put("userDefaultPasswd", params.get("password"));
				user.put("userValidFrom", params.get("joinDate"));
				user.put("userValidTo", "31/12/2099");
				user.put("userSecQuesID", 0);
				user.put("userSecQuesAns", "");
				user.put("userWorkNo", "");
				user.put("userMobileNo", "");
				user.put("userExtNo", "");
				user.put("userIsPartTime", 0);
				user.put("userDepartmentID", 0);
				user.put("userIsExternal", 0);

				logger.debug("user : {}",user);
//				memberListMapper.insertUser(user);


				//Save SystemRoleUser(For HP & CD)
				CodeMap.put("code", "user");
				String userId = memberListMapper.selectMemberId(CodeMap);//userid에 넣을 값을 select
				if(params.get("memberType").toString().equals("1")|| params.get("memberType").toString().equals("2")){
					Map<String, Object>  roleuser = new HashMap<String, Object>();
					if(params.get("memberType").toString().equals("1")){
						roleuser.put("roleID", 115);
					}else{
						roleuser.put("roleID", 121);
					}
					roleuser.put("userID", userId);
					roleuser.put("statusID", 1);
					//roleuser.put("createdAt", a.format(LocalDate.now()));
					roleuser.put("createdBy", params.get("creator"));
					//roleuser.put("updatedAt", a.format(LocalDate.now()));
					roleuser.put("updatedBy",params.get("creator"));

					logger.debug("roleuser : {}",roleuser);
					//memberListMapper.insertRoleUser(roleuser);
				}
			}

			//Save InvWhlocation(For DC & CT)

			if(params.get("memberType").toString().equals("2") || params.get("memberType").toString().equals("3")){
				Map<String, Object>  invWH = new HashMap<String, Object>();
				invWH.put("WHLocID", 0);
				invWH.put("WHLocCode", memberCode);
				invWH.put("WHLocDesc", params.get("fulllName"));
				invWH.put("WHLocAdd1", "");
				invWH.put("WHLocAdd2", "");
				invWH.put("WHLocAdd3", "");
				invWH.put("WHLocAreaId", 0);
				invWH.put("WHLocPostcodeID", 0);
				invWH.put("WHLocStateID", 0);
				invWH.put("WHLocCountryID", 0);
				invWH.put("WHLocTel1", "");
				invWH.put("WHLocTel2", "");
				invWH.put("WHLocBranchID", 0);
				invWH.put("WHLocTypeID", 278);
				invWH.put("WHLocStkGrade", "");
				invWH.put("WHLocStatusID", 1);
				invWH.put("WHLocUpdateBy", params.get("creator"));
				invWH.put("WHLocUpdateAt", new Date());
				invWH.put("Code2", "");
				invWH.put("Desc2", "");
				invWH.put("WHLocIsSync", true);

				logger.debug("invWH : {}",invWH);
				memberListMapper.insertinvWH(invWH);
			}

			/*if(params.get("memberType").toString().equals("5")  &&  !params.get("course").equals("")) { //20-10-2021 - HLTANG - close for LMS project
				if (params.get("traineeType1").toString().equals("2") || params.get("traineeType1").toString().equals("3") || params.get("traineeType1").toString().equals("7") || params.get("traineeType1").toString().equals("5758") ){ // ADDED HOMECARE AS TRAINEE TYPE -- BY TOMMY

    					logger.debug("=============================================================================================================");
    					logger.debug("=====================  memberType {}  traineeType {} ", params.get("memberType").toString(), params.get("traineeType").toString() );
    					logger.debug("=============================================================================================================");

						params.put("MemberId", MemberId);

						memberListMapper.traineeInsertInfor(params);
				}
			}*/


			success=true;
			String memCode = "";

				memCode = selectMemberCode.get("docNo").toString();

		return memCode;
	}

	@Transactional
	@Override
	public Map<String, Object> insertTerminateResign(Map<String, Object> params,SessionVO sessionVO) throws Exception{
		boolean success = false;
		Map<String, Object>  member = new HashMap<String, Object>();
		Map<String, Object>  promoEntry = new HashMap<String, Object>();
		int userId = sessionVO.getUserId();
		logger.debug("userId : {}",userId);
		Map<String, Object> resultValue = new HashMap<String, Object>(); //팝업 결과값 가져가는 map
		if(params.get("codeValue").toString().equals("2")){
			//Promote/Demote
			promoEntry.put("promoId", 0);
			promoEntry.put("requestNo", "");
			promoEntry.put("statusId", 60);
			promoEntry.put("promoTypeId", Integer.parseInt(params.get("action1").toString()));
			promoEntry.put("memTypeId",params.get("memtype"));
			promoEntry.put("memberId", params.get("memberId"));
			promoEntry.put("memberLvlFrom", params.get("memberLvl"));
			promoEntry.put("memberLvlTo", params.get("lvlTo"));
			promoEntry.put("created", new Date());
			promoEntry.put("creator", userId);
			promoEntry.put("updated", new Date());
			promoEntry.put("updator", userId);
			promoEntry.put("deptCodeFrom", "");
//			promoEntry.put("deptCodeTo", "");
			promoEntry.put("parentIdFrom", 0);
			promoEntry.put("parentIdTo", Integer.parseInt(params.get("cmbSuperior").toString()));
			promoEntry.put("statusIdFrom", 1);
			promoEntry.put("statusIdTo", 1);
			promoEntry.put("remark", params.get("remark1").toString().trim());
			promoEntry.put("parentDeptCodeFrom", "");
			promoEntry.put("parentDeptCodeTo", "");
			promoEntry.put("PRCode", "");
			promoEntry.put("promoSync", false);
			promoEntry.put("lastDeptCode","");
			promoEntry.put("lastGrpCode","");
			promoEntry.put("lastOrgCode", "");
			promoEntry.put("PRmemId",0);
			promoEntry.put("branchId",params.get("branchCode") != null && params.get("branchCode") != "" ? Integer.parseInt(params.get("branchCode").toString()) : 0);
			/* By KV -add promodemote date*/
			promoEntry.put("evtApplyDt", params.get("dtProDemote"));

			logger.debug("promoEntry : {}",promoEntry);
			EgovMap selectMemberOrgs = memberListMapper.selectMemberOrgs(params);

			logger.debug("selectMemberOrgs : {}", selectMemberOrgs);
			if(selectMemberOrgs != null){
				EgovMap eventCode = null;
				eventCode = getDocNo("66");
				int ID = 66;
				String nextDocNo = getNextDocNo("PMR", eventCode.get("docNo").toString());
				eventCode.put("nextDocNo", nextDocNo);
				logger.debug("eventCode : {}",eventCode);
				if(Integer.parseInt(eventCode.get("docNoId").toString()) == ID){
					logger.debug("update 문 탈 예정");
					memberListMapper.updateDocNo(eventCode);
				}
				EgovMap selectOrganization = memberListMapper.selectOrganization(params);
				logger.debug("selectOrganization : {}",selectOrganization);
				params.put("memberId", Integer.parseInt(promoEntry.get("parentIdTo").toString()));
				EgovMap selectOrganization_new = memberListMapper.selectOrganization(params);
				logger.debug("selectOrganization_new : {}",selectOrganization_new);
				promoEntry.put("requestNo", eventCode.get("docNo").toString());

				//promoEntry.put("deptCodeFrom", selectMemberOrgs.get("deptCode"));
				/*if (params.get("lvlTo") .equals("2") || params.get("lvlTo") .equals("3") || params.get("lvlTo") .equals("4") ) {
					promoEntry.put("deptCodeFrom", selectMemberOrgs.get("deptCode"));
    			} else if (params.get("lvlTo") .equals("1") ) {
    				promoEntry.put("deptCodeFrom", selectMemberOrgs.get("grpCode"));
    			}*/

				if (params.get("memberLvl") .equals("3") || params.get("memberLvl") .equals("4") ) {
					promoEntry.put("deptCodeFrom", selectMemberOrgs.get("deptCode"));
    			} else if (params.get("memberLvl") .equals("2") ) {
    				promoEntry.put("deptCodeFrom", selectMemberOrgs.get("grpCode"));
    			} else if (params.get("memberLvl") .equals("1") ) {
    				promoEntry.put("deptCodeFrom", selectMemberOrgs.get("orgCode"));
    			}

				EgovMap deptCode = null;
				logger.debug("params : {}", params);
				// Promote
				if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 2) {
					if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("63");
					} else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("64");
					} else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
						deptCode = getDocNo("65");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 1) {
					if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("162");
					} else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("161");
					} else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
						deptCode = getDocNo("160");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 3) {
					if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("105");
					} else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("104");
					} else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
						deptCode = getDocNo("103");
					}
				}else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 7) { // HOMECARE ADDED BY TOMMY
					if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("164");
					} else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("165");
					} else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
						deptCode = getDocNo("166");
					}
				}else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 5758) { // HOMECARE DELIVERY TECHNICIAN ADDED BY TOMMY
	                  if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
	                    deptCode = getDocNo("174");
	                } else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
	                    deptCode = getDocNo("173");
	                } else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
	                    deptCode = getDocNo("172");
	                }
				}else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 6672) { // LOGISTICS TECHNICIAN ADDED BY KEYI
                    if (params.get("memberLvl").equals("4") && params.get("lvlTo").equals("3")) {
                      deptCode = getDocNo("174");
                  } else if (params.get("memberLvl").equals("3") && params.get("lvlTo").equals("2")) {
                      deptCode = getDocNo("173");
                  } else if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("1")) {
                      deptCode = getDocNo("172");
                  }
            }

				// Demote
				if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 2) {
					if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("63");
					} else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("64");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 1) {
					if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("162");
					} else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("161");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 3) {
					if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("105");
					} else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("104");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 7) { // HOMECARE ADDED BY TOMMY
					if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
						deptCode = getDocNo("164");
					} else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
						deptCode = getDocNo("165");
					}
				} else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 5758) { // HOMECARE DELIVERY TECHNICIAN ADDED BY TOMMY
                  if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
                    deptCode = getDocNo("174");
                  } else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
                    deptCode = getDocNo("173");
                  }
				}else if (Integer.parseInt(params.get("memtype").toString().replaceAll(" ", "")) == 6672) { // LOGISTICS TECHNICIAN ADDED BY KEYI
	                  if (params.get("memberLvl").equals("2") && params.get("lvlTo").equals("3")) {
	                      deptCode = getDocNo("174");
	                    } else if (params.get("memberLvl").equals("1") && params.get("lvlTo").equals("2")) {
	                      deptCode = getDocNo("173");
	                    }
	  				}

				if (params.get("lvlTo").equals("4")) {
					promoEntry.put("deptCodeTo", selectOrganization_new.get("deptCode").toString() != null && selectOrganization_new.get("deptCode") !="" ? selectOrganization_new.get("deptCode").toString() : "");
				} else {
					nextDocNo = "";
					nextDocNo = getNextDocNo(deptCode.get("prefix").toString(), deptCode.get("docNo").toString());
					deptCode.put("nextDocNo", nextDocNo);
					logger.debug("deptCode : {}",deptCode);
					// 채번 +1
					memberListMapper.updateDocNo(deptCode);
					promoEntry.put("deptCodeTo", deptCode.get("docNo"));
				}

				/*Map<String, Object>  superiorEntry = new HashMap<String, Object>();
				logger.debug("params : {}", params);
				superiorEntry.put("memberLvl", Integer.parseInt(params.get("memberLvl").toString())-2);
				superiorEntry.put("memberType", params.get("memtype"));
				superiorEntry.put("memberID", params.get("requestMemberId"));
				superiorEntry.put("cmbSuperior", params.get("cmbSuperior"));
				logger.debug("superiorEntry : {}",superiorEntry);
				List<EgovMap> selectSuperiorTeam = memberListMapper.selectSuperiorTeam(superiorEntry);
				logger.debug("selectSuperiorTeam : {}",selectSuperiorTeam);
				promoEntry.put("deptCodeTo", selectSuperiorTeam.get(0).get("deptCode"));*/

//				promoEntry.put("parentIdFrom", selectMemberOrgs.get("memUpId") != null ? Integer.parseInt(selectMemberOrgs.get("memUpId").toString()) : 0);

				Map<String, Object>  parentEntry = new HashMap<String, Object>();
//				parentEntry.put("deptCode", selectOrganization_new.get("deptCode"));
//				parentEntry.put("lvlTo", (Integer.parseInt(params.get("lvlTo").toString())-1 > 0) ? Integer.parseInt(params.get("lvlTo").toString())-1 : "1" );
				parentEntry.put("memberId", params.get("requestMemberId"));
				logger.debug("parentEntry : {}",parentEntry);
				List<EgovMap> selectParentIdFrom = memberListMapper.selectParentIdFrom(parentEntry);
				promoEntry.put("parentIdFrom", (selectParentIdFrom.size() > 0) ? selectParentIdFrom.get(0).get("memUpId").toString() : "");

				if ( params.get("memberLvl").toString().equals("4") ) {
					promoEntry.put("parentDeptCodeFrom", promoEntry.get("deptCodeFrom"));
					promoEntry.put("PRCode", promoEntry.get("deptCodeFrom"));
				} else if ( params.get("memberLvl").toString().equals("1") || params.get("memberLvl").toString().equals("2") || params.get("memberLvl").toString().equals("3") ) {
					Map<String, Object>  parentDCFEntry = new HashMap<String, Object>();
					parentDCFEntry.put("memberId", params.get("requestMemberId"));
					logger.debug("parentDCFEntry : {}",parentDCFEntry);
					List<EgovMap> selectParentDCFrom = memberListMapper.selectParentDCFrom(parentDCFEntry);
					promoEntry.put("parentDeptCodeFrom", (selectParentDCFrom.size() > 0) ? selectParentDCFrom.get(0).get("deptCode").toString() : "");
					promoEntry.put("PRCode", (selectParentDCFrom.size() > 0) ? selectParentDCFrom.get(0).get("deptCode").toString() : "");
				}

				promoEntry.put("parentDeptCodeTo",  selectOrganization_new.get("deptCode").toString() != null && selectOrganization_new.get("deptCode") !="" ? selectOrganization_new.get("deptCode").toString() : "");
//				promoEntry.put("PRCode", selectOrganization.get("lastGrpCode").toString() != null ? selectOrganization.get("lastGrpCode").toString() : "");

				if ( params.get("action1").equals("747") ) {	// promote
					if ( params.get("lvlTo") .equals("3") ) {
						promoEntry.put("lastDeptCode", deptCode.get("docNo"));
						promoEntry.put("lastGrpCode", selectOrganization_new.get("lastGrpCode"));
						promoEntry.put("lastOrgCode", selectOrganization_new.get("lastOrgCode"));
						promoEntry.put("branchId", (selectOrganization_new != null) ? selectOrganization_new.get("brnchId") : 0);
					} else  if ( params.get("lvlTo") .equals("2") ) {
						promoEntry.put("lastGrpCode", deptCode.get("docNo"));
						promoEntry.put("lastOrgCode", selectOrganization_new.get("lastOrgCode"));
						promoEntry.put("branchId", params.get("branchCode"));
					} else if ( params.get("lvlTo") .equals("1") ) {
						promoEntry.put("lastOrgCode", deptCode.get("docNo"));
						promoEntry.put("branchId", 0);
					}
				} else {		// demote
					if ( params.get("lvlTo") .equals("4") ) {
						Map<String, Object>  lastCodeEntry = new HashMap<String, Object>();
						lastCodeEntry.put("deptCodeTo", promoEntry.get("deptCodeTo"));
						lastCodeEntry.put("memberLvl", params.get("memberLvl"));
						EgovMap selectLastCode = memberListMapper.selectLastCode(lastCodeEntry);
						logger.debug("selectLastCode : {}",selectLastCode);
						promoEntry.put("lastDeptCode", selectLastCode.get("lastDeptCode"));
						promoEntry.put("lastGrpCode", selectLastCode.get("lastGrpCode"));
						promoEntry.put("lastOrgCode", selectLastCode.get("lastOrgCode"));
						promoEntry.put("branchId", (selectOrganization_new != null) ? selectOrganization_new.get("brnchId") : 0);
					} else if ( params.get("lvlTo") .equals("3") ) {
						promoEntry.put("lastDeptCode", deptCode.get("docNo"));

						Map<String, Object>  lastCodeEntry = new HashMap<String, Object>();
						lastCodeEntry.put("deptCodeTo", promoEntry.get("parentDeptCodeTo"));
						lastCodeEntry.put("memberLvl", params.get("memberLvl"));
						EgovMap selectLastCode = memberListMapper.selectLastCode(lastCodeEntry);
						logger.debug("selectLastCode : {}",selectLastCode);
						promoEntry.put("lastGrpCode", selectLastCode.get("lastGrpCode"));
						promoEntry.put("lastOrgCode", selectLastCode.get("lastOrgCode"));
						promoEntry.put("branchId", (selectOrganization_new != null) ? selectOrganization_new.get("brnchId") : 0);
					} else  if ( params.get("lvlTo") .equals("2") ) {
						promoEntry.put("lastGrpCode", deptCode.get("docNo"));

						Map<String, Object>  lastCodeEntry = new HashMap<String, Object>();
						lastCodeEntry.put("deptCodeTo", promoEntry.get("parentDeptCodeTo"));
						lastCodeEntry.put("memberLvl", params.get("memberLvl"));
						EgovMap selectLastCode = memberListMapper.selectLastCode(lastCodeEntry);
						logger.debug("selectLastCode : {}",selectLastCode);
						promoEntry.put("lastOrgCode", selectLastCode.get("lastOrgCode"));
						promoEntry.put("branchId", params.get("branchCode"));
					}
				}

				Map<String, Object>  lastCodeEntry = new HashMap<String, Object>();
				lastCodeEntry.put("deptCodeTo", promoEntry.get("deptCodeTo"));
				lastCodeEntry.put("memberLvl", Integer.parseInt(params.get("memberLvl").toString())-2);
				logger.debug("lastCodeEntry : {}",lastCodeEntry);
				EgovMap selectLastCode = memberListMapper.selectLastCode(lastCodeEntry);
				logger.debug("selectLastCode : {}",selectLastCode);

//				promoEntry.put("branchId", (selectLastCode != null) ? selectLastCode.get("brnchId") : 0);

				promoEntry.put("PRmemId",promoEntry.get("promoTypeId").toString().equals("747") ? selectMemberOrgs.get("memUpId").toString() : 0);
				logger.debug("promoEntry : {}",promoEntry);
				memberListMapper.insertPromoEntry(promoEntry);

				if(params.get("action1").toString().equals("747") ){
    				resultValue.put("message", "Promote request successfully saved.<br />"
    				+ " Request number : " + eventCode.get("docNo").toString() + "<br /><br />");
				}else{
					resultValue.put("message", " Demote request successfully saved.<br />"
		    				+ " Request number : " + eventCode.get("docNo").toString() + "<br /><br />");
				}

				/*//call lms to update user details
            	Map<String, Object> memMap = new HashMap<String, Object>();
            	memMap.put("MemberID", params.get("requestMemberId").toString());

				// DO NOT REMOVE/ COMMENT THIS CODE WHEN COMMITTING CODE INTO SVN -- HUI DING
            	Map<String, Object> returnVal = lmsApiService.lmsMemberListUpdate(memMap);
				if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
					Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
					throw new RuntimeException(e1);
				}
*/
			}else{
				resultValue.put("message", "<b>Failed to save. Please try again later.</b>");

			}

		}else{
        		//Request Terminate/Resign
        		EgovMap memberView = memberListMapper.selectMemberListView(params);
        		logger.debug("memberView : {}",memberView);
        		EgovMap eventCode = null;

        		if(memberView.get("c32").toString().equals("1")){
        			member.put("memberId", memberView.get("memId"));
        			member.put("updated", new Date());
        			member.put("updator", userId);
        			member.put("status", Integer.parseInt(params.get("action").toString()) == 757 ? 3:51);
        			member.put("termDate", Integer.parseInt(params.get("action").toString()) == 757 ? params.get("dtTerRes").toString() : "01/01/1900" );
        			member.put("resignDate", Integer.parseInt(params.get("action").toString()) == 758 ? params.get("dtTerRes").toString() : "01/01/1900" );

        			logger.debug("member : {}",member);


        			promoEntry.put("promoId", 0);
        			promoEntry.put("requestNo", "");
        			promoEntry.put("statusId", 60);
        			promoEntry.put("promoTypeId", Integer.parseInt(params.get("action").toString()));
        			promoEntry.put("memTypeId",memberView.get("memType"));
        			promoEntry.put("memberId", memberView.get("memId"));
        			promoEntry.put("memberLvlFrom", memberView.get("c44"));
        			promoEntry.put("memberLvlTo", memberView.get("c44"));
        			promoEntry.put("created", new Date());
        			promoEntry.put("creator", userId);
        			promoEntry.put("updated", new Date());
        			promoEntry.put("updator", userId);
        			promoEntry.put("deptCodeFrom", "");
        			promoEntry.put("deptCodeTo", "");
        			promoEntry.put("parentIdFrom", memberView.get("c33"));
        			promoEntry.put("parentIdTo", memberView.get("c33"));
        			promoEntry.put("statusIdFrom", 1);
        			promoEntry.put("statusIdTo", Integer.parseInt(params.get("action").toString()) == 757 ? 3 : 51);
        			promoEntry.put("remark", params.get("remark").toString().trim());
        			promoEntry.put("parentDeptCodeFrom", "");
        			promoEntry.put("parentDeptCodeTo", "");
        			promoEntry.put("PRCode", "");
        			promoEntry.put("promoSync", false);
        			promoEntry.put("lastDeptCode", memberView.get("c41"));
        			promoEntry.put("lastGrpCode", memberView.get("c42"));
        			promoEntry.put("lastOrgCode", memberView.get("c43"));
        			promoEntry.put("PRmemId",0);
        			promoEntry.put("branchId",null);
        			promoEntry.put("evtApplyDt", params.get("dtTerRes"));
        			logger.debug("promoEntry : {}",promoEntry);

        			EgovMap selectMember = memberListMapper.selectMember(member);
        			logger.debug("selectMember : {}",selectMember);
        			if(selectMember != null){
        				EgovMap selectOrganization = memberListMapper.selectOrganization(member);
        				logger.debug("selectOrganization : {}",selectOrganization);
        				if(selectOrganization != null){
        					EgovMap selectMemberOrgs = memberListMapper.selectMemberOrgs(member);
        					logger.debug("selectMemberOrgs : {}",selectMemberOrgs);
        					promoEntry.put("deptCodeFrom", selectOrganization.get("deptCode"));
        					promoEntry.put("deptCodeTo", selectOrganization.get("deptCode"));
        					promoEntry.put("parentIDFrom", selectOrganization.get("memUpId") != null ? Integer.parseInt(selectOrganization.get("memUpId").toString()) : 0);
        					promoEntry.put("parentIDTo", selectOrganization.get("memUpId") != null ? Integer.parseInt(selectOrganization.get("memUpId").toString()) : 0);
        					promoEntry.put("parentDeptCodeFrom", selectOrganization.get("deptCode"));
        					promoEntry.put("parentDeptCodeTo", selectOrganization.get("deptCode"));

        					//update MemberOrganization
        					selectOrganization.put("orgStatusCodeID", 8);
        					selectOrganization.put("orgUpdateAt", new Date());
        					selectOrganization.put("orgUpdateBy", member.get("updator"));
        					selectOrganization.put("lastDeptCode", selectMemberOrgs.get("deptCode"));
        					selectOrganization.put("lastGrpCode", selectMemberOrgs.get("grpCode"));
        					selectOrganization.put("lastOrgCode", selectMemberOrgs.get("orgCode"));
        					selectOrganization.put("lastTopOrgCode", selectMemberOrgs.get("topOrgCode"));

        					memberListMapper.updateOrganization(selectOrganization);
        				}

        				eventCode = getDocNo("66");
        				int ID = 66;
        				String nextDocNo = getNextDocNo("PMR", eventCode.get("docNo").toString());
        				eventCode.put("nextDocNo", nextDocNo);
        				logger.debug("eventCode : {}",eventCode);
        				if(Integer.parseInt(eventCode.get("docNoId").toString()) == ID){
        					logger.debug("update 문 탈 예정");
        					memberListMapper.updateDocNo(eventCode);
        				}
        				promoEntry.put("requestNo", eventCode.get("docNo").toString());

        				//MemberPromoEntry
        				memberListMapper.insertPromoEntry(promoEntry);

        				//Member
        				selectMember.put("status", member.get("status"));
        				selectMember.put("resignDate", member.get("resignDate"));
        				selectMember.put("termDate", member.get("termDate"));
        				selectMember.put("updated", member.get("updated"));
        				selectMember.put("updator", member.get("updator"));
        				selectMember.put("syncCheck", member.get("syncCheck"));

        				logger.debug("selectMember : {}",selectMember);
//        				memberListMapper.updateMember(selectMember);
        				//User
        				EgovMap selectUserName = memberListMapper.selectUserName(selectMember);
        				if(selectUserName != null){
        					selectUserName.put("userStatusID", 8);
        					selectUserName.put("userUpdateAt", new Date());
        					selectUserName.put("userUpdateBy", member.get("updator"));

        					memberListMapper.updateUser(selectUserName);
        				}
        			}

                	Map<String, Object> memMap = new HashMap<String, Object>();
                	memMap.put("username", selectMember.get("memCode").toString());


                	//close for resign using batch to update lms
                	//update email to format(sysdate_email)
//                	String emailToChange = selectMember.get("email").toString();
//                	String strDt = CommonUtils.getNowDate();
//
//                	emailToChange = strDt + "_" + emailToChange;
//                	memMap.put("email", emailToChange);
//                	memMap.put("memberID", selectMember.get("memId").toString());
//                	memberListMapper.updateMemberEmail(memMap);
//
//                	//update lms site
                	// DO NOT REMOVE/ COMMENT THIS CODE WHEN COMMITTING CODE INTO SVN -- HUI DING
//                	Map<String, Object> returnVal = lmsApiService.lmsMemberListDeact(memMap);
//            		if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
//            			Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
//            			throw new RuntimeException(e1);
//            		}

        		}
        		if(Integer.parseInt(params.get("action").toString()) == 757){
    				resultValue.put("message", "Terminate request successfully saved.<br />"
    				+ " Request number : " + eventCode.get("docNo").toString() + "<br /><br />");
				}else{
					resultValue.put("message", " Resign request successfully saved.<br />"
		    				+ " Request number : " + eventCode.get("docNo").toString() + "<br /><br />");
				}

		}
		success=true;
		return resultValue;
	}


	/* BY KV start Do Save Vacation Request*/
	@Override
	public Map<String, Object> insertRequestVacation(Map<String, Object> params,SessionVO sessionVO) {
		boolean success = false;
		//Map<String, Object>  member = new HashMap<String, Object>();
		Map<String, Object>  vacationEntry = new HashMap<String, Object>();
		int userId = sessionVO.getUserId();
		logger.debug("userId : {}",userId);
		Map<String, Object> resultValue = new HashMap<String, Object>(); //팝업 결과값 가져가는 map

		    vacationEntry.put("promoId", 0);
			vacationEntry.put("requestNo", "");
			vacationEntry.put("statusId", 60);
			vacationEntry.put("memTypeId",params.get("requestMemberType"));
			vacationEntry.put("memberId", params.get("requestMemberId"));
			vacationEntry.put("created", new Date());
			vacationEntry.put("creator", userId);
			vacationEntry.put("updated", new Date());
			vacationEntry.put("updator", userId);
			vacationEntry.put("remark", params.get("remark").toString().trim());
			vacationEntry.put("branchId",params.get("branchCode") != null && params.get("branchCode") != "" ? Integer.parseInt(params.get("branchCode").toString()) : 0);
			vacationEntry.put("vactTypeId",params.get("typeofLeave")); // != null && params.get("typeofleave") != "" ? Integer.parseInt(params.get("typeofleave").toString()) : 0);
			vacationEntry.put("vactStdDt", params.get("dtStart"));
			vacationEntry.put("vactEndDt", params.get("dtEnd"));
			vacationEntry.put("vactReplCt", params.get("replacementCT"));

			logger.debug("vacationEntry : {}",vacationEntry);

				//KV start -this is calculate REQST_NO in org0007d
				EgovMap eventCode = null;
				eventCode = getDocNo("66");
				int ID = 66;
				String nextDocNo = getNextDocNo("PMR", eventCode.get("docNo").toString());
				eventCode.put("nextDocNo", nextDocNo);
				logger.debug("eventCode : {}",eventCode);
				if(Integer.parseInt(eventCode.get("docNoId").toString()) == ID){
					logger.debug("update 문 탈 예정");
					memberListMapper.updateDocNo(eventCode);
				}
				//KV end -this is calculate REQST_NO in org0007d

				EgovMap selectOrganization = memberListMapper.selectOrganization(params);
				logger.debug("selectOrganization : {}",selectOrganization);
				EgovMap selectOrganization_new = memberListMapper.selectOrganization(params);
				logger.debug("selectOrganization_new : {}",selectOrganization_new);
				vacationEntry.put("requestNo", eventCode.get("docNo").toString());
				logger.debug("promoEntry : {}",vacationEntry);

				memberListMapper.insertVacationEntry(vacationEntry);

				resultValue.put("message", "Vacation request successfully saved.<br />"
				+ " Request number : " + eventCode.get("docNo").toString() + "<br /><br />");

		success=true;
		return resultValue;
	}
	/* BY KV end Do Save Vacation Request*/


	@Override
	public List<EgovMap>  selectSuperiorTeam(Map<String, Object> params) {
		return memberListMapper.selectSuperiorTeam(params);
	}
	@Override
	public List<EgovMap>  selectDeptCode(Map<String, Object> params) {
		return memberListMapper.selectDeptCode(params);
	}

	@Override
	public List<EgovMap>  selectDeptCodeHp(Map<String, Object> params) {
		return memberListMapper.selectDeptCodeHp(params);
	}
	@Override
	public List<EgovMap>  selectCourse() {
		return memberListMapper.selectCourse();
	}

	@Transactional
	@Override
	public Map<String, Object> traineeUpdate(Map<String, Object> params,SessionVO sessionVO) throws Exception{
        boolean success = false;
        Map<String, Object> paramM = new HashMap<String, Object>();
        Map<String, Object> resultValue = new HashMap<String, Object>(); // 팝업 결과값 가져가는 map

        String oldMemCode = params.get("memberCode").toString();
        String formattedDate = "";

        if("2".equals(params.get("traineeType")) || "7".equals(params.get("traineeType"))) {
            try{
                String joinDate = "";
                String strDt = CommonUtils.getNowDate().substring(0,6) + "01";

                Date cDt = new SimpleDateFormat("yyyyMMdd").parse(strDt);
                Calendar cal = Calendar.getInstance();
                cal.setTime(cDt);
                cal.add(Calendar.MONTH, 1);

    			formattedDate = new SimpleDateFormat("dd-MM-yyyy").format(cal.getTime());

                joinDate = new SimpleDateFormat("dd-MMM-yyyy").format(cal.getTime());

                params.put("joinDt", joinDate);
            } catch(Exception ex) {
                ex.printStackTrace();
                logger.error(ex.toString());
            }
        }

        // CT, CD 코드 생성
        int a = memberListMapper.traineeUpdate(params);

        if (a > 0) {
            resultValue = memberListMapper.afterSelTrainee(params);

            EgovMap item = (EgovMap) memberListMapper.getAplcntId();
            paramM.put("aplcntId", item.get("aplcntid"));

            // SP_DAY_USER_CRT 프로시저 호출
            Map<String, Object> userPram = new HashMap<String, Object>();
            userPram.put("IN_MEMCODE", resultValue.get("memCode"));
            userPram.put("IN_TRAINTYPE", params.get("traineeType"));
            logger.debug("SP_DAY_USER_CRT 프로시저 호출 PRAM ===>" + userPram.toString());
            memberListMapper.SP_DAY_USER_CRT(userPram);
            userPram.put("P_STATUS", userPram.get("p1"));
            logger.debug("SP_DAY_USER_CRT 프로시저 호출 결과 ===>" + userPram);

            // SP_SVC_LOG_SYS0028M(P_MEM_CODE) 프로시저 호출
            Map<String, Object> logPram = new HashMap<String, Object>();
            logPram.put("P_MEM_CODE", resultValue.get("memCode"));
            logger.debug("SP_SVC_LOG_SYS0028M 프로시저 호출 PRAM ===>" + logPram.toString());
            memberListMapper.SP_SVC_LOG_SYS0028M(logPram);
            // logger.debug("SP_SVC_LOG_SYS0028M 프로시저 호출 결과 ===>" +logPram);

            // 2018-07-12 - Insertion of trainee's e-Agreement
            paramM.put("memCode", resultValue.get("memCode"));
            paramM.put("userId", sessionVO.getUserId());
            memberListMapper.updateCodyAplCde(paramM);

            if("2".equals(params.get("traineeType"))) {
            	memberListMapper.updateCdAplCody(paramM);
            }else{
            memberListMapper.updateCdApl(paramM);
            }
        }

        params.put("src", "member");
        EgovMap trDtls = new EgovMap();
        trDtls = (EgovMap) memberListMapper.getHPCtc(params);

        resultValue.put("telMobile", trDtls.get("mobile"));

        //call LMS to update member code
    	Map<String, Object> memMap = new HashMap<String, Object>();
    	memMap.put("username",oldMemCode);
    	memMap.put("newusername",paramM.get("memCode"));
    	memMap.put("memberType",params.get("traineeType"));
    	memMap.put("joinDt",formattedDate);

    	// DO NOT REMOVE/ COMMENT THIS CODE WHEN COMMITTING CODE INTO SVN -- HUI DING
    	Map<String, Object> returnVal = lmsApiService.lmsMemberListUpdateMemCode(memMap);
		if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
			Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
			throw new RuntimeException(e1);
		}

		//hltang 202209 -> for sso login purpose
		if(ssoLoginFlag > 0){
			resultValue.put("oldMemCode", oldMemCode);
		}

        return resultValue;
    }

	@Override
	public List<EgovMap> getMemberListView(Map<String, Object> params) {
		return memberListMapper.getMemberListView(params);
	}

	@Override
	public  int    memberListUpdate_user(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_user(params);
	}

	@Override
	public  int    memberListUpdate_memorg(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_memorg(params);
	}

	@Override
	public  int    memberListUpdate_memorg2(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_memorg2(params);
	}

	/*By KV - for service capacity update data purpose*/
	@Override
	public  int    memberListUpdate_memorg3(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_memorg3(params);
	}

	@Override
	public  int    memberListUpdate_member(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_member(params);
	}

	@Override
	public int updateMemberName(Map<String, Object> params) {
	    return memberListMapper.updateMemberName(params);
	}

	@Override
	public  int    UpdateMemberValidate(Map<String, Object> params) {
		return memberListMapper.updateMemberValidate(params);
	}

	@Override
	public int traineeUpdateInfo(Map<String, Object> params,SessionVO sessionVO) {

		int result = 0;

		if ( !params.get("course").equals("")) {

    		memberListMapper.traineeUpdateInfo(params);

    		params.put("creator", params.get("user_id"));
    		params.put("MemberId", params.get("MemberID"));

    		memberListMapper.traineeInsertInfor(params);

		}

		return result;
	}


	@Transactional
	@Override
	public boolean updateMember(Map<String, Object> params, List<Object> docType,SessionVO sessionVO) {
		Date defaultDate = new Date("01/01/1900");
		Date now = new Date();
		int userId = sessionVO.getUserId();
		/*
		if(Integer.parseInt((String) params.get("memberType")) == 2){
		MemApp.put("applicationID", 0);
		MemApp.put("applicantCode", "");
		MemApp.put("applicantType",Integer.parseInt((String) params.get("memberType")));
		MemApp.put("applicantName",params.get("memberNm").toString());
		 */
		Boolean success = false;
		Map<String, Object> det = new HashMap<String, Object>();
		SimpleDateFormat transFormat = new SimpleDateFormat("YY/MM/dd");

		try{
		//det.put("MemberID",Integer.parseInt((String) params.get("MemberID")));
		det.put("MemberID",(String) params.get("MemberID"));
		det.put("MemberCode",(String) params.get("MemberCode"));
		det.put("MemberType",0);
		det.put("Name",((String) params.get("memberNm")).toUpperCase());
		det.put("FullName",((String) params.get("fullName")).toUpperCase());
		det.put("Password","");
		det.put("NRIC","");
		det.put("DOB",transFormat.parse((String) params.get("birth")));
		det.put("Gender",(String) params.get("Gender"));
		det.put("Race",(String) params.get("cmbRace"));
		det.put("Marital",(String) params.get("marrital"));
		det.put("Nationality",(String) params.get("national"));
		det.put("Areal",(String) params.get("mArea"));
		det.put("PostCode",(String) params.get("mPostCd"));
		det.put("State",(String) params.get("mState"));
		det.put("Country",(String) params.get("mCountry"));
		det.put("TelOffice",(String) params.get("officeNo"));
		det.put("TelHouse",(String) params.get("residenceNo"));
		det.put("TelMobile",(String) params.get("mobileNo"));
		det.put("Email",(String) params.get("email"));
		det.put("SpuseCode",(String) params.get("spouseCode"));
		det.put("SpouseName",(String) params.get("spouseName"));
		det.put("spouseNric",((String) params.get("spouseNric")).toUpperCase());
		det.put("SpouseOccupation",(String) params.get("spouseOcc"));
		det.put("SpouseTelContact",(String) params.get("spouseContat"));
		det.put("spouseDob",(String) params.get("spouseDob"));
		det.put("EducationLevel",(String) params.get("educationLvl"));
		det.put("Language",(String) params.get("language"));
		det.put("Bank",(String) params.get("issuedBank"));
		det.put("BankAccountNo",(String) params.get("bankAccNo"));
		det.put("SponsorCode",(String) params.get("sponsorCd"));
		det.put("JoinDate",(String) params.get("joinDate"));
		det.put("ResignDate","");
		det.put("TermDate","");
		det.put("RenewDate","");
		det.put("AgrmntNo","");
		det.put("Branch",(String) params.get("branch"));
		det.put("Status",1);
		det.put("SyncCheck",false);
		det.put("Rank",0);
		det.put("Transport",(String) params.get("transportCd"));
		det.put("PromoDate",defaultDate);
		det.put("TRNo",(String) params.get("trNo"));
		det.put("Created",now.getTime());
		det.put("Creator",userId);
		det.put("Updated",now.getTime());
		det.put("Updator",userId);
		det.put("memIsOutSource",false);
		}catch(Exception e){

		}

        if (((String) params.get("memberType")).equals("1"))
        	det.put("Rank",Integer.parseInt((String) params.get("rank")));
        else
            det.put("Rank", 0);

        if(params.get("memberType").toString().equals("1") && docType.size() > 0){
			for(int i=0; i< docType.size(); i++){
				Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
				docSub.put("docSubId", 0);
				docSub.put("docSubTypeId", 247);
				docSub.put("docTypeID", docSub.get("typeId"));
				docSub.put("docSOID", 0);
				docSub.put("docMemId", (String) params.get("memberType"));
				docSub.put("docSubDate", new Date());
				docSub.put("docCopyQty", docSub.get("c1"));
				docSub.put("statusID", 1);
				docSub.put("creator", params.get("creator"));
				docSub.put("Created",  new Date());
				docSub.put("Updator", params.get("creator"));
				docSub.put("Updated",  new Date());
				docSub.put("docSubBatchId",  0);

				logger.debug("docSub : {}",docSub);
				memberListMapper.insertDocSubmission(docSub);
			}
		}

		//Save DocSubmission( For Cody)

		if(params.get("memberType").toString().equals("2") && docType.size() > 0){
			for(int i=0; i< docType.size(); i++){
				Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
				docSub.put("docSubId", 0);
				docSub.put("docSubTypeId", 1417);
				docSub.put("docTypeID", docSub.get("typeId"));
				docSub.put("docSOID", 0);
				docSub.put("docMemId", (String) params.get("memberType"));
				docSub.put("docSubDate", new Date());
				docSub.put("docCopyQty", docSub.get("c1"));
				docSub.put("statusID", 1);
				docSub.put("creator", params.get("creator"));
				docSub.put("Created",  new Date());
				docSub.put("Updator", params.get("creator"));
				docSub.put("Updated",  new Date());
				docSub.put("docSubBatchId",  0);

				logger.debug("docSub : {}",docSub);
				memberListMapper.insertDocSubmission(docSub);
			}
		}


        return success;
	}

	@Override
	public void saveDocSubmission (MemberListVO memberListVO,Map<String, Object> params, SessionVO sessionVO) throws Exception {

		logger.info("!@###### OrderModifyServiceImpl.saveDocSubmission");
		logger.debug("memberType : {}", params.get("memberType"));
		GridDataSet<DocSubmissionVO>    documentList     = memberListVO.getDocSubmissionVOList();

		List<DocSubmissionVO> docSubVOList = documentList.getUpdate(); // 수정 리스트 얻기

		int salesOrdId = memberListVO.getSalesOrdId();

		int docSubTypeId = 0;

		if(params.get("memberType").toString().equals("1")){
			docSubTypeId = 247;
		}

		if(params.get("memberType").toString().equals("2") ){
			docSubTypeId = 1417;
		}

		for(DocSubmissionVO docSubVO : docSubVOList) {
			if(docSubVO.getChkfield() == 1) {

				docSubVO.setDocSoId(salesOrdId);
				//docSubVO.setDocSubTypeId(SalesConstants.CCP_DOC_SUB_CODE_ID_ICS);
				docSubVO.setDocSubTypeId(docSubTypeId);
				docSubVO.setDocMemId(0);
				docSubVO.setCrtUserId(sessionVO.getUserId());
				docSubVO.setUpdUserId(sessionVO.getUserId());
				docSubVO.setDocSubBrnchId(sessionVO.getUserBranchId());

				memberListMapper.saveDocSubmission(docSubVO);
			}
			else {

				docSubVO.setUpdUserId(sessionVO.getUserId());
				docSubVO.setDocSubBrnchId(sessionVO.getUserBranchId());

				memberListMapper.updateDocSubmissionDel(docSubVO);
			}
		}

	}

	@Override
	public Map<String, Object> hpMemRegister(Map<String, Object> params,SessionVO sessionVO) throws Exception {
		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>(); //팝업 결과값 가져가는 map
		Map<String, Object> CodeMap = new HashMap<String, Object>();

		logger.debug("params : {}", params);
		EgovMap nricCheck = null;
		EgovMap rejoinCheck = null;
		nricCheck = memberListMapper.selectNricExist(params);
		rejoinCheck = memberListMapper.selectRejoin(params);
		logger.debug("nricCheck : {}", nricCheck);

		if (nricCheck == null || rejoinCheck.size() > 0) {
			// 실행
			EgovMap selectMemberCode = null; // 각가 docNo, docNoId, prefix구함

			//nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
			//selectMemberCode = getDocNo("1");

			//edit  hgham 25-12-2017
			Map mp = new HashMap();
			mp.put("docNo", "1");
			selectMemberCode = memberListMapper.getDocNo(mp);

			String memberCode = selectMemberCode.get("docNo").toString();
			params.put("memberCode", memberCode);

			params.put("branchId", sessionVO.getUserBranchId());
			params.put("userid", sessionVO.getUserId());

			String   memId_seq =  String.valueOf(memberListMapper.getORG0001D_SEQ(params));

			params.put("memId" ,memId_seq );
			int a = memberListMapper.hpMemRegister(params);

			EgovMap selectOrganization = null;
			if(a> 0){
			    // 2021-04-07 - LaiKW - Insert MSC0009D for HP Orientation
//			    memberListMapper.insertHPorientation(params);  //20-10-2021 - HLTANG - close for LMS project

				Map<String, Object> memOrg = new HashMap<String, Object>();
				CodeMap.put("code", "mem");
				String MemberId =    memId_seq; //memberListMapper.selectMemberId(CodeMap);//asis 어떻게 가져오는지 확인 다시해봐


				selectOrganization = memberListMapper.selectHpOranization(params);//deptCode 가져가서 select
				logger.debug("selectOrganization : {}",selectOrganization);
				String deptParentID="", lastGroupCode="", lastOrgCode = "";

				if(selectOrganization.get("memLvl").toString().equals("3")){
					deptParentID = selectOrganization.get("memId").toString();
				}

				logger.debug("in...... hpMemRegister");
				logger.debug("selectOrganization : {}", selectOrganization);

				if(selectOrganization.get("memId").toString() != null){

					memOrg.put("memberId",MemberId);
					memOrg.put("memberUpID",Integer.parseInt((deptParentID)));
					memOrg.put("memberLvl", 4);
					memOrg.put("deptCode",selectOrganization.get("deptCode"));
					memOrg.put("orgUpdateBy",params.get("orgUpdUserId"));
					memOrg.put("orgUpdateAt",new Date());
					memOrg.put("prevDeptCode","");
					memOrg.put("prevGroupCode","");
					memOrg.put("prevMemberUpId",0);
					memOrg.put("prevMemberLvl",0);
					memOrg.put("orgStatusCodeId",1);
					memOrg.put("prCode","");
					memOrg.put("prMemberId",0);
					memOrg.put("grandPrCode","");
					memOrg.put("grandPrMemberId",0);
					memOrg.put("lastDeptCode",selectOrganization.get("deptCode"));
					memOrg.put("lastGrpCode",selectOrganization.get("lastGrpCode"));
					memOrg.put("lastOrgCode",selectOrganization.get("lastOrgCode"));
					memOrg.put("lastTopOrgCode","");
					memOrg.put("branchId",0);


					logger.debug("memOrg : {}",memOrg);

					memberListMapper.insertOrganization(memOrg);

				}
				 //20-10-2021 - HLTANG - close for LMS project start


				//20230602 - CELESTE - CHANGE ON REGISTRATION FEES [S]
				String regOptionId = memberListMapper.selectHpRegOptionId(memOrg);
				int regPrice = memberListMapper.selectRegisPrice(regOptionId);


				//20230602 - CELESTE - CHANGE ON REGISTRATION FEES [E]
				EgovMap selectHpBillNo = null;
				String hpBillNo="";
				EgovMap selectInvoiceNo = null;
				//AcBilling Save (for Hp)

				int userId = sessionVO.getUserId();

				params.put("creator", userId);
				params.put("updator", userId);

				//if(params.get("memberType").toString().equals("1")){

				SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd");
				Date currentDay = new Date();

				String startDateString = "2019-10-01";
				String endDateString   = "2019-12-31";
				Date startDay    = sfd.parse(startDateString);
				Date endDay      = sfd.parse(endDateString);

				if(regPrice != 0){
					if(currentDay.before(startDay) || currentDay.after(endDay)){

    					selectHpBillNo = getDocNo("5");
    					logger.debug("selectHpBillNo : {}",selectHpBillNo);
    					hpBillNo=(String)selectHpBillNo.get("docNo");
    					int hPBillID=5;
    					String nextDocNo = getNextDocNo("HPB", selectHpBillNo.get("c1").toString());
    					logger.debug("nextDocNo : {}",nextDocNo);
    					selectHpBillNo.put("nextDocNo", nextDocNo);
    					logger.debug("selectHpBillNo : {}",selectHpBillNo);
    					if(Integer.parseInt(selectHpBillNo.get("docNoId").toString()) == hPBillID){
    						logger.debug("update 문 탈 예정");
    						memberListMapper.updateDocNo(selectHpBillNo);
    					}
    					params.put("hpBillNo", hpBillNo);

    					Map<String, Object> accBill = new HashMap<String, Object>();
    					accBill.put("billId", 0);
    					accBill.put("billINo", hpBillNo);
    					accBill.put("billTypeId", 222);
    					accBill.put("billSOID", 0);
    					accBill.put("billMemId", MemberId);
    					accBill.put("billASID", 0);
    					accBill.put("billPayTypeId", 224);
    					accBill.put("billMemberShipNo", "");
    					accBill.put("billDate", new Date());
    					//accBill.put("billAmt", 120);
    					accBill.put("billAmt", regPrice);
    					accBill.put("billRemark", "");
    					accBill.put("billIsPaid", false);
    					accBill.put("billIsComm", true);
    					accBill.put("updator", params.get("updator"));
    					accBill.put("updated", new Date());
    					accBill.put("syncCheck", true);
    					accBill.put("courseId", 0);
    					accBill.put("statusId", 1);

    					logger.debug("accBill : {}",accBill);
    					memberListMapper.insertAccBill(accBill);


    	    			//AccOrderBill Save
    	    			Map<String, Object> accOrderBill = new HashMap<String, Object>();
    	    			accOrderBill.put("accBillTaskId", 0);
    	    			accOrderBill.put("accBillRefDate", new Date());
    	    			accOrderBill.put("accBillRefNo", "1000");
    	    			accOrderBill.put("accBillOrderId", 0);
    	    			accOrderBill.put("accBillOrderNo", "");
    	    			accOrderBill.put("accBillTypeId", 1159);
    	    			accOrderBill.put("accBillModeId", 1171);
    	    			accOrderBill.put("accBillScheduleId", 0);
    	    			accOrderBill.put("accBillSchedulePeriod", 0);
    	    			accOrderBill.put("accBillAdjustmentId", 0);
    	    			//accOrderBill.put("accBillScheduleAmount", 120);
    	    			accOrderBill.put("accBillScheduleAmount", regPrice);
    	    			accOrderBill.put("accBillAdjustmentAmount", 0);
    	    			//accOrderBill.put("accBillTaxesAmount",String.format("%.2f", 120 - ((120) * 100 / (double)106))); -- without GST 6% edited by TPY 24/05/2018
    	    			accOrderBill.put("accBillTaxesAmount",0);
    	    			//accOrderBill.put("accBillNetAmount", String.format("%.2f",(double)120));
    	    			accOrderBill.put("accBillNetAmount", String.format("%.2f",(double)regPrice));
    	    			accOrderBill.put("accBillStatus", 1);
    	    			accOrderBill.put("accBillRemark",memberCode);
    	    			accOrderBill.put("accBillCreateAt", new Date());
    	    			accOrderBill.put("accBillCreateBy", params.get("creator"));
    	    			accOrderBill.put("accBillGroupId", 0);
    	    			accOrderBill.put("accBillTaxCodeId", 32);
    	    			//accOrderBill.put("accBillTaxRate", 6); -- without GST 6% edited by TPY 24/05/2018
    	    			accOrderBill.put("accBillTaxRate", 0);
    	    			accOrderBill.put("accBillAcctConversion", 0);
    	    			accOrderBill.put("accBillContractId", 0);

    	    			logger.debug("accOrderBill : {}",accOrderBill);
    	    			 memberListMapper.insertAccOrderBill(accOrderBill);

    	    			//GST 2015-01-06
    	    			selectInvoiceNo = getDocNoNumber("130");
    	    			updateDocNoNumber("130");

    	    			EgovMap org001dInfo = null;
    	    			org001dInfo = memberListMapper.selectORG001DInfo(MemberId) ;

    	    			//if (org001dInfo != null) {

    	    				logger.debug("org001dInfo : {}",org001dInfo);

    	    				Map<String, Object> selectMiscValue = new HashMap<String, Object>();
    	    				selectMiscValue.put("memberId", MemberId);
    	    				selectMiscValue.put("memberName", org001dInfo.get("memberNm"));
    	    				selectMiscValue.put("membetFullName", org001dInfo.get("fulllName"));
    	    				selectMiscValue.put("address1", org001dInfo.get("address1"));
    	    				selectMiscValue.put("address2", org001dInfo.get("address2"));
    	    				selectMiscValue.put("address3", org001dInfo.get("address3"));
    	    				selectMiscValue.put("address4", org001dInfo.get("address4"));
    	    				selectMiscValue.put("memberNirc", org001dInfo.get("nric"));


    	    				EgovMap selectMiscList = null;
    	    				selectMiscList = memberListMapper.selectMiscList(selectMiscValue) ;

    	    				if(selectMiscList != null){
    	    					Map<String, Object>  InvMISC = new HashMap<String, Object>();

    	    					InvMISC.put("taxInvoiceRefNo", selectInvoiceNo.get("docNo"));
    	    					InvMISC.put("taxInvoiceRefDate", new Date());
    	    					InvMISC.put("taxInvoiceServiceNo",memberCode);
    	    					InvMISC.put("taxInvoiceType", 117);
    	    					InvMISC.put("taxInvoiceCustName",selectMiscList.get("c1"));
    	    					InvMISC.put("taxInvoiceContactPerson",selectMiscList.get("c1"));
    	    					InvMISC.put("taxInvoiceAddress1",selectMiscList.get("c3"));
    	    					InvMISC.put("taxInvoiceAddress2",selectMiscList.get("c4"));
    	    					InvMISC.put("taxInvoiceAddress3",selectMiscList.get("c5"));
    	    					InvMISC.put("taxInvoiceAddress4",selectMiscList.get("c6"));
    	    					InvMISC.put("taxInvoicePostCode",selectMiscList.get("postCode"));
    	    					InvMISC.put("taxInvoiceStateName",selectMiscList.get("name"));
    	    					InvMISC.put("taxInvoiceCountry",selectMiscList.get("name1"));
    	    					InvMISC.put("taxInvoiceTaskID",0);
    	    					InvMISC.put("taxInvoiceRemark","");
    	    					//InvMISC.put("taxInvoiceCharges",String.format("%.2f",(double)120.00 * 100 / 106)); -- without GST 6% edited by TPY 24/05/2018
    	    					//InvMISC.put("taxInvoiceTaxes",String.format("%.2f",(120 - ((double)120.00 * 100 / 106)))); -- without GST 6% edited by TPY 24/05/2018
    	    					//InvMISC.put("taxInvoiceCharges",120);
    	    					InvMISC.put("taxInvoiceCharges",regPrice);
    	    					InvMISC.put("taxInvoiceTaxes",0);
    	    					//InvMISC.put("taxInvoiceAmountDue",String.format("%.2f",(double)120));
    	    					InvMISC.put("taxInvoiceAmountDue",String.format("%.2f",(double)regPrice));
    	    					InvMISC.put("taxInvoiceCreated",new Date());
    	    					InvMISC.put("areaId",selectMiscList.get("areaId"));
    	    					InvMISC.put("addrDtl",selectMiscList.get("addrDtl"));
    	    					InvMISC.put("street",selectMiscList.get("street"));
    	    					InvMISC.put("taxInvoiceCreator",Integer.parseInt(params.get("creator").toString()));

    	    					logger.debug("InvMISC : {}",InvMISC);
    	    					memberListMapper.insertInvMISC(InvMISC);

    	    					CodeMap.put("code", "tax");
    	    					String taxInvId = memberListMapper.selectMemberId(CodeMap);
    	    					Map<String, Object>  InvMISCD = new HashMap<String, Object>();
    	    					InvMISCD.put("taxInvoiceID",taxInvId );//위에 insert할때 값 가져와서 넣어줘야함
    	    					InvMISCD.put("invoiceItemType",  1260);
    	    					InvMISCD.put("invoiceItemOrderNo", "");
    	    					InvMISCD.put("invoiceItemPONo", "");
    	    					InvMISCD.put("invoiceItemCode", selectOrganization.get("deptCode"));
    	    					InvMISCD.put("invoiceItemDescription1",selectMiscList.get("c1"));
    	    					InvMISCD.put("invoiceItemDescription2",selectMiscList.get("c7"));
    	    					InvMISCD.put("invoiceItemSerialNo","");
    	    					InvMISCD.put("invoiceItemQuantity",1);
    	    					//InvMISCD.put("invoiceItemGSTRate",6); -- without GST 6% edited by TPY 24/05/2018
    	    					//InvMISCD.put("invoiceItemGSTTaxes",String.format("%.2f",(120 - ((double)120.00 * 100 / 106)))); -- without GST 6% edited by TPY 24/05/2018
    	    					//InvMISCD.put("invoiceItemCharges",String.format("%.2f",((double)120.00) * 100 / 106)); -- without GST 6% edited by TPY 24/05/2018
    	    					InvMISCD.put("invoiceItemGSTRate",0);
    	    					InvMISCD.put("invoiceItemGSTTaxes",0);
    	    					//InvMISCD.put("invoiceItemCharges",120);
    	    					InvMISCD.put("invoiceItemCharges",regPrice);
    	    					//InvMISCD.put("invoiceItemAmountDue",String.format("%.2f",(double)120));
    	    					InvMISCD.put("invoiceItemAmountDue",String.format("%.2f",(double)regPrice));
    	    					InvMISCD.put("invoiceItemAdd1","");
    	    					InvMISCD.put("invoiceItemAdd2","");
    	    					InvMISCD.put("invoiceItemAdd3","");
    	    					InvMISCD.put("invoiceItemPostCode","");
    	    					InvMISCD.put("invoiceItemStateName","");
    	    					InvMISCD.put("invoiceItemCountry","");
    	    					InvMISCD.put("invoiceItemBillRefNo","");
    	    					InvMISCD.put("areaId",selectMiscList.get("areaId"));
    	    					InvMISCD.put("addrDtl",selectMiscList.get("addrDtl"));
    	    					InvMISCD.put("street",selectMiscList.get("street"));

    	    					logger.debug("InvMISCD : {}",InvMISCD);
    	    					memberListMapper.insertInvMISCD(InvMISCD);


    	    					accOrderBill.put("accBillRemark",selectInvoiceNo.get("docNo"));
    	    					memberListMapper.updateBillRem(accOrderBill);
    	    				}
	    				} //20-10-2021 - HLTANG - close for LMS project end
				}


	    				params.put("updUserId", sessionVO.getUserId());

	    				memberListMapper.updateHpApproval(params);

	    				params.put("memberId", MemberId);

	    				// resultValue.put("memCode", afterSelTrainee 결과)
	    				resultValue =	memberListMapper.afterSelTrainee(params);

	    				// SP_DAY_USER_CRT 프로시저 호출  //20-10-2021 - HLTANG - close for LMS project start
	    	    		Map<String, Object>  userPram = new HashMap<String, Object>();
	    	    		userPram.put("IN_MEMCODE", resultValue.get("memCode"));
	    	    		logger.debug("SP_DAY_USER_CRT 프로시저 호출 PRAM ===>"+ userPram.toString());
	    	    		memberListMapper.SP_DAY_USER_CRT(userPram);
	    	    		userPram.put("P_STATUS", userPram.get("p1"));
	    	    		logger.debug("SP_DAY_USER_CRT 프로시저 호출 결과 ===>" +userPram);

	    			//} //20-10-2021 - HLTANG - close for LMS project end

	    				//call LMS API create user
	    	    		// DO NOT REMOVE/ COMMENT THIS CODE WHEN COMMITTING CODE INTO SVN -- HUI DING
	    	    		params.put("MemberID", MemberId);
	    				Map<String, Object> returnVal = lmsApiService.lmsMemberListInsert(params);
	    				if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.FAIL)){
	    					Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
	    					throw new RuntimeException(e1);
	    				}
			}

		} else {
			// 실행 안함
			resultValue.put("duplicMemCode", nricCheck.get("memCode"));
		}


		logger.debug("resultValue : {}", resultValue);
		return resultValue;
	}

	@Override
	public List<EgovMap> getMainDeptList() {
		// TODO Auto-generated method stub
		return memberListMapper.selectMainDept();
	}

	@Override
	public List<EgovMap> getSubDeptList(Map<String, Object> params) {

		 String isEmpty =(String) params.get("groupCode");
		 if(isEmpty != null ){
			 if(isEmpty.equals("Choose One")){
				 params.put("groupCode", null);
			 }
		 }

		return memberListMapper.selectSubDept(params);
	}

	@Override
	public List<EgovMap> getDeptCdListList(Map<String, Object> params) {

		return memberListMapper.getDeptCdListList(params);
	}

	@Override
	public List<EgovMap> getSpouseInfoView(Map<String, Object> params) {
		return memberListMapper.getSpouseInfoView(params);
	}

	@Override
	public BigDecimal getOwnPurcOutsInfo(Map<String, Object> params) {
		BigDecimal amount = BigDecimal.ZERO;
		memberListMapper.getOwnPurcOutsInfo(params);

		List <Map> a = (List<Map>) params.get("cv_1");

		if (params.get("cv_1") != null) {
			if(a.get(0).get("ownPurcOtstnd") !=null ){
				amount = new BigDecimal(a.get(0).get("ownPurcOtstnd").toString());
			}
	    }
		return amount;
	}

	@Override
	public EgovMap selectHPMemberListView(Map<String, Object> params) {
		return memberListMapper.getHPMemberListView(params);
	}
	@Override
	public List<EgovMap>  selectCoureCode(Map<String, Object> params) {
		return memberListMapper.selectCoureCode(params);
	}

	public String selectTypeGroupCode(Map<String,Object> params){
		return memberListMapper.selectTypeGroupCode(params);
	}

	@Override
	public List<EgovMap> selectDepartmentCodeLit(Map<String, Object> params) {

		return memberListMapper.selectDepartmentCodeLit(params);
	}

	@Override
	public List<EgovMap> selectBranchCodeLit(Map<String, Object> params) {

		return memberListMapper.selectBranchCodeLit(params);
	}

	@Override
	public List<EgovMap> checkNRIC1(Map<String, Object> params) {
		return memberListMapper.checkNRIC1(params);
	}

	@Override
	public List<EgovMap> checkNRIC2(Map<String, Object> params) {
		return memberListMapper.checkNRIC2(params);
	}

	@Override
	public List<EgovMap> checkNRIC3(Map<String, Object> params) {
		// add jgkim
		String nric = String.valueOf(params.get("nric"));
	    // 35 ~ 99가 아닐때 == 35 보다 작을때
		// 99보다 큰 값은 100
		if(Integer.parseInt(nric.substring(0, 2)) < 35) {
			return memberListMapper.checkNRIC3(params);
		} else {
			return new ArrayList<EgovMap>();
		}
	}

	@Override
    public List<EgovMap> selectMemberInfo(Map<String, Object> params) {
        return memberListMapper.selectMemberInfo(params);
    }

	@Override
    public List<EgovMap> selectMemberApprovalInfo(Map<String, Object> params) {
        return memberListMapper.selectMemberApprovalInfo(params);
	}

	@Override
    public void updateMemberStatus(Map<String, Object> params) {
        memberListMapper.updateMemberStatus(params);
    }

	// modify jgkim
	@Override
	public EgovMap checkSponsor(Map<String, Object> params) {
		return memberListMapper.checkSponsor(params);
	}

	@Override
	public List<EgovMap> selectBusinessType() {

		return memberListMapper.selectBusinessType();
	}

	@Override
	public List<EgovMap> getHpMemberView(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectHpMemberView(params);
	}

	@Override
	public EgovMap selectOneHPMember(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectOneHPMember(params);
	}

	@Override
	public int hpMemberUpdate(Map<String, Object> formMap) {
		memberListMapper.updateHpMember(formMap);
		return 0;
	}

	@Override
	public List<EgovMap> branch() {
		return memberListMapper.branch();
	}

	@Override
	public EgovMap selectMemberValidDate(Map<String, Object> params){
		return memberListMapper.selectMemberValidDate(params);
	}


	@Override
	public void updateMemberBranch(Map<String, Object> params) throws Exception {

		memberListMapper.updateMemberBranch(params);


	}

	@Override
	public void updateMemberBranch2(Map<String, Object> params) throws Exception {

		memberListMapper.updateMemberBranch2(params);


	}

	@Override
	public void updateDocSub(List<Object> updList, String memId, int userId,  String memType) {

		if(updList !=null){
    		for(int i=0 ; i < updList.size(); i++ ){
    			 //udtList : [{codeId=1414, codeName=Cody PA Copy, typeId=1414, typeDtSeq=4, docQty=0 ,
    			//하나씩 받아와서
    			Map<String, Object> oneDocSub = (Map<String, Object>) updList.get(i);
    			oneDocSub.put("memId", memId);
    			oneDocSub.put("userId", userId);
    			oneDocSub.put("memType", memType);
    			//이미들어가있나 확인
    			EgovMap isCheckDoc = memberListMapper.selectOneDocSub(oneDocSub);

    			int docQty= Integer.parseInt(String.valueOf( oneDocSub.get("docQty") ) );

    			if (  docQty != 0 ){// doc가 0이아니면
    				//있으면 인서트 없으면 업데이트
    				if(isCheckDoc != null){
    					memberListMapper.updateDocSub(oneDocSub);
    				}

    				else{


    					if(memType.equals("2")){
    						oneDocSub.put("subTypeId", 1417);
    					}else if(memType.equals("5")){
    						//trainee type
    					EgovMap getTrainType= memberListMapper.selectTrainType(oneDocSub);
    					String trainType = String.valueOf(getTrainType.get("train"));
    						if(trainType.equals("2")){
    							oneDocSub.put("subTypeId", 1417);
    						}
    						else{
    							oneDocSub.put("subTypeId", 247);
    						}

    					}
    					else{
    						oneDocSub.put("subTypeId", 247);
    					}

    					memberListMapper.insertDocSub(oneDocSub);
    				}
    			}

    			else{//docQty가 0이면 delete
    				if( isCheckDoc != null){
    					memberListMapper.deleteDocSub(oneDocSub);

    				}


    			}



    		}
		}
	}

	@Override
	public void memberCodyPaUpdate(Map<String, Object> params) {
		memberListMapper.updateCodyPaDate(params);

	}

	@Override
	public void MemberValidateUpdate(Map<String,Object> params){
		memberListMapper.updateMemberValidateDt(params);
	}

	@Override
	public boolean updateHpApprovalReject(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.updateHpApprovalReject(params) > 0;
	}


	@Override
	public List<EgovMap> selectMemberType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectMemberType(params);
	}

	@Override
	public List<EgovMap> selectSponBrnchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectSponBrnchList(params);
	}

	@Override
	public List<EgovMap> selectSponMemberSearch(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectSponMemberSearch(params);
	}

	@Override
	public void insertDocSub(List<Object> updList, String memCode, int userId, String memberType,  String trainType) {
		// TODO Auto-generated method stub
		Map<String, Object> getMap = new HashMap<>();
		getMap.put("memberType", memberType);
		getMap.put("memCode", memCode);
		//memId 가져오기
		EgovMap getMemId = memberListMapper.getMemIdwithCode(getMap);

		if(updList !=null){
    		for(int i=0 ; i < updList.size(); i++ ){
    			 //udtList : [{codeId=1414, codeName=Cody PA Copy, typeId=1414, typeDtSeq=4, docQty=0 ,
    			//하나씩 받아와서
    			Map<String, Object> oneDocSub = (Map<String, Object>) updList.get(i);
    			oneDocSub.put("memCode", memCode);
    			oneDocSub.put("userId", userId);
    			oneDocSub.put("memType", memberType);
    			oneDocSub.put("memId", String.valueOf(getMemId.get("memId")));


    			int docQty= Integer.parseInt(String.valueOf( oneDocSub.get("docQty") ) );

    			if (  docQty != 0 ){// doc가 0이아니면
    				if(trainType.equals("2")){
						oneDocSub.put("subTypeId", 1417);
					}
					else{
						oneDocSub.put("subTypeId", 247);
					}
    				memberListMapper.insertDocSub(oneDocSub);
    			}
    		}

	}
}

	@Override
	public EgovMap memberListService(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectTrainType(params);
	}

	@Override
	public void updateDocSubWhenAppr(Map<String, Object> params, SessionVO sessionVO) {
		int userId = sessionVO.getUserId();
		params.put("userId",userId);

		memberListMapper.updateDocSubWhenApproval(params);

	}

	@Override
	public EgovMap selectAreaInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectAreaInfo(params);
	}

	@Override
	public List<EgovMap> selectAllBranchCode() {
		// TODO Auto-generated method stub
		return memberListMapper.selectAllBranchCode();
	}

	@Override
	public EgovMap validateHpStatus(Map<String, Object> params) {
	    return memberListMapper.validateHpStatus(params);
	}

	@Override
	public void updateHpCfm(Map<String, Object> params) throws Exception {
	    memberListMapper.updateHpCfm(params);
	}

	@Override
	public EgovMap getHPCtc(Map<String, Object> params) {
	    return memberListMapper.getHPCtc(params);
	}

	@Override
    public EgovMap verifyAccess(Map<String, Object> params) {
        return memberListMapper.verifyAccess(params);
    }

	@Override
	public EgovMap getApplicantDetails(Map<String, Object> params) {
	    return memberListMapper.getApplicantDetails(params);
	}

	@Override
    public EgovMap checkBankAcc(Map<String, Object> params) {
        return memberListMapper.checkBankAcc(params);
    }

	//@AMEER INCOME TAX 20211012
	@Override
    public EgovMap checkIncomeTax(Map<String, Object> params) {
        return memberListMapper.checkIncomeTax(params);
    }

	@Override
	public EgovMap getUserRole(Map<String, Object> params) {
	    return memberListMapper.getUserRole(params);
	}

	@Override
    public void updateCodyCfm(Map<String, Object> params) throws Exception {
        memberListMapper.updateCodyCfm(params);
    }

	@Override
    public void updateMobileUse(Map<String, Object> params) throws Exception {
        memberListMapper.updateMobileUse(params);
    }

    @Override
    public EgovMap getCDInfo(Map<String, Object> params) {
        return memberListMapper.getCDInfo(params);
    }

    @Override
    public EgovMap getOrgDtls(Map<String, Object> params) {
        return memberListMapper.getOrgDtls(params);
    }

    @Override
	public List<EgovMap> selectHpMeetPoint() {
		return memberListMapper.selectHpMeetPoint();
	}

    @Override
    public void updateMeetpoint(Map<String, Object> params) {
        memberListMapper.updateMeetpoint(params);
    }

    @Override
	public List<EgovMap> selectMemberTypeHP(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectMemberTypeHP(params);
	}

	@Override
	public List<EgovMap> selectApprovalBranch(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return memberListMapper.selectApprovalBranch(params);
	}

	@Override
    public EgovMap checkAccLen(Map<String, Object> params) {
        return memberListMapper.checkAccLen(params);
    }

	@Override
	public List<EgovMap> selectAccBank(Map<String, Object> params) {
	    return memberListMapper.selectAccBank(params);
    }

	/*@Override
	public void updateAplctDtls(Map<String, Object> params) {
	    memberListMapper.updateAplctDtls(params);
	}*/

	// LaiKW - Comment starts here
	@Override
	public int memberListUpdate_SYS47(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_SYS47(params);
	}

	@Override
	public int memberListUpdate_ORG05(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_ORG05(params);
	}

	@Override
	public int memberListUpdate_ORG01(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_ORG01(params);
	}

	@Override
	public int memberListUpdate_ORG03(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_ORG03(params);
	}

	@Override
	public int memberListUpdate_MSC09(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_MSC09(params);
	}

	@Override
	public int memberListUpdate_ORG15(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_ORG15(params);
	}

	@Override
	public int memberListUpdate_ORG02(Map<String, Object> params) {
	    return memberListMapper.memberListUpdate_ORG02(params);
	}

	@Override
	public EgovMap selectMemCourse(Map<String, Object> params) {
	    return memberListMapper.selectMemCourse(params);
	}

	@Override
	public ReturnMessage checkMemCode(Map<String, Object> params) {
	    ReturnMessage message = new ReturnMessage();
	    logger.debug("params : {}", params);

	    int exist =  memberListMapper.checkMemCode(params);

	    if(exist > 0) {
	        message.setCode(AppConstants.FAIL);
	    } else {
	        message.setCode(AppConstants.SUCCESS);
	    }

	    return message;
	}
	// LaiKW - Comment end here

	@Override
    public List<EgovMap> selectTraining(Map<String, Object> params) {
        return memberListMapper.selectTraining(params);
    }

	@Override
	public int getNextMPID() {
	    return memberListMapper.getNextMPID();
	}

	@Override
    public List<EgovMap> searchMP(Map<String, Object> params) {
        return memberListMapper.searchMP(params);
    }

	@Override
	public int addMeetingPoint(List<Object> addList, String userId) {
	    int cnt = 0;

	    for(Object obj : addList) {
	        ((Map<String, Object>) obj).put("userId", userId);

	        cnt = memberListMapper.addMeetingPoint((Map<String, Object>) obj);
	    }

	    return cnt;
	};

	@Override
	public int updMeetingPoint(List<Object> updList, String userId) {
	    int cnt = 0;

        for(Object obj : updList) {
            ((Map<String, Object>) obj).put("userId", userId);

            cnt = memberListMapper.updMeetingPoint((Map<String, Object>) obj);
        }

        return cnt;
	}

	public int updHPMeetingPoint(Map<String, Object> params) throws Exception {
	    return memberListMapper.updHPMeetingPoint(params);
	}

	@Override
	public String getUpdUserID(Map<String, Object> params) {
	    return memberListMapper.getUpdUserID(params);
	}

	public int updateOrgUserPW(Map<String, Object> params) {

		if(ssoLoginFlag > 0){
    		try{
    			Map<String,Object> ssoParamsOldMem = new HashMap<String, Object>();
    	  		ssoParamsOldMem.put("memCode", params.get("memberCode").toString());
    	  		ssoParamsOldMem.put("password", params.get("userPasswd").toString());
    	  		Map<String,Object> returnSsoParams = ssoLoginService.ssoUpdateUserPassword(ssoParamsOldMem);
    		}catch(Exception ex) {
    			throw ex;
            }
		}

	    return memberListMapper.updateOrgUserPW(params);
	}

	@Override
    public List<EgovMap> selectPromoDisHistory(Map<String, Object> params) {
		return memberListMapper.selectPromoDisHistory(params);
	}

	@Override
    public EgovMap getCurrOrgDtls(Map<String, Object> params) {
        return memberListMapper.getCurrOrgDtls(params);
    }

	public EgovMap validateVaccineDeclarationStatus(Map<String, Object> params) {
	    return memberListMapper.validateVaccineDeclarationStatus(params);
	}

	@Override
	public EgovMap getVaccineDeclarationMemDetails(Map<String, Object> params) {
	    return memberListMapper.getVaccineDeclarationMemDetails(params);
	}

	@Override
	public void updateVaccineDeclaration(Map<String, Object> params) throws Exception {
	    memberListMapper.updateVaccineDeclaration(params);
	}

	@Override
    public List<EgovMap> selectTrApplByEmail(Map<String, Object> params) {
        return memberListMapper.selectTrApplByEmail(params);
    }

	//added by keyi social media
	public EgovMap  selectSocialMedia(Map<String, Object> params) {
	    return memberListMapper.selectSocialMedia(params);
	}

	@Override
	public void updateSocialMedia(Map<String, Object> params)  throws Exception {
	    memberListMapper.updateSocialMedia(params);
	}

	@Override
    public List<EgovMap> selectHTOrgCode(Map<String, Object> params) {
        return memberListMapper.selectHTOrgCode(params);
    }

	@Override
    public List<EgovMap> selectHTGroupCode(Map<String, Object> params) {
        return memberListMapper.selectHTGroupCode(params);
    }

	@Override
    public List<EgovMap> selectHTDeptCode(Map<String, Object> params) {
        return memberListMapper.selectHTDeptCode(params);
    }

	@Override
    public List<EgovMap> selectStatusList(Map<String, Object> params) {
        return memberListMapper.selectStatusList(params);
    }

	@Override
    public List<EgovMap> selectPositionList(Map<String, Object> params) {
        return memberListMapper.selectPositionList(params);
    }

	public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {

        int atchFlId = memberListMapper.selectNextFileId();

        FileGroupVO fileGroupVO = new FileGroupVO();

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", flVO.getAtchFileName());
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
        flInfo.put("fileUnqKey", params.get("claimUn"));
        flInfo.put("fileKeySeq", seq);
        memberListMapper.insertFileDetail(flInfo);
        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
        fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));
        memberListMapper.insertFileGroup(fileGroupVO);

    }

	@Override
	public void insertMemberListAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
		// TODO Auto-generated method stub

		int fileGroupKey = fileMapper.selectFileGroupKey();
		AtomicInteger i = new AtomicInteger(0); // get seq key.

		logger.debug("insertMemberListAttachBiz :: Start");

		list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updateMemberListAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs) {
		// TODO Auto-generated method stub
		logger.debug("params =====================================>>  " + params.toString());
		logger.debug("list.size : {}", list.size());
		String update = (String) params.get("update");
		String remove = (String) params.get("remove");
		String[] updateList = null;
		String[] removeList = null;
		if(!StringUtils.isEmpty(update)) {
			updateList = params.get("update").toString().split(",");
			logger.debug("updateList.length : {}", updateList.length);
		}
		if(!StringUtils.isEmpty(remove)) {
			removeList = params.get("remove").toString().split(",");
			logger.debug("removeList.length : {}", removeList.length);
		}
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				if(updateList != null && i < updateList.length && removeList != null && removeList.length > 0) {
					String atchFileId = updateList[i];
					String removeAtchFileId = removeList[i];
					if(atchFileId.equals(removeAtchFileId))
					{
						fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
					}
					else {
						int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
						this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
					}
				}
				else if(updateList != null && i < updateList.length) {
					String atchFileId = updateList[i];
					fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
				}
				else {
					int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
					this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
				}
			}
		}
		if(updateList == null && removeList != null && removeList.length > 0){
			for(String id : removeList){
				logger.info(id);
				String atchFileId = id;
				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
			}
		}
	}

	@Override
	public void deleteMemberListAttachBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("params =====================================>>  " + params);
		fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
	}

	@Override
    public List<EgovMap> selectMemberWorkingHistory(Map<String, Object> params) {
        return memberListMapper.selectMemberWorkingHistory(params);
    }

	@Override
    public List<EgovMap> selectHpRegistrationOption(Map<String, Object> params) {
        return memberListMapper.selectHpRegistrationOption(params);
    }

	// To get count of duplicated members with same email
	@Override
	public int selectCntMemSameEmail(Map<String, Object> params) {
	    return memberListMapper.selectCntMemSameEmail(params);
	}

	@Override
	public int insertMfaResetRequest(Map<String, Object> params){
		  return memberListMapper.insertMfaResetRequest(params);
	}

	@Override
	public int selectCurrRequestId() {
		return memberListMapper.selectCurrRequestId();
	}

	@Override
	public int insertMfaApprovalLine(Map<String, Object> params){
		  return memberListMapper.insertMfaApprovalLine(params);
	}

	@Override
	public List<EgovMap> mfaResetList(Map<String, Object> p) {
		return memberListMapper.mfaResetList(p);
	}

	@Override
	public void updateMFAApproval(Map<String, Object> p) {
		memberListMapper.updateMFAApproval(p);
	}

	@Override
	public int resetMfa(Map<String, Object> p) {
		return memberListMapper.resetMfa(p);
	}

	@Override
	public int insertResetMfaHistory(Map<String, Object> p) {
		return memberListMapper.insertResetMfaHistory(p);
	}

	@Override
    public List<EgovMap> getMfaResetHist(Map<String, Object> params) {
        return memberListMapper.getMfaResetHist(params);
    }

	@Override
    public List<EgovMap> checkEmail(Map<String, Object> params) {
        return memberListMapper.checkEmail(params);
    }

	// Added for Enhancement on New Button available to suspend member with email duplicate (for registering new)
	@Override
	public Map<String, Object> suspendFromCU(Map<String, Object> params) throws Exception{

		String emailToChange = params.get("email").toString();
    	String strDt = CommonUtils.getNowDate();

    	Map<String, Object> memMap = new HashMap<String, Object>();
    	memMap.put("username", params.get("memCode").toString());
    	emailToChange = strDt + "_" + emailToChange;
    	memMap.put("email", emailToChange);
    	memMap.put("memberID", params.get("memId").toString());

    	//update lms site
    	Map<String, Object> returnVal = lmsApiService.lmsMemberListDeact(memMap);
    	logger.debug("returnVal status ......." + returnVal.get("status").toString());
		if (returnVal != null && returnVal.get("status").toString().equals(AppConstants.SUCCESS)){
	    	memberListMapper.updateMemberEmail(memMap);
		}
		else {
			Exception e1 = new Exception (returnVal.get("message") != null ? returnVal.get("message").toString() : "");
			throw new RuntimeException(e1);
		}
		return returnVal;
	}

	@Transactional
	@Override
	public ReturnMessage sendWhatsApp(Map<String, Object> params) {

		ReturnMessage message = new ReturnMessage();

		try {

				String telno = CommonUtils.nvl(params.get("rTelNo"));
				String templateName = waApiBtnEhpAgreementTemplate;
				String payload = "=" + params.get("MemberID").toString();
				String path = "organization/agreementListing.do";
				String imageUrl = "https://iili.io/dTBskTG.jpg";

				Map<String, Object> param = new HashMap<>();
				param.put("telno", telno);
				param.put("templateName", templateName);
				param.put("language", AppConstants.LANGUAGE_EN);
				param.put("payload", payload);
				param.put("path", path);
				param.put("imageUrl", imageUrl);

				Map<String, Object> waResult = whatappsApiService.setWaTemplateConfiguration(param);

				message.setCode(waResult.get("status") == "00" ? AppConstants.SUCCESS : AppConstants.FAIL);
				message.setMessage(waResult.get("status") == "00" ? messageAccessor.getMessage("ehpAgreement.doneWhatsApp")
						: messageAccessor.getMessage("ehpAgreement.failWhatsApp"));
				return message;


		} catch (Exception e) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("ehpAgreement.failWhatsApp"));
			return message;
		}
	}

   /**
    * selectMagicAddressComboList (Magic Address)
    *
    * @param params
    * @return
    * @exception Exception
    * @author
    */
   @Override
   public List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception {

     // State
     if (params.get("state") == null && params.get("city") == null && params.get("postcode") == null) {
       params.put("colState", "1");
     }
     // City
     if (params.get("state") != null && params.get("city") == null && params.get("postcode") == null) {
       params.put("colCity", "1");
     }
     // Post Code
     if (params.get("state") != null && params.get("city") != null && params.get("postcode") == null) {
       params.put("colPostCode", "1");
     }
     // Area
     if (params.get("state") != null && params.get("city") != null && params.get("postcode") != null) {
       params.put("colArea", "1");
     }

     return memberListMapper.selectMagicAddressComboList(params);
   }

	@Override
    public EgovMap selectMfaDetails(Map<String, Object> params) {
        return memberListMapper.selectMfaDetails(params);
    }
}
