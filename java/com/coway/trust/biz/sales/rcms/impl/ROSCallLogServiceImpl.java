package com.coway.trust.biz.sales.rcms.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.rcms.ROSCallLogService;
import com.coway.trust.biz.sales.rcms.vo.callerDataVO;
import com.coway.trust.biz.sales.rcms.vo.orderRemDataVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("rosCallLogService")
public class ROSCallLogServiceImpl extends EgovAbstractServiceImpl implements ROSCallLogService{

	private static final Logger LOGGER = LoggerFactory.getLogger(ROSCallLogServiceImpl.class);



	@Resource(name = "rosCallLogMapper")
	private ROSCallLogMapper rosCallLogMapper;

	@Override
	public List<EgovMap> getAppTypeList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getAppTypeList(params);
	}

	@Override
	public List<EgovMap> selectRosCallLogList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.selectRosCallLogList(params);
	}

	@Override
	public EgovMap getRentInstallLatestNo(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getRentInstallLatestNo(params);
	}

	@Override
	public EgovMap getRentalStatus(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getRentalStatus(params);
	}

	@Override
	public List<EgovMap> selectROSSMSCodyTicketLogList(Map<String, Object> params) throws Exception{

		return rosCallLogMapper.selectROSSMSCodyTicketLogList(params);
	}

	@Override
	public List<EgovMap> getReasonCodeList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getReasonCodeList(params);
	}

	@Override
	public List<EgovMap> getFeedbackCodeList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getFeedbackCodeList(params);
	}

	@Override
	public List<EgovMap> selectROSCallLogBillGroupOrderCnt(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.selectROSCallLogBillGroupOrderCnt(params);
	}

	@Override
	public EgovMap getOrderServiceMemberViewByOrderID(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getOrderServiceMemberViewByOrderID(params);
	}

	@Override
	@Transactional
	public boolean insertNewRosCall(Map<String, Object> params) throws Exception {

		//Init
		int feedbackId = 0;
		String defaultDateTime = "";
		defaultDateTime =  SalesConstants.DEFAULT_DATE +" "+ SalesConstants.DEFAULT_TM;
		LOGGER.info("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: defaultDateTime : "+defaultDateTime);
		List<EgovMap> grpList = new ArrayList<EgovMap>();
		grpList = rosCallLogMapper.selectROSCallLogBillGroupOrderCnt(params);
/**##############################################################  CHECK NON AND LIST SIZE EQ 1 ______________________________________________________ **/
		if(Integer.parseInt(String.valueOf(params.get("chkGrp"))) == 0 || grpList.size() == 1 ){ //UNCHECK GROUP

			//FIRST CHECK ROS CALL ROG
			EgovMap currMap = null;
			currMap = rosCallLogMapper.chkCurrRosCall(params);  //Check Ros Call Current Status.....

			if(currMap != null){
				/******	CURRENT MONTH ROS CALL LOG FOUND ******/
				//________________________________________________________________________________________________________ 1. ROS CALL LOG(UPDATE)
				Map<String, Object> oneMap = new HashMap<String, Object>();
				oneMap.put("orderId", currMap.get("salesOrdId"));  //rosCallLogMaster.SalesOrderID = int.Parse(Request["OrderID"].ToString());
				//oneMap.put("rosCallerUserId", SalesConstants.ROS_CALLER_USER_ID);

				if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
					feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
				}
				oneMap.put("rosCallResnId", feedbackId);

				if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
					oneMap.put("rosCallRecallDt", defaultDateTime);
				}else{
					oneMap.put("rosCallRecallDt", params.get("reCallDate"));
				}

				oneMap.put("rosCallStusId", SalesConstants.ROS_CALL_STATUS_ID);
				oneMap.put("userId", params.get("userId"));
				oneMap.put("rosStatus", params.get("rosStatus"));
				oneMap.put("ptpDt", params.get("ptpDate"));

				LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) START ");
				LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) PARAM :  " + oneMap.toString());
				rosCallLogMapper.updateROSCallInfo(oneMap);
				LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) END ");

				//________________________________________________________________________________________________________ 2. CALL RESULT

				int callResultSeq = 0;
				int callEntId = 0;
				int actionId = 0;
				double rosAmt = 0;
				int chkSms = 0;
				String smsRem = "";
				int callEntSeq = 0;

				EgovMap currCallEntMap = null;
				currCallEntMap = rosCallLogMapper.chkCurrCallEntryInfo(params); //Check Call Entry Current Status.....

				if(currCallEntMap != null){
					//________________________________________________________________________________________________________CASE : ROS CALL ENTRY FOUND
					//ROS CALLENTRY FOUND
					//________________________________________________________________________________________________________ 2 - 1 . CALL RESULT INSERT
					Map<String, Object> callEntMap = new HashMap<String, Object>();

					callResultSeq = rosCallLogMapper.getSeqCCR0007D();
					callEntMap.put("callResultSeq", callResultSeq);

					callEntId = Integer.parseInt(String.valueOf(currCallEntMap.get("callEntryId")));
					callEntMap.put("callEntId", callEntId);

					if(params.get("action") != null){
						actionId = Integer.parseInt(String.valueOf(params.get("action")));
					}
					callEntMap.put("callStusId", actionId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
					}else{
						callEntMap.put("callDt", params.get("reCallDtYmd"));
					}

					callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					callEntMap.put("callFdbchId", feedbackId);
					callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
					callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
					callEntMap.put("callCrtUserId", params.get("userId"));
					callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
					callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

					if(params.get("collectAmt") != null){
						rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
					}
					callEntMap.put("callRosAmt", rosAmt);

					if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
					}else{ //CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
						smsRem = String.valueOf(params.get("smsRem"));
					}
					callEntMap.put("callSMS", chkSms);
					callEntMap.put("callSMSRem", smsRem);

					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT START ");
					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
					rosCallLogMapper.insertCallResultInfo(callEntMap);
					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT END ");

					///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//________________________________________________________________________________________________________ 2 - 2 . CALL ENTRY UPDATE
					Map<String, Object> updCallEntMap = new HashMap<String, Object>();
					updCallEntMap.put("resultId", callResultSeq);
					updCallEntMap.put("userId", params.get("userId"));
					updCallEntMap.put("callEntId", callEntId);

					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY START ");
					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
					rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY END ");
				}else{
					//________________________________________________________________________________________________________CASE : ROS CALL ENTRY  NOT FOUND
					//ROS CALLENTRY NOT FOUND
					//________________________________________________________________________________________________________ 2 - 1 . CALL ENTRY INSERT (MAKE CALL ENTRY)
					Map<String, Object> callInsMap = new HashMap<String, Object>();
					callEntSeq = rosCallLogMapper.getSeqCCR0006D();

					callInsMap.put("callEntSeq", callEntSeq);
					callInsMap.put("salesOrdId", params.get("orderId"));
					callInsMap.put("typeId", SalesConstants.ROS_NEW_CALL_ENTRY_TYPE_ID);
					callInsMap.put("stusCodeId", SalesConstants.ROS_NEW_CALL_ENTRY_STATUS_ID);
					callInsMap.put("resultId", SalesConstants.ROS_NEW_CALL_ENTRY_RESULT_ID);
					callInsMap.put("docId", SalesConstants.ROS_NEW_CALL_ENTRY_DOC_ID);
					callInsMap.put("userId", params.get("userId"));
					callInsMap.put("callDt", SalesConstants.DEFAULT_DATE);
					callInsMap.put("isWaitForCancl", SalesConstants.ROS_NEW_CALL_ENTRY_WAIT_CANCEL);
					callInsMap.put("happCallerId", SalesConstants.ROS_NEW_CALL_ENTRY_HAPPY_CALLER_ID);
					callInsMap.put("oriCallDt", SalesConstants.DEFAULT_DATE);

					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT START ");
					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT PARAM :  " + callInsMap.toString());
					rosCallLogMapper.insertCallEntryInfo(callInsMap);
					LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT END ");

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					//________________________________________________________________________________________________________ 2 - 2 . CALL RESULT INSERT
					Map<String, Object> callEntMap = new HashMap<String, Object>();

					callResultSeq = rosCallLogMapper.getSeqCCR0007D();
					callEntMap.put("callResultSeq", callResultSeq);
					callEntMap.put("callEntId", callEntSeq);

					if(params.get("action") != null){
						actionId = Integer.parseInt(String.valueOf(params.get("action")));
					}
					callEntMap.put("callStusId", actionId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
					}else{
						callEntMap.put("callDt", params.get("reCallDtYmd"));
					}

					callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					callEntMap.put("callFdbchId", feedbackId);
					callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
					callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
					callEntMap.put("callCrtUserId", params.get("userId"));
					callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
					callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

					if(params.get("collectAmt") != null){
						rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
					}
					callEntMap.put("callRosAmt", rosAmt);

					if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
					}else{ //CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
						smsRem = String.valueOf(params.get("smsRem"));
					}
					callEntMap.put("callSMS", chkSms);
					callEntMap.put("callSMSRem", smsRem);

					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT START ");
					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
					rosCallLogMapper.insertCallResultInfo(callEntMap);
					LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT END ");


                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//________________________________________________________________________________________________________ 2 - 3 . CALL ENTRY UPDATE
                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
                    updCallEntMap.put("resultId", callResultSeq);
                    updCallEntMap.put("userId", params.get("userId"));
                    updCallEntMap.put("callEntId", callEntId);

                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY START ");
                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY END ");
				}
			}else{
				/******	CURRENT MONTH ROS CALL LOG NOT FOUND ******/
				//____________________________________________________________________________________________________________________________ 1. ROS CALL LOG(INSERT)
				Map<String, Object> oneMap = new HashMap<String, Object>();
				oneMap.put("orderId", params.get("orderId"));  //Sales Ord Id
				oneMap.put("rosCallerUserId", SalesConstants.ROS_CALLER_USER_ID);

				if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
					feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
				}
				oneMap.put("rosCallResnId", feedbackId);

				if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
					oneMap.put("rosCallRecallDt", defaultDateTime);
				}else{
					oneMap.put("rosCallRecallDt", params.get("reCallDate"));
				}

				oneMap.put("rosCallStusId", SalesConstants.ROS_CALL_STATUS_ID);
				oneMap.put("userId", params.get("userId"));
				oneMap.put("rosStatus", params.get("rosStatus"));
				oneMap.put("ptpDt", params.get("ptpDate"));

				LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) START ");
				LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) PARAM :  " + oneMap.toString());
				rosCallLogMapper.insertROSCallInfo(oneMap);
				LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) END ");


				//________________________________________________________________________________________________________ 2. CALL RESULT

				int callResultSeq = 0;
				int callEntId = 0;
				int actionId = 0;
				double rosAmt = 0;
				int chkSms = 0;
				String smsRem = "";
				int callEntSeq = 0;

				EgovMap currCallEntMap = null;
				currCallEntMap = rosCallLogMapper.chkCurrCallEntryInfo(params); //Check Call Entry Current Status.....

				if(currCallEntMap != null){
					//________________________________________________________________________________________________________CASE : ROS CALL ENTRY FOUND
					//ROS CALLENTRY FOUND
					//________________________________________________________________________________________________________ 2 - 1 . CALL RESULT INSERT
					Map<String, Object> callEntMap = new HashMap<String, Object>();

					callResultSeq = rosCallLogMapper.getSeqCCR0007D();
					callEntMap.put("callResultSeq", callResultSeq);

					callEntId = Integer.parseInt(String.valueOf(currCallEntMap.get("callEntryId")));
					callEntMap.put("callEntId", callEntId);

					if(params.get("action") != null){
						actionId = Integer.parseInt(String.valueOf(params.get("action")));
					}
					callEntMap.put("callStusId", actionId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
					}else{
						callEntMap.put("callDt", params.get("reCallDtYmd"));
					}

					callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					callEntMap.put("callFdbchId", feedbackId);
					callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
					callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
					callEntMap.put("callCrtUserId", params.get("userId"));
					callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
					callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

					if(params.get("collectAmt") != null){
						rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
					}
					callEntMap.put("callRosAmt", rosAmt);

					if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
					}else{ //CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
						smsRem = String.valueOf(params.get("smsRem"));
					}
					callEntMap.put("callSMS", chkSms);
					callEntMap.put("callSMSRem", smsRem);

					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT START ");
					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
					rosCallLogMapper.insertCallResultInfo(callEntMap);
					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT END ");

                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    //________________________________________________________________________________________________________ 2 - 2 . CALL ENTRY UPDATE
                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
                    updCallEntMap.put("resultId", callResultSeq);
                    updCallEntMap.put("userId", params.get("userId"));
                    updCallEntMap.put("callEntId", callEntId);

                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY START ");
                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY END ");
				}else{
					//________________________________________________________________________________________________________CASE : ROS CALL ENTRY  NOT FOUND
					//ROS CALLENTRY NOT FOUND
					//________________________________________________________________________________________________________ 2 - 1 . CALL ENTRY INSERT (MAKE CALL ENTRY)
					Map<String, Object> callInsMap = new HashMap<String, Object>();
					callEntSeq = rosCallLogMapper.getSeqCCR0006D();

					callInsMap.put("callEntSeq", callEntSeq);
					callInsMap.put("salesOrdId", params.get("orderId"));
					callInsMap.put("typeId", SalesConstants.ROS_NEW_CALL_ENTRY_TYPE_ID);
					callInsMap.put("stusCodeId", SalesConstants.ROS_NEW_CALL_ENTRY_STATUS_ID);
					callInsMap.put("resultId", SalesConstants.ROS_NEW_CALL_ENTRY_RESULT_ID);
					callInsMap.put("docId", SalesConstants.ROS_NEW_CALL_ENTRY_DOC_ID);
					callInsMap.put("userId", params.get("userId"));
					callInsMap.put("callDt", SalesConstants.DEFAULT_DATE);
					callInsMap.put("isWaitForCancl", SalesConstants.ROS_NEW_CALL_ENTRY_WAIT_CANCEL);
					callInsMap.put("happCallerId", SalesConstants.ROS_NEW_CALL_ENTRY_HAPPY_CALLER_ID);
					callInsMap.put("oriCallDt", SalesConstants.DEFAULT_DATE);

					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT START ");
					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT PARAM :  " + callInsMap.toString());
					rosCallLogMapper.insertCallEntryInfo(callInsMap);
					LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT END ");

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					//________________________________________________________________________________________________________ 2 - 2 . CALL RESULT INSERT
					Map<String, Object> callEntMap = new HashMap<String, Object>();

					callResultSeq = rosCallLogMapper.getSeqCCR0007D();
					callEntMap.put("callResultSeq", callResultSeq);
					callEntMap.put("callEntId", callEntSeq);

					if(params.get("action") != null){
						actionId = Integer.parseInt(String.valueOf(params.get("action")));
					}
					callEntMap.put("callStusId", actionId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
					}else{
						callEntMap.put("callDt", params.get("reCallDtYmd"));
					}

					callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					callEntMap.put("callFdbchId", feedbackId);
					callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
					callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
					callEntMap.put("callCrtUserId", params.get("userId"));
					callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
					callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

					if(params.get("collectAmt") != null){
						rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
					}
					callEntMap.put("callRosAmt", rosAmt);

					if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
					}else{ //CHECK
						chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
						smsRem = String.valueOf(params.get("smsRem"));
					}
					callEntMap.put("callSMS", chkSms);
					callEntMap.put("callSMSRem", smsRem);

					LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT START ");
					LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
					rosCallLogMapper.insertCallResultInfo(callEntMap);
					LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT END ");


                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//________________________________________________________________________________________________________ 2 - 3 . CALL ENTRY UPDATE
                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
                    updCallEntMap.put("resultId", callResultSeq);
                    updCallEntMap.put("userId", params.get("userId"));
                    updCallEntMap.put("callEntId", callEntId);

                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY START ");
                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY END ");
				}
			}
		}else{ //CHECK GROUP AND LIST SIZE MORE THAN 1 OR CHECK GROUP
			//All List Save --grpList
			/**##############################################################  CHECK AND LIST SIZE MORE TAHN 1 ______________________________________________________ **/

			for (int idx = 0; idx < grpList.size(); idx++) {

				//SALES_ORD_ID
				EgovMap ordMap = grpList.get(idx);

				//FIRST CHECK ROS CALL ROG
				EgovMap currMap = null;
				params.put("orderId", ordMap.get("salesOrdId"));
				currMap = rosCallLogMapper.chkCurrRosCall(params);  //Check Ros Call Current Status.....

				if(currMap != null){
					/******	CURRENT MONTH ROS CALL LOG FOUND ******/
					//________________________________________________________________________________________________________ 1. ROS CALL LOG(UPDATE)
					Map<String, Object> oneMap = new HashMap<String, Object>();
					oneMap.put("orderId", ordMap.get("salesOrdId"));

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					oneMap.put("rosCallResnId", feedbackId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						oneMap.put("rosCallRecallDt", defaultDateTime);
					}else{
						oneMap.put("rosCallRecallDt", params.get("reCallDate"));
					}

					oneMap.put("rosCallStusId", SalesConstants.ROS_CALL_STATUS_ID);
					oneMap.put("userId", params.get("userId"));
					oneMap.put("rosStatus", params.get("rosStatus"));
					oneMap.put("ptpDt", params.get("ptpDate"));

					LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) START ");
					LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) PARAM :  " + oneMap.toString());
					rosCallLogMapper.updateROSCallInfo(oneMap);
					LOGGER.info("<currMap IS NOT NULL> ::::: 1) ________________________ROS MASTER(UPDATE) END ");

					//________________________________________________________________________________________________________ 2. CALL RESULT

					int callResultSeq = 0;
					int callEntId = 0;
					int actionId = 0;
					double rosAmt = 0;
					int chkSms = 0;
					String smsRem = "";
					int callEntSeq = 0;

					EgovMap currCallEntMap = null;
					params.put("orderId", ordMap.get("salesOrdId"));
					currCallEntMap = rosCallLogMapper.chkCurrCallEntryInfo(params); //Check Call Entry Current Status.....

					if(currCallEntMap != null){
						//________________________________________________________________________________________________________CASE : ROS CALL ENTRY FOUND
						//ROS CALLENTRY FOUND
						//________________________________________________________________________________________________________ 2 - 1 . CALL RESULT INSERT
						Map<String, Object> callEntMap = new HashMap<String, Object>();

						callResultSeq = rosCallLogMapper.getSeqCCR0007D();
						callEntMap.put("callResultSeq", callResultSeq);

						callEntId = Integer.parseInt(String.valueOf(currCallEntMap.get("callEntryId")));
						callEntMap.put("callEntId", callEntId);

						if(params.get("action") != null){
							actionId = Integer.parseInt(String.valueOf(params.get("action")));
						}
						callEntMap.put("callStusId", actionId);

						if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
							callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
						}else{
							callEntMap.put("callDt", params.get("reCallDtYmd"));
						}

						callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

						if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
							feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
						}
						callEntMap.put("callFdbchId", feedbackId);
						callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
						callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
						callEntMap.put("callCrtUserId", params.get("userId"));
						callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
						callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

						if(params.get("collectAmt") != null){
							rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
						}
						callEntMap.put("callRosAmt", rosAmt);

						if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
						}else{ //CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
							smsRem = String.valueOf(params.get("smsRem"));
						}
						callEntMap.put("callSMS", chkSms);
						callEntMap.put("callSMSRem", smsRem);

						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT START ");
						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
						rosCallLogMapper.insertCallResultInfo(callEntMap);
						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________INS CALL RESULT END ");

						///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						//________________________________________________________________________________________________________ 2 - 2 . CALL ENTRY UPDATE
						Map<String, Object> updCallEntMap = new HashMap<String, Object>();
						updCallEntMap.put("resultId", callResultSeq);
						updCallEntMap.put("userId", params.get("userId"));
						updCallEntMap.put("callEntId", callEntId);

						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY START ");
						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
						rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________UPD CALL ENTRY END ");
					}else{
						//________________________________________________________________________________________________________CASE : ROS CALL ENTRY  NOT FOUND
						//ROS CALLENTRY NOT FOUND
						//________________________________________________________________________________________________________ 2 - 1 . CALL ENTRY INSERT (MAKE CALL ENTRY)
						Map<String, Object> callInsMap = new HashMap<String, Object>();
						callEntSeq = rosCallLogMapper.getSeqCCR0006D();

						callInsMap.put("callEntSeq", callEntSeq);
						callInsMap.put("salesOrdId", ordMap.get("salesOrdId"));
						callInsMap.put("typeId", SalesConstants.ROS_NEW_CALL_ENTRY_TYPE_ID);
						callInsMap.put("stusCodeId", SalesConstants.ROS_NEW_CALL_ENTRY_STATUS_ID);
						callInsMap.put("resultId", SalesConstants.ROS_NEW_CALL_ENTRY_RESULT_ID);
						callInsMap.put("docId", SalesConstants.ROS_NEW_CALL_ENTRY_DOC_ID);
						callInsMap.put("userId", params.get("userId"));
						callInsMap.put("callDt", SalesConstants.DEFAULT_DATE);
						callInsMap.put("isWaitForCancl", SalesConstants.ROS_NEW_CALL_ENTRY_WAIT_CANCEL);
						callInsMap.put("happCallerId", SalesConstants.ROS_NEW_CALL_ENTRY_HAPPY_CALLER_ID);
						callInsMap.put("oriCallDt", SalesConstants.DEFAULT_DATE);

						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT START ");
						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT PARAM :  " + callInsMap.toString());
						rosCallLogMapper.insertCallEntryInfo(callInsMap);
						LOGGER.info("<currMap IS NOT NULL> ::::: 2) ________________________CALL ENTRY INSERT END ");

						/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

						//________________________________________________________________________________________________________ 2 - 2 . CALL RESULT INSERT
						Map<String, Object> callEntMap = new HashMap<String, Object>();

						callResultSeq = rosCallLogMapper.getSeqCCR0007D();
						callEntMap.put("callResultSeq", callResultSeq);
						callEntMap.put("callEntId", callEntSeq);

						if(params.get("action") != null){
							actionId = Integer.parseInt(String.valueOf(params.get("action")));
						}
						callEntMap.put("callStusId", actionId);

						if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
							callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
						}else{
							callEntMap.put("callDt", params.get("reCallDtYmd"));
						}

						callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

						if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
							feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
						}
						callEntMap.put("callFdbchId", feedbackId);
						callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
						callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
						callEntMap.put("callCrtUserId", params.get("userId"));
						callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
						callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

						if(params.get("collectAmt") != null){
							rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
						}
						callEntMap.put("callRosAmt", rosAmt);

						if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
						}else{ //CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
							smsRem = String.valueOf(params.get("smsRem"));
						}
						callEntMap.put("callSMS", chkSms);
						callEntMap.put("callSMSRem", smsRem);

						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT START ");
						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
						rosCallLogMapper.insertCallResultInfo(callEntMap);
						LOGGER.info("<currMap IS NOT NULL> ::::: 3) ________________________INS CALL RESULT END ");


	                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						//________________________________________________________________________________________________________ 2 - 3 . CALL ENTRY UPDATE
	                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
	                    updCallEntMap.put("resultId", callResultSeq);
	                    updCallEntMap.put("userId", params.get("userId"));
	                    updCallEntMap.put("callEntId", callEntId);

	                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY START ");
	                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
	                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
	                    LOGGER.info("<currMap IS NOT NULL> ::::: 4) ________________________UPD CALL ENTRY END ");
					}
				}else{
					/******	CURRENT MONTH ROS CALL LOG NOT FOUND ******/
					//____________________________________________________________________________________________________________________________ 1. ROS CALL LOG(INSERT)
					Map<String, Object> oneMap = new HashMap<String, Object>();
					oneMap.put("orderId", ordMap.get("salesOrdId"));  //Sales Ord Id
					oneMap.put("rosCallerUserId", SalesConstants.ROS_CALLER_USER_ID);

					if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
						feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
					}
					oneMap.put("rosCallResnId", feedbackId);

					if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
						oneMap.put("rosCallRecallDt", defaultDateTime);
					}else{
						oneMap.put("rosCallRecallDt", params.get("reCallDate"));
					}

					oneMap.put("rosCallStusId", SalesConstants.ROS_CALL_STATUS_ID);
					oneMap.put("userId", params.get("userId"));
					oneMap.put("rosStatus", params.get("rosStatus"));
					oneMap.put("ptpDt", params.get("ptpDate"));

					LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) START ");
					LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) PARAM :  " + oneMap.toString());
					rosCallLogMapper.insertROSCallInfo(oneMap);
					LOGGER.info("<currMap IS  NULL> ::::: 1) ________________________ROS MASTER(INSERT) END ");


					//________________________________________________________________________________________________________ 2. CALL RESULT

					int callResultSeq = 0;
					int callEntId = 0;
					int actionId = 0;
					double rosAmt = 0;
					int chkSms = 0;
					String smsRem = "";
					int callEntSeq = 0;

					EgovMap currCallEntMap = null;
					params.put("orderId", ordMap.get("salesOrdId"));
					currCallEntMap = rosCallLogMapper.chkCurrCallEntryInfo(params); //Check Call Entry Current Status.....

					if(currCallEntMap != null){
						//________________________________________________________________________________________________________CASE : ROS CALL ENTRY FOUND
						//ROS CALLENTRY FOUND
						//________________________________________________________________________________________________________ 2 - 1 . CALL RESULT INSERT
						Map<String, Object> callEntMap = new HashMap<String, Object>();

						callResultSeq = rosCallLogMapper.getSeqCCR0007D();
						callEntMap.put("callResultSeq", callResultSeq);

						callEntId = Integer.parseInt(String.valueOf(currCallEntMap.get("callEntryId")));
						callEntMap.put("callEntId", callEntId);

						if(params.get("action") != null){
							actionId = Integer.parseInt(String.valueOf(params.get("action")));
						}
						callEntMap.put("callStusId", actionId);

						if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
							callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
						}else{
							callEntMap.put("callDt", params.get("reCallDtYmd"));
						}

						callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

						if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
							feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
						}
						callEntMap.put("callFdbchId", feedbackId);
						callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
						callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
						callEntMap.put("callCrtUserId", params.get("userId"));
						callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
						callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

						if(params.get("collectAmt") != null){
							rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
						}
						callEntMap.put("callRosAmt", rosAmt);

						if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
						}else{ //CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
							smsRem = String.valueOf(params.get("smsRem"));
						}
						callEntMap.put("callSMS", chkSms);
						callEntMap.put("callSMSRem", smsRem);

						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT START ");
						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
						rosCallLogMapper.insertCallResultInfo(callEntMap);
						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________INS CALL RESULT END ");

	                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	                    //________________________________________________________________________________________________________ 2 - 2 . CALL ENTRY UPDATE
	                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
	                    updCallEntMap.put("resultId", callResultSeq);
	                    updCallEntMap.put("userId", params.get("userId"));
	                    updCallEntMap.put("callEntId", callEntId);

	                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY START ");
	                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
	                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
	                    LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________UPD CALL ENTRY END ");
					}else{
						//________________________________________________________________________________________________________CASE : ROS CALL ENTRY  NOT FOUND
						//ROS CALLENTRY NOT FOUND
						//________________________________________________________________________________________________________ 2 - 1 . CALL ENTRY INSERT (MAKE CALL ENTRY)
						Map<String, Object> callInsMap = new HashMap<String, Object>();
						callEntSeq = rosCallLogMapper.getSeqCCR0006D();

						callInsMap.put("callEntSeq", callEntSeq);
						callInsMap.put("salesOrdId", ordMap.get("salesOrdId"));
						callInsMap.put("typeId", SalesConstants.ROS_NEW_CALL_ENTRY_TYPE_ID);
						callInsMap.put("stusCodeId", SalesConstants.ROS_NEW_CALL_ENTRY_STATUS_ID);
						callInsMap.put("resultId", SalesConstants.ROS_NEW_CALL_ENTRY_RESULT_ID);
						callInsMap.put("docId", SalesConstants.ROS_NEW_CALL_ENTRY_DOC_ID);
						callInsMap.put("userId", params.get("userId"));
						callInsMap.put("callDt", SalesConstants.DEFAULT_DATE);
						callInsMap.put("isWaitForCancl", SalesConstants.ROS_NEW_CALL_ENTRY_WAIT_CANCEL);
						callInsMap.put("happCallerId", SalesConstants.ROS_NEW_CALL_ENTRY_HAPPY_CALLER_ID);
						callInsMap.put("oriCallDt", SalesConstants.DEFAULT_DATE);

						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT START ");
						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT PARAM :  " + callInsMap.toString());
						rosCallLogMapper.insertCallEntryInfo(callInsMap);
						LOGGER.info("<currMap IS  NULL> ::::: 2) ________________________CALL ENTRY INSERT END ");

						/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

						//________________________________________________________________________________________________________ 2 - 2 . CALL RESULT INSERT
						Map<String, Object> callEntMap = new HashMap<String, Object>();

						callResultSeq = rosCallLogMapper.getSeqCCR0007D();
						callEntMap.put("callResultSeq", callResultSeq);
						callEntMap.put("callEntId", callEntSeq);

						if(params.get("action") != null){
							actionId = Integer.parseInt(String.valueOf(params.get("action")));
						}
						callEntMap.put("callStusId", actionId);

						if(params.get("reCallDate") == null || ("").equals(String.valueOf(params.get("reCallDate")))){
							callEntMap.put("callDt", SalesConstants.DEFAULT_DATE);
						}else{
							callEntMap.put("callDt", params.get("reCallDtYmd"));
						}

						callEntMap.put("callActnDt", SalesConstants.DEFAULT_DATE);

						if(params.get("feedback") != null && !("").equals(String.valueOf(params.get("feedback")))){
							feedbackId = Integer.parseInt(String.valueOf(params.get("feedback")));
						}
						callEntMap.put("callFdbchId", feedbackId);
						callEntMap.put("callCtId", SalesConstants.ROS_CALL_CT_ID); //0
						callEntMap.put("callRem", params.get("rosRem"));  //callResultDetails.CallRemark = txtROSRemark_ROS.Text.Trim();
						callEntMap.put("callCrtUserId", params.get("userId"));
						callEntMap.put("callCrtUserIdDept", SalesConstants.ROS_CALL_CREATE_BY_DEPT); //callResultDetails.CallCreateByDept = 0;
						callEntMap.put("callHcId", SalesConstants.ROS_CALL_HCID);

						if(params.get("collectAmt") != null){
							rosAmt = Double.parseDouble(String.valueOf(params.get("collectAmt")));
						}
						callEntMap.put("callRosAmt", rosAmt);

						if(Integer.parseInt(String.valueOf(params.get("chkSmS"))) == 0){  //NOT CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_FALSE;
						}else{ //CHECK
							chkSms = SalesConstants.ROS_CHECK_SMS_TRUE;
							smsRem = String.valueOf(params.get("smsRem"));
						}
						callEntMap.put("callSMS", chkSms);
						callEntMap.put("callSMSRem", smsRem);

						LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT START ");
						LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT PARAM :  " + callEntMap.toString());
						rosCallLogMapper.insertCallResultInfo(callEntMap);
						LOGGER.info("<currMap IS  NULL> ::::: 3) ________________________INS CALL RESULT END ");


	                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						//________________________________________________________________________________________________________ 2 - 3 . CALL ENTRY UPDATE
	                    Map<String, Object> updCallEntMap = new HashMap<String, Object>();
	                    updCallEntMap.put("resultId", callResultSeq);
	                    updCallEntMap.put("userId", params.get("userId"));
	                    updCallEntMap.put("callEntId", callEntId);

	                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY START ");
	                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY PARAM :  " + updCallEntMap.toString());
	                    rosCallLogMapper.updateCallEntryInfo(updCallEntMap);
	                    LOGGER.info("<currMap IS  NULL> ::::: 4) ________________________UPD CALL ENTRY END ");
					}
				}
			}//LOOP END

		}///Insert End

		return true;
	}

	@Override
	public List<EgovMap> selectOrderRemList(Map<String, Object> params) throws Exception{

		return rosCallLogMapper.selectOrderRemList(params);
	}

	@Override

	public Map<String, Object> uploadOrdRem(Map<String, Object> params) throws Exception{

		//Return Map
		Map<String, Object> rtnMap = new HashMap<String, Object>();


		//(1)________________________________Insert Order Remark Upload Master

		Map<String, Object> ordMap = new HashMap<String, Object>();
		int ordRemSeq = rosCallLogMapper.getSeqSAL0054D();
		LOGGER.info("###################  ordRemSeq : " + ordRemSeq);
		ordMap.put("ordRemSeq", ordRemSeq);
		ordMap.put("ordRemStus", SalesConstants.ROS_ORD_REM_UPLOAD_STATUS);
		ordMap.put("userId", params.get("userId"));

		rosCallLogMapper.insertOrderRem(ordMap);


		//(2)________________________________Insert Order Remark Upload Detail (bulk)
		List<orderRemDataVO> vos = (List)params.get("voList");



		LOGGER.info("################### vos : " + vos.size());


		List<Map> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);
			final int seq  = rosCallLogMapper.getSeqSAL0055D();
			map.put("uploadDetId", seq);
			map.put("uploadMId", ordRemSeq);
			map.put("ordNo", 	String.format("%07d", Integer.parseInt(r.getOrderNo())));
			map.put("rem", r.getRemark());
			map.put("statusId", SalesConstants.ROS_ORD_REM_UPLOAD_STATUS);
			map.put("orderId", 0);
			map.put("userId", params.get("userId"));
			map.put("validStatusId", SalesConstants.ROS_ORD_VALID_STATUS_ID);
			map.put("validRem", "");
			return map;
		})	.collect(Collectors.toList());

		/*
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		int seq = 0;
		for (int idx = 0; idx < vos.size(); idx++) {
			Map<String, Object> map = new HashMap<String, Object>();

			LOGGER.info("________________________________________________________ before seq : " + seq);
			seq  = rosCallLogMapper.getSeqSAL0055D();
			LOGGER.info("________________________________________________________ After seq : " + seq);

			map.put("uploadDetId", seq);
			map.put("uploadMId", ordRemSeq);
			map.put("ordNo", vos.get(idx).getOrderNo());
			map.put("rem", vos.get(idx).getRemark());
			map.put("statusId", SalesConstants.ROS_ORD_REM_UPLOAD_STATUS);
			map.put("orderId", 0);
			map.put("userId", params.get("userId"));
			map.put("validStatusId", SalesConstants.ROS_ORD_VALID_STATUS_ID);
			map.put("validRem", "");

			list.add(idx, map);

		}*/

		int size = 1000;
		int page = list.size() % size == 0 ? (list.size() / size) - 1 : list.size() / size;
		int start;
		int end;

		Map<String, Object> ordDMap = new HashMap<>();
		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;
			if(i == page){
				end = list.size();
			}
			ordDMap.put("list",
					list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
			rosCallLogMapper.insertOrderRemDetail(ordDMap);
		}


		//(3)________________________________OrderRemarkUpload_DetVerify (call Procedure)
		//posMapper.posBookingCallSP_LOGISTIC_REQUEST(logPram);
		Map<String, Object> prcMap = new HashMap<String, Object>();
		prcMap.put("ordRemSeq", ordRemSeq);

		rosCallLogMapper.spOrderRemarkUpload_DetVerify(prcMap);

		//Return
		rtnMap.put("ordRemSeq", ordRemSeq);

		return rtnMap;
	}

	@Override
	public EgovMap selectBatchViewInfo(Map<String, Object> params) throws Exception {

		EgovMap rtnInfoMap = null;
		int totCnt = 0;
		int validCnt = 0;
		int inValidCnt = 0;
		rtnInfoMap = rosCallLogMapper.selectBatchViewInfo(params);

		totCnt = rosCallLogMapper.cntOrdRemUpload(params);

		params.put("validOrd", SalesConstants.ROS_ORD_VALID_REM);
		validCnt = rosCallLogMapper.cntOrdRemUpload(params);
		params.remove("validOrd");

		params.put("inValidOrd", SalesConstants.ROS_ORD_INVALID_REM);
		inValidCnt = rosCallLogMapper.cntOrdRemUpload(params);

		rtnInfoMap.put("totCnt", totCnt);
		rtnInfoMap.put("validCnt", validCnt);
		rtnInfoMap.put("inValidCnt", inValidCnt);

		return rtnInfoMap;
	}

	@Override
	public List<EgovMap> getBatchDetailInfoList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getBatchDetailInfoList(params);
	}

	@Override
	public EgovMap searchExistOrdNo(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.searchExistOrdNo(params);
	}

	@Override
	public EgovMap alreadyExistOrdNo(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.alreadyExistOrdNo(params);
	}

	@Override
	public void addNewOrdNo(Map<String, Object> params) throws Exception {

		int seq  = rosCallLogMapper.getSeqSAL0055D();
		params.put("uploadDetId", seq);
		if(params.get("addRem") == null){
			params.put("addRem", "");
		}
		params.put("stusId", SalesConstants.ROS_ORD_REM_UPLOAD_STATUS);
		params.put("validStatusId", SalesConstants.ROS_ORD_VALID_STATUS_PASS_ID);
		params.put("validRemark", "");

		rosCallLogMapper.addNewOrdNo(params);
	}

	@Override
	public void updOrdNo (Map<String, Object> params) throws Exception {

		params.put("stusId", SalesConstants.ROS_ORD_DISABLE_ID);

		rosCallLogMapper.updOrdNo(params);
	}

	@Override
	public void updBatch(Map<String, Object> params) throws Exception {

		params.put("stusId", SalesConstants.ROS_ORD_DISABLE_ID);
		rosCallLogMapper.updBatch(params);

	}

	@Override
	public void confirmBatch(Map<String, Object> params) throws Exception {

		EgovMap chkMap = null;
		chkMap = rosCallLogMapper.chkBatchMasterInfo(params);

		if(chkMap != null){

			//Call Procedure
			Map<String, Object> prcMap = new HashMap<String, Object>();
			prcMap.put("batchId", params.get("batchId"));
			prcMap.put("userId", params.get("userId"));

			rosCallLogMapper.spOrderRemarkUpload_Confirm(prcMap);

			//Upd Master
			Map<String, Object> insMap = new HashMap<String, Object>();
			insMap.put("batchId", params.get("batchId"));  //det.UploadMID = int.Parse(Request["UploadMID"].ToString());
			insMap.put("stusId", SalesConstants.ROS_ORD_VALID_STATUS_PASS_ID); //det.StatusID = 4;
			insMap.put("userId", params.get("userId"));

			rosCallLogMapper.updConfirmOrdRemMaster(insMap);
		}
	}


	@Override
	public List<EgovMap> selectCallerList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.selectCallerList(params);
	}

	@Override
	public Map<String, Object> uploadCaller(Map<String, Object> params) throws Exception {

		//Return Map
		Map<String, Object> rtnMap = new HashMap<String, Object>();


		//(1)________________________________Insert Caller Master

		Map<String, Object> callerMap = new HashMap<String, Object>();
		List<callerDataVO> vos = (List)params.get("voList");  // File List

		int batchId = rosCallLogMapper.getSeqMSC0011D();
		LOGGER.info("###################  batchId : " + batchId);
		callerMap.put("batchId", batchId);
		callerMap.put("stusCodeId", SalesConstants.ROS_CALLER_UPD_STATUS_ID); //1
		callerMap.put("userId", params.get("userId"));
		callerMap.put("totUpDt", vos.size());
		callerMap.put("totCmplt", SalesConstants.ROS_CALLER_UPD_COMPL);
		callerMap.put("totFail", SalesConstants.ROS_CALLER_UPD_FAIL);

		rosCallLogMapper.instCallerMaster(callerMap);

		//(2)________________________________Insert Caller Detail (bulk)

		List<Map> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);
			final int itmId  = rosCallLogMapper.getSeqMSC0012D();
			map.put("itmId", itmId);
			map.put("batchId", batchId);
			map.put("stusCodeId", SalesConstants.ROS_CALLER_UPD_DETAIL_STATUS_CODE_ID);
			map.put("itmMsg", "");  // det.ItemMessage = "";
			map.put("ordNo", 	String.format("%07d", Integer.parseInt(r.getOrderNo())));
			map.put("sysOrdId", SalesConstants.ROS_CALLER_SYS_ORD_ID); //  det.SysOrderID = 0;
			map.put("userName", r.getCaller());
			map.put("sysUserId", SalesConstants.RSO_CALLER_SYS_USER_ID);
			return map;
		})	.collect(Collectors.toList());

		/*
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		int seq = 0;
		for (int idx = 0; idx < vos.size(); idx++) {
			Map<String, Object> map = new HashMap<String, Object>();

			LOGGER.info("________________________________________________________ before seq : " + seq);
			seq  = rosCallLogMapper.getSeqSAL0055D();
			LOGGER.info("________________________________________________________ After seq : " + seq);

			map.put("uploadDetId", seq);
			map.put("uploadMId", ordRemSeq);
			map.put("ordNo", vos.get(idx).getOrderNo());
			map.put("rem", vos.get(idx).getRemark());
			map.put("statusId", SalesConstants.ROS_ORD_REM_UPLOAD_STATUS);
			map.put("orderId", 0);
			map.put("userId", params.get("userId"));
			map.put("validStatusId", SalesConstants.ROS_ORD_VALID_STATUS_ID);
			map.put("validRem", "");

			list.add(idx, map);

		}*/

		int size = 1000;
		int page = list.size() / size;
		int start;
		int end;

		Map<String, Object> callerDMap = new HashMap<>();
		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;
			if(i == page){
				end = list.size();
			}
			callerDMap.put("list",
					list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
			rosCallLogMapper.insertCallerDetail(callerDMap);
		}


		//(3)________________________________spROSCallerUpdate (call Procedure)
		//posMapper.posBookingCallSP_LOGISTIC_REQUEST(logPram);
		Map<String, Object> prcMap = new HashMap<String, Object>();
		prcMap.put("batchId", batchId);

		rosCallLogMapper.spROSCallerUpdate(prcMap);


		//(4)_________________________________ Count

		Map<String, Object> cntInfoMap = new HashMap<String, Object>();
		EgovMap cntMap = null;
		cntInfoMap.put("batchId", batchId);
		cntMap = rosCallLogMapper.countInfoByBatchId(cntInfoMap);

		//Return
		rtnMap.put("batchId", batchId);
		rtnMap.put("totUpDt", cntMap.get("totUpDt"));
		rtnMap.put("totCmplt", cntMap.get("totCmplt"));
		rtnMap.put("totFail", cntMap.get("totFail"));

		return rtnMap;
	}

	@Override
	public List<EgovMap> getCallerDetailList(Map<String, Object> params) throws Exception {

		return rosCallLogMapper.getCallerDetailList(params);
	}
}

