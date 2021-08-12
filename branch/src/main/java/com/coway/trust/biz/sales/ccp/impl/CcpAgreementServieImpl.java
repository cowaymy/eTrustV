package com.coway.trust.biz.sales.ccp.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpAgreementService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpAgreementService")
public class CcpAgreementServieImpl extends EgovAbstractServiceImpl implements CcpAgreementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementServieImpl.class);

	@Resource(name = "ccpAgreementMapper")
	private CcpAgreementMapper ccpAgreementMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Override
	public List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception {

		if("" != params.get("salesOrdNo") && null != params.get("salesOrdNo")){

			List<String> tempList = null;

			tempList = ccpAgreementMapper.selectItemBatchNofromSalesOrdNo(params);

			if(tempList != null && tempList.size() != 0){

				params.put("exist", "1");
				params.put("getBatchNoList", tempList);

			}else{

				params.put("exist", "0");
			}

		}

		return ccpAgreementMapper.selectContactAgreementList(params);
	}


	@Override
	public EgovMap getOrderId(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.getOrderId(params);
	}

	@Override
	public List<EgovMap> selectAfterServiceJsonList(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectAfterServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectBeforeServiceJsonList(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectBeforeServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectSearchOrderNo(params);
	}


	@Override
	public List<EgovMap> selectSearchMemberCode(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectSearchMemberCode(params);
	}


	@Override
	public EgovMap getMemCodeConfirm(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.getMemCodeConfirm(params);
	}


	@Override
	public List<EgovMap> selectCurierListJsonList() throws Exception {

		return ccpAgreementMapper.selectCurierListJsonList();
	}


	@Override
	public List<EgovMap> selectOrderJsonList(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectOrderJsonList(params);
	}

	@Override
	@Transactional
	public Map<String, Object> insertAgreement(Map<String, Object> params) throws Exception {
		//params.put("userId", sessionVO.getUserId());
		//Gird
		List<Object> grid =  (List<Object>)params.get(AppConstants.AUIGRID_ADD);
		//Form
	    Map<String, Object> formMap = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM);

	    /* ###  Session ###*/
	    formMap.put("userId", params.get("userId"));

		/*#####################  User Roll Id Setting ########################*/
    	EgovMap userRollMap = ccpAgreementMapper.getUserInfo(formMap);

    	int rollId;
    	if(userRollMap == null ){
    		rollId = 0;
    	}else{
    		rollId = (Integer)userRollMap.get("govAgRoleId");
    	}
    	formMap.put("rollId", rollId);

		/* ##################  Document Number Numbering Set Param #####################*/
		//put Code Id = 51
    	formMap.put("docNoId", SalesConstants.AGREEMENT_CODEID	);
    	String docNo = "";
    	docNo = ccpAgreementMapper.getDocNo(formMap); //docNo
    	LOGGER.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    	LOGGER.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!           생성된 DOCNO : " + docNo);
    	LOGGER.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    	formMap.put("docNo", docNo);

		/* ################## insert 1 ##########################*/
		//Send Date
		formMap.put("sendDt", SalesConstants.DEFAULT_DATE);
		//RECIVE DATE
		if(SalesConstants.AGREEMENT_TRUE.equals(formMap.get("consignment"))){
			formMap.put("rcivDt", formMap.get("consignmentReciveDt"));
		}else{
			formMap.put("rcivDt", SalesConstants.DEFAULT_DATE);
		}
		String govAgreeIdSeq = "";
		String govMsgIdSeq = "";
		String govConsignSeq = "";

		String govAgItmIdSeq = "";
		String govCallEntryIdSeq = "";
		String govCallResultIdSeq = "";

		govAgreeIdSeq = ccpAgreementMapper.crtSeqSAL0033D();
		LOGGER.info("____________________________________________________________________________________________________________");
		LOGGER.info("_____________________ 생성 된 AgrId : " + govAgreeIdSeq);
		LOGGER.info("____________________________________________________________________________________________________________");
		formMap.put("govAgreeIdSeq", govAgreeIdSeq);

		LOGGER.info("____________________________________________________________________________________________________________");
		LOGGER.info("_____________________ insert1 전 파라미터 확인 :  AgrId = " + formMap.get("govAgreeIdSeq"));
		LOGGER.info("____________________________________________________________________________________________________________");
		ccpAgreementMapper.insertGovAgreementInfo(formMap);
		LOGGER.info("######################################################");
		LOGGER.info("################### Insert 1 Complete ###################");
		LOGGER.info("######################################################");

		/* ##################   insert 2 ######################*/

		govMsgIdSeq = ccpAgreementMapper.crtSeqSAL0036D();
		formMap.put("govMsgIdSeq", govMsgIdSeq);
		LOGGER.info("____________________________________________________________________________________________________________");
		LOGGER.info("_____________________ 생성 된 msgId : " + govMsgIdSeq);
		LOGGER.info("____________________________________________________________________________________________________________");

		LOGGER.info("____________________________________________________________________________________________________________");
		LOGGER.info("_____________________ insert2 전 파라미터 확인 :  AgrId = " + formMap.get("govAgreeIdSeq") + " , msgId = " + formMap.get("govMsgIdSeq"));
		LOGGER.info("____________________________________________________________________________________________________________");
		ccpAgreementMapper.insertGovAgreementMessLog(formMap);
		LOGGER.info("######################################################");
		LOGGER.info("################### Insert 2 Complete ###################");
		LOGGER.info("######################################################");


		if(SalesConstants.AGREEMENT_TRUE.equals(formMap.get("consignment"))){

			govConsignSeq = ccpAgreementMapper.crtSeqSAL0035D();

			formMap.put("govConsignSeq", govConsignSeq);
			formMap.put("agCnsgnSendDt", SalesConstants.DEFAULT_DATE);
			if(SalesConstants.CONSIGNMENT_HAND.equals(formMap.get("inputCourier"))){
				formMap.put("consignBtHand", '1');
			}else{
				formMap.put("consignBtHand", '0');
			}

			ccpAgreementMapper.insertConsignment(formMap);

			LOGGER.info("######################################################");
			LOGGER.info("################### Consignment Complete ###################");
			LOGGER.info("######################################################");

		}

		/*################# Grid Insert( Insert 3, 4, 5) , Update 1 #######################*/
		for (int idx = 0; idx < grid.size(); idx++) {

			Map<String, Object> insMap = (Map<String, Object>)grid.get(idx);

			//Param Setting
			insMap.put("userId", params.get("userId"));
			insMap.put("inputPeriodStart", formMap.get("inputPeriodStart"));
			insMap.put("inputPeriodEnd", formMap.get("inputPeriodEnd"));
			insMap.put("docNo",  docNo);
			insMap.put("agreementAgmRemark", formMap.get("agreementAgmRemark"));

			govAgItmIdSeq = ccpAgreementMapper.crtSeqSAL0034D();
			insMap.put("govAgItmIdSeq", govAgItmIdSeq);
			insMap.put("govAgreeIdSeq", govAgreeIdSeq);
			//SUB

			LOGGER.info("____________________________________________________________________________________________________________");
			LOGGER.info("___________________________ insMap 에 들어있는 AgrId : " + insMap.get("govAgreeIdSeq"));
			LOGGER.info("____________________________________________________________________________________________________________");

			ccpAgreementMapper.insertGovAgreementSub(insMap);

			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(AgreementSub) ###################");
			LOGGER.info("######################################################");

			//CALL ENTRY

			govCallEntryIdSeq = ccpAgreementMapper.crtSeqCCR0006D();
			insMap.put("govCallEntryIdSeq", govCallEntryIdSeq);
			ccpAgreementMapper.insertCallEntry(insMap); //result ID

			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(Call Entry) ###################");
			LOGGER.info("######################################################");

			//CALL RESULT

			govCallResultIdSeq = ccpAgreementMapper.crtSeqCCR0007D();
			insMap.put("govCallResultIdSeq", govCallResultIdSeq);
			ccpAgreementMapper.insertCallResult(insMap); //CallResultID;

			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(Call Result) ###################");
			LOGGER.info("######################################################");

			//Update Result Id
			ccpAgreementMapper.updateResultId(insMap);

			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Update Complete(Call Result) ###################");
			LOGGER.info("######################################################");

		}
		LOGGER.info("######################################################");
		LOGGER.info("###################  Insert 3, 4, 5 Complete Update 1 Complete ###################");
		LOGGER.info("######################################################");


		/*################# UPDATE 2 #######################*/
		ccpAgreementMapper.updatePreUpdUserId(formMap);


		//Return

		Map<String, Object> returnMap = new HashMap<String, Object>();

		returnMap.put("msgId", govMsgIdSeq);
		returnMap.put("docNo", docNo);

		LOGGER.info("####################### Return Map : " + returnMap.toString());


		return returnMap;
	}


	@Override
	public boolean sendSuccessEmail(Map<String, Object> params) throws Exception {

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		toList.add("nurul@coway.com.my");
		toList.add("amira.crt@coway.com.my");

		String subject = "Agreement No (" + params.get("docNo") + ") - Closed With Status Approved ";
		String content = "Please to inform you that Agreement No (" + params.get("docNo") + ") has been closed with status active by [" + params.get("fullName") + "] on " + getCurTime()  + ".<br />" +
                "Please check in web system for more details.<br /><br/>" +
                "Please do not reply this email.<br />" +
                "Thank you.";

		email.setTo(toList);
		email.setHtml(true);
		email.setSubject(subject);
		email.setText(content);

		boolean isSuccess = adaptorService.sendEmail(email, false);

		return isSuccess;
	}


	@Override
	public EgovMap selectAgreementInfo(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectAgreementInfo(params);
	}


	@Override
	public List<EgovMap> getMessageStatusCode(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.getMessageStatusCode(params);
	}


	@Override
	public List<EgovMap> selectConsignmentLogAjax(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectConsignmentLogAjax(params);
	}


	@Override
	public List<EgovMap> selectMessageLogAjax(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectMessageLogAjax(params);
	}


	@Override
	public List<EgovMap> selectContactOrdersAjax(Map<String, Object> params) throws Exception {

		return ccpAgreementMapper.selectContactOrdersAjax(params);
	}



	/* 전체 Save*/
	@Override
	@Transactional
	public Map<String, Object> updateAgreementMtcEdit(Map<String, Object> params) throws Exception {
		LOGGER.info("################ UPDATE 에서 파라미터를 확인 해 보자 ############################");
		LOGGER.info("##################################################################");
		LOGGER.info("Params : " + params.toString());
		LOGGER.info("##################################################################");
		// updAgrId == Agreement Id ,  updPrgId == Progress Hidden Id ,  updMsgStatus == messageStatus Id

		/*int AgreementID = int.Parse(Request["AGRID"].ToString());-------------------------------------------세팅 끝
        string AgrMessage = this.txtRemark.Text.Replace("'", "''"); -------------------------------------------세팅 끝
        int AgrProgressID = int.Parse(this.hidAgrProgressID.Value); -------------------------------------------세팅 끝
        int AgrMessageStatusID = int.Parse(this.cmbStatus.SelectedValue); -------------------------------------------세팅 끝

        int? AgrResultProgressID = module.GetProgressStatus(AgreementID, AgrProgressID, AgrMessageStatusID); ----- 아래 로직으로 가져오기
        bool HasNotification = bool.Parse(this.ddlNotification.SelectedValue); -------------------------------------------세팅 끝
        int NoticeMonth = int.Parse(this.ddlNoticeMonth.SelectedValue);*/ //-------------------------------------------세팅 끝

		//Params : {updAgrId=3988, updPrgId=7, hiddenUpdMsgStatus=10, pudAgrNo=AGM0002915, updMsgStatus=10, updIsNotification=true, updNotificationMonth=2, updResultRemark=FDGDSDSFGF, userId=184}


		//1 . ProgressStatus 를 가져오기
		// Not Equal '10'
		EgovMap statusMap = null;
		Map<String, Object> returnMap = new HashMap<String, Object>();
		int resultPrg = 0;
		String msgLogSeq = "";

		int getPrgId = Integer.parseInt((String)params.get("updPrgId"));
		int getupdMsgStatus = Integer.parseInt((String)params.get("updMsgStatus"));
		LOGGER.info("_______________________________________________ getPrgId : " + getPrgId);
		LOGGER.info("_______________________________________________ getupdMsgStatus : " + getupdMsgStatus);

		if (params.get("erlTerNonCrisisChk") != null && "on".equals(params.get("erlTerNonCrisisChk"))){
			params.put("erlTerNonCrisisChk", 1);
    	} else {
    		params.put("erlTerNonCrisisChk", 0);
    	}

		if(getPrgId != 10){

			if(getupdMsgStatus == 5){
				LOGGER.info("__________________________________   (resultPrg 구하기 )  getPrgId != 10 && getupdMsgStatus == 5 ");
				params.put("ordByNext", "1");
				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result

				resultPrg = ((BigDecimal)statusMap.get("govAgStepNext")).intValue();

			}else if(getupdMsgStatus == 6){
				LOGGER.info("__________________________________    (resultPrg 구하기 )  getPrgId != 10 && getupdMsgStatus == 6 ");
				params.put("ordByPre", "1");
				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
				resultPrg = ((BigDecimal)statusMap.get("govAgStepPrev")).intValue();

			}else if(getupdMsgStatus == 44){
				LOGGER.info("__________________________________    (resultPrg 구하기 )  getPrgId != 10 && getupdMsgStatus == 44 ");
				params.put("ordByStep", "1");
				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
				resultPrg = ((BigDecimal)statusMap.get("govAgStepId")).intValue();

			}else{
				LOGGER.info("__________________________________    (resultPrg 구하기 )  getPrgId != 10 && else ");
				params.put("ordByStepSeqNo", "1");
				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
				resultPrg = ((BigDecimal)statusMap.get("govAgStepSeqNo")).intValue();
			}
		}else{

        			if(getupdMsgStatus == 5){
        				LOGGER.info("__________________________________    (resultPrg 구하기 )  getPrgId == 10 && getupdMsgStatus == 5  ");
        				params.put("ordByStepSeqNo", "1");
        				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
        				resultPrg = ((BigDecimal)statusMap.get("govAgStepSeqNo")).intValue();

        			}else if(getupdMsgStatus == 6){
        				LOGGER.info("__________________________________   (resultPrg 구하기 )   getPrgId == 10 && getupdMsgStatus == 6  ");
        				params.put("ordByPre", "1");
        				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
        				resultPrg = ((BigDecimal)statusMap.get("govAgStepPrev")).intValue();

        			}else{
        				LOGGER.info("__________________________________   (resultPrg 구하기 )   getPrgId == 10 && else  ");
        				params.put("ordByStep", "1");
        				statusMap = ccpAgreementMapper.selectProgressStatus(params); //Progress Result
        				resultPrg = ((BigDecimal)statusMap.get("govAgStepId")).intValue();
        			}

		}// params Set End (AgrResultPrgId)
		LOGGER.info("__________________________________ 가져온 resultPrg : " + resultPrg);

		/*##################     Update  Start ##################################*/

		//Params Set ( 1. Message Log // 2. Agreement)
		// 1. 공통 파라미터 세팅
		if(params.get("updIsNotification").equals("true")){ //Notification
			LOGGER.info("__________________________________ updIsNotification 는  true 이므로 1로 세팅됨 쿼리에서 미사용");
			params.put("updIsNotification", "1");
		}else{
			LOGGER.info("__________________________________ updIsNotification 는  false 이므로 0으로 세팅됨 쿼리에서 미사용");
			params.put("updIsNotification", "0");
		}
		if(params.get("updAgrType") == null || "".equals(params.get("updAgrType"))){
			params.put("updAgrType", "949");
		}
		params.put("govAgrPreUpdator", "0"); // PreUpdator
		params.put("govAgrPrgId", resultPrg); // Agreement Progress Id
		// '10'
		LOGGER.info("__________________________________ getPrgId : " + getPrgId);
		LOGGER.info("__________________________________ getupdMsgStatus : " + getupdMsgStatus);
		if(getPrgId == 10){

			if(getupdMsgStatus == 5){
				LOGGER.info("__________________________________ getPrgId == 10 && getupdMsgStatus == 5");
				params.put("govAgrStatusId", "4");
			}else if(getupdMsgStatus == 44){
				LOGGER.info("__________________________________ getPrgId == 10 && getupdMsgStatus == 44");
				params.put("govAgrStatusId", "1");
			}else{
				LOGGER.info("__________________________________ getPrgId == 10 && else");
				params.put("govAgrStatusId", "1");
			}
		}else if(getPrgId == 7){

			if(getupdMsgStatus == 5){
				LOGGER.info("__________________________________ getPrgId == 7 && getupdMsgStatus == 5");
				params.put("govAgrStatusId", "1");
			}else if(getupdMsgStatus == 10){
				LOGGER.info("__________________________________ getPrgId == 7 && getupdMsgStatus == 10");
				params.put("govAgrStatusId", "10");
			}else if(getupdMsgStatus == 44){
				LOGGER.info("__________________________________ getPrgId == 7 && getupdMsgStatus == 44");
				params.put("govAgrStatusId", "1");
			}else{
				LOGGER.info("__________________________________ getPrgId == 7 && else");
				params.put("govAgrStatusId", "8");
			}
		}else if(getPrgId == 9){

			if(getupdMsgStatus == 5){
				LOGGER.info("__________________________________ getPrgId == 9 && getupdMsgStatus == 5");
				params.put("govAgrStatusId", "1");
				params.put("updIsNotification", "1");
				params.put("updNotificationMonth", "1");
			}else if(getupdMsgStatus == 44){
				LOGGER.info("__________________________________ getPrgId == 9 && getupdMsgStatus == 44");
				params.put("govAgrStatusId", "1");
				params.put("updIsNotification", "1");
				params.put("updNotificationMonth", "1");
			}else{
				LOGGER.info("__________________________________ getPrgId == 9 && else");
				params.put("govAgrStatusId", "1");
				params.put("updIsNotification", "1");
				params.put("updNotificationMonth", "1");
			}
		}else{
			// Progress ID = 8 - Verifying Progress

			if(getupdMsgStatus == 5){
				LOGGER.info("__________________________________ getPrgId  가  10, 7, 9 아님  && getupdMsgStatus == 5" );
				params.put("govAgrStatusId", "1");

			}else if(getupdMsgStatus == 44){
				LOGGER.info("__________________________________ getPrgId  가  10, 7, 9 아님  && getupdMsgStatus == 44" );
				params.put("govAgrStatusId", "1");
			}else{
				LOGGER.info("__________________________________ getPrgId  가  10, 7, 9 아님  && else" );
				params.put("govAgrStatusId", "1");
			}
		} // if End

		LOGGER.info("################################################################");
		LOGGER.info("######## 최종 Parameter 확인  : " + params.toString());
		LOGGER.info("################################################################");
		//여기서 부터 시작 2017-09-05 일정

		//GEt Sales Order Id LIST
		List<EgovMap> soIdList = null;
		soIdList = ccpAgreementMapper.selectAgmSoIdList(params);
		LOGGER.info("__________________________________ soIdList : " + soIdList.size() );
		// 2 Save 2 Map
    	for (int idx = 0; idx < soIdList.size(); idx++) {

    			Map<String, Object> callLogMap = new HashMap<String, Object>();
    			Map<String, Object> resultMap = new HashMap<String, Object>();

    			//Caller
    			callLogMap.put("salesOrdId", soIdList.get(idx).get("govAgItmSalesOrdId"));
    			callLogMap.put("callerUserId", "0");
    			callLogMap.put("callerReasonId", "0");
    			callLogMap.put("callerRecallDate", SalesConstants.DEFAULT_DATE);
    			callLogMap.put("callerStatusId", "4");
    			callLogMap.put("userId", params.get("userId"));

    			//Call Result
    			resultMap.put("callResultId", "0");
    			resultMap.put("callEntryId", "0");
    			resultMap.put("callStatusId", "1");
    			resultMap.put("callDate", SalesConstants.DEFAULT_DATE);
    			resultMap.put("callActnDt", SalesConstants.DEFAULT_DATE);
    			resultMap.put("callFeedBackId", "0");
    			resultMap.put("callCTId", "0");
    			resultMap.put("callRemark", params.get("updResultRemark"));
    			resultMap.put("userId", params.get("userId"));
    			resultMap.put("callCrtDept", "0");
    			resultMap.put("callHcId", "0");

    			//AmgCallLog Save
    			// year Month SalesOrderId 로 ROS 가져오기
    			EgovMap tempRosMap = null;
    			EgovMap tempEntryMap = null;
    			//First Select
    			tempRosMap = ccpAgreementMapper.getRosCallLog(callLogMap);

    			if(tempRosMap != null){

    				//CURRENT MONTH ROS CALL LOG FOUND
    				tempRosMap.put("callerReasonId", callLogMap.get("callerReasonId"));
    				tempRosMap.put("callRecallDate", callLogMap.get("callerRecallDate"));
    				tempRosMap.put("callStatusId", callLogMap.get("callerStatusId"));

    				//First Update
    				ccpAgreementMapper.updateRosCall(tempRosMap);

    				//Second Select
    				tempEntryMap = ccpAgreementMapper.selectCallEntry(callLogMap);

    				if(tempEntryMap != null){

    					resultMap.put("callEntryId", tempEntryMap.get("callEntryId"));
    					//Insert
    					ccpAgreementMapper.insertEditCallResult(resultMap);
    					//Update
    					//tempEntryMap  ,
    					ccpAgreementMapper.updateEditCallEntry(tempEntryMap);
    				}else{

    					//Null insert
    					ccpAgreementMapper.insertEditCallEntry(callLogMap); //Need salesOrdId

    					tempEntryMap = ccpAgreementMapper.selectCallEntry(callLogMap);

    					resultMap.put("callEntryId", tempEntryMap.get("callEntryId"));
    					//Insert
    					ccpAgreementMapper.insertEditCallResult(resultMap);
    					//Update
    					//tempEntryMap  ,
    					ccpAgreementMapper.updateEditCallEntry(tempEntryMap);

    				}

    			}else{ //tempRosMap  Null
    				//ROS CALL LOG NOT FOUND
    				//Insert
    				ccpAgreementMapper.insertRosCall(callLogMap);

    				//Select
    				tempEntryMap = ccpAgreementMapper.selectCallEntry(callLogMap);

    				if(tempEntryMap != null){

    					//ROS CALLENTRY FOUND
    					resultMap.put("callEntryId", tempEntryMap.get("callEntryId"));
    					//Insert
    					ccpAgreementMapper.insertEditCallResult(resultMap);
    					//Update
    					//tempEntryMap  ,
    					ccpAgreementMapper.updateEditCallEntry(tempEntryMap);

    				}else{

    					//Null insert
    					ccpAgreementMapper.insertEditCallEntry(callLogMap); //Need salesOrdId

    					tempEntryMap = ccpAgreementMapper.selectCallEntry(callLogMap);

    					resultMap.put("callEntryId", tempEntryMap.get("callEntryId"));
    					//Insert
    					ccpAgreementMapper.insertEditCallResult(resultMap);
    					//Update
    					//tempEntryMap  ,
    					ccpAgreementMapper.updateEditCallEntry(tempEntryMap);
    				}

    			}

        }// Loop End

    	//Insert Message << 범인  returnItemID = MessLog.GovAgrMsgID;

    	msgLogSeq = ccpAgreementMapper.crtSeqSAL0036D(); //Seq

    	params.put("msgLogSeq", msgLogSeq);
    	ccpAgreementMapper.insertAgreementMessLog(params);

    	//Agreement List
    	List<EgovMap> editAfList = null;
    	editAfList = ccpAgreementMapper.selectEditAfAgreementList(params);
    	if(editAfList != null && editAfList.size() > 0){

    		Map<String, Object> updParam = new HashMap<String, Object>();

    		updParam.put("govAgrId", editAfList.get(0).get("govAgId")); //where govAgId

    		updParam.put("govAgPreUpdator",  params.get("updAgrId"));
    		updParam.put("govAgrStatusId", params.get("govAgrStatusId"));
    		updParam.put("govAgrProgressId", params.get("govAgrPrgId"));
    		updParam.put("govAgrUpdator", params.get("userId"));

    		if( ("5").equals(String.valueOf(params.get("hiddenUpdMsgStatus"))) || ("44").equals(String.valueOf(params.get("hiddenUpdMsgStatus")))){
    			//sepa Params
    			updParam.put("isChangeDate", "1");

    			updParam.put("govAgrStartDate", params.get("updPeriodStart"));
        		updParam.put("govAgrEndDate", params.get("updPeriodEnd"));
    		}

    		ccpAgreementMapper.updateCcpLatMessageId(updParam);

    	}
    	//TODO  GovAgreement.First().GovAgrPreUpdator = Agreement.GovAgrID;  :: ASIS Source Need Confirm(CCP.cs)
    	//Update
    	//param Set
    	int hidMsgStus = Integer.parseInt((String)params.get("hiddenUpdMsgStatus"));

    	if(hidMsgStus == 5 || hidMsgStus == 44){
    		params.put("changeMsgDate", "1");
    	}
    	ccpAgreementMapper.updateAgreement(params);

    	LOGGER.info("#########################################################################");
    	LOGGER.info("##############Agreement Maintenance Save Success!!!");
    	LOGGER.info("#########################################################################");

    	//Return
    	returnMap.put("msgLogSeq", msgLogSeq);
    	returnMap.put("updPrgId", params.get("updPrgId"));
    	returnMap.put("updMsgStatus", params.get("updMsgStatus"));
    	returnMap.put("pudAgrNo", params.get("pudAgrNo"));

    	return  returnMap;

	}

	/* Consignment Save */
	@Override
	@Transactional
	public void updateNewConsignment(Map<String, Object> params) throws Exception {

		LOGGER.info("#########################################################################");
		LOGGER.info("####### params : " + params.toString());
		LOGGER.info("#########################################################################");

		//Params Set
		if(params.get("updCourier").equals("H")){
			params.put("byHand", 1);
		}

		if(params.get("updCourier").equals("C")){
			params.put("byHand", 0);
		}

		params.put("defaultDate", SalesConstants.DEFAULT_DATE);

		//1. update (Agreement)
		ccpAgreementMapper.updateReceiveDate(params);

		//2.select <<  AgrId 로 가져온   AgrConsignId
		EgovMap consignMap = null;
		consignMap = ccpAgreementMapper.getConsignId(params);
		params.put("agCnsgnId", consignMap.get("agCnsgnId"));

		//3. update << consignment  2번에서 가져온 AgrConsignId 의 IsCurrent 컬럼 0으로 업데이트
		ccpAgreementMapper.updateCurrentStatus(params);

		//4. insert (Final)
		ccpAgreementMapper.insertNewConsign(params);

	}


	@Override
	public boolean sendUpdateEmail(Map<String, Object> params) throws Exception {

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		//params
		String prgId = "";
		String msgStatus = "";
		//subject and contents
		String subject  = "";
		String content = "";
		String agrNo = "";

		prgId = String.valueOf(params.get("updPrgId"));
		msgStatus = String.valueOf(params.get("updMsgStatus"));
		agrNo = String.valueOf(params.get("pudAgrNo"));

		//List
		toList.add("nurul@coway.com.my");

		if(prgId.equals("7")){

			if (msgStatus.equals("5")) {

				subject = "Agreement No (" + agrNo + ") - Closed With Status Approved ";
				content = "Please to inform you that Agreement No (" + agrNo + ") has been closed with status approve by [" + params.get("fullName") + "] on " + getCurTime() + ".<br />" +
                        "Please check in web system for more details.<br /><br/>" +
                        "Please do not reply this email.<br />" +
                        "Thank you.";

			}

		}else if(prgId.equals("8")){

			if(msgStatus.equals("6")){

				subject = "Agreement No (" + agrNo + ") - Closed With Status Rejected ";
				content = "Please to inform you that Agreement No (" + agrNo + ") has been closed with status reject by [" + params.get("fullName") + "] on " + getCurTime() + ".<br />" +
                                  "Please check in web system for more details.<br /><br/>" +
                                  "Please do not reply this email.<br />" +
                                  "Thank you.";

			}else if(msgStatus.equals("5")){

				subject = "Agreement No (" + agrNo + ") - Closed With Status Approved ";
				content = "Please to inform you that Agreement No (" + agrNo + ") has been closed with status approve by [" + params.get("fullName")  + "] on " + getCurTime() + ".<br />" +
	                                   "Please continues process your CCP for scoring .<br /><br/>" +
	                                  "Please check in web system for more details.<br /><br/>" +
	                                  "Please do not reply this email.<br />" +
	                                  "Thank you.";
			}

		}

		email.setTo(toList);
		email.setHtml(false);
		email.setSubject(subject);
		email.setText(content);

		boolean isSuccess = adaptorService.sendEmail(email, false);

		return isSuccess;
	}




	@Override
	public void uploadCcpFile(Map<String, Object> params) throws Exception {

			ccpAgreementMapper.updateCcpAgreementMessageFile(params);
	}


	private String getCurTime(){

		long time = System.currentTimeMillis();

		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

		String str = dayTime.format(new Date(time));

		return str;
	}


}
