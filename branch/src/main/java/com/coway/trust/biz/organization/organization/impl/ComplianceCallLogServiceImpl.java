package com.coway.trust.biz.organization.organization.impl;

import java.util.Date;
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
	public EgovMap selectComplianceNoValue(Map<String, Object> params) {
		return complianceCallLogMapper.selectComplianceNoValue(params);
	}

	@Override
	public List<EgovMap> selectOrderDetailComplianceId(Map<String, Object> params) {
		return complianceCallLogMapper.selectOrderDetailComplianceId(params);
	}

	@Override
	public List<EgovMap> selectComplianceRemark(Map<String, Object> params) {
		return complianceCallLogMapper.selectComplianceRemark(params);
	}

	@Override
	public EgovMap selectAttachDownload(Map<String, Object> params) {
		return complianceCallLogMapper.selectAttachDownload(params);
	}

	@Override
	public List<EgovMap> getPicList(Map<String, Object> params) {
		return complianceCallLogMapper.getPicList(params);
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

		//String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
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
		com_sub.put("complianceAttachmentFilename", params.get("hidFileName").toString());
		com_sub.put("complianceCreateAt", "");
		com_sub.put("complianceCreateBy", sessionVo.getUserId());
		com_sub.put("compliancePersonInCharge", params.get("changePerson") != "" && params.get("changePerson") != null ? Integer.parseInt(params.get("changePerson").toString()) : 0);
		com_sub.put("complianceGroupId", params.get("groupId"));

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

	@Override
	public boolean deleteOrderDetail(Map<String, Object> params) {
		boolean success = false;

		EgovMap orderDetail = complianceCallLogMapper.selectOrder(params);
		if(orderDetail != null){
    		Map<String, Object> co =new HashMap<String, Object>();

    		co.put("complianceId", orderDetail.get("cmplncItmId"));
    		co.put("complianceSOID", params.get("orderNo"));
    		co.put("complianceStatusId", 8);

    		complianceCallLogMapper.updateCo(co);
    		success = true;
		}

		return success;
	}

	@Override
	public boolean  insertComplianceOrderDetail(List<Object> gridOrder,Map<String, Object> formList) {

		if(gridOrder != null){
    		if(gridOrder.size() > 0){
    			for(int i=0; i<gridOrder.size(); i++){
    				Map<String, Object> gridOrderDate = (Map<String, Object>) gridOrder.get(i);
    				Map<String, Object> co = new HashMap<String, Object>();
    				co.put("complianceId",formList.get("complianceId"));
    				co.put("complianceSOID", gridOrderDate.get("salesOrdId"));
    				co.put("complianceStatusId", 1);
    				co.put("complianceRemark", null);

    				complianceCallLogMapper.insertComplianceOrder(co);
    			}
    		}
	}
		return true;

	}

	@Override
	public boolean  saveMaintenceCompliance(Map<String, Object> params,SessionVO sessionVo) {

		boolean success = false;
		EgovMap compliance = complianceCallLogMapper.selectComplianceNoValue(params);

		if(compliance != null){
    		Map<String, Object> com =new HashMap<String, Object>();

    		com.put("complianceId", Integer.parseInt(params.get("complianceId").toString()));
    		com.put("complianceStatusId",Integer.parseInt(params.get("caseStatus").toString()));
    		com.put("complianceUpdateAt",new Date());
    		com.put("complianceUpdateBy",sessionVo.getUserId());

    		 //insert
    		complianceCallLogMapper.updateCom(com);



    		Map<String, Object> com_sub =new HashMap<String, Object>();


    		logger.debug("PARAMS111 : {}",params.get("complianceRem").toString());
    		com_sub.put("complianceItemId", 0);
    		com_sub.put("complianceId", Integer.parseInt(params.get("complianceId").toString()));
    		com_sub.put("complianceSOID", null);
    		com_sub.put("complianceStatusId", params.get("caseStatus") != null && params.get("caseStatus") !="" ? Integer.parseInt(params.get("caseStatus").toString()) : 0 );
    		com_sub.put("complianceActionId", params.get("action") != null && params.get("action") != "" ? Integer.parseInt(params.get("action").toString()) : 0 );
    		com_sub.put("complianceFollowUpId", params.get("comfup") != null && params.get("comfup") !=""  ? Integer.parseInt(params.get("comfup").toString()) : 0 );
    		com_sub.put("complianceReceivedDate", params.get("recevCaseDt") != null && params.get("recevCaseDt") !="" ? params.get("recevCaseDt").toString() : null );
    		com_sub.put("complianceClosedDate", params.get("recevCloDt") != null &&params.get("recevCloDt") !="" ? params.get("recevCloDt").toString() : null );
    		com_sub.put("complianceRemark", params.get("complianceRem").toString());
    		com_sub.put("complianceCaseCategory", params.get("caseCategory") != null &&  params.get("caseCategory") != "" ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
    		com_sub.put("complianceDocType", params.get("docType") != null && params.get("docType") != "" ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		com_sub.put("complianceFinding",  params.get("finding")  != null  && params.get("finding").toString() == "1" ? 1 : 0);
    		com_sub.put("complianceCollectAmt", params.get("collAmount") != null && params.get("collAmount") != ""  ? Integer.parseInt(params.get("collAmount").toString()) :0);
    		com_sub.put("complianceFinalAction",  params.get("finalAction") != null &&  params.get("finalAction") !="" ? Integer.parseInt(params.get("finalAction").toString()) : 0 );
    		com_sub.put("complianceHasAttachment", params.get("hidFileName").toString().trim() != "" && params.get("hidFileName").toString().trim() != null ? true : false);
    		com_sub.put("complianceAttachmentFilename", params.get("hidFileName").toString().trim());
    		com_sub.put("complianceCreateAt", "");
    		com_sub.put("complianceCreateBy", sessionVo.getUserId());
    		com_sub.put("compliancePersonInCharge", params.get("changePerson") != "" && params.get("changePerson") != null ? Integer.parseInt(params.get("changePerson").toString()) : 0);

    		//insert
    		complianceCallLogMapper.insertComSub(com_sub);

    		success = true;
		}
		return success;

	}

	@Override
	public boolean  saveOrderMaintence(Map<String, Object> params,SessionVO sessionVo) {

			boolean success = false;
    		Map<String, Object> cs =new HashMap<String, Object>();

    		cs.put("complianceItemId",0);
    		cs.put("complianceSOID",Integer.parseInt(params.get("orderId").toString()));
    		cs.put("complianceActionId", params.get("action") != null && params.get("action") != "" ? Integer.parseInt(params.get("action").toString()) : 0);
    		cs.put("complianceFollowUpId",params.get("comfup") != null && params.get("comfup") !=""  ? Integer.parseInt(params.get("comfup").toString()) : 0 );
    		cs.put("complianceRemark",params.get("complianceRem").toString());
    		cs.put("complianceCreateAt", new Date());
    		cs.put("complianceCreateBy",sessionVo.getUserId());

    		 //insert
    		complianceCallLogMapper.insertComCs(cs);
    		success = true;

		return success;

	}

	@Override
	public boolean  saveOrderMaintenceSync(Map<String, Object> params,SessionVO sessionVo) {

			boolean success = false;
    		Map<String, Object> cs =new HashMap<String, Object>();

    		cs.put("complianceItemId",0);
    		cs.put("complianceSOID",Integer.parseInt(params.get("orderId").toString()));
    		cs.put("complianceActionId", params.get("action") != null && params.get("action") != "" ? Integer.parseInt(params.get("action").toString()) : 0);
    		cs.put("complianceFollowUpId",params.get("comfup") != null && params.get("comfup") !=""  ? Integer.parseInt(params.get("comfup").toString()) : 0 );
    		cs.put("complianceRemark",params.get("complianceRem").toString());
    		cs.put("complianceCreateAt", new Date());
    		cs.put("complianceCreateBy",sessionVo.getUserId());

    		List<EgovMap> qrycclord = complianceCallLogMapper.selectComplianceSOID(params);

    		//insert
    		for(int i = 0; i<qrycclord.size(); i++){
    			cs.put("complianceSOID",qrycclord.get(i).get("cmplncSoId"));
    			complianceCallLogMapper.insertComCs(cs);
    		}
    		success = true;

		return success;

	}



	@Override
	public String insertComplianceReopen(Map<String, Object> params,SessionVO sessionVo) {
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


		Map<String, Object> com_sub =new HashMap<String, Object>();

		//String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
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
		com_sub.put("complianceAttachmentFilename", "");
		com_sub.put("complianceCreateAt", "");
		com_sub.put("complianceCreateBy", sessionVo.getUserId());
		com_sub.put("compliancePersonInCharge", 0);
		com_sub.put("complianceGroupId",params.get("groupId") != "" && params.get("groupId") != null ? Integer.parseInt(params.get("groupId").toString()) : 0 );

		//insert
		complianceCallLogMapper.insertComSub(com_sub);

		return complianceNo;

	}
}
