package com.coway.trust.biz.services.bs.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.bs.ServiceApiHSDetailService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.BizExceptionFactoryBean;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.BizMsgVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiHSDetailServiceImpl.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date             Author Description ------------- ----------- -------------
 * 2019. 09. 20. Jun       First creation
 * 2020. 04. 27. ONGHC AMEND hsFailJobRequestProc
 */
@Service("serviceApiHSDetailService")
public class ServiceApiHSDetailServiceImpl extends EgovAbstractServiceImpl implements ServiceApiHSDetailService {
  private static final Logger logger = LoggerFactory.getLogger(ServiceApiHSDetailServiceImpl.class);

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "MSvcLogApiService")
  private MSvcLogApiService MSvcLogApiService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Override
  public ResponseEntity<HeartServiceResultDto> hsResultProc(Map<String, Object> insApiresult,
      Map<String, Object> params, List<Object> paramsDetailList) throws Exception {
    String transactionId = "";
    String serviceNo = "";
    SessionVO sessionVO = new SessionVO();

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String strToday = sdf.format(cal.getTime());

    // CURRENT YEAR, MONTH, DAY
    StringBuffer today2 = new StringBuffer();
    today2.append(String.format("%02d", cal.get(cal.DATE)));
    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
    today2.append(String.format("%04d", cal.get(cal.YEAR)));

    String toSetlDt = today2.toString();

    transactionId = String.valueOf(insApiresult.get("transactionId"));
    serviceNo = String.valueOf(insApiresult.get("serviceNo"));

    // CHECK IF SVC0008D MEM_CODE AND SVC0006D MEM_CODE ARE THE SAME
    int hsResultMemId = hsManualService.hsResultSync(params);

    if (hsResultMemId > 0) {
      // RESULT CHECK HS IS ACTIVE
      int isHsCnt = hsManualService.isHsAlreadyResult(params);

      // IF NO RESULT OR IS 0
      if (isHsCnt == 0) {
        try {
          String userId = MSvcLogApiService.getUseridToMemid(params);
          sessionVO.setUserId(Integer.parseInt(userId));

          // UPDATE FAUCET EXCHANGE
          if (params.get("faucetExch") != null) {
            if ("1".equals(CommonUtils.nvl(params.get("faucetExch").toString()))) {
              int cnt = MSvcLogApiService.updFctExch(params);

              if (cnt < 1) {
                String procTransactionId = transactionId;
                String procName = "HeartService";
                String procKey = serviceNo;
                String procMsg = "[SAL0090D] UPDATE FAIL";
                String errorMsg = "[API] [" + params.get("salesOrderNo") + "] [SAL0090D] UPDATE FAIL.";
                throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }
            }
          }

          Map<String, Object> getHsBasic = MSvcLogApiService.getHsBasic(params);
          logger.debug("### HS BASIC INFO : " + getHsBasic.toString());

          // API SETTING
          params.put("hidschdulId", getHsBasic.get("schdulId"));
          params.put("hidSalesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
          params.put("hidCodyId", (String) userId);
          params.put("settleDate", toSetlDt);
          params.put("resultIsSync", '0');
          params.put("resultIsEdit", '0');
          params.put("resultStockUse", '1');
          params.put("resultIsCurr", '1');
          params.put("resultMtchId", '0');
          params.put("resultIsAdj", '0');
          params.put("cmbStatusType", "4");
          params.put("renColctId", "0");

          // API OVER
          params.put("remark", insApiresult.get("resultRemark"));
          params.put("cmbCollectType", String.valueOf(insApiresult.get("rcCode")));

          // API ADDED
          params.put("temperateSetng", String.valueOf(insApiresult.get("temperatureSetting")));
          params.put("nextAppntDt", insApiresult.get("nextAppointmentDate"));
          params.put("nextAppointmentTime", String.valueOf(insApiresult.get("nextAppointmentTime")));
          params.put("ownerCode", String.valueOf(insApiresult.get("ownerCode")));
          params.put("resultCustName", insApiresult.get("resultCustName"));
          params.put("resultMobileNo", String.valueOf(insApiresult.get("resultIcMobileNo")));
          params.put("resultRptEmailNo", String.valueOf(insApiresult.get("resultReportEmailNo")));
          params.put("resultAceptName", insApiresult.get("resultAcceptanceName"));
          params.put("sgnDt", insApiresult.get("signData"));
          params.put("stage", "API");

          params.put("hidSerialRequireChkYn", String.valueOf(insApiresult.get("serialRequireChkYn")));

          logger.debug("### HS PARAM : " + params.toString());
          logger.debug("### HS PARAM FILTER : " + paramsDetailList.toString());

          // SERVICE TO VALUE SETTING
          Map<String, Object> asResultInsert = new HashMap();
          logger.debug("### HS INSERT [BEFORE] : " + asResultInsert.toString());

          Map rtnValue = hsManualService.addIHsResult(params, paramsDetailList, sessionVO);
          logger.debug("### HS INSERT RESULT : " + rtnValue.toString());

          if (null != rtnValue) {
            HashMap spMap = (HashMap) rtnValue.get("spMap");
            logger.debug("spMap :" + spMap.toString());
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }

            logger.debug("++++ String.valueOf( insApiresult.get('serialRequireChkYn')) ::"
                + String.valueOf(insApiresult.get("serialRequireChkYn")));

            if ("Y".equals(String.valueOf(insApiresult.get("serialRequireChkYn")))) {
              params.put("scanSerial", String.valueOf(insApiresult.get("scanSerial")));
              params.put("salesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
              params.put("reqstNo", String.valueOf(rtnValue.get("hsrNo")));
              params.put("delvryNo", null);
              params.put("callGbn", "HS");
              params.put("mobileYn", "Y");
              params.put("userId", userId);
              params.put("pErrcode", "");
              params.put("pErrmsg", "");
              MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

              logger.debug("### SP_SVC_BARCODE_SAVE params  : " + params.toString());

              if (!"000".equals(params.get("pErrcode"))) {
                String procTransactionId = transactionId;
                String procName = "HeartService";
                String procKey = serviceNo;
                String procMsg = "Failed to Barcode Save";
                String errorMsg = "[API] " + params.get("pErrmsg");
                throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }

              spMap.put("pErrcode", "");
              spMap.put("pErrmsg", "");
              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

              String errCode = (String) spMap.get("pErrcode");
              String errMsg = (String) spMap.get("pErrmsg");

              logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
              logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

              // pErrcode : 000 = Success, others = Fail
              if (!"000".equals(errCode)) {
                String procTransactionId = transactionId;
                String procName = "HeartService";
                String procKey = serviceNo;
                String procMsg = "Failed to Save";
                String errorMsg = "[API] ERROR CODE : " + errCode + ", MSG : " + errMsg;
                throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }

              logger.debug("### SP_SVC_LOGISTIC_REQUEST_SERIAL params  : " + spMap.toString());

            } else {
              // SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
            }

            // HS LOG HISTORY
            if (RegistrationConstants.IS_INSERT_HEART_LOG) {
              MSvcLogApiService.updateSuccessStatus(transactionId);
            }
          }
        } catch (Exception e) {
          String procTransactionId = transactionId;
          String procName = "HeartService";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }
      } else {
        logger.debug("### HS NOT IN ACTIVE STATUS. ");
      }
    } else {
      String procTransactionId = transactionId;
      String procName = "HeartService";
      String procKey = serviceNo;
      String procMsg = "NoTarget Data";
      String errorMsg = "[API] [" + params.get("userId") + "] IT IS NOT ASSIGNED CODY CODE.";
      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    }

    logger.debug(
        "==================================[MB]HEART SERVICE RESULT - END - ====================================");

    return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
  }

  @Override
  public ResponseEntity<HSFailJobRequestDto> hsFailJobRequestProc(Map<String, Object> params) throws Exception {
    String serviceNo = String.valueOf(params.get("serviceNo"));

    MSvcLogApiService.upDateHsFailJobResultM(params);
    MSvcLogApiService.insertHsFailJobResult(params);

    return ResponseEntity.ok(HSFailJobRequestDto.create(serviceNo));
  }

  @Override
  public ResponseEntity<HeartServiceResultDto> htResultProc(Map<String, Object> insApiresult,
      Map<String, Object> params, List<Object> paramsDetailList) throws Exception {
    String transactionId = "";
    String serviceNo = "";
    SessionVO sessionVO = new SessionVO();

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String strToday = sdf.format(cal.getTime());

    // CURRENT YEAR, MONTH, DAY
    StringBuffer today2 = new StringBuffer();
    today2.append(String.format("%02d", cal.get(cal.DATE)));
    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
    today2.append(String.format("%04d", cal.get(cal.YEAR)));

    String toSetlDt = today2.toString();

    transactionId = String.valueOf(insApiresult.get("transactionId"));
    serviceNo = String.valueOf(insApiresult.get("serviceNo"));

    // CHECK IF SVC0008D MEM_CODE AND SVC0006D MEM_CODE ARE THE SAME
    int hsResultMemId = hsManualService.hsResultSync(params);

    if (hsResultMemId > 0) {
      // RESULT CHECK HS IS ACTIVE
      int isHsCnt = hsManualService.isHsAlreadyResult(params);

      // IF NO RESULT OR IS 0
      if (isHsCnt == 0) {
        try {
          String userId = MSvcLogApiService.getUseridToMemid(params);
          sessionVO.setUserId(Integer.parseInt(userId));

          Map<String, Object> getHsBasic = MSvcLogApiService.getHtBasic(params);
          if (getHsBasic == null) {
            String procTransactionId = transactionId;
            String procName = "HeartService";
            String procKey = serviceNo;
            String procMsg = "No Target Basic Data";
            String errorMsg = "[API] [" + serviceNo + "] No Target Basic Data.";
            throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
          }

          logger.debug("### CS BASIC INFO : " + getHsBasic.toString());

          // API SETTING
          params.put("hidschdulId", getHsBasic.get("schdulId"));
          params.put("hidSalesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
          params.put("hidCodyId", (String) userId);
          params.put("settleDate", toSetlDt);
          params.put("resultIsSync", '0');
          params.put("resultIsEdit", '0');
          params.put("resultStockUse", '1');
          params.put("resultIsCurr", '1');
          params.put("resultMtchId", '0');
          params.put("resultIsAdj", '0');
          params.put("cmbStatusType", "4");
          params.put("renColctId", "0");

          // API OVER
          params.put("remark", insApiresult.get("resultRemark"));
          params.put("cmbCollectType", String.valueOf(insApiresult.get("rcCode")));

          // API ADDED
          params.put("temperateSetng", String.valueOf(insApiresult.get("temperatureSetting")));
          params.put("nextAppntDt", insApiresult.get("nextAppointmentDate"));
          params.put("nextAppointmentTime", String.valueOf(insApiresult.get("nextAppointmentTime")));
          params.put("ownerCode", String.valueOf(insApiresult.get("ownerCode")));
          params.put("resultCustName", insApiresult.get("resultCustName"));
          params.put("resultMobileNo", String.valueOf(insApiresult.get("resultIcMobileNo")));
          params.put("resultRptEmailNo", String.valueOf(insApiresult.get("resultReportEmailNo")));
          params.put("resultAceptName", insApiresult.get("resultAcceptanceName"));
          params.put("sgnDt", insApiresult.get("signData"));
          params.put("stage", "API");

          logger.debug("### CS PARAM : " + params.toString());

          Map rtnValue = hsManualService.addIHtResult(params, paramsDetailList, sessionVO);
          logger.debug("### CS INSERT RESULT : " + rtnValue.toString());

          if (null != rtnValue) {
            // 홈케어 주문일 경우만 호출
            if ("Y".equals(String.valueOf(insApiresult.get("homeCareOrderYn")))) {
              params.put("scanSerial", String.valueOf(insApiresult.get("scanSerial")));
              params.put("salesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
              params.put("reqstNo", String.valueOf(rtnValue.get("resultDocNo")));
              params.put("delvryNo", null);
              params.put("callGbn", "HS");
              params.put("mobileYn", "Y");
              params.put("userId", userId);
              params.put("pErrcode", "");
              params.put("pErrmsg", "");
              MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

              if (!"000".equals(params.get("pErrcode"))) {
                String procTransactionId = transactionId;
                String procName = "HeartService";
                String procKey = serviceNo;
                String procMsg = "Failed to Barcode Save";
                String errorMsg = "[API] " + params.get("pErrmsg");
                throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }
            }
          }
        } catch (Exception e) {
          String procTransactionId = transactionId;
          String procName = "HeartService";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }
      } else {
        logger.debug("### HS NOT IN ACTIVE STATUS. ");
      }
    } else {
      String procTransactionId = transactionId;
      String procName = "HeartService";
      String procKey = serviceNo;
      String procMsg = "NoTarget Data";
      String errorMsg = "[API] [" + params.get("userId") + "] IT IS NOT ASSIGNED CODY CODE.";
      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    }

    logger.debug(
        "==================================[MB]HEART SERVICE RESULT - END - ====================================");

    return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
  }

  @Override
  public ResponseEntity<HSFailJobRequestDto> htFailJobRequestProc(Map<String, Object> params) throws Exception {
    String serviceNo = String.valueOf(params.get("serviceNo"));

    SessionVO sessionVO = new SessionVO();
    String userId = MSvcLogApiService.getUseridToMemid(params);
    sessionVO.setUserId(Integer.parseInt(userId));

    Map<String, Object> getHsBasic = MSvcLogApiService.getHtBasic(params);
    if (getHsBasic == null) {
      String procTransactionId = "";
      String procName = "HeartService";
      String procKey = serviceNo;
      String procMsg = "No Target Basic Data";
      String errorMsg = "[API] [" + serviceNo + "] No Target Basic Data.";
      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    }

    params.put("hidschdulId", getHsBasic.get("schdulId"));
    params.put("hidSalesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
    params.put("hidCodyId", (String) userId);

    MSvcLogApiService.insertHtFailJobResult(params, sessionVO);
    MSvcLogApiService.upDateHtFailJobResultM(params);

    return ResponseEntity.ok(HSFailJobRequestDto.create(serviceNo));
  }
}
