package com.coway.trust.biz.organization.organization.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberListService")


public class MemberListServiceImpl extends EgovAbstractServiceImpl implements MemberListService{
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;


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
	public String saveMember(Map<String, Object> params, List<Object> docType) {

		String appId="";
		String memCode = "";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
		if(Integer.parseInt((String) params.get("memberType")) == 2803){   //if HP Applicant

			MemApp.put("applicationID", 0);
			MemApp.put("applicantCode", "");
			MemApp.put("applicantType",Integer.parseInt((String) params.get("memberType")));
			MemApp.put("applicantName",params.get("memberNm").toString());
			MemApp.put("applicantFullName",params.get("memberNm").toString());
			MemApp.put("applicantIdentification",getRandomNumber(5));
			MemApp.put("applicantNRIC",params.get("nric").toString());
			MemApp.put("applicantDOB",params.get("Birth").toString());
			MemApp.put("applicantGender", params.get("gender"));
			MemApp.put("applicantRace",Integer.parseInt((String) params.get("cmbRace")));
			MemApp.put("applicantMarital",0);
			MemApp.put("applicantNationality",Integer.parseInt((String) params.get("national")));
			//MemApp.put("applicantAdd1", params.get("address1").toString().trim()!=null ? params.get("address1").toString().trim() : "");
			//MemApp.put("applicantAdd2", params.get("address2").toString().trim()!=null ? params.get("address2").toString().trim() : "");
			//MemApp.put("applicantAdd3", params.get("address3").toString().trim()!=null ? params.get("address3").toString().trim() : "");
			//MemApp.put("applicantAdd4","");
			//MemApp.put("applicantAreald",params.get("area")!=null ? Integer.parseInt(params.get("area").toString().trim()) : 0);
			//MemApp.put("applicantPostCodeId",params.get("postCode")!=null ? Integer.parseInt(params.get("postCode").toString().trim()) : 0);
			//MemApp.put("applicantStateId",params.get("state") !=null ? Integer.parseInt(params.get("state").toString().trim()) : 0);
			//MemApp.put("applicantCountryId",params.get("country")!=null ? Integer.parseInt(params.get("country").toString().trim()) : 0);
			MemApp.put("applicantTelOffice","");
			MemApp.put("applicantTelHouse",params.get("residenceNo").toString().trim()!=null ? params.get("residenceNo").toString().trim() : "");
			MemApp.put("applicantTelMobile",params.get("mobileNo").toString().trim()!=null ? params.get("mobileNo").toString().trim() : "");
			MemApp.put("applicantEmail",params.get("email").toString().trim()!=null ? params.get("email").toString().trim() : "");
			MemApp.put("applicantSpouseCode","");
			MemApp.put("applicantSpouseName",params.get("spouseName").toString().trim()!=null ? params.get("spouseName").toString().trim() : "");
			MemApp.put("applicantSpouseNRIC",params.get("spouseNRIC").toString().trim()!=null ? params.get("spouseNRIC").toString().trim() : "");
			MemApp.put("applicantSpouseOccupation",params.get("spouseOcc").toString().trim()!=null ? params.get("spouseOcc").toString().trim() : "");
			MemApp.put("applicantSpouseTelContact",params.get("spouseContat").toString().trim()!=null ? params.get("spouseContat").toString().trim() : "");
			MemApp.put("applicantSpouseDOB",params.get("spouseDOB").toString().trim()!=null ? params.get("spouseDOB").toString().trim() :"01/01/1900");
			MemApp.put("applicantEduLevel",params.get("educationLvl")!=null && params.get("educationLvl")!="" ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
			MemApp.put("applicantLanguage",params.get("language")!="" && params.get("language")!=null ? Integer.parseInt(params.get("language").toString().trim()) : 0);
			MemApp.put("applicantBankID",Integer.parseInt(params.get("issuedBank").toString()));
			MemApp.put("applicantBankAccNo",params.get("bankAccNo").toString().trim());
			MemApp.put("applicantSponsorCode",params.get("sponsorCd").toString().trim()!=null ? params.get("sponsorCd").toString().trim() : "");
			MemApp.put("applicantTransport",0);
			MemApp.put("remark","");
			MemApp.put("statusId",44);
			MemApp.put("created",new Date());
			MemApp.put("creator",52366);
			MemApp.put("updated",new Date());
			MemApp.put("updator",52366);
			MemApp.put("confirmation",false);
			MemApp.put("confirmDate","01/01/1900");
			MemApp.put("deptCode",params.get("deptCd").toString());
			//addr 주소 가져오기
			//MemApp.put("areaId",params.get("searchSt1").toString());
			MemApp.put("areaId",params.get("areaId").toString());
			MemApp.put("streetDtl",params.get("streetDtl1")!= null ?params.get("streetDtl1").toString() : "");
			MemApp.put("addrDtl",params.get("addrDtl1")!= null ? params.get("addrDtl1").toString() : "");
			
			//Department
			MemApp.put("searchdepartment",params.get("searchdepartment").toString().trim()!=null ? params.get("searchdepartment").toString().trim() : "");
			MemApp.put("searchSubDept"		,params.get("subDept").toString().trim()!=null ? params.get("subDept").toString().trim() : "");

			logger.debug("MemApp : {}",MemApp);
			EgovMap appNo = getDocNo("145");
			MemApp.put("applicantCode", appNo.get("docNo"));
			logger.debug("appNo : {}",appNo);
			updateDocNoNumber("145");

			//insert HP applicant
			memberListMapper.insertMemApp(MemApp);
			codeMap1.put("code", "memApp");
			appId = memberListMapper.selectMemberId(codeMap1);

			memCode = MemApp.get("applicantCode").toString();

			/*if(success){
			if(Integer.parseInt((String) params.get("memberType")) == 2){
				if(MemApp != null){
					//sendSMS(params);
				}
			}
		}*/

			return memCode;
		}

		else
		{

		int rank = 0;
		if(params.get("memberType").equals("1") ){
			rank=433;
		}
		if(params.get("memberType").equals("2") || params.get("memberType").equals("3")){
			rank=53;
		}
		if(params.get("memberType").equals("4")){
			rank=427;
		}

		params.put("memberID", 0);
		params.put("memberCode", "");
		params.put("memberType", Integer.parseInt((String) params.get("memberType")));
		params.put("memberNm", params.get("memberNm").toString().trim().toUpperCase());
		params.put("fulllName", params.get("memberNm").toString().trim().toUpperCase());
		params.put("password", params.get("nric").toString().trim().substring(((String) params.get("nric")).trim().length() - 6, 6));
		params.put("nric", params.get("nric").toString().trim().toUpperCase());
		//params.put("address1", params.get("address1").toString().trim()!=null ? params.get("address1").toString().trim() : "");
		//params.put("address2", params.get("address2").toString().trim()!=null ? params.get("address2").toString().trim() : "");
		//params.put("address3", params.get("address3").toString().trim()!=null ? params.get("address3").toString().trim() : "");
		//params.put("address4", "");
		//params.put("area", params.get("area")!=null ? Integer.parseInt(params.get("area").toString().trim()) : 0);
		//params.put("postCode", params.get("postCode")!=null ? Integer.parseInt(params.get("postCode").toString().trim()) : 0);
		params.put("race", Integer.parseInt((String) params.get("cmbRace")));
		params.put("nation", Integer.parseInt((String) params.get("national")));
		params.put("marrital", Integer.parseInt((String) params.get("marrital")));
		//params.put("state", params.get("state") !=null ? Integer.parseInt(params.get("state").toString().trim()) : 0);
		params.put("country", params.get("country")!=null ? Integer.parseInt(params.get("country").toString().trim()) : 0);
		params.put("mobileNo", params.get("mobileNo").toString().trim()!=null ? params.get("mobileNo").toString().trim() : "");
		params.put("officeNo", params.get("officeNo").toString().trim()!=null ? params.get("officeNo").toString().trim() : "");
		params.put("residenceNo", params.get("residenceNo").toString().trim()!=null ? params.get("residenceNo").toString().trim() : "");
		params.put("email", params.get("email").toString().trim()!=null ? params.get("email").toString().trim() : "");
		params.put("educationLvl", params.get("educationLvl")!=null &&  params.get("educationLvl")!="" ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
		params.put("language", params.get("language")!=null && params.get("language")!=""? Integer.parseInt(params.get("language").toString().trim()) : 0);
		params.put("issuedBank", params.get("issuedBank")!=null ? params.get("issuedBank").toString().trim() : "");
		params.put("bankAccNo", params.get("bankAccNo").toString().trim()!=null ? params.get("bankAccNo").toString().trim() : "");
		params.put("sponsorCd", params.get("sponsorCd").toString().trim()!=null ? params.get("sponsorCd").toString().trim() : "");
		params.put("reSignDate","01/01/1900");
		params.put("termDate","01/01/1900");
		params.put("RenewDate",params.get("joinDate"));
		params.put("AgrmntNo","");
		params.put("branch", params.get("branch")!=null &&  params.get("branch")!=""? Integer.parseInt(params.get("branch").toString().trim()) : 0);
		params.put("status","1");
		params.put("SyncCheck",false);
		params.put("rank",rank);
		params.put("transportCd", params.get("transportCd")!=null &&  params.get("transportCd")!=""? Integer.parseInt(params.get("transportCd").toString().trim()) : 0);
		params.put("promoteDate","01/01/1900");
		params.put("trNo", params.get("trNo")!=null ? params.get("trNo").toString().trim() : "");
		params.put("created",new Date());
		params.put("creator",52366);
		params.put("updated",new Date());
		params.put("updator",52366);
		params.put("memIsOutSource",false);
		params.put("applicantID", appId !=null ? appId : 0);
		params.put("BusinessesType",1375);
		params.put("Hospitalization",false);
		params.put("deptCode",params.get("deptCd")!=null ? params.get("deptCd").toString().trim() : "");
		params.put("codyPaExpr",params.get("codyPaExpr")!=null ? params.get("codyPaExpr").toString().trim() : "");
		//params.put("traineeType",Integer.parseInt(params.get("traineeType").toString()));

		//addr 가져오기
		params.put("areaId",params.get("areaId").toString());
		params.put("streetDtl",params.get("streetDtl1")!= null ?params.get("streetDtl1").toString() : "");
		params.put("addrDtl",params.get("addrDtl1")!= null ? params.get("addrDtl1").toString() : "");
		
		//Department
		params.put("searchdepartment",params.get("searchdepartment").toString().trim()!=null ? params.get("searchdepartment").toString().trim() : "");
		params.put("searchSubDept"		,params.get("subDept").toString().trim()!=null ? params.get("subDept").toString().trim() : "");

		//두번째 탭 text 가져오기
		params.put("spouseCode", params.get("spouseCode").toString().trim()!=null ? params.get("spouseCode").toString().trim() : "");
		params.put("spouseName", params.get("spouseName").toString().trim()!=null ? params.get("spouseName").toString().trim() : "");
		params.put("spouseNric", params.get("spouseNRIC").toString().trim()!=null ? params.get("spouseNRIC").toString().trim() : "");
		params.put("spouseOcc", params.get("spouseOcc").toString().trim()!=null ? params.get("spouseOcc").toString().trim() : "");
		params.put("spouseDob", params.get("spouseDOB").toString().equals("") ? "01/01/1900":params.get("spouseDOB").toString().trim() );
		params.put("spouseContat", params.get("spouseContat").toString().trim()!=null ? params.get("spouseContat").toString().trim() : "");


		Boolean success = false;

		if(params != null){
			memCode = doSaveMember(params, docType);


		}
		return memCode;
		}

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

			}*/

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
				memberListMapper.insertUser(user);


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
			
			if(params.get("memberType").toString().equals("5")  &&  !params.get("course").equals("")) {
				if (params.get("traineeType1").toString().equals("2") || params.get("traineeType1").toString().equals("3") ){
			
    					logger.debug("=============================================================================================================");
    					logger.debug("=====================  memberType {}  traineeType {} ", params.get("memberType").toString(), params.get("traineeType").toString() );
    					logger.debug("=============================================================================================================");
					
						params.put("MemberId", MemberId);
					
						memberListMapper.traineeInsertInfor(params);
				}
			}
			
			
			success=true;
			String memCode = "";

				memCode = selectMemberCode.get("docNo").toString();

		return memCode;
	}

	@Transactional
	@Override
	public Map<String, Object> insertTerminateResign(Map<String, Object> params,SessionVO sessionVO) {
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
			promoEntry.put("deptCodeTo", "");
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
				promoEntry.put("deptCodeFrom", selectMemberOrgs.get("deptCode"));
				promoEntry.put("parentIdFrom", selectMemberOrgs.get("memUpId") != null ? Integer.parseInt(selectMemberOrgs.get("memUpId").toString()) : 0);
				promoEntry.put("parentDeptCodeFrom", selectOrganization.get("deptCode").toString() != null ? selectOrganization.get("deptCode").toString() : "");
				promoEntry.put("parentDeptCodeTo",  selectOrganization_new.get("deptCode").toString() != null && selectOrganization_new.get("deptCode") !="" ? selectOrganization_new.get("deptCode").toString() : "");
				promoEntry.put("PRCode", promoEntry.get("promoTypeId").toString().equals("747") ? selectOrganization.get("deptCode") != null? selectOrganization.get("deptCode").toString() : "" : "");
				promoEntry.put("lastDeptCode", selectMemberOrgs.get("deptCode"));
				promoEntry.put("lastGrpCode", selectMemberOrgs.get("grpCode"));
				promoEntry.put("lastOrgCode", selectMemberOrgs.get("orgCode"));
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
        			member.put("termDate", Integer.parseInt(params.get("action").toString()) == 757 ? params.get("dtT/R").toString() : "01/01/1900" );
        			member.put("resignDate", Integer.parseInt(params.get("action").toString()) == 758 ? params.get("dtT/R").toString() : "01/01/1900" );

        			logger.debug("member : {}",member);


        			promoEntry.put("promoId", 0);
        			promoEntry.put("requestNo", "");
        			promoEntry.put("statusId", 4);
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
        			promoEntry.put("parentIdFrom", 0);
        			promoEntry.put("parentIdTo", 0);
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
        				memberListMapper.updateMember(selectMember);
        				//User
        				EgovMap selectUserName = memberListMapper.selectUserName(selectMember);
        				if(selectUserName != null){
        					selectUserName.put("userStatusID", 8);
        					selectUserName.put("userUpdateAt", new Date());
        					selectUserName.put("userUpdateBy", member.get("updator"));

        					memberListMapper.updateUser(selectUserName);
        				}
        			}
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
			vacationEntry.put("memTypeId",params.get("memtype"));
			vacationEntry.put("memberId", params.get("memberId"));
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

	@Override
	public Map<String, Object> traineeUpdate(Map<String, Object> params,SessionVO sessionVO) {
		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>(); //팝업 결과값 가져가는 map

		int a =memberListMapper.traineeUpdate(params);

		if(a> 0){
			resultValue =	memberListMapper.afterSelTrainee(params);
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
	public  int    memberListUpdate_member(Map<String, Object> params) {
		return memberListMapper.memberListUpdate_member(params);
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
		det.put("SpouseNRIC",((String) params.get("spouseNRIC")).toUpperCase());
		det.put("SpouseOccupation",(String) params.get("spouseOcc"));
		det.put("SpouseTelContact",(String) params.get("spouseContat"));
		det.put("SpouseDOB",(String) params.get("spouseDOB"));
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

				memberListMapper.saveDocSubmission(docSubVO);
			}
			else {

				docSubVO.setUpdUserId(sessionVO.getUserId());

				memberListMapper.updateDocSubmissionDel(docSubVO);
			}
		}

	}

	@Override
	public Map<String, Object> hpMemRegister(Map<String, Object> params,SessionVO sessionVO) {
		boolean success = false;
		Map<String, Object> resultValue = new HashMap<String, Object>(); //팝업 결과값 가져가는 map
		Map<String, Object> CodeMap = new HashMap<String, Object>();

		EgovMap selectMemberCode = null; // 각가 docNo, docNoId, prefix구함
		
		//nextDocNo = getNextDocNo("",selectMemberCode.get("docNo").toString());
		
		//selectMemberCode = getDocNo("1");
		
		//edit  hgham 25-12-2017
		Map mp = new HashMap();
		mp.put("docNo", "1");
		selectMemberCode = memberListMapper.getDocNo(mp);
		
		String memberCode = selectMemberCode.get("docNo").toString();
		params.put("memberCode", memberCode);
		
		int a =memberListMapper.hpMemRegister(params);

		if(a> 0){
			
			Map<String, Object> memOrg = new HashMap<String, Object>();
			CodeMap.put("code", "mem");
			String MemberId = memberListMapper.selectMemberId(CodeMap);//asis 어떻게 가져오는지 확인 다시해봐

			EgovMap selectOrganization = null;
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
				memOrg.put("orgUpdateBy",selectOrganization.get("creator"));
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
				memOrg.put("lastGrpCode",lastGroupCode);
				memOrg.put("lastOrgCode",lastOrgCode);
				memOrg.put("lastTopOrgCode","");
				memOrg.put("branchId",0);


				logger.debug("memOrg : {}",memOrg);

				memberListMapper.insertOrganization(memOrg);

			} 
			
			params.put("updUserId", sessionVO.getUserId());
			
			memberListMapper.updateHpApproval(params);
			
			params.put("memberId", MemberId);
			
			resultValue =	memberListMapper.afterSelTrainee(params);
			
		}

		return resultValue;
	}
	
	@Override
	public List<EgovMap> getMainDeptList() {
		// TODO Auto-generated method stub
		return memberListMapper.selectMainDept();
	}	
	
	@Override
	public List<EgovMap> getSubDeptList(Map<String, Object> params) {
		
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
	public EgovMap selectHPMemberListView(Map<String, Object> params) {
		return memberListMapper.getHPMemberListView(params);
	}
	@Override
	public List<EgovMap>  selectCoureCode(Map<String, Object> params) {
		return memberListMapper.selectCoureCode(params);
	}	
}
