package com.coway.trust.biz.organization.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.MemberListService;
import com.coway.trust.web.organization.MemberListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberListService")


public class MemberListServiceImpl extends EgovAbstractServiceImpl implements MemberListService{
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);
	
	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;
	
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
	public Boolean saveMember(Map<String, Object> params) {
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
		params.put("reSignDate","01/01/1900");
		params.put("termDate","01/01/1900");
		params.put("RenewDate",params.get("joinDate"));
		params.put("AgrmntNo","");
		params.put("branch", params.get("branch")!=null ? Integer.parseInt(params.get("branch").toString().trim()) : 0);
		params.put("status","1");
		params.put("SyncCheck",false);
		params.put("rank",rank);
		params.put("transportCd", params.get("transportCd")!=null ? Integer.parseInt(params.get("transportCd").toString().trim()) : 0);
		params.put("promoteDate","01/01/1900");
		params.put("trNo", params.get("trNo")!=null ? params.get("trNo").toString().trim() : "");
		params.put("created",new Date());
		params.put("creator","99999");
		params.put("updated",new Date());
		params.put("updator","99999");
		params.put("memIsOutSource",false);
		params.put("applicantID",false);
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
		}
		
		return success;
	}
	
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
			docNo = (String) selectDocNo.get("c1") != null ? (String) selectDocNo.get("c1") : "";
			String prefix = (String) selectDocNo.get("c2") != null ? (String) selectDocNo.get("c2") : "";
			selectDocNo.put("c1", docNo);
			selectDocNo.put("c2", prefix);
		}
		return selectDocNo;
	}
	
	/*public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}
		String docNoFormat = "";
		
		for(int i = 1; i <= docNoLength; i++){
			docNoFormat += "0";
		}
		
		int nextNo = Integer.parseInt(docNo) + 1;
		logger.debug("nextNo : {}",nextNo);
		nextDocNo = String.format(docNoFormat, nextNo);
		return nextDocNo;
	}*/
	
	public Boolean doSaveMember(Map<String, Object> params) {
		Boolean success = false;
		try{
			String memberCode = "";
			int ID = 0;
			String nextDocNo= "";
			EgovMap selectMemberCode = null; // 각가 docNo, docNoId, prefix구함
			
			switch(Integer.parseInt(params.get("memberType").toString())){
			
			case 1:
				selectMemberCode = getDocNo("1");
				logger.debug("selectMemberCode : {}",selectMemberCode);
				ID=1;
				//nextDocNo = getNextDocNo("",selectMemberCode.get("c1").toString());
				logger.debug("nextDocNo : {}",nextDocNo);
				selectMemberCode.put("nextDocNo", nextDocNo);
				break;
			}
			
			if(Integer.parseInt(selectMemberCode.get("docNoId").toString()) == ID){
				logger.debug("update 문 탈 예정");
				//memberListMapper.updateDocNo(selectMemberCode);
			}
			params.put("memberCode", memberCode);
			//memberListMapper.insertMember(params);
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
			String MemberId = memberListMapper.selectMemberId();

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
				
				//memberListMapper.insertOrganization(memOrg);
				
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
					
					//memberListMapper.insertOrganization(memOrg);
				}
			}
			
			//AcBilling Save (for Hp)
			
			if(params.get("memberType").toString().equals("1")){
				
				selectMemberCode = getDocNo("5");
				logger.debug("selectMemberCode : {}",selectMemberCode);
				memberCode=(String)selectMemberCode.get("c1");
				ID=1;
				//nextDocNo = getNextDocNo("HPB", selectMemberCode.get("c1").toString());
				logger.debug("nextDocNo : {}",nextDocNo);
				selectMemberCode.put("nextDocNo", nextDocNo);
				logger.debug("selectMemberCode : {}",selectMemberCode);
				if(Integer.parseInt(selectMemberCode.get("docNoId").toString()) == ID){
					logger.debug("update 문 탈 예정");
					//memberListMapper.updateDocNo(selectMemberCode);
				}
				params.put("memberCode", memberCode);
				
				Map<String, Object> accBill = new HashMap<String, Object>();
				accBill.put("billId", 0);
				accBill.put("billINo", memberCode);
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
				accBill.put("updator", "");
				accBill.put("updated", new Date());
				accBill.put("syncCheck", true);
				accBill.put("courseId", 0);
				accBill.put("statusId", 1);
				
				logger.debug("accBill : {}",accBill);
				//memberListMapper.insertAccBill(accBill);
				
			}
			success=true;
		}catch(Exception e){
			success=false;
			e.printStackTrace();
		}
			
		return success;
	}	
}
