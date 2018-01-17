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

import com.coway.trust.biz.organization.organization.TransferService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.TransferController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("transferService")
public class TransferServiceImpl extends EgovAbstractServiceImpl implements TransferService{
	private static final Logger logger = LoggerFactory.getLogger(TransferController.class);

	@Resource(name = "transferMapper")
	private TransferMapper transferMapper;

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;

	@Override
	public List<EgovMap> selectMemberLevel(Map<String, Object> params) {
		return transferMapper.selectMemberLevel(params);
	}
	@Override
	public List<EgovMap> selectFromTransfer(Map<String, Object> params) {
		return transferMapper.selectFromTransfer(params);
	}

	@Override
	public List<EgovMap> selectTransferList(Map<String, Object> params) {
		return transferMapper.selectTransferList(params);
	}

	@Override
	public boolean insertTransferMember(Map<String, Object> params,SessionVO sessionVo) {
		boolean success = false;
		String nextDocNo = "";
		String[] memCode = params.get("selectValue").toString().split(",");
		String transferDate = params.get("transferDate").toString();
		for(int i=0; i< memCode.length; i++){

			EgovMap memberModel = transferMapper.selectMemberModel(memCode[i]);
			logger.debug("memberModel : {}", memberModel);
			int formMemberId = Integer.parseInt(memberModel.get("memberupid1").toString());
			EgovMap parentFrom = transferMapper.selectDepartment(formMemberId);

			int toMemberId = Integer.parseInt(params.get("toTransfer").toString());
			EgovMap parentTo = transferMapper.selectDepartment(formMemberId);

			Map<String, Object> memberPromoEntry = new HashMap<String, Object>();
			EgovMap runningNo = getDocNo("66");

			int level =  Integer.parseInt(memberModel.get("memberlvl1").toString());
			
			//BranchId value
			EgovMap deptCode = transferMapper.selectDeptCode(toMemberId);
			logger.debug("deptCode : {}", deptCode);
			String branchId = transferMapper.selectBranchId(toMemberId);
			memberPromoEntry.put("requestNo", runningNo.get("docNo"));
			nextDocNo = getNextDocNo(runningNo.get("prefix").toString(),runningNo.get("docNo").toString());
			runningNo.put("nextDocNo", nextDocNo);
			memberListMapper.updateDocNo(runningNo);
			memberPromoEntry.put("statusID", 60); // MemberEvent In Progress value
			memberPromoEntry.put("promoTypeId", 749);
			memberPromoEntry.put("memTypeId", memberModel.get("memType"));
			memberPromoEntry.put("memberID", memberModel.get("memId"));
			memberPromoEntry.put("memberLvlFrom", memberModel.get("memberlvl1"));
			memberPromoEntry.put("memberLvlTo", memberModel.get("memberlvl1"));
			memberPromoEntry.put("created", new Date());
			memberPromoEntry.put("creator", sessionVo.getUserId());
			memberPromoEntry.put("updated", new Date());
			memberPromoEntry.put("updator", sessionVo.getUserId());
			memberPromoEntry.put("deptCodeFrom", memberModel.get("deptcode1"));
			if (memberModel.get("memberlvl1").toString().equals("4")) {
				memberPromoEntry.put("deptCodeTo", deptCode.get("deptCode"));
			} else {
				memberPromoEntry.put("deptCodeTo", memberModel.get("deptcode1"));
			}
			memberPromoEntry.put("parentDeptCodeFrom", parentFrom.get("deptCode"));
			memberPromoEntry.put("parentIDFrom", parentFrom.get("memId"));
			if (memberModel.get("memberlvl1").toString().equals("4")) {//////수정가능
				memberPromoEntry.put("parentDeptCodeTo", deptCode.get("deptCode"));
			} else {
//				memberPromoEntry.put("parentDeptCodeTo", parentTo.get("deptCode"));
				memberPromoEntry.put("parentDeptCodeTo", deptCode.get("deptCode"));
			}
//			memberPromoEntry.put("parentDeptCodeTo", parentTo.get("deptCode"));
			memberPromoEntry.put("parentIDTo", deptCode.get("memId"));
			memberPromoEntry.put("statusIDFrom", 1);
			memberPromoEntry.put("statusIDTo", 1);
			memberPromoEntry.put("PRCode", parentFrom.get("deptCode"));
			memberPromoEntry.put("remark", "Member"+ memCode[i] +"group transfer.");
			memberPromoEntry.put("toMemberId", toMemberId);
			memberPromoEntry.put("branchId", branchId);

			if (memberModel.get("memberlvl1").toString().equals("4")) {
				memberPromoEntry.put("lastDeptCode",deptCode.get("deptCode"));
				memberPromoEntry.put("lastGrpCode", deptCode.get("lastGrpCode"));
				memberPromoEntry.put("lastOrgCode", deptCode.get("lastOrgCode"));
			} else if (memberModel.get("memberlvl1").toString().equals("3")) {
				memberPromoEntry.put("lastDeptCode", memberModel.get("deptcode1"));
				memberPromoEntry.put("lastGrpCode", deptCode.get("lastGrpCode"));
				memberPromoEntry.put("lastOrgCode", deptCode.get("lastOrgCode"));
			} else if (memberModel.get("memberlvl1").toString().equals("2")) {
				memberPromoEntry.put("lastGrpCode", memberModel.get("deptcode1"));
				memberPromoEntry.put("lastOrgCode", deptCode.get("lastOrgCode"));
			}
//			memberPromoEntry.put("lastDeptCode",deptCode.get("lastDeptCode") );
//			memberPromoEntry.put("lastGrpCode", deptCode.get("lastGrpCode"));
//			memberPromoEntry.put("lastOrgCode", deptCode.get("lastOrgCode"));
			memberPromoEntry.put("evtApplyDt", transferDate);

			logger.debug("memberPromoEntry : {}",memberPromoEntry);
			String returnPromoId = updatePromoEntry(memberPromoEntry);

			success = true;
		}
		return success;
	}
	@Transactional
	public String updatePromoEntry(Map<String, Object> memberPromoEntry){
		String promoId = "";

		if(memberPromoEntry.get("promoTypeId").toString().equals("749")){
			EgovMap singleDept = transferMapper.selectMemberOrg(Integer.parseInt(memberPromoEntry.get("memberID").toString()));

			singleDept.put("prevDeptCode",singleDept.get("deptCode"));
			singleDept.put("prevMemberUpID",Integer.parseInt(singleDept.get("memUpId").toString()));
			singleDept.put("prevMemberLvl",singleDept.get("memLvl"));

			singleDept.put("prevGroupCode", memberPromoEntry.get("parentDeptCodeFrom"));

			if(Integer.parseInt(memberPromoEntry.get("memberLvlFrom").toString()) == 4){
				singleDept.put("deptCode", memberPromoEntry.get("deptCodeTo"));
			}

			singleDept.put("memberUpID", memberPromoEntry.get("toMemberId"));
			singleDept.put("orgUpdateAt", new Date());
			singleDept.put("orgUpdateBy", memberPromoEntry.get("updator"));

			//Member Organization update
			//transferMapper.updateTransfrrOrganization(singleDept);

		}
		logger.debug("memberPromoEntry : {}",memberPromoEntry);

		//promotion insert
		transferMapper.insertTransferPromoEntry(memberPromoEntry);

		promoId = transferMapper.selectPromoId();
		logger.debug("promoId : {}",promoId);
		return promoId;
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

	@Override
	public String selectBranchId(int codeId) {
		return transferMapper.selectBranchId(codeId);
	}

}
