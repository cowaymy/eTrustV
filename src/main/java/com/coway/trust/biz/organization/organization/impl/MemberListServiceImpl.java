package com.coway.trust.biz.organization.organization.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.organization.organization.MemberListController;

import antlr.Parser;
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

	public List<EgovMap> selectUserBranch() {
		return memberListMapper.selectUserBranch();
	}
	
	public List<EgovMap> selectUser() {
		return memberListMapper.selectUser();
	}

	public List<EgovMap> selectMemberList(Map<String, Object> params) {
		return memberListMapper.selectMemberList(params);
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
	
	
	
	@Override
	public Boolean saveMember(Map<String, Object> params) {
		
		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
		if(Integer.parseInt((String) params.get("memberType")) == 2){
			
			MemApp.put("applicationID", 0);
			MemApp.put("applicantCode", "");
			MemApp.put("applicantType",Integer.parseInt((String) params.get("memberType")));
			MemApp.put("applicantName",params.get("memberNm").toString());
			MemApp.put("applicantFullName",params.get("memberNm").toString());
			MemApp.put("applicantIdentification","");// 랜덤 어쩌구 만들어야함
			MemApp.put("applicantNRIC",params.get("nric").toString());
			MemApp.put("applicantDOB",params.get("Birth").toString());
			MemApp.put("applicantGender", params.get("gender"));
			MemApp.put("applicantRace",Integer.parseInt((String) params.get("race")));
			MemApp.put("applicantMarital",0);
			MemApp.put("applicantNationality",Integer.parseInt((String) params.get("nation")));
			MemApp.put("applicantAdd1", params.get("address1").toString().trim()!=null ? params.get("address1").toString().trim() : "");
			MemApp.put("applicantAdd2", params.get("address2").toString().trim()!=null ? params.get("address2").toString().trim() : "");
			MemApp.put("applicantAdd3", params.get("address3").toString().trim()!=null ? params.get("address3").toString().trim() : "");
			MemApp.put("applicantAdd4","");
			MemApp.put("applicantAreald",params.get("area")!=null ? Integer.parseInt(params.get("area").toString().trim()) : 0);
			MemApp.put("applicantPostCodeId",params.get("postCode")!=null ? Integer.parseInt(params.get("postCode").toString().trim()) : 0);
			MemApp.put("applicantStateId",params.get("state") !=null ? Integer.parseInt(params.get("state").toString().trim()) : 0);
			MemApp.put("applicantCountryId",params.get("country")!=null ? Integer.parseInt(params.get("country").toString().trim()) : 0);
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
			MemApp.put("applicantEduLevel",params.get("educationLvl")!=null ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
			MemApp.put("applicantLanguage",params.get("language")!=null ? Integer.parseInt(params.get("language").toString().trim()) : 0);
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
			MemApp.put("confirmDate","1900-01-01");
			MemApp.put("deptCode",params.get("deptCode"));
			
			logger.debug("MemApp : {}",MemApp);
			
			EgovMap appNo = getDocNo("145");
			MemApp.put("applicantCode", appNo.get("docNo"));
			logger.debug("appNo : {}",appNo);
			updateDocNoNumber("145");
			
			//memberListMapper.insertMemApp(MemApp);
			codeMap1.put("code", "memApp");
			appId = memberListMapper.selectMemberId(codeMap1);
		}
		
		/*SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}*/
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
		params.put("address1", params.get("address1").toString().trim()!=null ? params.get("address1").toString().trim() : "");
		params.put("address2", params.get("address2").toString().trim()!=null ? params.get("address2").toString().trim() : "");
		params.put("address3", params.get("address3").toString().trim()!=null ? params.get("address3").toString().trim() : "");
		params.put("address4", "");
		params.put("area", params.get("area")!=null ? Integer.parseInt(params.get("area").toString().trim()) : 0);
		params.put("postCode", params.get("postCode")!=null ? Integer.parseInt(params.get("postCode").toString().trim()) : 0);
		params.put("race", Integer.parseInt((String) params.get("race")));
		params.put("nation", Integer.parseInt((String) params.get("nation")));
		params.put("marrital", Integer.parseInt((String) params.get("marrital")));
		params.put("state", params.get("state") !=null ? Integer.parseInt(params.get("state").toString().trim()) : 0);
		params.put("country", params.get("country")!=null ? Integer.parseInt(params.get("country").toString().trim()) : 0);
		params.put("mobileNo", params.get("mobileNo").toString().trim()!=null ? params.get("mobileNo").toString().trim() : "");
		params.put("officeNo", params.get("officeNo").toString().trim()!=null ? params.get("officeNo").toString().trim() : "");
		params.put("residenceNo", params.get("residenceNo").toString().trim()!=null ? params.get("residenceNo").toString().trim() : "");
		params.put("email", params.get("email").toString().trim()!=null ? params.get("email").toString().trim() : "");
		params.put("educationLvl", params.get("educationLvl")!=null ? Integer.parseInt(params.get("educationLvl").toString().trim()) : 0);
		params.put("language", params.get("language")!=null ? Integer.parseInt(params.get("language").toString().trim()) : 0);
		params.put("bank", params.get("bank")!=null ? params.get("bank").toString().trim() : "");
		params.put("bankAccNo", params.get("bankAccNo").toString().trim()!=null ? params.get("bankAccNo").toString().trim() : "");
		params.put("sponsorCd", params.get("sponsorCd").toString().trim()!=null ? params.get("sponsorCd").toString().trim() : "");
		params.put("reSignDate","1900-01-01");
		params.put("termDate","1900-01-01");
		params.put("RenewDate",params.get("joinDate"));
		params.put("AgrmntNo","");
		params.put("branch", params.get("branch")!=null ? Integer.parseInt(params.get("branch").toString().trim()) : 0);
		params.put("status","1");
		params.put("SyncCheck",false);
		params.put("rank",rank);
		params.put("transportCd", params.get("transportCd")!=null ? Integer.parseInt(params.get("transportCd").toString().trim()) : 0);
		params.put("promoteDate","1900-01-01");
		params.put("trNo", params.get("trNo")!=null ? params.get("trNo").toString().trim() : "");
		params.put("created",new Date());
		params.put("creator",52366);
		params.put("updated",new Date());
		params.put("updator",52366);
		params.put("memIsOutSource",false);
		params.put("applicantID",appId);
		params.put("BusinessesType",1375);
		params.put("Hospitalization",false);
		params.put("deptCode",params.get("deptCd")!=null ? params.get("deptCd").toString().trim() : "");
		params.put("codyPaExpr",params.get("codyPaExpr")!=null ? params.get("codyPaExpr").toString().trim() : "");
		
		
		//두번째 탭 text 가져오기
		params.put("spouseCode", params.get("spouseCode").toString().trim()!=null ? params.get("spouseCode").toString().trim() : "");
		params.put("spouseName", params.get("spouseName").toString().trim()!=null ? params.get("spouseName").toString().trim() : "");
		params.put("spouseNric", params.get("spouseNRIC").toString().trim()!=null ? params.get("spouseNRIC").toString().trim() : "");
		params.put("spouseOcc", params.get("spouseOcc").toString().trim()!=null ? params.get("spouseOcc").toString().trim() : "");
		params.put("spouseDob", params.get("spouseDOB").toString().trim()!=null ? params.get("spouseDOB").toString().trim() :"01/01/1900");
		params.put("spouseContat", params.get("spouseContat").toString().trim()!=null ? params.get("spouseContat").toString().trim() : "");
		
		Boolean success = false;
		if(params != null){
			success = doSaveMember(params);
			
			if(success){
				if(Integer.parseInt((String) params.get("memberType")) == 2){
					if(MemApp != null){
						
					}
				}
			}
		}
		
		
		
		return success;
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
			docNo = prefix+(String) selectDocNo.get("c1");
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
		if(docNoId.equals("145")){
			nextDocNo = String.format("%07d", nextDocNoNumber);
		}else{//130일때
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
		}
		
		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}
	
	@Transactional
	public Boolean doSaveMember(Map<String, Object> params) {
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
			String deptParentID="";
					if(params.get("deptCode").toString() == null){
						deptParentID = params.get("deptCode").toString();
					}else
						if(selectOrganization.get("memLvl").toString().equals("3") && selectOrganization.get("deptCode").toString().equals(params.get("deptCode").toString())){
							deptParentID = selectOrganization.get("memId").toString();
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
				memOrg.put("lastDeptCode","");
				memOrg.put("lastGrpCode","");
				memOrg.put("lastOrgCode","");
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
			
			EgovMap selectHpBillNo = null;
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
    				InvMISC.put("taxInvoiceAddress1",selectMiscList.get("address1"));
    				InvMISC.put("taxInvoiceAddress2",selectMiscList.get("address2"));
    				InvMISC.put("taxInvoiceAddress3",selectMiscList.get("address3"));
    				InvMISC.put("taxInvoiceAddress4",selectMiscList.get("address4"));
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
    				InvMISCD.put("invoiceItemDescription2",selectMiscList.get("nric"));
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
			
			}
			
			//Save MemberAgreement
			if(params.get("codyPaExpr").toString() != null){
				Map<String, Object>  MA = new HashMap<String, Object>();
				MA.put("agreementID", 0);
				MA.put("agreementRefNo", "");
				MA.put("memberID", MemberId);
				MA.put("agreementTypeID", 1416);
				MA.put("agreementStatusID", 1);
				MA.put("agreementRemark", "");
				MA.put("agreementStartDate", "1900-01-01");
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
				user.put("userValidTo", "2099-12-31");
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
				if(params.get("memberType").toString().equals("1")|| params.get("memberType").toString().equals("2")){
					Map<String, Object>  roleuser = new HashMap<String, Object>();
					if(params.get("memberType").toString().equals("1")){
						roleuser.put("roleID", 115);
					}else{
						roleuser.put("roleID", 121);
					}
					roleuser.put("userID", "");
					roleuser.put("statusID", 1);
					//roleuser.put("createdAt", a.format(LocalDate.now()));
					roleuser.put("createdBy", params.get("creator"));
					//roleuser.put("updatedAt", a.format(LocalDate.now()));
					roleuser.put("updatedBy",params.get("creator"));
					
					logger.debug("roleuser : {}",roleuser);
					memberListMapper.insertRoleUser(roleuser);
				}
			}
			
			//Save InvWhlocation(For DC & CT)
			
			if(params.get("memberType").toString().equals("2") || params.get("memberType").toString().equals("3")){
				Map<String, Object>  invWH = new HashMap<String, Object>();
				invWH.put("WHLocID", 0);
				invWH.put("WHLocCode", memberCode);
				invWH.put("WHLocDesc", params.get("fullName"));
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
				//쿼리 없으니 asis 테스트
			}
			success=true;
		
		return success;
	}	
}
