package com.coway.trust.biz.organization.organization.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.GuardianOfComplianceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.ComplianceCallLogController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("guardianOfComplianceService")
public class GuardianOfComplianceServiceImpl extends EgovAbstractServiceImpl implements GuardianOfComplianceService{
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);
	@Resource(name = "guardianOfComplianceMapper")
	GuardianOfComplianceMapper guardianOfComplianceMapper;
	@Resource(name = "memberListMapper")
	MemberListMapper memberListMapper;

	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianofComplianceList(params);
	}

	@Override
	public List<EgovMap> selectGuardianofComplianceListCodyHP(Map<String, Object> params, SessionVO sessionVo) {
		params.put("userID", sessionVo.getUserId());
		return guardianOfComplianceMapper.selectGuardianofComplianceListCodyHP(params);
	}

	@Override
	public List<EgovMap> selectGuardianofComplianceListSearch(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianofComplianceListSearch(params);
	}

	@Override
	public EgovMap  saveGuardian(Map<String, Object> params, SessionVO sessionVo) {

		EgovMap saveView = new EgovMap();

		EgovMap caseNo = null; // 각가 docNo, docNoId, prefix구함
		String nextDocNo= "";
		String guardianNo = "";
		int ID = 0;

		caseNo = getDocNoExpand("2");
		guardianNo = caseNo.get("docNo").toString();
		String complianceNo = "";
		params.put("guardianNo", guardianNo);
		ID=2;
		nextDocNo = getNextDocNo("PRZ",caseNo.get("docNo").toString());
		logger.debug("nextDocNo : {}",nextDocNo);
		caseNo.put("nextDocNo", nextDocNo);
		guardianOfComplianceMapper.updateDocNo(caseNo);

		params.put("guardianNo",guardianNo);
		params.put("guardianCaseCategory",params.get("caseCategory1") != null && params.get("caseCategory1") !=""  ? Integer.parseInt(params.get("caseCategory1").toString()) : 0 );
		params.put("guardianSubCaseCategory",params.get("caseCategory2") != null && params.get("caseCategory2") !=""  ? Integer.parseInt(params.get("caseCategory2").toString()) : 0 );
		//params.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
		params.put("complaintDate", params.get("reqstRefDt").toString());
		/*params.put("orderId", Integer.parseInt(params.get("searchOrderId").toString()));*/
		params.put("orderId", params.get("searchOrderId") != null && params.get("searchOrderId") !=""  ?  Integer.parseInt(params.get("searchOrderId").toString()) : 0 );
		if("".equals(params.get("memberId").toString())) {
		    params.put("memberId", params.get("memberId"));
		    params.put("memTypeId", 0);
		} else {
		    params.put("memberId", Integer.parseInt(params.get("memberId").toString()));
		    params.put("memTypeId", Integer.parseInt(params.get("memTypeId").toString()));
		}
		params.put("ActionId", params.get("action") != null && params.get("action") !=""  ? Integer.parseInt(params.get("action").toString()) : 0 );
		params.put("complaintRemark", params.get("complianceRem").toString());
		params.put("reqstCrtUserId", sessionVo.getUserId());
		params.put("reqstUpdUserId", sessionVo.getUserId());
		params.put("hidFileName", params.get("hidFileName").toString());
		params.put("groupId", Integer.parseInt(params.get("groupId").toString()));

		guardianOfComplianceMapper.saveGuardian(params);

        Map<String, Object> guar_sub =new HashMap<String, Object>();

        guar_sub.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
        guar_sub.put("guardianStatusId","1");
        guar_sub.put("guardianRemark",params.get("complianceRem").toString());
        guar_sub.put("guardianCaseCategory",params.get("guardianCaseCategory") != null && params.get("guardianCaseCategory") !=""  ? Integer.parseInt(params.get("guardianCaseCategory").toString()) : 0 );
        guar_sub.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
		guar_sub.put("guardianCreateBy", sessionVo.getUserId());
		guar_sub.put("guardianUpdatedBy", sessionVo.getUserId());
		guar_sub.put("fileId", params.get("fileId") != null && params.get("fileId") !=""  ? Integer.parseInt(params.get("fileId").toString()) : 0);
		guar_sub.put("guardianAction", params.get("cmbactionStatus") != null && !params.get("cmbactionStatus").toString().isEmpty() ? params.get("cmbactionStatus").toString() : null);
		guar_sub.put("guardianEyeward", params.get("cmbeyeward") != null && !params.get("cmbeyeward").toString().isEmpty() ? params.get("cmbeyeward").toString() : null);
		guar_sub.put("guardianApprovalCode", null);
		guar_sub.put("guardianApprovalStatusId", null);


		 //insert
		guardianOfComplianceMapper.insertGuarSub(guar_sub); //Insert to MSC0044M

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
		if("".equals(params.get("memberId").toString())) {
		    com.put("memberId",0);
		} else {
		    com.put("memberId", Integer.parseInt(params.get("memberId").toString()));
		}
		com.put("complianceStatusId", 1);
		com.put("complianceCreatAt", "");
		com.put("complianceCreateBy", sessionVo.getUserId());
		com.put("complianceUpdateAt", "");
		com.put("complianceUpdateBy", sessionVo.getUserId());
		 //insert
		guardianOfComplianceMapper.insertCom(com); //INSERT TO MSC0005D

		int complianceId = guardianOfComplianceMapper.selectComplianceId();


    	Map<String, Object> co = new HashMap<String, Object>();
    	co.put("complianceId", complianceId);
    	co.put("complianceSOID", Integer.parseInt(params.get("orderId").toString()));
    	co.put("complianceStatusId", 1);
    	co.put("complianceRemark", "");

    	guardianOfComplianceMapper.insertComplianceOrder(co); //INSERT TO MSC0006D


		Map<String, Object> com_sub =new HashMap<String, Object>();

		//String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
		logger.debug("PARAMS111 : {}",params.get("complianceRem").toString());
		com_sub.put("complianceItemId", 0);
		com_sub.put("complianceId", complianceId);
		com_sub.put("complianceSOID", null);
		com_sub.put("complianceStatusId", 1 );
		com_sub.put("complianceActionId", 0 );
		com_sub.put("complianceFollowUpId", 0 );
		com_sub.put("complianceReceivedDate", params.get("reqstRefDt").toString());
		com_sub.put("complianceClosedDate", null );
		com_sub.put("complianceRemark", params.get("complianceRem").toString());
		com_sub.put("complianceCaseCategory", params.get("guardianCaseCategory") != null && params.get("guardianCaseCategory") !=""  ? Integer.parseInt(params.get("guardianCaseCategory").toString()) : 0 );
		com_sub.put("complianceDocType", 0 );
		com_sub.put("complianceFinding", 0);
		com_sub.put("complianceCollectAmt", 0);
		com_sub.put("complianceFinalAction",  0 );
		com_sub.put("complianceHasAttachment", true);
		com_sub.put("complianceAttachmentFilename", params.get("hidFileName").toString());
		com_sub.put("complianceCreateAt", "");
		com_sub.put("complianceCreateBy", sessionVo.getUserId());
		com_sub.put("compliancePersonInCharge", params.get("reqstCrtUserId") != "" && params.get("reqstCrtUserId") != null ? Integer.parseInt(params.get("reqstCrtUserId").toString()) : 0);
		com_sub.put("complianceGroupId", Integer.parseInt(params.get("groupId").toString()));
		//insert
		guardianOfComplianceMapper.insertComSub(com_sub);//INSERT TO MSC0007D

		saveView.put("success", true);
		//saveView.put("massage", messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SUCC));

		return saveView;
	}

	@Override
	public List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectSalesOrdNoInfo(params);
	}

	@Override
	public EgovMap selectGuardianofComplianceInfo(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianofComplianceInfo(params);
	}

	@Override
	public List<EgovMap> selectGuardianRemark(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianRemark(params);
	}

	@Override
	public boolean  saveGuardianCompliance(Map<String, Object> params,SessionVO sessionVo) {

		boolean success = false;
		EgovMap guardian = guardianOfComplianceMapper.selectGuardianNoValue(params);

		if(guardian != null){
    		Map<String, Object> com =new HashMap<String, Object>();

    		com.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
    		com.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
    		com.put("guardianRemark",params.get("complianceContent").toString());
    		com.put("guardianCaseCategory",params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
    		com.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		com.put("guardianCreateBy", sessionVo.getUserId());

    		 //insert
    		guardianOfComplianceMapper.updateGuar(com);

            Map<String, Object> guar_sub =new HashMap<String, Object>();

            guar_sub.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
            guar_sub.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
            guar_sub.put("guardianRemark",params.get("complianceContent").toString());
            guar_sub.put("guardianCaseCategory",params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
            guar_sub.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		guar_sub.put("guardianCreateBy", sessionVo.getUserId());
    		guar_sub.put("guardianUpdatedBy", sessionVo.getUserId());

    		 //insert
    		guardianOfComplianceMapper.insertGuarSub(guar_sub);



    		success = true;
		}
		return success;

	}

	@Override
	public String  insertGuardian(Map<String, Object> params,SessionVO sessionVo) {
		logger.debug("PARAMS111 : {}",params.toString());
		EgovMap caseNo = null; // 각가 docNo, docNoId, prefix구함
		String nextDocNo= "";
		String complianceNo = "";
		int ID = 0;
        EgovMap guardian = guardianOfComplianceMapper.selectGuardianNoValue(params);

		if(guardian != null){
    		Map<String, Object> guar =new HashMap<String, Object>();

    		guar.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
    		guar.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
    		guar.put("guardianRemark",params.get("complianceContent").toString());
    		guar.put("guardianCaseCategory",params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
    		guar.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		//guar.put("guardianCreateBy", sessionVo.getUserId());
    		guar.put("guardianCreateBy", params.get("changePerson") != "" && params.get("changePerson") != null ? Integer.parseInt(params.get("changePerson").toString()) : 0);
    		guar.put("guardianpersonInvolvedId",Integer.parseInt(params.get("personInvolvedId").toString()));
    		guar.put("guardianAction", params.get("cmbactionStatus") != null && !params.get("cmbactionStatus").toString().isEmpty() ? params.get("cmbactionStatus").toString() : null);
    		guar.put("guardianEyeward", params.get("cmbeyeward") != null && !params.get("cmbeyeward").toString().isEmpty() ? params.get("cmbeyeward").toString() : null);
    		if (params.get("memCodeField") != null && !params.get("memCodeField").toString().isEmpty() && (params.get("cmbreqStatus").toString().equals("10") || params.get("cmbreqStatus").toString().equals("36"))) {
    		    guar.put("guardianApprovalCode", params.get("memCodeField").toString());
    		    guar.put("guardianApprovalStatusId", "60");
    		} else {
    		    guar.put("guardianApprovalCode", null);  // You can assign null if condition is not met
    		    guar.put("guardianApprovalStatusId", null);  // You can assign null if condition is not met
    		}

    		//guar.put("fileId", params.get("fileId"));
    		 //insert
    		guardianOfComplianceMapper.updateGuar(guar);//Update MSC0043M


            Map<String, Object> guar_sub =new HashMap<String, Object>();

            guar_sub.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
            guar_sub.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
            guar_sub.put("guardianRemark",params.get("complianceContent").toString());
            guar_sub.put("guardianCaseCategory",params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
            guar_sub.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		guar_sub.put("guardianCreateBy", sessionVo.getUserId());
    		guar_sub.put("guardianUpdatedBy", sessionVo.getUserId());
    		guar_sub.put("fileId", params.get("fileId") != null && params.get("fileId") !=""  ? Integer.parseInt(params.get("fileId").toString()) : 0);
    		guar_sub.put("guardianAction", params.get("cmbactionStatus") != null && !params.get("cmbactionStatus").toString().isEmpty() ? params.get("cmbactionStatus").toString() : null);
    		guar_sub.put("guardianEyeward", params.get("cmbeyeward") != null && !params.get("cmbeyeward").toString().isEmpty() ? params.get("cmbeyeward").toString() : null);
    		if (params.get("memCodeField") != null && !params.get("memCodeField").toString().isEmpty() &&
    		    (params.get("cmbreqStatus").toString().equals("10") || params.get("cmbreqStatus").toString().equals("36"))) {
    		    guar_sub.put("guardianApprovalCode", params.get("memCodeField").toString());
    		    guar_sub.put("guardianApprovalStatusId", "60");
    		} else {
    		    guar_sub.put("guardianApprovalCode", null);  // If condition is not met, assign null
    		    guar_sub.put("guardianApprovalStatusId", null);  // Assign null if condition is not met
    		}

    		 //insert
    		guardianOfComplianceMapper.insertGuarSub(guar_sub); //Insert to MSC0044M

    	if ( params.get("cmbreqStatus").toString().equals("1") || params.get("cmbreqStatus").toString().equals("60")) {
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
    		if("".equals(params.get("memId").toString())) {
    		    com.put("memberId",0);
    		} else {
    		    com.put("memberId", Integer.parseInt(params.get("memId").toString()));
    		}
    		com.put("complianceStatusId", 1);
    		com.put("complianceCreatAt", "");
    		com.put("complianceCreateBy", sessionVo.getUserId());
    		com.put("complianceUpdateAt", "");
    		com.put("complianceUpdateBy", sessionVo.getUserId());
    		 //insert
    		guardianOfComplianceMapper.insertCom(com); //INSERT TO MSC0005D

    		int complianceId = guardianOfComplianceMapper.selectComplianceId();


        	Map<String, Object> co = new HashMap<String, Object>();
        	co.put("complianceId", complianceId);
        	co.put("complianceSOID", Integer.parseInt(params.get("orderId").toString()));
        	co.put("complianceStatusId", 1);
        	co.put("complianceRemark", "");

        	guardianOfComplianceMapper.insertComplianceOrder(co); //INSERT TO MSC0006D


    		Map<String, Object> com_sub =new HashMap<String, Object>();

    		//String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
    		logger.debug("PARAMS111 : {}",params.get("complianceRem").toString());
    		com_sub.put("complianceItemId", 0);
    		com_sub.put("complianceId", complianceId);
    		com_sub.put("complianceSOID", null);
    		com_sub.put("complianceStatusId", 1 );
    		com_sub.put("complianceActionId", params.get("actionId") != null && params.get("actionId") !=""  ? Integer.parseInt(params.get("actionId").toString()) : 0 );
    		com_sub.put("complianceFollowUpId", 0 );
    		com_sub.put("complianceReceivedDate", params.get("custCplntDt").toString());
    		com_sub.put("complianceClosedDate", null );
    		com_sub.put("complianceRemark", params.get("complianceRem").toString());
    		com_sub.put("complianceCaseCategory", params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
    		com_sub.put("complianceDocType", params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		com_sub.put("complianceFinding", 0);
    		com_sub.put("complianceCollectAmt", 0);
    		com_sub.put("complianceFinalAction",  0 );
    		com_sub.put("complianceHasAttachment", true);
    		com_sub.put("complianceAttachmentFilename", params.get("hidFileName").toString());
    		com_sub.put("complianceCreateAt", "");
    		com_sub.put("complianceCreateBy", sessionVo.getUserId());
    		com_sub.put("compliancePersonInCharge", params.get("changePerson") != "" && params.get("changePerson") != null ? Integer.parseInt(params.get("changePerson").toString()) : 0);
    		com_sub.put("complianceGroupId", Integer.parseInt(params.get("groupId").toString()));
    		//insert
    		guardianOfComplianceMapper.insertComSub(com_sub);//INSERT TO MSC0007D
    		}
		}
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

	public EgovMap getDocNoExpand(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = guardianOfComplianceMapper.selectDocNoExpand(docNoId);
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
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectOrderList(params);
	}

	@Override
	public EgovMap selectMemberByMemberIDCode(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return guardianOfComplianceMapper.selectMemberByMemberIDCode(params);
	}

	@Override
	public EgovMap selectAttachDownload(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectAttachDownload(params);
	}

	@Override
	public boolean  updateGuardianCompliance(Map<String, Object> params,SessionVO sessionVo) {

		boolean success = false;
		EgovMap guardian = guardianOfComplianceMapper.selectGuardianNoValue(params);

		if(guardian != null){
    		Map<String, Object> com =new HashMap<String, Object>();

    		com.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
    		com.put("guardianRemark",params.get("complianceRem").toString());
    		com.put("guardianCreateBy", sessionVo.getUserId());

    		 //insert
    		guardianOfComplianceMapper.updateGuarContent(com);


    		success = true;
		}
		return success;

	}

	@Override
	public List<EgovMap> selectReasonCodeList(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectReasonCodeList(params);
	}

	@Override
	public List<EgovMap> getSubCatList(Map<String, Object> params) {
		return guardianOfComplianceMapper.getSubCatList(params);
  }

	@Override
	public String  gocApprove(Map<String, Object> params,SessionVO sessionVo) {
		logger.debug("gocApprove : {}",params.toString());
		EgovMap caseNo = null; // 각가 docNo, docNoId, prefix구함
		String nextDocNo= "";
		String complianceNo = "";
		int ID = 0;
        EgovMap guardian = guardianOfComplianceMapper.selectGuardianNoValue(params);

		if(guardian != null){
    		Map<String, Object> guar =new HashMap<String, Object>();

    		guar.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));

    		 //insert
    		guardianOfComplianceMapper.gocApprove(guar);//Update MSC0043M


            Map<String, Object> guar_sub =new HashMap<String, Object>();

            guar_sub.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
            guar_sub.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
            guar_sub.put("guardianRemark",params.get("complianceContent").toString());
    		guar_sub.put("guardianCreateBy", sessionVo.getUserId());
    		guar_sub.put("guardianUpdatedBy", sessionVo.getUserId());
    		guar_sub.put("fileId", params.get("fileId") != null && params.get("fileId") !=""  ? Integer.parseInt(params.get("fileId").toString()) : 0);
    		guar_sub.put("guardianAction", params.get("cmbactionStatus") != null && !params.get("cmbactionStatus").toString().isEmpty() ? params.get("cmbactionStatus").toString() : null);
    		guar_sub.put("guardianEyeward", params.get("cmbeyeward") != null && !params.get("cmbeyeward").toString().isEmpty() ? params.get("cmbeyeward").toString() : null);
    		guar_sub.put("guardianApprovalCode", params.get("memCodeField").toString());
    		guar_sub.put("guardianApprovalStatusId", "5");


    		 //insert
    		guardianOfComplianceMapper.insertGuarSubApprove(guar_sub); //Insert to MSC0044M


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
		if("".equals(params.get("memId").toString())) {
		    com.put("memberId",0);
		} else {
		    com.put("memberId", Integer.parseInt(params.get("memId").toString()));
		}
		com.put("complianceStatusId", 1);
		com.put("complianceCreatAt", "");
		com.put("complianceCreateBy", sessionVo.getUserId());
		com.put("complianceUpdateAt", "");
		com.put("complianceUpdateBy", sessionVo.getUserId());
		 //insert
		guardianOfComplianceMapper.insertCom(com); //INSERT TO MSC0005D

		int complianceId = guardianOfComplianceMapper.selectComplianceId();


    	Map<String, Object> co = new HashMap<String, Object>();
    	co.put("complianceId", complianceId);
    	co.put("complianceSOID", Integer.parseInt(params.get("orderId").toString()));
    	co.put("complianceStatusId", 1);
    	co.put("complianceRemark", "");

    	guardianOfComplianceMapper.insertComplianceOrder(co); //INSERT TO MSC0006D


		Map<String, Object> com_sub =new HashMap<String, Object>();

		//String NewFilename = "~/WebShare/ComplianceCallLog/ComplianceCallLog/" + complianceNo + ".zip";
		logger.debug("gocApprove : {}",params.get("complianceRem").toString());
		com_sub.put("complianceItemId", 0);
		com_sub.put("complianceId", complianceId);
		com_sub.put("complianceSOID", null);
		com_sub.put("complianceStatusId", 1 );
		com_sub.put("complianceActionId", params.get("actionId") != null && params.get("actionId") !=""  ? Integer.parseInt(params.get("actionId").toString()) : 0 );
		com_sub.put("complianceFollowUpId", 0 );
		com_sub.put("complianceReceivedDate", params.get("custCplntDt").toString());
		com_sub.put("complianceClosedDate", null );
		com_sub.put("complianceRemark", params.get("complianceRem").toString());
		com_sub.put("complianceCaseCategory", params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
		com_sub.put("complianceDocType", params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
		com_sub.put("complianceFinding", 0);
		com_sub.put("complianceCollectAmt", 0);
		com_sub.put("complianceFinalAction",  0 );
		com_sub.put("complianceHasAttachment", true);
		com_sub.put("complianceAttachmentFilename", params.get("hidFileName").toString());
		com_sub.put("complianceCreateAt", "");
		com_sub.put("complianceCreateBy", sessionVo.getUserId());
		com_sub.put("compliancePersonInCharge", params.get("changePerson") != "" && params.get("changePerson") != null ? Integer.parseInt(params.get("changePerson").toString()) : 0);
		com_sub.put("complianceGroupId", Integer.parseInt(params.get("groupId").toString()));
		//insert
		guardianOfComplianceMapper.insertComSub(com_sub);//INSERT TO MSC0007D
		}
		return complianceNo;

	}

	@Override
	public void gocReject(Map<String, Object> params,SessionVO sessionVo) {
		logger.debug("gocReject : {}",params.toString());
		EgovMap caseNo = null; // 각가 docNo, docNoId, prefix구함
		String nextDocNo= "";
		String complianceNo = "";
		int ID = 0;
        EgovMap guardian = guardianOfComplianceMapper.selectGuardianNoValue(params);

		if(guardian != null){
    		Map<String, Object> guar =new HashMap<String, Object>();

    		guar.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));

    		 //insert
    		guardianOfComplianceMapper.gocReject(guar);//Update MSC0043M

            Map<String, Object> guar_sub =new HashMap<String, Object>();

            guar_sub.put("reqstId", Integer.parseInt(params.get("reqstId").toString()));
            guar_sub.put("guardianStatusId",Integer.parseInt(params.get("cmbreqStatus").toString()));
            guar_sub.put("guardianRemark",params.get("complianceContent").toString());
            guar_sub.put("guardianCaseCategory",params.get("caseCategory") != null && params.get("caseCategory") !=""  ? Integer.parseInt(params.get("caseCategory").toString()) : 0 );
            guar_sub.put("guardianCaseDetail",params.get("docType") != null && params.get("docType") !=""  ? Integer.parseInt(params.get("docType").toString()) : 0 );
    		guar_sub.put("guardianCreateBy", sessionVo.getUserId());
    		guar_sub.put("guardianUpdatedBy", sessionVo.getUserId());
    		guar_sub.put("fileId", params.get("fileId") != null && params.get("fileId") !=""  ? Integer.parseInt(params.get("fileId").toString()) : 0);
    		guar_sub.put("guardianAction", params.get("cmbactionStatus") != null && !params.get("cmbactionStatus").toString().isEmpty() ? params.get("cmbactionStatus").toString() : null);
    		guar_sub.put("guardianEyeward", params.get("cmbeyeward") != null && !params.get("cmbeyeward").toString().isEmpty() ? params.get("cmbeyeward").toString() : null);
    		guar_sub.put("guardianApprovalCode", params.get("memCodeField").toString());
    		guar_sub.put("guardianApprovalStatusId", "6");

    		 //insert
    		guardianOfComplianceMapper.insertGuarSub(guar_sub); //Insert to MSC0044M

		}
	}
}
