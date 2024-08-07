package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.MemberEventService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : OrganizationEventServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("memberEventService")
public class MemberEventServiceImpl extends EgovAbstractServiceImpl implements MemberEventService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberEventServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "memberEventMapper")
	private MemberEventMapper memberEventMapper;

	@Resource(name = "transferMapper")
	private TransferMapper transferMapper;


	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectOrganizationEventList(Map<String, Object> params) {

//		for(int i=0; i < params.size(); i++) {
//			logger.debug("requestStatus : {}", params.get("StatusList"));
//		}

		return memberEventMapper.selectOrganizationEventList(params);

	}

	@Override
	public List<EgovMap> reqStatusComboList() {

		return memberEventMapper.reqStatusComboList();
	}

	@Override
	public List<EgovMap> reqPersonComboList() {

		return memberEventMapper.reqPersonComboList();
	}



	public EgovMap getMemberEventDetailPop(Map<String, Object> params) {

		logger.debug("getPstRequestDODetaiPop serviceImpl 호출 : " + params.get("promoId"));
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));

		return memberEventMapper.getMemberEventDetailPop(params);
	}


	@Override
	public List<EgovMap> selectPromteDemoteList(Map<String, Object> params) {
		return memberEventMapper.selectPromteDemoteList(params);
	}


	@Transactional
	public boolean selectMemberPromoEntries(Map<String, Object> params) {
		boolean success = false;
		logger.debug("getMemberEventDetailPop serviceImpl 호출 : " + params.get("promoId"));

		EgovMap formList = memberEventMapper.selectMemberPromoEntries(params);

		String vMemTypeId =  formList.get("memTypeId").toString();
		String vMemLvlTo = formList.get("memLvlTo").toString();

		logger.debug("vMemLvlTo::::" +vMemLvlTo);
		logger.debug("vMemTypeId::::" + vMemTypeId );


		if(formList.size()>0) {

			String nextDocNo = "";
			String newDeptCode1 = "";
			EgovMap newDeptCode = null;
			if(formList.get("memLvlTo").toString().equals("4")) {
				newDeptCode = memberEventMapper.getMemberOrganizations(formList);
				logger.debug("newDeptCode::::" + newDeptCode );

			} else if (formList.get("memLvlTo").toString().equals("0")) {
				// request vacation
			} else {
				//Get New Dept Code
//				int docNoID = getNewDeptCodeDocNoId(vMemTypeId ,vMemLvlTo );
//				logger.debug("DocNoID::::" + docNoID );
//
//				EgovMap  qryDocNo = memberEventMapper.getDocNoes(docNoID);
////				Map<String,Object> mapQryDocNo = (Map<String,Object>)qryDocNo.get(0);
//				logger.debug("qryDocNo:::: : {}" + qryDocNo );
//
//                String vDocNo = qryDocNo.get("docNo").toString();
//                String vDocNoPrefix = qryDocNo.get("docNoPrefix").toString();
//
//                newDeptCode1 = vDocNoPrefix + vDocNo;
//                logger.debug("DocNoID::::" + newDeptCode1 );
//
//                nextDocNo = getNextDocNo(vDocNoPrefix, vDocNo);
//                logger.debug("nextDocNo : {}",nextDocNo);
//
//
//                if(qryDocNo.size()>0){
//                	vDocNo = nextDocNo;
//                	qryDocNo.put("docNo", nextDocNo);
//                	qryDocNo.put("docNoID", docNoID);
//                	memberEventMapper.updateDocNoes(qryDocNo);
//                }
			}

			//MemberOrganization
//			EgovMap mQryMemOrg     = memberEventMapper.getMemberOrganizationsMemId(formList.get("memId").toString());
//            EgovMap mQryMemUpOrg = memberEventMapper.getMemberOrganizationsMemUpId(mQryMemOrg.get("memUpId").toString());
//            EgovMap mQryMemPrOrg  = memberEventMapper.getMemberOrganizationsMemPrId(formList.get("prMemId").toString());

//            logger.debug("mQryMemOrg : {}",mQryMemOrg);
//            logger.debug("mQryMemUpOrg : {}",mQryMemUpOrg);
//            logger.debug("mQryMemPrOrg : {}",mQryMemPrOrg);

//            String prevDeptCode = mQryMemOrg.get("deptCode").toString();
//            String prevMemberUpID;
//            String prevMemberLvl;

//			if (mQryMemOrg.get("memUpId").toString() != null)
//				prevMemberUpID = mQryMemOrg.get("memUpId").toString();
//			else
//				prevMemberUpID = "0";
//
//			if (mQryMemOrg.get("memLvl").toString() != null)
//				prevMemberLvl = mQryMemOrg.get("memLvl").toString();
//			else
//				prevMemberLvl = "0";
			//화면에서 memId가져와서 넣어줘야함
			EgovMap deptCode = memberEventMapper.selectDeptCode(Integer.parseInt(params.get("promoId").toString()));
			int memberUpId = 0;
			//memberUpId = memberEventMapper.selectMemUpId(mQryMemUpOrg.get("deptCode").toString());
			logger.debug("deptCode : {}", deptCode);
			Map<String, Object> mMemOrg = new HashMap<String, Object>();
//			mQryMemOrg.put("prevDeptCode", prevDeptCode);
//			mQryMemOrg.put("prevMemIdId", prevMemberUpID);
//			mQryMemOrg.put("prevMemLvl", prevMemberLvl);
//			mQryMemOrg.put("prevGrpCode", mQryMemPrOrg.get("deptCode"));
//			mQryMemOrg.put("deptCode", deptCode.get("lastDeptCode"));
			//mQryMemOrg.put("memUpId", memberUpId);
//			mQryMemOrg.put("memUpId", mQryMemUpOrg.get("memUpId"));
//			mQryMemOrg.put("memLvlTo", formList.get("memLvlTo"));
//			mMemOrg.put("orgUpdDt", sysdate);
//			mQryMemOrg.put("orgUpdUserId", formList.get("orgUpdUserId"));
//			mQryMemOrg.put("prCode", "");
//			mQryMemOrg.put("prMemId", 0);
//			mQryMemOrg.put("grandPrCode", mQryMemPrOrg.get("prCode"));
//			mQryMemOrg.put("grandPrMemId", mQryMemPrOrg.get("prMemId"));
//			mQryMemOrg.put("brnchId", deptCode.get("brnchId")  != null ? deptCode.get("brnchId") :0);

//			mQryMemOrg.put("lastDeptCode", deptCode.get("lastDeptCode"));
//			mQryMemOrg.put("lastGrpCode", deptCode.get("lastGrpCode"));
//			mQryMemOrg.put("lastOrgCode", deptCode.get("lastOrgCode"));


			//2017 -11 -20    hgham edit   전위원 요청 배치로 변경 한다고 함. (업데이트도 오류 있음.)
			//memberEventMapper.updateMemberOrganizations(mQryMemOrg);

			Map<String, Object> updateValue = new HashMap<String, Object>(); // ORG0001D BRNCH_ID UPDATE
			updateValue.put("brnchId", deptCode.get("brnchId"));
			updateValue.put("memId", params.get("memId"));
//			memberEventMapper.updateMemberBranch(updateValue);



            //Member
			EgovMap mQryMember    = memberEventMapper.getMemberSearch(formList.get("memId").toString());
//			mQryMember.put("promoDt", sysdate);
//			mQryMember.put("stusId", sysdate);
			mQryMember.put("memId", formList.get("memId").toString());
			mQryMember.put("orgUpdUserId", formList.get("orgUpdUserId"));
			mQryMember.put("syncChk", false);

			memberEventMapper.updateMember(mQryMember);


			logger.debug("formList::::" + formList );
            //MemberPromoEntry
			Map<String, Object> mPromoEntry = new HashMap<String, Object>();
			mPromoEntry.put("stusId", params.get("confirmStatus"));
			mPromoEntry.put("deptCode", formList.get("deptCodeTo"));
			mPromoEntry.put("updDt", formList.get("updDt"));
			mPromoEntry.put("updUserId", formList.get("updUserId"));
			mPromoEntry.put("promoId", params.get("promoId"));
			mPromoEntry.put("branchId", params.get("branchId"));
			mPromoEntry.put("evtApplyDate", CommonUtils.isEmpty(params.get("evtApplyDate")) ? null : params.get("evtApplyDate"));

			logger.debug("mPromoEntry::::" + mPromoEntry);
            memberEventMapper.updateMemberPromoEntry(mPromoEntry);

            success = true;
		}
		return success;
	}






	public String getNextDocNo(String prefixNo, String docNo) {
		String nextDocNo = "";
		int docNoLength = 0;
		if (prefixNo != null && prefixNo != "") {
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		} else {
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0" + docNoLength + "d", nextNo);

		return nextDocNo;
	}



	public int getNewDeptCodeDocNoId (String memberTypeID, String level) {

		int DocNoID = 0;

        if (memberTypeID.equals("1")) {
            if (level.equals("1"))
                DocNoID = 160; //HP org code  old ID:62
            else if (level.equals("2"))
                DocNoID = 161; //HP group code old ID:61
            else if (level.equals("3"))
                DocNoID = 162; //HP dept Code old ID:60
        }else if (memberTypeID.equals("2")) {
            if (level.equals("1"))
                DocNoID = 65;
            else if (level.equals("2"))
                DocNoID = 64;
            else if (level.equals("3"))
                DocNoID = 63;
        }else if (memberTypeID.equals("3")){
            if (level.equals("1"))
                DocNoID = 103;
            else if (level.equals("2"))
                DocNoID = 104;
            else if (level.equals("3"))
                DocNoID = 105;
        }else if (memberTypeID.equals("7")){ // HOMECARE -- ADDED BY TOMMY
            if (level.equals("1"))
                DocNoID = 166; // HOMECARE ORG CODE
            else if (level.equals("2"))
                DocNoID = 165; // HOMECARE GROUP CODE
            else if (level.equals("3"))
                DocNoID = 164; // HOMECARE DEPT CODE
        }else if (memberTypeID.equals("5758")){ // HOMECARE DELIVERY TECHNICIAN -- ADDED BY TOMMY
          if (level.equals("1"))
            DocNoID = 172; // HOMECARE DELIVERY TECHNICIAN ORG CODE
        else if (level.equals("2"))
            DocNoID = 173; // HOMECARE DELIVERY TECHNICIAN GROUP CODE
        else if (level.equals("3"))
            DocNoID = 174; // HOMECARE DELIVERY TECHNICIAN DEPT CODE
    }

		return DocNoID;
	}


	public EgovMap getAvailableChild(Map<String, Object> params) {
		return memberEventMapper.getAvailableChild(params);
	}

}
