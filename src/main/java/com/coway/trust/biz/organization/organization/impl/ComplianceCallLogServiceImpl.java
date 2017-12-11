package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.ComplianceCallLogService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.ComplianceCallLogController;
import com.coway.trust.web.organization.organization.MemberListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("complianceCallLogService")
public class ComplianceCallLogServiceImpl extends EgovAbstractServiceImpl implements ComplianceCallLogService{
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);
	@Resource(name = "complianceCallLogMapper")
	ComplianceCallLogMapper complianceCallLogMapper;
	@Resource(name = "memberListMapper")
	MemberListMapper memberListMapper;
	@Override
	public List<EgovMap> selectComplianceLog(Map<String, Object> params) {
		return complianceCallLogMapper.selectComplianceLog(params);
	}
	
	@Override
	public EgovMap getMemberDetail(Map<String, Object> params) {
		return complianceCallLogMapper.getMemberDetail(params);
	}
	
	@Override
	public EgovMap selectCheckOrder(Map<String, Object> params) {
		return complianceCallLogMapper.selectCheckOrder(params);
	}
	
	@Override
	public EgovMap selectComplianceOrderDetail(Map<String, Object> params) {
		return complianceCallLogMapper.selectComplianceOrderDetail(params);
	}
	
	
	@Override
	public String  insertCompliance(Map<String, Object> params,SessionVO sessionVo,List<EgovMap> gridOrder) {
		EgovMap caseNo = null; // 각가 docNo, docNoId, prefix구함 
		String nextDocNo= "";
		String complianceNo = "";
		int ID = 0;
		
		caseNo = getDocNo("148");
		complianceNo = caseNo.get("docNo").toString();
		params.put("complianceNo", complianceNo);
		ID=148;
		nextDocNo = getNextDocNo("CCL",caseNo.get("docNo").toString());
		logger.debug("nextDocNo : {}",nextDocNo);
		caseNo.put("nextDocNo", nextDocNo);
		memberListMapper.updateDocNo(caseNo);
		
		Map<String, Object> com =new HashMap<String, Object>();
		
		com.put("complianceId", 0);
		com.put("complianceNo", complianceNo);
		com.put("memberId", Integer.parseInt(params.get("memberId").toString()));
		com.put("complianceStatusId", params.get("caseStatus") !=null && params.get("caseStatus") !="" ? Integer.parseInt(params.get("caseStatus").toString()) : 1);
		com.put("complianceCreatAt", "");
		com.put("complianceCreateBy", sessionVo.getUserId());
		com.put("complianceUpdateAt", "");
		com.put("complianceUpdateBy", sessionVo.getUserId());
		 //insert
		complianceCallLogMapper.insertCom(com);
		
		int complianceId = complianceCallLogMapper.selectComplianceId();
		
		logger.debug("gridOrder : {}",gridOrder);
		logger.debug("PARAMS : {}",params);
		if(gridOrder != null){
    		if(gridOrder.size() > 0){
    			for(int i=0; i<gridOrder.size(); i++){
    				Map<String, Object> gridOrderDate = (Map<String, Object>) gridOrder.get(i);
    				Map<String, Object> co = new HashMap<String, Object>();
    				co.put("complianceId", complianceId);
    				co.put("complianceSOID", gridOrderDate.get("salesOrdId"));
    				co.put("complianceStatusId", 1);
    				co.put("complianceRemark", "");
    				
    				complianceCallLogMapper.insertComplianceOrder(co);
    			}
    		}
	}
		
		
		Map<String, Object> com_sub =new HashMap<String, Object>();
		
		String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
		logger.debug("PARAMS111 : {}",params.get("complianceRem").toString());
		com_sub.put("complianceItemId", 0);
		com_sub.put("complianceId", complianceId);
		com_sub.put("complianceSOID", null);
		com_sub.put("complianceStatusId", params.get("caseStatus") != null && params.get("caseStatus") !="" ? Integer.parseInt(params.get("caseStatus").toString()) : 0 );
		com_sub.put("complianceActionId", params.get("action") != null && params.get("action") != "" ? Integer.parseInt(params.get("action").toString()) : 0 );
		com_sub.put("complianceFollowUpId", params.get("comfup") != null && params.get("comfup") !=""  ? Integer.parseInt(params.get("comfup").toString()) : 0 );
		com_sub.put("complianceReceivedDate", params.get("recevCaseDt") != null && params.get("recevCaseDt") !="" ? params.get("recevCaseDt").toString() : null );
		com_sub.put("complianceClosedDate", params.get("recevCloDt") != null &&params.get("recevCloDt") !="" ? params.get("recevCloDt").toString() : null );
		com_sub.put("complianceRemark", params.get("complianceRem").toString());
		com_sub.put("complianceCaseCategory", params.get("caseCategory") != null &&  params.get("caseCategory") != "" ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
		com_sub.put("complianceDocType", params.get("docType") != null && params.get("docType") != "" ? Integer.parseInt(params.get("docType").toString()) : 0 );
		com_sub.put("complianceFinding", 0);
		com_sub.put("complianceCollectAmt", 0);
		com_sub.put("complianceFinalAction",  params.get("finalAction") != null &&  params.get("finalAction") !="" ? Integer.parseInt(params.get("finalAction").toString()) : 0 );
		com_sub.put("complianceHasAttachment", true);
		com_sub.put("complianceAttachmentFilename", NewFilename);
		com_sub.put("complianceCreateAt", "");
		com_sub.put("complianceCreateBy", sessionVo.getUserId());
		
		//insert
		complianceCallLogMapper.insertComSub(com_sub);
				
		return complianceNo;
		
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
}
