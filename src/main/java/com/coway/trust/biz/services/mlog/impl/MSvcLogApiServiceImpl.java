package com.coway.trust.biz.services.mlog.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.history.AsDetailDto;
import com.coway.trust.api.mobile.services.history.AsDetailForm;
import com.coway.trust.api.mobile.services.sales.OutStandingResultVo;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.SmsMapper;
import com.coway.trust.biz.common.type.SMSTemplateType;
import com.coway.trust.biz.homecare.services.impl.htManualMapper;
import com.coway.trust.biz.logistics.returnusedparts.impl.ReturnUsedPartsMapper;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.google.gson.JsonObject;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
//import com.coway.trust.biz.logistics.returnusedparts.impl;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/04/2019    ONGHC      1.0.1       - Amend File Format
 * 29/07/2019    ONGHC      1.0.2       - Add Function
 * 29/07/2019    ONGHC      1.0.3       - Amend productReturnResult to Add Status Checking
 * 13/08/2019    ONGHC      1.0.4       - Add updFctExch
 * 27/11/2019    ONGHC      1.0.5       - Amend productReturnResult
 * 22/04/2020    ONGHC      1.0.6       - Create getRelateOrdLst
 * 23/04/2019    ONGHC      1.0.7       - Add function getOrdDetail
 * 29/04/2020    ONGHC      1.0.8       - Add function insertSVC0115D
 * 03/04/2023    FANNIE      1.0.9       - Add function updateGPS
 *********************************************************************************************/

@Service("MSvcLogApiService")
public class MSvcLogApiServiceImpl extends EgovAbstractServiceImpl implements MSvcLogApiService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "MSvcLogApiMapper")
  private MSvcLogApiMapper MSvcLogApiMapper;

  @Resource(name = "returnUsedPartsMapper")
  private ReturnUsedPartsMapper returnUsedPartsMapper;

  @Autowired
  private SmsMapper smsMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;

  @Resource(name = "ASManagementListMapper")
  private ASManagementListMapper ASManagementListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "htManualMapper")
  private htManualMapper htManualMapper;

  @Override
  public List<EgovMap> getHeartServiceJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getHeartServiceJobList(params);
  }

  @Override
  public List<EgovMap> getHeartServiceJobList_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getHeartServiceJobList_b(params);
  }

  @Override
  public List<EgovMap> getAfterServiceJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getAfterServiceJobList(params);
  }

  @Override
  public List<EgovMap> getAfterServiceJobList_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getAfterServiceJobList_b(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void saveHearLogs(List<Map<String, Object>> logs) {
    for (Map<String, Object> log : logs) {
      MSvcLogApiMapper.insertHeatLog(log);
    }
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateSuccessStatus(String transactionId) {
    MSvcLogApiMapper.updateSuccessStatus(transactionId);

  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateErrStatus(String transactionId) {
    MSvcLogApiMapper.updateErrStatus(transactionId);
  }

  @Override
  public List<EgovMap> heartServiceParts(Map<String, Object> params) {
    return MSvcLogApiMapper.heartServiceParts(params);
  }

  @Override
  public List<EgovMap> heartServiceParts_b(Map<String, Object> params) {
    return MSvcLogApiMapper.heartServiceParts_b(params);
  }

  @Override
  public List<EgovMap> afterServiceParts(Map<String, Object> params) {
    return MSvcLogApiMapper.afterServiceParts(params);
  }

  @Override
  public List<EgovMap> afterServiceParts_b(Map<String, Object> params) {
    return MSvcLogApiMapper.afterServiceParts_b(params);
  }

  @Override
  public void resultRegistration(List<Map<String, Object>> heartLogs) {
    Map<String, Object> insMap = null;
    int seq = MSvcLogApiMapper.getNextSvc006dSeq();
    String docNo = commonMapper.selectDocNo("11");
    String returnMsg = "";
    String memId = "";

    if (heartLogs.size() > 0) {
      for (int i = 0; i < heartLogs.size(); i++) {
        insMap = heartLogs.get(i);
        memId = MSvcLogApiMapper.getUseridToMemid(insMap);

        insMap.put("bsResultId", seq);
        insMap.put("docNo", docNo);
        insMap.put("typeId", 306); // BEFORE SERVICE
        insMap.put("memId", memId);

        logger.debug("====================resultRegistration=====================");
        logger.debug(" INSTALLATION MAP : {}", insMap);
        logger.debug("====================resultRegistration=====================");

        MSvcLogApiMapper.insertHsResultD(insMap);
      }

      EgovMap hsAssiinlList = MSvcLogApiMapper.selectHsAssiinlList(insMap);
      insMap.put("salesOrdId", hsAssiinlList.get("salesOrdId"));
      insMap.put("schdulId", hsAssiinlList.get("schdulId"));
      // insMap.put("memId", memId); //userid -> memcode
      insMap.put("failResnId", 0);

      if (hsAssiinlList.size() < 0) {
        returnMsg += "baseInfo empty!!";
      }

      insMap.put("resultIsSync", '0');
      insMap.put("resultIsEdit", '0');
      insMap.put("resultStockUse", '1');
      insMap.put("resultIsCurr", '1');
      insMap.put("resultMtchId", '0');
      insMap.put("resultIsAdj", '0');

      insMap.put("resultStusCodeId", '4');
      insMap.put("renColctId", '0');

      MSvcLogApiMapper.insertHsResultSVC0006D(insMap);

      EgovMap getHsResultMList = MSvcLogApiMapper.selectHSResultMList(insMap);
      int scheduleCnt = MSvcLogApiMapper.selectHSScheduleMCnt(insMap);

      if (scheduleCnt > 0) {
        EgovMap insertHsSchedule = new EgovMap();
        // insMap.put("resultStusCodeId",
        // getHsResultMList.get("resultStusCodeId"));
        // insMap.put("actnMemId", getHsResultMList.get("codyId"));

        MSvcLogApiMapper.updateHsSVC0008D(insMap);
      }

      returnUsedPartsMapper.returnPartsInsert(insMap.get("serviceNo").toString());
    }
  }

  @Override
  public void insertInstallationResult(Map<String, Object> params) {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> callEntry = new HashMap<String, Object>();
    Map<String, Object> callResult = new HashMap<String, Object>();
    Map<String, Object> orderLog = new HashMap<String, Object>();

    String serialNo = params.get("serialNo").toString();

    EgovMap installResult = MSvcLogApiMapper.getInstallResultByInstallEntryID(params);
    String usrId = MSvcLogApiMapper.getUseridToMemid(params);

    logger.debug("====================insertInstallationResult=====================");
    logger.debug(" INSTALLATION RESULT : {}", installResult);
    logger.debug("====================insertInstallationResult=====================");

    int statusId = '4'; // INSTALLATION STATUS
    String sirimNo = params.get("sirimNo").toString();
    String userId = params.get("userId").toString(); // CT CODE
    String curTime = new SimpleDateFormat("yyyyMMdd").format(new Date());

    // installResult.put("resultID", 0);
    installResult.put("resultID", 0);
    installResult.put("entryId", installResult.get("installEntryId"));
    installResult.put("statusCodeId", statusId);
    installResult.put("ctid", usrId);

    // installResult.put("installDate", params.get("installDate"));-> todate

    installResult.put("installDate", curTime);
    installResult.put("remark", params.get("resultRemark").toString().trim());
    // installResult.put("GLPost", 0);
    // installResult.put("creator", sessionVO.getUserId());
    installResult.put("created", new Date());
    installResult.put("sirimNo", sirimNo);
    installResult.put("serialNo", serialNo);
    installResult.put("updated", new Date());
    installResult.put("updator", usrId);
    installResult.put("adjAmount", 0);
    installResult.put("statusCodeId", 4);

    resultValue.put("value", "Completed");
    resultValue.put("installEntryNo", installResult.get("installEntryId"));

    params.put("installStatus", 4);

    try {
      insertInstallation(statusId, installResult, callEntry, callResult, orderLog);

      // 물류 호출 add by hgham
      Map<String, Object> logPram = null;
      if (Integer.parseInt(params.get("installStatus").toString()) == 4) {

        ///////////////////////// 물류 호출//////////////////////
        logPram = new HashMap<String, Object>();
        logPram.put("ORD_ID", installResult.get("installEntryNo"));
        logPram.put("RETYPE", "COMPLET");
        logPram.put("P_TYPE", "OD01");
        logPram.put("P_PRGNM", "INSCOM");
        logPram.put("USERID", usrId);

        logger.debug("ORDERCALL 물류 호출 PRAM ===>" + logPram.toString());
        servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(logPram);
        logger.debug("ORDERCALL 물류 호출 결과 ===>");
        ///////////////////////// 물류 호출 END //////////////////////
      }
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }

  private boolean insertInstallation(int statusId, Map<String, Object> installResult, Map<String, Object> callEntry,
      Map<String, Object> callResult, Map<String, Object> orderLog) throws ParseException {
    String maxId = "";
    EgovMap maxIdValue = new EgovMap();
    MSvcLogApiMapper.insertInstallResult(installResult);
    EgovMap entry = installationResultListMapper.selectEntry(installResult);

    logger.debug("====================insertInstallationResult=====================");
    logger.debug(" INSTALLATION ENTRY : {}", entry);

    maxIdValue.put("value", "resultId");
    maxId = installationResultListMapper.selectMaxId(maxIdValue);

    logger.debug(" INSTALLATION RESULT ID : {}", maxId);
    logger.debug("====================insertInstallationResult=====================");

    entry.put("installResultId", maxId);
    entry.put("stusCodeId", installResult.get("statusCodeId"));
    entry.put("updated", installResult.get("created"));
    entry.put("updator", installResult.get("creator"));
    installationResultListMapper.updateInstallEntry(entry);

    return true;
  }

  @Override
  public List<EgovMap> getInstallationJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getInstallationJobList(params);
  }

  @Override
  public List<EgovMap> getInstallationJobList_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getInstallationJobList_b(params);
  }

  @Override
  public List<EgovMap> getProductRetrunJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getProductRetrunJobList(params);
  }

  @Override
  public List<EgovMap> getProductRetrunJobList_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getProductRetrunJobList_b(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void saveAfterServiceLogs(List<Map<String, Object>> asTransLogs) {
    for (Map<String, Object> asTransLog : asTransLogs) {
      MSvcLogApiMapper.insertAsResultLog(asTransLog);
    }
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW) /* Woongjin Jun */
  public void saveInstallServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertInstallServiceLog(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void insert_SVC0026T(Map<String, Object> params) {
    MSvcLogApiMapper.insert_SVC0026T(params);
  }

  @Override
  public int prdResultSync(Map<String, Object> params) {
    return MSvcLogApiMapper.prdResultSync(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateSuccessASStatus(String transactionId) {
    MSvcLogApiMapper.updateSuccessASStatus(transactionId);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateASErrStatus(String transactionId) {
    MSvcLogApiMapper.updateASErrStatus(transactionId);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updatePRStatus(String transactionId) {
    MSvcLogApiMapper.updatePRStatus(transactionId);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updatePRErrStatus(String transactionId) {
    MSvcLogApiMapper.updatePRErrStatus(transactionId);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateSuccessInstallStatus(String transactionId) {
    MSvcLogApiMapper.updateSuccessInstallStatus(transactionId);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateSuccessErrInstallStatus(String transactionId) {
    MSvcLogApiMapper.updateSuccessErrInstallStatus(transactionId);
  }

  @Override
  public List<EgovMap> getRentalCustomerList(Map<String, Object> params) {
    return MSvcLogApiMapper.getRentalCustomerList(params);
  }

  @Override
  public EgovMap productReturnResult(Map<String, Object> params) {
    EgovMap rMp = new EgovMap();

    logger.debug("====================productReturnResult=====================");
    logger.debug(" PARAM : {}", params);

    int log39cnt = MSvcLogApiMapper.insert_LOG0039D(params);
    logger.debug(" TOTAL INSERT RECORD : " + log39cnt);

    if (log39cnt > 0) {
      logger.debug("UPDATE LOG0038D: ");
      int log38cnt = MSvcLogApiMapper.updateState_LOG0038D(params);
      logger.debug("TOTAL UPDATE RECORD LOG0038D: " + log38cnt);

      logger.debug("INSERT SAL0009D: ");
      int sal9dcnt = MSvcLogApiMapper.insert_SAL0009D(params);
      logger.debug("TOTAL INSERT RECORD LOG0038D: " + sal9dcnt);

      logger.debug("UPDATE SAL0020D: ");
      int sal20dcnt = MSvcLogApiMapper.updateState_SAL0020D(params);
      logger.debug("TOTAL UPDATE RECORD SAL0020D: " + sal20dcnt);

      logger.debug("UPDATE SAL0071D: ");
      int sal71dcnt = MSvcLogApiMapper.updateState_SAL0071D(params);
      logger.debug("TOTAL UPDATE RECORD SAL0071D: " + sal71dcnt);
    }

    params.put("P_SALES_ORD_NO", params.get("salesOrderNo"));
    params.put("P_USER_ID", params.get("stkRetnCrtUserId"));
    params.put("P_RETN_NO", params.get("serviceNo"));
    MSvcLogApiMapper.SP_RETURN_BILLING_EARLY_TERMI(params);

    logger.debug("UPDATE SAL0001D: ");
    int sal1dcnt = MSvcLogApiMapper.updateState_SAL0001D(params);
    logger.debug("TOTAL UPDATE RECORD SAL0001D: " + sal1dcnt);

    // 물류 호출 add by hgham
    Map<String, Object> logPram = null;
    ///////////////////////// 물류 호출/////////////////////////
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", params.get("serviceNo"));
    logPram.put("RETYPE", "SVO");
    logPram.put("P_TYPE", "OD91");
    logPram.put("P_PRGNM", "LOG39");
    logPram.put("USERID", MSvcLogApiMapper.getRetnCrtUserId(params));

    logger.debug("productReturnResult 물류  PRAM ===>" + logPram.toString());

    if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
    	servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
    }
    else {
    	servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
    }

    logger.debug("productReturnResult 물류  결과 ===>" + logPram.toString());
    logPram.put("P_RESULT_TYPE", "PR");
    logPram.put("P_RESULT_MSG", logPram.get("p1"));

    if (!"000".equals(logPram.get("p1"))) {
    	throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1")+ ":" + "RETURN PRODUCT Result Error");
    }
    ///////////////////////// 물류 호출 END //////////////////////

    rMp.put("SP_MAP", logPram);

    logger.debug("SP-MAP " + logPram);

    logger.debug("= PARAM = " + params.toString());
    EgovMap searchSAL0001D = MSvcLogApiMapper.newSearchCancelSAL0001D(params);

    logger.debug("====================== PROMOTION COMBO CHECKING - START - ==========================");
    logger.debug("= PARAM = " + searchSAL0001D.toString());

    // CHECK ORDER PROMOTION IS IT FALL ON COMBO PACKAGE PROMOTION
    // 1ST CHECK PCKAGE_BINDING_NO (SUB)
    int count = MSvcLogApiMapper.chkSubPromo(searchSAL0001D);
    logger.info("= CHECK PCKAGE_BINDING_NO (SUB) = " + count);

    if (count > 0) {
      // CANCELLATION IS SUB COMBO PACKAGE.
      // TODO REVERT MAIN PRODUCT PROMO. CODE
      logger.debug("====================== CANCELLATION IS SUB COMBO PACKAGE ==========================");

      EgovMap revCboPckage = MSvcLogApiMapper.revSubCboPckage(searchSAL0001D);
      revCboPckage.put("reqStageId", "25");

      logger.info("= PARAM 2 = " + revCboPckage.toString());
      MSvcLogApiMapper.insertSAL0254D(revCboPckage);

    } else {
      // 2ND CHECK PACKAGE (MAIN)
      count = MSvcLogApiMapper.chkMainPromo(searchSAL0001D);

      if (count > 0) {
        // CANCELLATION IS MAIN COMBO PACKAGE.
        // TODO REVERT SUB PRODUCT PROMO. CODE AND RENTAL PRICE

        logger.debug("====================== CANCELLATION IS MAIN COMBO PACKAGE ==========================");

        EgovMap revCboPckage = MSvcLogApiMapper.revMainCboPckage(searchSAL0001D);
        revCboPckage.put("reqStageId", "25");

        logger.info("= PARAM 2 = " + revCboPckage.toString());
        MSvcLogApiMapper.insertSAL0254D(revCboPckage);
      } else {
        // DO NOTHING (IS NOT A COMBO PACKAGE)
      }
    }
    logger.debug("====================== PROMOTION COMBO CHECKING - END - ==========================");

    logger.debug("====================productReturnResult=====================");

    return rMp;
  }

  @Override
  public int isPrdRtnAlreadyResult(Map<String, Object> params) {
    return MSvcLogApiMapper.isPrdRtnAlreadyResult(params);
  }

  @Override
  public int updFctExch(Map<String, Object> params) {
    return MSvcLogApiMapper.updFctExch(params);
  }

  @Override
  public void setPRFailJobRequest(Map<String, Object> params) {
    logger.debug("setPRFailJobRequest==>" + params.toString());

    logger.debug("====================setPRFailJobRequest=====================");
    logger.debug(" PARAM (BEFORE) : " + params.toString());

    String callEntryID = MSvcLogApiMapper.select_SeqCCR0006D(params);

    params.put("callEntryID", callEntryID);

    String callResultID = MSvcLogApiMapper.select_SeqCCR0007D(params);

    params.put("callResultID", callResultID);

    logger.debug(" PARAM (AFTER) : " + params.toString());

    MSvcLogApiMapper.insert_CCR0006D(params);
    MSvcLogApiMapper.insert_CCR0007D(params);

    int log38cnt = MSvcLogApiMapper.updateFailed_LOG0038D(params);
    int log39cnt = MSvcLogApiMapper.insertFailed_LOG0039D(params);
    MSvcLogApiMapper.updateFailed_SAL0020D(params);

    logger.debug(" TOTAL UPDATE RECORD LOG0038D : " + log38cnt);
    logger.debug(" TOTAL INSERT RECORD LOG0039D : " + log39cnt);

    /*EgovMap  PRFailReason = MSvcLogApiMapper.selectPRFailReason(params);
	params.put("FailReasonCode", PRFailReason.get("code"));


	params.put("userId", "CT100676");
	params.put("handphoneTel", "0165666878");

	logger.debug("================TEMP YONG FOR DEV/LOCAL DEBUG PR - START ================");
	logger.debug("PARAMS :" + params.toString());
	logger.debug("CHECKPOINT  - get handphoneTel:" + params.get("handphoneTel").toString());
	logger.debug("CHECKPOINT  - get userId:" + params.get("userId").toString());
	logger.debug("CHECKPOINT  - get FailReasonCode:" + params.get("FailReasonCode").toString());
	logger.debug("CHECKPOINT  - get appTypeId:" + params.get("appTypeId").toString());
	logger.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - END ================");
    String smsMessage = "";
    if( !(String.valueOf(params.get("appTypeId")).equals("Education") || String.valueOf(params.get("appTypeId")).equals("Free Trial") || String.valueOf(params.get("appTypeId")).equals("Auxiliary"))
    		//&& !(String.valueOf(params.get("stkRetnResnId")).equals("1993"))
    		){
        smsMessage = "COWAY:Dear Customer, Your Appointment for Product collection has failed due to "+ params.get("FailReasonCode").toString() +".Will call to set new appointment.";
     }
    logger.debug("TEST001");

    Map<String, Object> smsList = new HashMap<>();
    smsList.put("userId", params.get("userId").toString());
    smsList.put("userId", String.valueOf(params.get("userId")));
    smsList.put("userId", params.get("userId"));
    logger.debug("TEST002" + params.get("userId"));

    smsList.put("smsType", 975);
    logger.debug("TEST003");

    smsList.put("smsMessage", smsMessage);
    logger.debug("TEST004 " + smsMessage);

    smsList.put("smsMobileNo", params.get("handphoneTel").toString());
    logger.debug("TEST005 :" + params.get("handphoneTel").toString());

    if(smsMessage != "")
    {

    	logger.debug("Into  sendSms");
    	sendSms(smsList);
    }*/

    logger.debug("====================setPRFailJobRequest=====================");
  }

  @Override
  public void aSresultRegistration(List<Map<String, Object>> asTransLogs) {
  }

  @Override
  public AsDetailDto selectAsDetails(AsDetailForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }

    EgovMap selectAsDetails = MSvcLogApiMapper.selectAsDetails(AsDetailForm.createMap(param));
    AsDetailDto rtn = new AsDetailDto();
    if (MapUtils.isNotEmpty(selectAsDetails)) {
      return rtn.create(selectAsDetails);
    }
    return rtn;
  }


  @Override
  public List<EgovMap> serviceHistory(Map<String, Object> params) {
    return MSvcLogApiMapper.serviceHistory(params);
  }

  @Override
  public List<EgovMap> getAsFilterHistoryDList(Map<String, Object> params) {
    return MSvcLogApiMapper.getAsFilterHistoryDList(params);
  }

  @Override
  public List<EgovMap> getAsPartsHistoryDList(Map<String, Object> params) {
    return MSvcLogApiMapper.getAsPartsHistoryDList(params);
  }

  @Override
  public List<EgovMap> getHsFilterHistoryDList(Map<String, Object> params) {
    return MSvcLogApiMapper.getHsFilterHistoryDList(params);
  }

  @Override
  public List<EgovMap> getHsPartsHistoryDList(Map<String, Object> params) {
    return MSvcLogApiMapper.getHsPartsHistoryDList(params);
  }

  @Override
  public Map<String, Object> getAsBasic(Map<String, Object> params) {
    return MSvcLogApiMapper.getAsBasic(params);
  }

  @Override
  public Map<String, Object> selectOutstandingResult(Map<String, Object> params) {
    return MSvcLogApiMapper.selectOutstandingResult(params);
  }

  @Override
  public List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params) {
    return MSvcLogApiMapper.selectOutstandingResultDetailList(params);
  }

  @Override
  public void updateSuccessAsReStatus(String transactionId) {
    MSvcLogApiMapper.insertAsReServiceLog(transactionId);
  }

  @Override
  public void updateSuccessHsReStatus(String transactionId) {
    MSvcLogApiMapper.insertHsReServiceLog(transactionId);
  }

  @Override
  public void updateSuccessInsReStatus(String transactionId) {
    MSvcLogApiMapper.insertInsReServiceLog(transactionId);
  }

  @Override
  public EgovMap getInstallResultByInstallEntryID(Map<String, Object> params) {
    return MSvcLogApiMapper.getInstallResultByInstallEntryID(params);
  }

  @Override
  public String getUseridToMemid(Map<String, Object> params) {
    return MSvcLogApiMapper.getUseridToMemid(params);
  }

  @Override
  public void savePrFailServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertPrFailServiceLog(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void saveInsFailServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertInsFailServiceLog(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateSuccessInsFailServiceLogs(int resultSeq) {
    MSvcLogApiMapper.updateInsFailServiceLog(resultSeq);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void saveAsFailServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertAsFailServiceLog(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void saveHsFailServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertHsFailServiceLog(params);
  }

  @Override
  public void savePrReServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertPrReServiceLog(params);
  }

  @Override
  public void saveInsReServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertInsReServiceLog(params);
  }

  @Override
  public void saveHsReServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertHsReServiceLog(params);
  }

  @Override
  public void saveAsReServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertAsReServiceLog(params);
  }

  @Override
  public Map<String, Object> getHsBasic(Map<String, Object> params) {
    return MSvcLogApiMapper.getHsBasic(params);
  }

  @Override
  public void saveCanSMSServiceLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertCanSMSServiceLog(params);
  }

  @Override
  public void updateReApointResult(Map<String, Object> params) {
    MSvcLogApiMapper.updateReApointResult(params);
  }

  @Override
  public EgovMap selectAsBasicInfo(Map<String, Object> params) {
    return MSvcLogApiMapper.selectAsBasicInfo(params);
  }

  @Override
  public void updateInsReAppointmentReturnResult(Map<String, Object> params) {
    MSvcLogApiMapper.updateInsReAppointmentReturnResult(params);
  }

  @Override
  public void updateHsReAppointmentReturnResult(Map<String, Object> params) {
    MSvcLogApiMapper.updateHsReAppointmentReturnResult(params);
  }

  @Override
  public void updatePrReAppointmentReturnResult(Map<String, Object> params) {
    MSvcLogApiMapper.updateAppTm_LOG0038D(params);
  }

  @Override
  public void saveASRequestRegistrationLogs(Map<String, Object> params) {
    MSvcLogApiMapper.insertASRequestRegistrationLogs(params);
  }

  @Override
  public void updateSuccessRequestRegiStatus(String transactionId) {
    MSvcLogApiMapper.updateSuccessRequestRegiStatus(transactionId);
  }

  @Override
  public void insertASRequestRegist(Map<String, Object> params) {
    MSvcLogApiMapper.insertASRequestRegist(params);
  }

  @Override
  public void insertHsFailJobResult(Map<String, Object> params) {
    MSvcLogApiMapper.insertHsFailJobResult(params);
  }

  @Override
  public void insertAsFailJobResult(Map<String, Object> params) {
    MSvcLogApiMapper.insertAsFailJobResult(params);
  }

  @Override
  public void insertInstallFailJobResult(Map<String, Object> params) {
    MSvcLogApiMapper.insertInstallFailJobResult(params);
  }

  @Override
  public List<EgovMap> getASRequestResultList(Map<String, Object> params) {
    return MSvcLogApiMapper.getASRequestResultList(params);
  }

  @Override
  public List<EgovMap> getASRequestCustList(Map<String, Object> params) {
    return MSvcLogApiMapper.getASRequestCustList(params);
  }

  @Override
  public void upDateHsFailJobResultM(Map<String, Object> params) {
    MSvcLogApiMapper.upDateHsFailJobResultM(params);
  }

  @Override
  public void upDatetAsFailJobResultM(Map<String, Object> params) {
    MSvcLogApiMapper.upDatetAsFailJobResultM(params);
  }

  @Override
  public void upDateInstallFailJobResultM(Map<String, Object> params) {
    MSvcLogApiMapper.upDateInstallFailJobResultM(params);
  }

  @Override
  public void insertCancelSMS(Map<String, Object> params) {
    MSvcLogApiMapper.insertCancelSMS(params);
  }

  @Override
  public void SP_RETURN_BILLING_EARLY_TERMI(Map<String, Object> params) {
    MSvcLogApiMapper.SP_RETURN_BILLING_EARLY_TERMI(params);
  }

  @Override
  public String getcancReqNo(Map<String, Object> params) {
    return MSvcLogApiMapper.getcancReqNo(params);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateInsFailServiceLogs(Map<String, Object> params) {
  }

  @Override
  public String getInstallDate(Map<String, Object> insApiresult) {
    return MSvcLogApiMapper.getInstallDate(insApiresult);
  }

  /* Woongjin Jun */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public int insert_SVC0066T(Map<String, Object> params) {
    return MSvcLogApiMapper.insert_SVC0066T(params);
  }

  /*
   * @Override public void aSresultRegistration(List<Map<String, Object>>
   * asTransLogs) { // TODO Auto-generated method stub
   *
   * Map<String, Object> insMap = null; int r=0;
   *
   * if(asTransLogs.size()>0){
   *
   * insMap.put("DOCNO", "21"); EgovMap eMap =
   * ASManagementListMapper.getASEntryDocNo(insMap); EgovMap seqMap =
   * ASManagementListMapper.getResultASEntryId(insMap);
   *
   * String AS_RESULT_ID = String.valueOf(seqMap.get("seq"));
   *
   * insMap.put("AS_RESULT_ID", AS_RESULT_ID); insMap.put("AS_RESULT_NO",
   * String.valueOf(eMap.get("asno")));
   * insMap.put("updator",insMap.get("updator"));
   *
   * //master insert int c= ASManagementListMapper.insertSVC0004D(insMap);
   *
   * //svc0001d 상태 업데이트 int b=
   * ASManagementListMapper.updateStateSVC0001D(insMap);
   *
   *
   * for (int i = 0; i < asTransLogs.size(); i++) {
   *
   * Map<String, Object> insMapDtail = asTransLogs.get(i); Map<String, Object>
   * iMap = new HashMap();
   *
   * iMap.put("AS_RESULT_ID", AS_RESULT_ID); iMap.put("ASR_ITM_CLM", "0");
   * iMap.put("ASR_ITM_TAX_CODE_ID", "0" ); iMap.put("ASR_ITM_TXS_AMT" , "0" );
   *
   * r = ASManagementListMapper.insertSVC0005D(iMap) ; } } }
   */

  @Override
  public List<EgovMap> getCareServiceJob_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getCareServiceJobList_b(params);
  }

  @Override
  public List<EgovMap> getCareServiceParts_b(Map<String, Object> params) {
    return MSvcLogApiMapper.getCareServiceParts_b(params);
  }

  /* Woongjin Jun */
  @Override
  public List<EgovMap> getCareServiceJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getCareServiceJobList(params);
  }

  @Override
  public List<EgovMap> getHcServiceJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getHcServiceJobList(params);
  }

  @Override
  public void updateHTReAppointmentReturnResult(Map<String, Object> params) {
    MSvcLogApiMapper.updateHTReAppointmentReturnResult(params);
  }

  @Override
  public void insertHtFailJobResult(Map<String, Object> params, SessionVO sessionVO) {
	  int schdulId = Integer.parseInt(params.get("hidschdulId").toString());
	  int nextSeq = htManualMapper.getNextSvc006dSeq();
	  String docNo = commonMapper.selectDocNo("11");

	  EgovMap insertHsResultfinal = new EgovMap();
	  insertHsResultfinal.put("resultId", nextSeq);
	  insertHsResultfinal.put("docNo", docNo);
	  insertHsResultfinal.put("typeId", 306);
	  insertHsResultfinal.put("schdulId", schdulId);
	  insertHsResultfinal.put("salesOrdId", Integer.parseInt(params.get("hidSalesOrdId").toString()));
	  insertHsResultfinal.put("codyId", Integer.parseInt(params.get("hidCodyId").toString()));
	  //insertHsResultfinal.put("setlDt", "01/01/1900");
	  insertHsResultfinal.put("setlDt", null);
      insertHsResultfinal.put("resultStusCodeId", 21);
      insertHsResultfinal.put("failResnId", Integer.parseInt(params.get("failReasonCode").toString()));
      insertHsResultfinal.put("renColctId", 0);
      insertHsResultfinal.put("whId", 0);
      insertHsResultfinal.put("resultRem", "");
      insertHsResultfinal.put("resultCrtUserId", sessionVO.getUserId());
      insertHsResultfinal.put("resultUpdUserId", sessionVO.getUserId());
      insertHsResultfinal.put("resultIsSync", 0);
      insertHsResultfinal.put("resultIsEdit", 0);
      insertHsResultfinal.put("resultStockUse", 0);
      insertHsResultfinal.put("resultIsCurr", 1);
      insertHsResultfinal.put("resultMtchId", 0);
      insertHsResultfinal.put("resultIsAdj", 0);
      insertHsResultfinal.put("temperateSetng", "");
      insertHsResultfinal.put("nextAppntDt", "");
      insertHsResultfinal.put("nextAppointmentTime", "");
      insertHsResultfinal.put("ownerCode", "");
      insertHsResultfinal.put("resultCustName", "");
      insertHsResultfinal.put("resultMobileNo", "");
      insertHsResultfinal.put("resultRptEmailNo", "");
      insertHsResultfinal.put("resultAceptName", "");
      insertHsResultfinal.put("sgnDt", "");

      logger.debug("### insertHsResultfinal : {}", insertHsResultfinal);
      htManualMapper.insertHsResultfinal(insertHsResultfinal);
  }

  @Override
  public void upDateHtFailJobResultM(Map<String, Object> params) {
    MSvcLogApiMapper.upDateHtFailJobResultM(params);
  }

  @Override
  public EgovMap SP_SVC_BARCODE_SAVE(Map<String, Object> params) {
    return (EgovMap)MSvcLogApiMapper.SP_SVC_BARCODE_SAVE(params);
  }

  @Override
  public EgovMap SP_SVC_BARCODE_CHANGE(Map<String, Object> params) {
    return (EgovMap)MSvcLogApiMapper.SP_SVC_BARCODE_CHANGE(params);
  }

  @Override
  public Map<String, Object> getHtBasic(Map<String, Object> params) {
    return MSvcLogApiMapper.getHtBasic(params);
  }

  @Override
  public List<EgovMap> hcServiceHistory(Map<String, Object> params) {
    return MSvcLogApiMapper.hcServiceHistory(params);
  }

  @Override
  public List<EgovMap> selectSerialList(Map<String, Object> params) {
    return MSvcLogApiMapper.selectSerialList(params);
  }

  @Override
  public EgovMap getOrdID(Map<String, Object> params) {
    return MSvcLogApiMapper.getOrdID(params);
  }

  @Override
  public List<EgovMap> getDtInstallationJobList(Map<String, Object> params) {
    return MSvcLogApiMapper.getDtInstallationJobList(params);
  }

  @Override
  public EgovMap getFraOrdInfo(Map<String, Object> params) {
    return MSvcLogApiMapper.getFraOrdInfo(params);
  }

  @Override
  public void updateInsDtReAppointmentReturnResult(Map<String, Object> params) {
	  MSvcLogApiMapper.updateInsReAppointmentReturnResult(params);

	  // Frame Update
	  MSvcLogApiMapper.updateInsDtReAppointmentReturnResult(params);
  }

  @Override
  public EgovMap getPrdRtnDelvryNo(Map<String, Object> params) {
    return MSvcLogApiMapper.getPrdRtnDelvryNo(params);
  }

  @Override
  public EgovMap getPrFraOrdInfo(Map<String, Object> params) {
    return MSvcLogApiMapper.getPrFraOrdInfo(params);
  }

  @Override
  public String getBeforeProductSerialNo(Map<String, Object> params) {
    return MSvcLogApiMapper.getBeforeProductSerialNo(params);
  }
  /* Woongjin Jun */

  /* Woongjin Han */
  @Override
  public EgovMap getDelvryNo(Map<String, Object> params) {
    return MSvcLogApiMapper.getDelvryNo(params);
  }
  /* Woongjin Han */

  @Override
  public List<EgovMap> getRelateOrdLst(Map<String, Object> params) {
    return MSvcLogApiMapper.getRelateOrdLst(params);
  }

  @Override
  public List<EgovMap> getOrdDetail(Map<String, Object> params) {
    return MSvcLogApiMapper.getOrdDetail(params);
  }

  @Override
  public String selectSVC0115D(Map<String, Object> params) {
    return MSvcLogApiMapper.selectSVC0115D(params);
  }

  @Override
  public void insertSVC0115D(Map<String, Object> params) {
    MSvcLogApiMapper.insertSVC0115D(params);
  }

  @Override
  public List<EgovMap> searchRentalCollectionByBSNewList(Map<String, Object> params) {
    return MSvcLogApiMapper.searchRentalCollectionByBSNewList(params);
  }

  @Autowired
  private AdaptorService adaptorService;

 /* @Override
  public void sendSms(Map<String, Object> smsList){
    //int userId = (int) smsList.get("userId");

    int userId = 1234;
    SmsVO sms = new SmsVO(userId, 975);

    logger.debug("Trobleshooting >> userId ::" + userId);
    logger.debug("Trobleshooting >> sms ::" + sms);

    sms.setMessage(smsList.get("smsMessage").toString());
    sms.setMobiles(smsList.get("smsMobileNo").toString());

    logger.debug("Trobleshooting >> smsMessage ::" + smsList.get("smsMessage").toString());
    logger.debug("Trobleshooting >> smsMobileNo ::" + smsList.get("smsMobileNo").toString());

    //send SMS
    SmsResult smsResult = adaptorService.sendSMS(sms);

    logger.debug("Trobleshooting 0099");
  }*/

  @Override
  public JsonObject updateGPS(Map<String, Object> params) {
    JsonObject rtnUpdateGpsObj = new JsonObject();
    JsonObject jsonReturn = new JsonObject();

    logger.debug("##### updateGps params values: {} #####", params.toString());

    Map<String,Object> updateGpsMap = new HashMap<String,Object>();
    Map<String,Object> custAddDtlLst = new HashMap<String,Object>();

    String oRtnCode = "";
    String oRtnMsg = "";
    try {
        custAddDtlLst = MSvcLogApiMapper.getCustAddDtlLst(params);

        if((params.get("currentGpsValLat") != "" || params.get("currentGpsValLat") != null) && (params.get("currentGpsValLong") !="" || params.get("currentGpsValLong") != null)){
            updateGpsMap.put("salesOrderNo", params.get("salesOrderNo"));
            updateGpsMap.put("currentGpsValLat", params.get("currentGpsValLat"));
            updateGpsMap.put("currentGpsValLong", params.get("currentGpsValLong"));
            updateGpsMap.put("crtUserId", params.get("userId"));
            updateGpsMap.put("custAddId", custAddDtlLst.get("addId").toString());

            MSvcLogApiMapper.updateGps(updateGpsMap);
            jsonReturn.addProperty("oRtnCode", "TRUE");
            jsonReturn.addProperty("oRtnMsg", "-");
        }

        return jsonReturn;
    }catch(Exception e) {
        logger.error("##### Unexception error on updateGps:  #####"+e.toString());
        e.printStackTrace();

        jsonReturn.addProperty("oRtnCode", "FALSE");
        jsonReturn.addProperty("oRtnMsg", e.toString());

        return jsonReturn;
    }
  }

  @Override
  public List<EgovMap> getCustNRIC(Map<String, Object> params) {
    return MSvcLogApiMapper.getCustNRIC(params);
  }
}
