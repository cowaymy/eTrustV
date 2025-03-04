package com.coway.trust.biz.services.orderCall.impl;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.biz.services.orderCall.vo.ChatbotCallLogResult;
import com.coway.trust.biz.services.orderCall.vo.ChatbotCallLogResult.Result;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.services.installation.InstallationResultListController;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 31/01/2019    ONGHC      1.0.1       - Add insertCallResult_2 to replace insertCallResult
 *********************************************************************************************/

@Service("orderCallListService")
public class OrderCallListServiceImpl extends EgovAbstractServiceImpl implements OrderCallListService {

  private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "orderCallListMapper")
  private OrderCallListMapper orderCallListMapper;

  @Resource(name = "memberListMapper")
  private MemberListMapper memberListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Value("${etrust.base.url}")
  private String etrustBaseUrl;

	@Value("${cbt.api.client.username}")
	private String CBTApiClientUser;

	@Value("${cbt.api.client.password}")
	private String CBTApiClientPassword;

    @Value("${cbt.api.url.domains.callLog}")
    private String CBTApiDomains;

    @Value("${cbt.api.url.callLogAppointmentReq}")
    private String CBTApiUrlCallLogAppointmentReq;

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
  public Map<String, Object> insertCallResult(Map<String, Object> params, SessionVO sessionVO) {
    String salesOrdNo = params.get("salesOrdNo").toString();
    String installationNo = "";
    Map<String, Object> resultValue = new HashMap<String, Object>();
    if (sessionVO != null) {
      Map<String, Object> callMaster = getSaveCallCenter(params, sessionVO);
      Map<String, Object> callDetails = getSaveCallDetails(params, sessionVO);
      Map<String, Object> installMaster = new HashMap<String, Object>();
      Map<String, Object> orderLogList = new HashMap<String, Object>();
      if (Integer.parseInt(params.get("callStatus").toString()) == 20) {
        installMaster = getSaveInstallMaster(params, sessionVO);
        orderLogList = getSaveOrderLogList(params, sessionVO);
      }

      String returnNo = "";
      boolean success = false;
      resultValue = orderCallLogSave(callMaster, callDetails, installMaster, orderLogList, salesOrdNo, params);

    }

    return resultValue;
  }

  @Transactional
  private Map<String, Object> orderCallLogSave(Map<String, Object> callMaster, Map<String, Object> callDetails,
      Map<String, Object> installMaster, Map<String, Object> orderLogList, String salesOrdNo,
      Map<String, Object> params) {
    String returnNo = "";
    String maxId = ""; // 각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    EgovMap maxIdValue = new EgovMap();
    EgovMap callEntry = orderCallListMapper.selectCallEntry(callMaster);
    EgovMap installNo = new EgovMap();
    Map<String, Object> logPram = new HashMap<String, Object>();

    if (callEntry != null) {
      // Insert CALL LOG RESULT
      orderCallListMapper.insertCallResult(callDetails);

      // UPDATE CALL LOG ENTRY
      returnNo = callEntry.get("callEntryId").toString();
      callEntry.put("statusCodeId", callMaster.get("statusCodeId"));

      // RESULTID 값 가져오기
      maxIdValue.put("value", "callResultId");
      maxId = orderCallListMapper.selectMaxId(maxIdValue);
      // RESULT 값 가져와서 CallEntry에 저장
      callEntry.put("resultId", maxId);
      if (Integer.parseInt(callMaster.get("statusCodeId").toString()) == 19
          || Integer.parseInt(callMaster.get("statusCodeId").toString()) == 30) {
        callEntry.put("callDate", callMaster.get("callDate"));
      }
      callEntry.put("isWaitForCancel", callMaster.get("isWaitForCancel"));
      callEntry.put("updated", callMaster.get("updated"));
      callEntry.put("updator", callMaster.get("updator"));
      orderCallListMapper.updateCallEntry(callEntry);
      int callEntId = 0;
      if (installMaster.get("callEntryId") != null && installMaster.get("callEntryId") != "") {
        callEntId = Integer.parseInt(installMaster.get("callEntryId").toString());
      }
      if (installMaster != null && callEntId > 0) {

        // INSERT INSTALL ENTRY
        installNo = getDocNo("9");
        returnNo = installNo.get("docNo").toString();
        int ID = 9;
        String nextDocNo = getNextDocNo("INS", installNo.get("docNo").toString());
        installNo.put("nextDocNo", nextDocNo);
        logger.debug("installNo : {}", installNo);

        // UPDATE DOC NO
        memberListMapper.updateDocNo(installNo);

        installMaster.put("installEntryNo", installNo.get("docNo"));// 물류 보낼때
                                                                    // installEntryNo
                                                                    // 필요함
        logger.debug("installMaster : {}", installMaster);
        orderCallListMapper.insertInstallEntry(installMaster);

        if (Integer.parseInt(params.get("callStatus").toString()) == 20) {
          ///////////////////////// 물류 호출//////////////////////
          logPram.put("ORD_ID", installNo.get("docNo"));
          logPram.put("RETYPE", "SVO");
          logPram.put("P_TYPE", "OD01");
          logPram.put("P_PRGNM", "OCALL");
          logPram.put("USERID", Integer.parseInt(String.valueOf(callMaster.get("updator"))));

          logger.debug("ORDERCALL 물류 호출 PRAM ===>" + logPram.toString());
          servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
          logPram.put("P_RESULT_TYPE", "IN");
          logPram.put("P_RESULT_MSG", logPram.get("p1"));
          logger.debug("ORDERCALL 물류 호출 결과 ===>");
          ///////////////////////// 물류 호출 END //////////////////////

          // ONGHC - START
          // START UPDATE SVC0001D'S AS_CALLLOG_ID FOR ADD ON COMPONENT
          EgovMap salesEntry = orderCallListMapper.selectOrderEntry(salesOrdNo);
          if (salesEntry != null) {
            logger.debug("salesEntry " + salesEntry);
            if (salesEntry.get("cpntId") != null && !salesEntry.get("cpntId").toString().equals("")) {
              if (Integer.parseInt(salesEntry.get("cpntId").toString()) > 0) { // IS
                                                                               // NOT
                                                                               // DEFAULT
                                                                               // SET
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
      if (orderLogList != null && orderLogList.size() > 0
          && Integer.parseInt(callMaster.get("statusCodeId").toString()) == 20) {
        orderLogList.put("refId", installMaster.get("installEntryId").toString());
        orderCallListMapper.insertSalesOrderLog(orderLogList);
      }

    }
    Map<String, Object> resultValue = new HashMap<String, Object>();
    String installationNo = "";
    if (installNo.get("docNo") != null && installNo.get("docNo") != "") {
      installationNo = installNo.get("docNo").toString();
    }
    resultValue.put("installationNo", installationNo);
    resultValue.put("salesOrdNo", salesOrdNo);
    resultValue.put("spMap", logPram);

    return resultValue;
  }

@Override
  public Map<String, Object> insertCallResult_2(Map<String, Object> params, SessionVO sessionVO) {
    Map<String, Object> resultValue = new HashMap<String, Object>();

    if (sessionVO != null) {
      Map<String, Object> callMaster = getSaveCallCenter(params, sessionVO);
      Map<String, Object> callDetails = getSaveCallDetails(params, sessionVO);
      Map<String, Object> installMaster = new HashMap<String, Object>();
      Map<String, Object> orderLogList = new HashMap<String, Object>();
      Map<String, Object> logPram = new HashMap<String, Object>();
      EgovMap installNo = new EgovMap();
      boolean stat = false;
      String pType = "";
      String pPrgm = "";

      if (Integer.parseInt(params.get("callStatus").toString()) == 20) {
        installMaster = getSaveInstallMaster(params, sessionVO);
        orderLogList = getSaveOrderLogList(params, sessionVO);

        installMaster.put("CTSSessionCode", params.get("CTSSessionCode"));
        installMaster.put("CTSSessionSegmentType", params.get("CTSSessionSegmentType"));

        // INSERT INSTALL ENTRY
        installNo = getDocNo("9");
        //returnNo = installNo.get("docNo").toString();
        int ID = 9;
        String nextDocNo = getNextDocNo("INS", installNo.get("docNo").toString());
        installNo.put("nextDocNo", nextDocNo);
        logger.debug("installNo : {}", installNo);

        // UPDATE DOC NO
        memberListMapper.updateDocNo(installNo);

        installMaster.put("installEntryNo", installNo.get("docNo"));
        logger.debug("installMaster : {}", installMaster);

        int callEntId = 0;
        if (installMaster.get("callEntryId") != null && installMaster.get("callEntryId") != "") {
          callEntId = Integer.parseInt(installMaster.get("callEntryId").toString());
        }

        logger.debug("### callEntryId: " + callEntId);

        // IF installMaster NOT EMPTY AND INSIDE installMaster CONTAIN CALL ENTRY ID
        if (installMaster != null && callEntId > 0) {
          // PRE INSERT INSTALL ENTRY
          installMaster.put("installEntryId",orderCallListMapper.installEntryIdSeq());

          orderCallListMapper.insertInstallEntry(installMaster);
        }

        if (params.get("callTypeId").equals("258")) { // PRODUCT RETURN
          pType = "OD53";
          pPrgm = "PEXCALL";
        } else {
          pType = "OD01";
          pPrgm = "OCALL";
        }

        ///////////////////////// 물류 호출//////////////////////
        logPram.put("ORD_ID", installMaster.get("installEntryNo"));
        logPram.put("RETYPE", "SVO");
        logPram.put("P_TYPE", pType);
        logPram.put("P_PRGNM", pPrgm);
        logPram.put("USERID", Integer.parseInt(String.valueOf(sessionVO.getUserId())));

        logger.debug("ORDERCALL 물류 호출 PRAM ===>" + logPram.toString());
        if(params.get("hiddenATP").equals("Y")){
        	servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_STO(logPram);
        }else{
        	servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
        }
        logPram.put("P_RESULT_TYPE", "IN");
        logPram.put("P_RESULT_MSG", logPram.get("p1"));
        logger.debug("ORDERCALL 물류 호출 결과 ===>");
        ///////////////////////// 물류 호출 END //////////////////////

        logger.debug("logPram.get(p1) ===>" + logPram.get("p1"));
        if (!"000".equals(logPram.get("p1"))) {
          stat = false;
          // REMOVE INSTALL ENTRY
          if (installMaster != null && callEntId > 0) {
            // PRE INSERT INSTALL ENTRY
            orderCallListMapper.deleteInstallEntry(installMaster);
          }
        } else {
          stat = true;
          servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(logPram);
        }

      } else {
        stat = true; // RECALL / WAITING FOR CANCEL
      }

      if (stat) {
        resultValue = orderCallLogSave_2(callMaster, callDetails, installMaster, orderLogList,
            params.get("salesOrdNo").toString(), params);
      }

      if (stat) {
        resultValue.put("logStat", "0");
      } else {
        resultValue.put("logStat", "1");
      }
    }
	return resultValue;
  }

  @Transactional
  private Map<String, Object> orderCallLogSave_2(Map<String, Object> callMaster, Map<String, Object> callDetails,
      Map<String, Object> installMaster, Map<String, Object> orderLogList, String salesOrdNo,
      Map<String, Object> params) {

    // String returnNo = "";
    String maxId = "";
    EgovMap maxIdValue = new EgovMap();
    // EgovMap installNo = new EgovMap();
    Map<String, Object> logPram = new HashMap<String, Object>();
    EgovMap salesVerify = new EgovMap();

    // GET CALL LOG MASTER INFORMATION CCR0006D
    EgovMap callEntry = orderCallListMapper.selectCallEntry(callMaster);
    EgovMap installNo = new EgovMap();
    String returnNo = "";

    if (callEntry != null) {
      // INSERT CALL LOG RESULT CCR0007D
      orderCallListMapper.insertCallResult(callDetails);

      // UPDATE CALL LOG ENTRY
      // returnNo = callEntry.get("callEntryId").toString();
      callEntry.put("statusCodeId", callMaster.get("statusCodeId"));

      maxIdValue.put("value", "callResultId");
      maxIdValue.put("callEntryId", callEntry.get("callEntryId"));
      maxId = orderCallListMapper.selectMaxId(maxIdValue);
      callEntry.put("resultId", maxId);

      if (Integer.parseInt(callMaster.get("statusCodeId").toString()) == 19
          || Integer.parseInt(callMaster.get("statusCodeId").toString()) == 30) {
        callEntry.put("callDate", callMaster.get("callDate"));
      }

      callEntry.put("isWaitForCancel", callMaster.get("isWaitForCancel"));
      callEntry.put("updated", callMaster.get("updated"));
      callEntry.put("updator", callMaster.get("updator"));
      // UPDATE CALL LOG MASTER TBL CCR0006D
      orderCallListMapper.updateCallEntry(callEntry);

      int callEntId = 0;
      if (installMaster.get("callEntryId") != null && installMaster.get("callEntryId") != "") {
        callEntId = Integer.parseInt(installMaster.get("callEntryId").toString());
      }

      // IF installMaster NOT EMPTY AND INSIDE installMaster CONTAIN CALL ENTRY
      // ID
      if (installMaster != null && callEntId > 0) {
        // INSERT INSTALL ENTRY
        //orderCallListMapper.insertInstallEntry(installMaster);

        if (Integer.parseInt(params.get("callStatus").toString()) == 20) {
          // ONGHC - START
          // START UPDATE SVC0001D'S AS_CALLLOG_ID FOR ADD ON COMPONENT
          EgovMap salesEntry = orderCallListMapper.selectOrderEntry(salesOrdNo);
          if (salesEntry != null) {
            logger.debug("salesEntry " + salesEntry);
            if (salesEntry.get("cpntId") != null && !salesEntry.get("cpntId").toString().equals("")) {
              if (Integer.parseInt(salesEntry.get("cpntId").toString()) > 0) { // IS
                                                                               // NOT
                                                                               // DEFAULT
                                                                               // SET
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
      if (orderLogList != null && orderLogList.size() > 0
          && Integer.parseInt(callMaster.get("statusCodeId").toString()) == 20) {
        orderLogList.put("refId", installMaster.get("installEntryId").toString());
        orderCallListMapper.insertSalesOrderLog(orderLogList);
      }

      if(params.get("verify") != null){
        //orderCallListMapper.insertSalesVerification(params);
        orderCallListMapper.updateSalesVerification(params);
      }

    }
    Map<String, Object> resultValue = new HashMap<String, Object>();
    String installationNo = "";
    if (installMaster.get("installEntryNo") != null && installMaster.get("installEntryNo") != "") {
      installationNo = installMaster.get("installEntryNo").toString();
    }

    resultValue.put("installationNo", installationNo);
    resultValue.put("salesOrdNo", salesOrdNo);

    return resultValue;
  }

  public String getNextDocNo(String prefixNo, String docNo) {
    String nextDocNo = "";
    int docNoLength = 0;
    System.out.println("!!!" + prefixNo);
    if (prefixNo != null && prefixNo != "") {
      docNoLength = docNo.replace(prefixNo, "").length();
      docNo = docNo.replace(prefixNo, "");
    } else {
      docNoLength = docNo.length();
    }

    int nextNo = Integer.parseInt(docNo) + 1;
    nextDocNo = String.format("%0" + docNoLength + "d", nextNo);
    logger.debug("nextDocNo : {}", nextDocNo);
    return nextDocNo;
  }

  public EgovMap getDocNo(String docNoId) {
    int tmp = Integer.parseInt(docNoId);
    String docNo = "";
    EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
    logger.debug("selectDocNo : {}", selectDocNo);
    String prefix = "";

    if (Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp) {

      if (selectDocNo.get("c2") != null) {
        prefix = (String) selectDocNo.get("c2");
      } else {
        prefix = "";
      }
      docNo = prefix.trim() + (String) selectDocNo.get("c1");
      // prefix = (selectDocNo.get("c2")).toString();
      logger.debug("prefix : {}", prefix);
      selectDocNo.put("docNo", docNo);
      selectDocNo.put("prefix", prefix);
    }
    return selectDocNo;
  }

  private Map<String, Object> getSaveOrderLogList(Map<String, Object> params, SessionVO sessionVO) {
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

  private Map<String, Object> getSaveInstallMaster(Map<String, Object> params, SessionVO sessionVO) {
    Map<String, Object> installMaster = new HashMap<String, Object>();
    int CTId = 0;
    CTId = Integer.parseInt(params.get("CTID").toString());
    // CT 받아오는거 다시 확인
    String appointmentDate = "";
    if (params.get("appDate") != null) {
      appointmentDate = params.get("appDate").toString();
    }
    String CTGroup = "";
    if (params.get("CTgroup") != null) {
      CTGroup = params.get("CTgroup").toString();
    }
    installMaster.put("installEntryId", 0);
    installMaster.put("installEntryNo", "");
    installMaster.put("salesOrderId", params.get("salesOrdId"));
    installMaster.put("statusCodeId", 1);
    installMaster.put("CTID", CTId);
    installMaster.put("installDate", appointmentDate);
    installMaster.put("appDate", appointmentDate);
    installMaster.put("callEntryId", params.get("callEntryId"));
    installMaster.put("installStkId",  CommonUtils.intNvl(params.get("hiddenProductId")));
    installMaster.put("installResultId", 0);
    installMaster.put("created", new Date());
    installMaster.put("creator", sessionVO.getUserId());
    installMaster.put("allowComm", false);
    installMaster.put("isTradeIn", false);
    installMaster.put("CTGroup", CTGroup);
    installMaster.put("updated", new Date());
    installMaster.put("updator", sessionVO.getUserId());
    installMaster.put("revId", 0);
    installMaster.put("stock", params.get("stock"));
    logger.debug("installMaster : {}", installMaster);
    return installMaster;
  }

  private Map<String, Object> getSaveCallDetails(Map<String, Object> params, SessionVO sessionVO) {
    Map<String, Object> callDetails = new HashMap<String, Object>();
    String recallDate = "";
    if (params.get("recallDate") != "") {
      recallDate = params.get("recallDate").toString();
    }
    String appointmentDate = "";
    if (params.get("appDate") != null) {
      appointmentDate = params.get("appDate").toString();
    }
    int feedbackId = 0;
    if (Integer.parseInt(params.get("feedBackCode").toString()) > 0) {
      feedbackId = Integer.parseInt(params.get("feedBackCode").toString());
    }
    int CTId = 0;
    if (params.get("CTID") != null && params.get("CTID") != "") {
      CTId = Integer.parseInt(params.get("CTID").toString());
    }
    // if(params.get("CT").TO) CT 내용 가져오는거 해야함
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

  private Map<String, Object> getSaveCallCenter(Map<String, Object> params, SessionVO sessionVO) {
    Map<String, Object> callMaster = new HashMap<String, Object>();
    boolean IsWaitCancel = false;
    if (Integer.parseInt(params.get("callStatus").toString()) == 30) {
      IsWaitCancel = true;
    }
    String recallDate = "";
    if (params.get("recallDate") != "") {
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
    callMaster.put("oriCallDate", "01/01/1900");
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

  @Override
  public List<EgovMap> selectCallLogTyp() {
    return orderCallListMapper.selectCallLogTyp();
  }

  @Override
  public List<EgovMap> selectCallLogSta() {
    return orderCallListMapper.selectCallLogSta();
  }

  @Override
  public List<EgovMap> selectCallLogSrt() {
    return orderCallListMapper.selectCallLogSrt();
  }

  @Override
  public int chkRcdTms(Map<String, Object> params) {
    return orderCallListMapper.chkRcdTms(params);
  }

  @Override
  public int selRcdTms(Map<String, Object> params) {
    return orderCallListMapper.selRcdTms(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> insertCallResultSerial(Map<String, Object> params, SessionVO sessionVO) {
	  Map<String, Object> resultValue = new HashMap<String, Object>();

	  if (sessionVO != null) {
		  Map<String, Object> callMaster = getSaveCallCenter(params, sessionVO);
          Map<String, Object> callDetails = getSaveCallDetails(params, sessionVO);
          Map<String, Object> installMaster = new HashMap<String, Object>();
          Map<String, Object> orderLogList = new HashMap<String, Object>();
          Map<String, Object> logPram = new HashMap<String, Object>();
          EgovMap installNo = new EgovMap();
          boolean stat = false;
          String pType = "";
          String pPrgm = "";
          String docNo = "";
          int callEntId = 0;
          String smsMessage = "";

          if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
        	  installMaster = getSaveInstallMaster(params, sessionVO);
        	  orderLogList = getSaveOrderLogList(params, sessionVO);

        	  // INSERT INSTALL ENTRY
        	  installNo = getDocNo("9");
        	  docNo = CommonUtils.nvl(installNo.get("docNo"));
        	  callEntId = CommonUtils.intNvl(installMaster.get("callEntryId").toString());

        	  String nextDocNo = getNextDocNo("INS", docNo);
        	  installNo.put("nextDocNo", nextDocNo);

        	  // UPDATE DOC NO
              memberListMapper.updateDocNo(installNo);

              installMaster.put("installEntryNo", docNo);

              // IF installMaster NOT EMPTY AND INSIDE installMaster CONTAIN CALL ENTRY ID
              if (installMaster != null && Integer.compare(callEntId, 0) > 0) {
            	  // PRE INSERT INSTALL ENTRY
            	  installMaster.put("installEntryId",orderCallListMapper.installEntryIdSeq());
            	  logger.debug("##################### {}", params.get("productCat"));
                  if ("ACI".equals(params.get("productCat"))) {
                	  try{
                			BitMatrix bitMatrix = new MultiFormatWriter().encode(etrustBaseUrl+"/homecare/services/install/getAcInstallationInfo.do?insNo="+docNo, BarcodeFormat.QR_CODE, 200, 200);

                      		ByteArrayOutputStream bos = new ByteArrayOutputStream();
                      		MatrixToImageWriter.writeToStream(bitMatrix, "png", bos);
                      		installMaster.put("insQr", bos.toByteArray());
                	  }catch(Exception e){
                		  logger.debug("No Qr generated");
                	  }
                  }
            	  orderCallListMapper.insertInstallEntry(installMaster);
              }

              if (params.get("callTypeId").equals("258")) { // PRODUCT RETURN
            	  pType = "OD53";
            	  pPrgm = "PEXCALL";
              } else {
            	  pType = "OD01";
            	  pPrgm = "OCALL";
              }

              ///////////////////////// 물류 호출//////////////////////
              logPram.put("ORD_ID", docNo);
              logPram.put("RETYPE", "SVO");
              logPram.put("P_TYPE", pType);
              logPram.put("P_PRGNM", pPrgm);
              logPram.put("USERID", CommonUtils.intNvl(sessionVO.getUserId()));

              logger.debug("ORDERCALL 물류 호출 PRAM ===>" + logPram.toString());
              servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
              logPram.put("P_RESULT_TYPE", "IN");
              logPram.put("P_RESULT_MSG", logPram.get("p1"));
              logger.debug("ORDERCALL 물류 호출 결과 ===>");
              ///////////////////////// 물류 호출 END //////////////////////

              if (!"000".equals(logPram.get("p1"))) {
            	  stat = false;
            	  // REMOVE INSTALL ENTRY
            	  if (installMaster != null && callEntId > 0) {
            		  // PRE INSERT INSTALL ENTRY
            		  orderCallListMapper.deleteInstallEntry(installMaster);
            	  }
              } else {
            	  stat = true;
            	  servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(logPram);
              }

              /*if(params.get("appType").toString() != "EDU" && params.get("appType").toString() != "TRL" && params.get("appType").toString() != "AUX"){
                smsMessage = "COWAY:Dear Customer, Ur Appt for Installation is set on "+ installMaster.get("appDate") +".For Enquiry 1-800-1000.";

                Map<String, Object> smsList = new HashMap<>();
                smsList.put("userId", sessionVO.getUserId());
                smsList.put("smsType", 975);
                smsList.put("smsMessage", smsMessage);
                smsList.put("smsMobileNo", "0175977998");
                //smsList.put("smsMobileNo", params.get("telM").toString());

                sendSms(smsList);
              }*/
          } else {
        	  stat = true; // RECALL / WAITING FOR CANCEL
          }

          if (stat) {
        	  resultValue = orderCallLogSave_2(callMaster, callDetails, installMaster, orderLogList, CommonUtils.nvl(params.get("salesOrdNo")), params);
          }
          if (stat) {
        	  resultValue.put("logStat", "0");
          } else {
        	  resultValue.put("logStat", "1");
          }
	  }
	  return resultValue;
  }

  @Override
  public List<EgovMap> selectPromotionList() {
    return orderCallListMapper.selectPromotionList();
  }

  @Override
  public void sendSms(Map<String, Object> smsList){
    int userId = (int) smsList.get("userId");
    SmsVO sms = new SmsVO(userId, 975);

    sms.setMessage(smsList.get("smsMessage").toString());
    sms.setMobiles(smsList.get("smsMobileNo").toString());
    //send SMS
    SmsResult smsResult = adaptorService.sendSMS(sms);
  }

	@Override
	public Map<String, Object> callLogSendSMS(Map<String, Object> params, SessionVO sessionVO) {
		Map<String, Object> smsResultValue = new HashMap<String, Object>();
		String smsMessage = "";

		try{
		  //SMS for OrderCal Appointment
		    smsMessage = "COWAY: Order " + params.get("salesOrdNo").toString() + ", Janji temu anda utk Pemasangan Produk ditetapkan pada " + params.get("appDate").toString()
		    		+ ". Sebarang pertanyaan, sila hubungi 1800-888-111.";

		    params.put("chkSMS", CommonUtils.nvl(params.get("chkSMS"))); //to prevent untick SMS

		    logger.debug("//SMS params" + params.toString());

		       if(params.get("appType").equals("REN") || params.get("appType").equals("TRLREN") || params.get("appType").equals("OUT") || params.get("appType").equals("INS"))//IF APPTYPE = RENTAL/OUTRIGHT/INSTALLMENT
		       {
		    	   logger.debug("//IN SMS1");

		    	   if(params.get("callStatus").equals("20") && params.get("feedBackCode").equals("225") //IF CALL LOG STATUS == READY TO INSTALL, IF FEEDBACK CODE == READY TO DO
		    			   && params.get("custType").equals("Individual") && params.get("chkSMS").equals("on")){ //IF CUST_TYPE = INDIVIDUAL , IF CHECKED SMS CHECKBOX)

		           	       Map<String, Object> smsList = new HashMap<>();
		                   smsList.put("userId", sessionVO.getUserId());
		                   smsList.put("smsType", 975);
		                   smsList.put("smsMessage", smsMessage);
		                   smsList.put("smsMobileNo", params.get("custMobileNo").toString());

		                   sendSms(smsList);
		    	   }
		      }
		    }catch(Exception e){
		    	logger.info("Fail to send SMS to " + params.get("custMobileNo").toString());
		    	smsResultValue.put("smsLogStat", "3");
		    }finally{
				logger.info("===resultValueFail===" + smsResultValue.toString()); //when failed to send sms
		    }

		smsResultValue.put("smsLogStat", "0");//if success
		logger.info("===resultValue===" + smsResultValue.toString());
		return smsResultValue;
	}

	  @Override
	  public List<EgovMap> getCallLogAppointmentList(Map<String, Object> params) {
	    return orderCallListMapper.getCallLogAppointmentList(params);
	  }

	  @Override
	  public ReturnMessage blastCallLogAppointmentList(Map<String, Object> params){
		  ReturnMessage message = new ReturnMessage();
		  List<EgovMap> appointmentList = orderCallListMapper.getCallLogAppointmentsInfo(params);

		  List<EgovMap> customers = new ArrayList();
			String defaultExpiry = orderCallListMapper.getCallLogExpirySetting();

			//Safety check for if setting not applied
			if(defaultExpiry.equals("")){
				defaultExpiry = "24";
			}

		  if(appointmentList.size() > 0){
				for(int i=0; i<appointmentList.size();i++){
					EgovMap appointmentDtl = appointmentList.get(i);

					//Check RDC Stock before add
					EgovMap orderParam = new EgovMap();
					orderParam.put("salesOrdNo", CommonUtils.nvl(appointmentDtl.get("salesOrdNo")));
					orderParam.put("productCode", CommonUtils.nvl(appointmentDtl.get("stkCode")));

					if(CommonUtils.nvl(appointmentDtl.get("hcIndicator")).equals("Y")){
						orderParam.put("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
						orderParam.put("productCat", CommonUtils.nvl(appointmentDtl.get("stockCatCode")));
					}

					EgovMap rdcStock = orderCallListMapper.selectRdcStock(orderParam);

					if (rdcStock == null || Integer.parseInt(CommonUtils.nvl2(rdcStock.get("availQty"),"0")) == 0) {
							/*Failed due to no stock*/
					      message.setMessage("No RDC stock found for Order No: " + CommonUtils.nvl(appointmentDtl.get("salesOrdNo")));
					      message.setCode("99");
					      return message;
					}else{
						EgovMap customerInfo = new EgovMap();
						customerInfo.put("requestId", CommonUtils.nvl(appointmentDtl.get("callEntryId")));
						customerInfo.put("type", CommonUtils.nvl("order"));
						customerInfo.put("language", CommonUtils.nvl("en"));
						customerInfo.put("customerName", CommonUtils.nvl(appointmentDtl.get("custName")));
						customerInfo.put("phoneNumber", CommonUtils.nvl(appointmentDtl.get("telNo")));
						customerInfo.put("last6DigitNric", CommonUtils.nvl(appointmentDtl.get("last6Nric")));
						customerInfo.put("orderNo", CommonUtils.nvl(appointmentDtl.get("salesOrdNo")));
						customerInfo.put("productImage", CommonUtils.nvl(appointmentDtl.get("productImage")));
						customerInfo.put("productModel", CommonUtils.nvl(appointmentDtl.get("productModel")));
						customerInfo.put("monthlyRentalFees", CommonUtils.nvl(appointmentDtl.get("mthRentAmt")));
						customerInfo.put("contractPeriod", CommonUtils.nvl(appointmentDtl.get("contractPeriod")));
						customerInfo.put("installationAddress", CommonUtils.nvl(appointmentDtl.get("addrDtl")));
						customerInfo.put("showTnc", true);
						customerInfo.put("tncFile", CommonUtils.nvl(appointmentDtl.get("tncFileName")));
						customerInfo.put("expireAfterHours", Integer.parseInt(defaultExpiry));

						customers.add(customerInfo);
					}
				}

				if(customers.size() > 0){
	                String json = "";
					try{
				        Map<String, Object> cbtApiParams = new HashMap<String, Object>();
		    			Gson gson = new GsonBuilder().create();

		    			/*to cater format for API, new to build a outer MAP*/
		    			Map<String,Object> customersObj = new HashMap();
		    			customersObj.put("customers", customers);
		    			json = gson.toJson(customersObj);

	            		String cbtUrl = CBTApiDomains + CBTApiUrlCallLogAppointmentReq;
	                    cbtApiParams.put("jsonString", json);
	                    cbtApiParams.put("cbtUrl", cbtUrl);
	                    Map<String,Object> result = cbtCallLogReqApi(cbtApiParams);

	                    if(result != null){
		      		      	message.setMessage(CommonUtils.nvl(result.get("responseMessage")));
		      		      	message.setCode(CommonUtils.nvl(result.get("responseCode")));
	                    }
	                    else{
		      		      	message.setMessage("Success");
		      		      	message.setCode("00");
	                    }

					}catch (Exception e) {
					      message.setMessage("Unexpected Error Occurs.");
					      message.setCode("99");
	                }
				}
				else{
				      message.setMessage("No appointment list found.");
				      message.setCode("99");
				      return message;
				}
		  }
		  else{
		      message.setMessage("No appointment list found.");
		      message.setCode("99");
		      return message;
		  }

		  return message;
	  }

		private Map<String, Object> cbtCallLogReqApi(Map<String, Object> params){
			Map<String, Object> resultValue = new HashMap<String, Object>();
			resultValue.put("status", "99");
			resultValue.put("message", "CBT Failed: Please contact Administrator.");

			String respTm = null;

			StopWatch stopWatch = new StopWatch();
		    stopWatch.reset();
		    stopWatch.start();

		    String cbtUrl = params.get("cbtUrl").toString();
			String jsonString = params.get("jsonString").toString();
			String output1 = "";

			ChatbotCallLogResult p = new ChatbotCallLogResult();

			try{
				URL url = new URL(cbtUrl);

				//insert to api0004m
		        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		        conn.setDoOutput(true);
		        conn.setRequestMethod("POST");
		        conn.setRequestProperty("Content-Type", "application/json");
		        conn.setRequestProperty("ClientId", CBTApiClientUser);
		        conn.setRequestProperty("ClientAccessToken", CBTApiClientPassword);
//		        conn.setRequestProperty("Authorization", authorization); // Uncomment if using BASIC AUTH
		        OutputStream os = conn.getOutputStream();
		        os.write(jsonString.getBytes());
		        os.flush();


				if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
					BufferedReader br = new BufferedReader(new InputStreamReader(
			                (conn.getInputStream())));
					conn.getResponseMessage();

			        String output = "";
			        while ((output = br.readLine()) != null) {
			        	output1 = output;
			        }

			        Gson g = new Gson();
			        p = g.fromJson(output1, ChatbotCallLogResult.class);
			        if(p.isSuccess() == true){
			        	p.setErrorCode(200);
			        	resultValue.put("status", "00");
						resultValue.put("message", "Success");

						if(p.getResult() != null){
							List<Result> results = new ArrayList<>();
							results = p.getResult();

							for(int i=0; i <results.size(); i++){
								/*UPDATE CBT0007M*/
								Result result = new Result();
								result = results.get(i);

								Map<String,Object> updateRecord = new HashMap();
								if(result.isSent()){
									/*Success send*/
									updateRecord.put("stusCodeId", 44); //Pending Next Step
									updateRecord.put("callEntryId", result.getRequestId());
									updateRecord.put("waRemarks","Whatsapp appointment sent.");

									orderCallListMapper.updateCallLogAppointmentSentStatus(updateRecord);
									orderCallListMapper.updateCCR0006DCallLogAppointmentSentStatus(updateRecord);
								}
								else{
									/*Fail send*/
									updateRecord.put("stusCodeId", 21);
									updateRecord.put("callEntryId", result.getRequestId());
									updateRecord.put("waRemarks","Whatsapp appointment send failed.");

									orderCallListMapper.updateCallLogAppointmentSentStatus(updateRecord);
									orderCallListMapper.updateCCR0006DCallLogAppointmentSentStatus(updateRecord);
								}
							}
						}
			        }else{
			        	p.setErrorCode(400);
			        	resultValue.put("status", "99");
						resultValue.put("message", "Fail -" + p.getError());

						/*Have to Update CBT0007M?*/
			        }

					conn.disconnect();

					br.close();
				}else{
					p.setErrorCode(400);
					p.setSuccess(false);
					resultValue.put("status", "99");
					resultValue.put("message", "No Response");
				}
			}catch(Exception e){
				p.setErrorCode(99);
				p.setSuccess(false);
				resultValue.put("status", AppConstants.FAIL);
				resultValue.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");
			}finally{
		          stopWatch.stop();
		          respTm = stopWatch.toString();

				    params.put("responseCode", resultValue.get("status") == null ? "" : resultValue.get("status").toString());
		            params.put("responseMessage", resultValue.get("message") == null ? "" : resultValue.get("message").toString());
		            params.put("reqPrm", jsonString != null ? jsonString.length() >= 2000 ? jsonString.substring(0,2000) : jsonString : jsonString);
		            params.put("url", cbtUrl);
		            params.put("respTm", respTm);
		            params.put("resPrm", output1);
		            params.put("apiUserId", 7);

		          this.rtnRespMsg(params);

			}

			return params;
		}

		private void rtnRespMsg(Map<String, Object> param) {

		    EgovMap data = new EgovMap();
		    Map<String, Object> params = new HashMap<>();

		      params.put("respCde", param.get("responseCode"));
		      params.put("errMsg", param.get("responseMessage"));
		      params.put("reqParam", param.get("reqPrm"));
		      params.put("prgPath", param.get("url"));
		      params.put("respTm", param.get("respTm"));
		      params.put("respParam", param.get("resPrm"));
		      params.put("apiUserId", param.get("apiUserId"));

		      orderCallListMapper.insertApiAccessLog(params);
		  }
}
