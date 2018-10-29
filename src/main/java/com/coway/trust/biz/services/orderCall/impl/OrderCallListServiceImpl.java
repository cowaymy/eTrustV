package com.coway.trust.biz.services.orderCall.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.services.installation.InstallationResultListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderCallListService")
public class OrderCallListServiceImpl extends EgovAbstractServiceImpl implements OrderCallListService {

	private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

	@Resource(name = "orderCallListMapper")
	private OrderCallListMapper orderCallListMapper;

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;


	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;



	@Override
	public List<EgovMap> selectOrderCall(Map<String, Object> params) {
		return orderCallListMapper.selectOrderCall(params);
	}

	@Override
	public List<EgovMap> selectCallStatus() {
		return orderCallListMapper.selectCallStatus();
	}


	@Override
	public EgovMap getOrderCall(Map<String, Object> params) {
		return orderCallListMapper.getOrderCall(params);
	}

	@Override
	public List<EgovMap> selectCallLogTransaction(Map<String, Object> params) {
		return orderCallListMapper.selectCallLogTransaction(params);
	}


	@Override
	public Map<String, Object>  insertCallResult(Map<String, Object> params, SessionVO sessionVO) {
		String salesOrdNo = params.get("salesOrdNo").toString();
		String installationNo = "";
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			Map<String, Object> callMaster = getSaveCallCenter(params, sessionVO);
			Map<String, Object> callDetails = getSaveCallDetails(params, sessionVO);
			Map<String, Object> installMaster = new HashMap<String, Object>();
			Map<String, Object> orderLogList = new HashMap<String, Object>();
			if(Integer.parseInt(params.get("callStatus").toString()) == 20){
				installMaster = getSaveInstallMaster(params, sessionVO);
				orderLogList = getSaveOrderLogList(params, sessionVO);
			}

			String returnNo="";
			boolean success = false;
			resultValue = orderCallLogSave(callMaster, callDetails, installMaster,  orderLogList ,salesOrdNo ,params);

		}

		return resultValue;
	}
	@Transactional
	private  Map<String, Object> orderCallLogSave(Map<String, Object> callMaster
																		,Map<String, Object> callDetails
																		,Map<String, Object> installMaster
																		,Map<String, Object> orderLogList
																		,String salesOrdNo
																		,Map<String, Object> params){
		String returnNo="";
		String maxId = "";  //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
		EgovMap maxIdValue = new EgovMap();
		EgovMap callEntry = orderCallListMapper.selectCallEntry(callMaster);
		EgovMap installNo = new EgovMap();
		Map<String, Object>  logPram = new HashMap<String, Object>();

		if(callEntry != null){
			//Insert CALL LOG RESULT
			orderCallListMapper.insertCallResult(callDetails);

			//UPDATE CALL LOG ENTRY
			returnNo = callEntry.get("callEntryId").toString();
			callEntry.put("statusCodeId", callMaster.get("statusCodeId"));

			//RESULTID 값 가져오기
			maxIdValue.put("value", "callResultId");
			maxId = orderCallListMapper.selectMaxId(maxIdValue);
			//RESULT 값 가져와서 CallEntry에 저장
			callEntry.put("resultId", maxId);
			if(Integer.parseInt(callMaster.get("statusCodeId").toString()) == 19 ||Integer.parseInt(callMaster.get("statusCodeId").toString()) == 30 ){
				callEntry.put("callDate", callMaster.get("callDate"));
			}
			callEntry.put("isWaitForCancel", callMaster.get("isWaitForCancel"));
			callEntry.put("updated", callMaster.get("updated"));
			callEntry.put("updator", callMaster.get("updator"));
			orderCallListMapper.updateCallEntry(callEntry);
			int callEntId = 0 ;
			if(installMaster.get("callEntryId")!=null&&installMaster.get("callEntryId")!=""){
				callEntId = Integer.parseInt(installMaster.get("callEntryId").toString());
			}
			if(installMaster != null && callEntId > 0){

				//INSERT INSTALL ENTRY
				installNo = getDocNo("9");
				returnNo = installNo.get("docNo").toString();
				int ID = 9;
				String nextDocNo=getNextDocNo("INS",installNo.get("docNo").toString());
				installNo.put("nextDocNo", nextDocNo);
				logger.debug("installNo : {}", installNo);

				//UPDATE DOC NO
				memberListMapper.updateDocNo(installNo);

				installMaster.put("installEntryNo", installNo.get("docNo"));//물류 보낼때 installEntryNo 필요함
				logger.debug("installMaster : {}", installMaster);
				orderCallListMapper.insertInstallEntry(installMaster);


				if(Integer.parseInt(params.get("callStatus").toString()) ==20){
					/////////////////////////물류 호출//////////////////////
        			logPram.put("ORD_ID", installNo.get("docNo"));
        			logPram.put("RETYPE", "SVO");
        			logPram.put("P_TYPE", "OD01");
        			logPram.put("P_PRGNM", "OCALL");
        			logPram.put("USERID", Integer.parseInt(String.valueOf(callMaster.get("updator"))));

        			logger.debug("ORDERCALL 물류 호출 PRAM ===>"+ logPram.toString());
        			servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
        		 	logPram.put("P_RESULT_TYPE", "IN");
            		logPram.put("P_RESULT_MSG", logPram.get("p1"));
        			logger.debug("ORDERCALL 물류 호출 결과 ===>");
        			/////////////////////////물류 호출 END //////////////////////

        			// ONGHC - START
        			// START UPDATE SVC0001D'S AS_CALLLOG_ID FOR ADD ON COMPONENT
        			EgovMap salesEntry = orderCallListMapper.selectOrderEntry(salesOrdNo);
        			if (salesEntry != null) {
        			  logger.debug("salesEntry " + salesEntry);
        			  if (salesEntry.get("cpntId") != null && !salesEntry.get("cpntId").toString().equals("")) {
        				  if (Integer.parseInt(salesEntry.get("cpntId").toString()) > 0) { // IS NOT DEFAULT SET
        				    salesEntry.put("callEntryId", callEntry.get("callEntryId").toString());
        				    salesEntry.put("CTID", params.get("CTID").toString());
        				    salesEntry.put("CTgroup", params.get("CTgroup").toString());
        				    logger.debug("salesEntry " + salesEntry);
        				    orderCallListMapper.updateASEntry(salesEntry);
        				  }
        			  }
        			} else {
        			  logger.debug("Sales Entry No " + salesOrdNo + " Not Found!!");
        			}
        			// ONGHC - END
				}


			}
			if(orderLogList != null && orderLogList.size() > 0 && Integer.parseInt(callMaster.get("statusCodeId").toString()) == 20){

			}

		}
		Map<String, Object> resultValue = new HashMap<String, Object>();
		String installationNo ="";
		if(installNo.get("docNo")!=null&&installNo.get("docNo")!=""){
			installationNo = installNo.get("docNo").toString();
		}
		resultValue.put("installationNo", installationNo);
		resultValue.put("salesOrdNo", salesOrdNo);
		resultValue.put("spMap", logPram);

		return resultValue;
	}

	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
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

	private Map<String, Object> getSaveOrderLogList(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> orderLogList = new HashMap<String, Object>();
		 orderLogList.put("logId", 0);
		 orderLogList.put("salesOrderId", params.get("salesOrdId"));
		 orderLogList.put("progressId", 4);
		 orderLogList.put("logDate", new Date());
		 orderLogList.put("refId", 0);
		 orderLogList.put("isLock", true);
		 orderLogList.put("logCreator", sessionVO.getUserId());
		 orderLogList.put("logCreated", new Date());

		return orderLogList;
	}
	private Map<String, Object> getSaveInstallMaster(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> installMaster = new HashMap<String, Object>();
		int CTId = 0;
		CTId = Integer.parseInt(params.get("CTID").toString());
		//CT 받아오는거 다시 확인
		String appointmentDate = "";
		if(params.get("appDate") != null){
			appointmentDate = params.get("appDate").toString();
		}
		String CTGroup = "";
		if(params.get("CTgroup") != null){
			CTGroup  = params.get("CTgroup").toString();
		}
		installMaster.put("installEntryId", 0);
		installMaster.put("installEntryNo", "");
		installMaster.put("salesOrderId", params.get("salesOrdId"));
		installMaster.put("statusCodeId", 1);
		installMaster.put("CTID", CTId);
		installMaster.put("installDate", appointmentDate);
		installMaster.put("appDate", appointmentDate);
		installMaster.put("callEntryId", params.get("callEntryId"));
		installMaster.put("installStkId", Integer.parseInt(params.get("hiddenProductId").toString()));
		installMaster.put("installResultId", 0);
		installMaster.put("created", new Date());
		installMaster.put("creator", sessionVO.getUserId());
		installMaster.put("allowComm", false);
		installMaster.put("isTradeIn", false);
		installMaster.put("CTGroup", CTGroup);
		installMaster.put("updated", new Date());
		installMaster.put("updator",sessionVO.getUserId());
		installMaster.put("revId",0);
		installMaster.put("stock", params.get("stock"));
		logger.debug("installMaster : {}", installMaster);
		return installMaster;
	}
	private Map<String, Object> getSaveCallDetails(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> callDetails = new HashMap<String, Object>();
		String recallDate = "";
		if(params.get("recallDate") != ""){
			recallDate = params.get("recallDate").toString();
		}
		String appointmentDate = "";
		if(params.get("appDate") != null){
			appointmentDate = params.get("appDate").toString();
		}
		int feedbackId = 0;
		if(Integer.parseInt(params.get("feedBackCode").toString())  > 0){
			feedbackId = Integer.parseInt(params.get("feedBackCode").toString());
		}
		int CTId = 0;
		if(params.get("CTID")!=null&&params.get("CTID")!=""){
			CTId = Integer.parseInt(params.get("CTID").toString());
		}
		//if(params.get("CT").TO) CT 내용 가져오는거 해야함
		callDetails.put("callResultId", 0);
		callDetails.put("callEntryId", params.get("callEntryId"));
		callDetails.put("callStatusId", Integer.parseInt(params.get("callStatus").toString()));
		callDetails.put("callCallDate", recallDate);
		callDetails.put("callActionDate", appointmentDate);
		callDetails.put("callFeedBackId", feedbackId);
		callDetails.put("callCTId", CTId);
		callDetails.put("callRemark", params.get("remark").toString().trim());
		callDetails.put("callCreateBy", sessionVO.getUserId());
		callDetails.put("callCreateAt", new Date());
		callDetails.put("callCreateByDept", 0);
		callDetails.put("callHCID", 0);
		callDetails.put("callROSAmt", 0);
		callDetails.put("callSMS", false);
		callDetails.put("CallSMSRemark", "");
		logger.debug("callDetails : {}", callDetails);
		return callDetails;

	}

	private Map<String, Object> getSaveCallCenter(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> callMaster = new HashMap<String, Object>();
		boolean IsWaitCancel = false;
		if(Integer.parseInt(params.get("callStatus").toString()) == 30){
			IsWaitCancel = true;
		}
		String recallDate = "";
		if(params.get("recallDate") != ""){
			recallDate = params.get("recallDate").toString();
		}
		callMaster.put("callEntryId", params.get("callEntryId"));
		callMaster.put("salesOrderId", params.get("salesOrdId"));
		callMaster.put("typeId", 0);
		callMaster.put("statusCodeId", Integer.parseInt(params.get("callStatus").toString()));
		callMaster.put("resultId", 0);
		callMaster.put("docId", 0);
		callMaster.put("creator", 0);
		callMaster.put("created", "01/01/1900");
		callMaster.put("callDate", recallDate);
		callMaster.put("isWaitForCancel", IsWaitCancel);
		callMaster.put("updated", new Date());
		callMaster.put("updator", sessionVO.getUserId());
		callMaster.put("oriCallDate","01/01/1900");
		logger.debug("callMaster : {}", callMaster);
		return callMaster;
	}

	@Override
	public List<EgovMap> getstateList() {
		// TODO Auto-generated method stub
		return orderCallListMapper.getstateList();
	}

	@Override
	public List<EgovMap> getAreaList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderCallListMapper.getAreaList(params);
	}

	@Override
	public EgovMap selectCdcAvaiableStock(Map<String, Object> params) {

		return orderCallListMapper.selectCdcAvaiableStock(params);
	}

	@Override
	public EgovMap selectRdcStock(Map<String, Object> params) {

		return orderCallListMapper.selectRdcStock(params);
	}


	@Override
	public EgovMap getRdcInCdc(Map<String, Object> params) {
		return orderCallListMapper.getRdcInCdc(params);
	}

	@Override
	public List<EgovMap> selectProductList() {
		return orderCallListMapper.selectProductList();
	}
}
