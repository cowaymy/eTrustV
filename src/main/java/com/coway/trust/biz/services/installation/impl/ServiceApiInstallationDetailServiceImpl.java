package com.coway.trust.biz.services.installation.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultDetailForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.installation.ServiceApiInstallationDetailService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.exception.BizExceptionFactoryBean;
import com.coway.trust.cmmn.model.BizMsgVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiInstallationDetailServiceImpl.java
 * @Description : Mobile Installation Data Save
 *
 *
 * @History Date Author Description /********************************************************************************************* DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 17/09/2019 JUN 1.0.1 - Jun First creation 16/07/2020 ONGHC 1.0.2 - Amend installFailJobRequestProc 17/08/2020 FARUQ 1.0.3 - Get the product name when fail on mobile site
 *********************************************************************************************/

@Service("serviceApiInstallationDetailService")
public class ServiceApiInstallationDetailServiceImpl extends EgovAbstractServiceImpl
    implements ServiceApiInstallationDetailService {
  private static final Logger logger = LoggerFactory.getLogger(ServiceApiInstallationDetailServiceImpl.class);

  @Resource(name = "MSvcLogApiService")
  private MSvcLogApiService MSvcLogApiService;

  @Resource(name = "installationResultListService")
  private InstallationResultListService installationResultListService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;

  @Resource(name = "hcInstallResultListService")
	private HcInstallResultListService hcInstallResultListService;

  @Override
  public ResponseEntity<InstallationResultDto> installationResultProc(Map<String, Object> insApiresult)
      throws Exception {

    String transactionId = "";
    String serviceNo = "";

    SessionVO sessionVO1 = new SessionVO();

    Map<String, Object> params = insApiresult;

    transactionId = String.valueOf(params.get("transactionId"));
    serviceNo = String.valueOf(params.get("serviceNo"));

    // SAL0046D CHECK
    int isInsMemIdCnt = installationResultListService.insResultSync(params);

    if (isInsMemIdCnt > 0) {
      // SAL0046D CHECK (STUS_CODE_ID <> '1')
      int isInsCnt = installationResultListService.isInstallAlreadyResult(params);

      // MAKE SURE IT'S ALREADY PROCEEDED
      if (isInsCnt == 0) {
        String statusId = "4"; // INSTALLATION STATUS

        // DETAIL INFO SELECT (SALES_ORD_NO, INSTALL_ENTRY_NO)
        EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
        params.put("installEntryId", installResult.get("installEntryId"));

        logger.debug("### insApiresult :  " + insApiresult.toString());

        // INST AS FILTER CHARGE PARTS 19/05/2021 ALEXXX
        List<Map<String, Object>> paramsDetail = InstallationResultDetailForm.createMaps((List<InstallationResultDetailForm>) insApiresult.get("partList"));
		logger.debug("### INST AS PART INFO : " + paramsDetail.toString());


        Map<String, Object> salesOrdId = new HashMap<String, Object>();
        salesOrdId.put("salesOrdId", String.valueOf(installResult.get("salesOrdId")));
        String beforeProductSerialNo = MSvcLogApiService.getBeforeProductSerialNo(salesOrdId); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}

        // DETAIL INFO SELECT (installEntryId)
        EgovMap orderInfo = installationResultListService.getOrderInfo(params);

        logger.debug("### INSTALLATION STOCK : " + orderInfo.get("stkId"));
        if (orderInfo.get("stkId") != null || !("".equals(orderInfo.get("stkId")))) {
          // CHECK STOCK QUANTITY
          Map<String, Object> locInfoEntry = new HashMap<String, Object>();
          locInfoEntry.put("CT_CODE", CommonUtils.nvl(insApiresult.get("userId").toString()));
          locInfoEntry.put("STK_CODE", CommonUtils.nvl(orderInfo.get("stkId").toString()));

          logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

          // select FN_GET_SVC_AVAILABLE_INVENTORY(#{CT_CODE}, #{STK_CODE}) AVAIL_QTY from dual
          // 재고 수량 조회
          EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

          logger.debug("LOC. INFO. : {}" + locInfo);

          if (locInfo != null) {
            if (Integer.parseInt(locInfo.get("availQty").toString()) < 1) {
              MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

              Map<String, Object> m = new HashMap();
              m.put("APP_TYPE", "INS");
              m.put("SVC_NO", insApiresult.get("serviceNo"));
              m.put("ERR_CODE", "03");
              m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                  + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
              m.put("TRNSC_ID", transactionId);

              MSvcLogApiService.insert_SVC0066T(m);

              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "PRODUCT UNAVAILABLE";
              String errorMsg = "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                  + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString();
              logger.debug("exception param : " + procTransactionId);
              logger.debug("exception param : " + procName);
              logger.debug("exception param : " + procKey);
              logger.debug("exception param : " + procMsg);
              logger.debug("exception param : " + errorMsg);
              throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
            }
          } else {
            MSvcLogApiService.updateSuccessErrInstallStatus(transactionId);

            Map<String, Object> m = new HashMap();
            m.put("APP_TYPE", "INS");
            m.put("SVC_NO", insApiresult.get("serviceNo"));
            m.put("ERR_CODE", "03");
            m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. ");
            m.put("TRNSC_ID", transactionId);

            MSvcLogApiService.insert_SVC0066T(m);

            String procTransactionId = transactionId;
            String procName = "Installation";
            String procKey = serviceNo;
            String procMsg = "PRODUCT LOC NO DATA";
            String errorMsg = "PRODUCT LOC NO DATA";
            throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
          }
        }

        String userId = MSvcLogApiService.getUseridToMemid(params); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
        String installDate = MSvcLogApiService.getInstallDate(insApiresult); // SELECT TO_CHAR( TO_DATE(#{checkInDate} ,'YYYY/MM/DD') , 'DD/MM/YYYY' ) FROM DUAL

        params.put("installStatus", String.valueOf(statusId));
        params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
        params.put("hidEntryId", String.valueOf(installResult.get("installEntryId")));
        params.put("hidCustomerId", String.valueOf(installResult.get("custId")));
        params.put("hidSalesOrderId", String.valueOf(installResult.get("salesOrdId")));
        params.put("hidTaxInvDSalesOrderNo", String.valueOf(installResult.get("salesOrdNo")));
        params.put("hidStockIsSirim", String.valueOf(installResult.get("isSirim")));
        params.put("hidStockGrade", installResult.get("stkGrad"));
        params.put("hidSirimTypeId", String.valueOf(installResult.get("stkCtgryId")));
        params.put("hiddeninstallEntryNo", String.valueOf(installResult.get("installEntryNo")));
        params.put("hidTradeLedger_InstallNo", String.valueOf(installResult.get("installEntryNo")));
        params.put("hidCallType", String.valueOf(installResult.get("typeId")));


        //params.put("resultIcMobileNo", String.valueOf(insApiresult.get("resultIcMobileNo")));
        // ctCode
        // failId
        // failLct

        params.put("installDate", installDate);
        params.put("CTID", String.valueOf(userId));
        params.put("updator", String.valueOf(userId));
        params.put("nextCallDate", "01-01-1999");
        params.put("refNo1", "0");
        params.put("refNo2", "0");
        params.put("codeId", String.valueOf(installResult.get("257")));
        params.put("checkCommission", 1);

/*     params.put("boosterPump", String.valueOf(installResult.get("boosterPump")));
        params.put("aftPsi", String.valueOf(installResult.get("aftPsi")));
        params.put("aftLpm", String.valueOf(installResult.get("aftLpm")));*/

        params.put("boosterPump", String.valueOf(insApiresult.get("boosterPump")));
        params.put("aftPsi", String.valueOf(insApiresult.get("aftPsi")));
        params.put("aftLpm", String.valueOf(insApiresult.get("aftLpm")));
        params.put("turbLvl", String.valueOf(insApiresult.get("turbLvl")));
        params.put("waterSrcType", String.valueOf(insApiresult.get("waterSrcType")));

/*        params.put("boosterPump", String.valueOf(params.get("boosterPump")));
        params.put("aftPsi", String.valueOf(params.get("aftPsi")));
        params.put("aftLpm", String.valueOf(params.get("aftLpm")));*/

        params.put("custMobileNo", String.valueOf(insApiresult.get("custMobileNo")));
        params.put("chkSMS", String.valueOf(insApiresult.get("chkSMS")));
        params.put("checkSend", String.valueOf(insApiresult.get("checkSend")));

        if (orderInfo != null) {
          params.put("hidOutright_Price", CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
        } else {
          params.put("hidOutright_Price", "0");
        }

        params.put("hidAppTypeId", installResult.get("codeId"));
        params.put("hidStockIsSirim", String.valueOf(insApiresult.get("sirimNo")));
        params.put("hidSerialNo", String.valueOf(insApiresult.get("serialNo")));
        params.put("remark", insApiresult.get("resultRemark"));
        params.put("EXC_CT_ID", String.valueOf(userId));

        params.put("hidSerialRequireChkYn", String.valueOf(insApiresult.get("serialRequireChkYn")));
        params.put("mobileYn", "Y");

        logger.debug("### INSTALLATION PARAM : " + params.toString());

        sessionVO1.setUserId(Integer.parseInt(userId));

     // INST. ACCS LIST START
        List<Map<String, Object>> paramsDetailInstAccLst = InstallationResultDetailForm.createMaps((List<InstallationResultDetailForm>) insApiresult.get("installAccList"));
        logger.debug("### INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString());
        //List lstStr = null;
        List<String> lstStr = new ArrayList<>();
        for (Map<String, Object> accLst : paramsDetailInstAccLst) {

        	logger.debug("accLst : " + accLst.size());
          if (accLst != null) {
            lstStr.add(String.valueOf(accLst.get("insAccPartId")));
            logger.debug("### insAccPartIdT : " + String.valueOf(accLst.get("insAccPartId")));
          }
        }
        logger.debug("### INST ACCS LIST SIZE : " + lstStr.size());

        params.put("instAccLst", lstStr);
        // INST. ACCS LIST END

        try {
          Map rtnValue = installationResultListService.insertInstallationResult(params, sessionVO1);

          if (null != rtnValue) {
            HashMap spMap = (HashMap) rtnValue.get("spMap");
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }

            logger.debug("++++ String.valueOf( insApiresult.get('serialRequireChkYn')) ::"
                + String.valueOf(insApiresult.get("serialRequireChkYn")));

            if ("Y".equals(String.valueOf(insApiresult.get("serialRequireChkYn")))) {
              if ("Y".equals(String.valueOf(insApiresult.get("serialChk")))) {
                if ("Y".equals(String.valueOf(insApiresult.get("realAsExchangeYn")))) {
                  if (beforeProductSerialNo != String.valueOf(insApiresult.get("realBeforeProductSerialNo"))) {
                    params.put("scanSerial", String.valueOf(insApiresult.get("realBeforeProductSerialNo")));
                    params.put("realBeforeProductSerialNo", beforeProductSerialNo);
                    params.put("salesOrdId", String.valueOf(installResult.get("salesOrdId")));
                    params.put("itmCode", String.valueOf(insApiresult.get("realBeforeProductCode")));
                    params.put("reqstNo", String.valueOf(installResult.get("installEntryNo")));
                    params.put("callGbn", "EXCH_RETURN");
                    params.put("mobileYn", "Y");
                    params.put("userId", userId);
                    params.put("pErrcode", "");
                    params.put("pErrmsg", "");
                    MSvcLogApiService.SP_SVC_BARCODE_CHANGE(params);

                    if (!"000".equals(params.get("pErrcode"))) {
                      String procTransactionId = transactionId;
                      String procName = "Installation";
                      String procKey = serviceNo;
                      String procMsg = "Failed to Barcode Save";
                      String errorMsg = "[API] " + params.get("pErrmsg");
                      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
                    }
                  }
                }
              }

              // KR_HAN ADD
              // SP_SVC_BARCODE_SAVE : KR_HAN ADD START
              params.put("scanSerial", String.valueOf(insApiresult.get("serialNo")));
              params.put("salesOrdId", String.valueOf(installResult.get("salesOrdId")));
              params.put("reqstNo", String.valueOf(installResult.get("installEntryNo")));
              params.put("delvryNo", null); // ?????????
              params.put("callGbn", "INSTALL");
              params.put("mobileYn", "Y");
              params.put("userId", userId);
              params.put("pErrcode", "");
              params.put("pErrmsg", "");
              MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

              if (!"000".equals(params.get("pErrcode"))) {
                String procTransactionId = transactionId;
                String procName = "Installation";
                String procKey = serviceNo;
                String procMsg = "Failed to Barcode Save";
                String errorMsg = "[API] " + params.get("pErrmsg");
                throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }
              // SP_SVC_BARCODE_SAVE : KR_HAN ADD END

              logger.debug("+++ SP_SVC_BARCODE_SAVE params ::" + params.toString());

              spMap.put("pErrcode", "");
              spMap.put("pErrmsg", "");
              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

              String errCode = (String) spMap.get("pErrcode");
              String errMsg = (String) spMap.get("pErrmsg");

              // pErrcode : 000 = Success, others = Fail
              if (!"000".equals(errCode)) {
                String procTransactionId = transactionId;
                String procName = "Installation";
                String procKey = serviceNo;
                String procMsg = "Failed to Save";
                String errorMsg = "[API] " + errMsg;
                throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
              }
            } else {
              // SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
            }

            //send sms
            Map<String, Object> smsResultValue = new HashMap<String, Object>();

            try{
            	smsResultValue = installationResultListService.installationSendSMS(params.get("hidAppTypeId").toString(), params);
	      	}catch (Exception e){
	      		logger.info("===smsResultValue===" + smsResultValue.toString());
	      		logger.info("===Failed to send SMS to" + params.get("custMobileNo").toString() + "===");
	      	}
          }

          logger.info("###insApiresult.get(chkCrtAs): " + insApiresult.get("chkCrtAs"));

       // Added for inserting charge out filters and spare parts at AS. By Hui Ding, 06-04-2021
    	  if (insApiresult.get("chkCrtAs") != null && insApiresult.get("chkCrtAs").toString().equals("1")){

    		  // user_id
    		  int user_id_47 = 0;

    		  // set CT_ID into installResult
    		  installResult.put("ctId", String.valueOf(userId)); // mem_id

    		  if (userId != null){ // get user_id from mem_code
    			  Map<String, Object> p = new HashMap<String, Object>();
    			  p.put("memId", String.valueOf(userId));
    			  EgovMap userIdResult = installationResultListMapper.selectUserByMemId(p);

    			  if (userIdResult != null && userIdResult.get("userId") != null){
    				  user_id_47 = Integer.valueOf(userIdResult.get("userId").toString());
    			  }
    		  }

    		  // change format from
    		  String appntDtFormatted = null;

    		  logger.info("### appointment date before: " + installResult.get("appntDt"));

    		  if (installResult.get("appntDt") != null){
    			  Date appntDtOri = new SimpleDateFormat("yyyy-MM-dd").parse(installResult.get("appntDt").toString());
    			  appntDtFormatted = CommonUtils.getFormattedString("dd/MM/yyyy", appntDtOri);
    			  installResult.put("appntDt", appntDtFormatted); // format date (in string) to dd/MM/yyyy format
    		  }

    		  logger.info("### appointment date after: " + installResult.get("appntDt"));
    		  logger.info("### INS AS (filter param) : " + paramsDetail.toString());

    		  /** Added for INS AS. Hui Ding, 2021-10-26 **/
    		  double totalPrice = 0.00;

    		  List<Map<String, Object>> newPartList = new ArrayList<Map<String, Object>>();
    		  Map<String, Object> newPart = null;
    		  for (Map<String, Object> part : paramsDetail){
    			  if (part != null){
    				  newPart = new HashMap<String, Object>();

    				  newPart.put("filterID", String.valueOf(part.get("filterCode")));
    				  newPart.put("srvFilterLastSerial", String.valueOf(part.get("filterBarcdSerialNo")));
    				  newPart.put("filterQty", String.valueOf(part.get("filterChangeQty")));
    				  newPart.put("stockTypeId", String.valueOf(part.get("partsType")));
    				  newPart.put("filterPrice", String.valueOf(part.get("salesPrice")));
    				  newPart.put("filterTotal", String.valueOf(part.get("salesPrice")));
    				  newPart.put("filterDesc", "API");
    				  newPart.put("filterExCode", 0);
    				  newPart.put("filterRemark", "NA");

    				  totalPrice += (part.get("salesPrice") != null ? Double.parseDouble(part.get("salesPrice").toString()) : 0.00);

    				  if (part.get("chargesFoc") != null && part.get("chargesFoc").toString().equals("1")){
    					  newPart.put("filterType", "FOC");
    					  totalPrice = 0.00;
    				  } else {
    					  newPart.put("filterType", "CHG");
    				  }

    				  newPartList.add(newPart);
    			  }
    		  }

    		  params.put("txtFilterCharge", totalPrice);
			  params.put("txtTotalCharge", totalPrice);
			  params.put("txtLabourCharge", 0.00); // temporary set foc


    		  installationResultListService.saveInsAsEntry(newPartList, params, installResult, user_id_47 );
    	  }
          // End of inserting charge out filters and spare parts at AS

        } catch (Exception e) {
          String procTransactionId = transactionId;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }
      } else {
        // 대상이 없다면 정상 완료 처리
        if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
          MSvcLogApiService.updateSuccessInstallStatus(String.valueOf(params.get("transactionId")));
        }
      }
    } else {
      String procTransactionId = transactionId;
      String procName = "Installation";
      String procKey = serviceNo;
      String procMsg = "NoTarget Data";
      String errorMsg = "[API] [" + insApiresult.get("userId") + "] IT IS NOT ASSIGNED CT CODE.";
      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    }

	  logger.debug("### INSTALLATION FINAL PARAM : " + params.toString());

    return ResponseEntity.ok(InstallationResultDto.create(transactionId));
  }

  @Override
  public ResponseEntity<InstallFailJobRequestDto> installFailJobRequestProc(Map<String, Object> params)
      throws Exception {
    String serviceNo = String.valueOf(params.get("serviceNo"));
    SessionVO sessionVO1 = new SessionVO();
    int resultSeq = 0;
    if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
      resultSeq = (Integer) params.get("resultSeq");
    }

    Date dt = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(dt);
    cal.add(Calendar.DATE, 1);
    int year = cal.get(cal.YEAR);
    String month = String.format("%02d", cal.get(cal.MONTH) + 1);
    String date = String.format("%02d", cal.get(cal.DATE));
    String todayPlusOne = (String.valueOf(date) + '/' + String.valueOf(month) + '/' + String.valueOf(year));

    int isInsCnt = installationResultListService.isInstallAlreadyResult(params);

    // IF STATUS ARE NOT ACTIVE
    if (isInsCnt == 0) {
      String statusId = "21";

      // SAL0046D SELECT
      EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
      params.put("installEntryId", installResult.get("installEntryId"));

      EgovMap orderInfo = installationResultListService.getOrderInfo(params);

      String userId = MSvcLogApiService.getUseridToMemid(params);
      sessionVO1.setUserId(Integer.parseInt(userId));

      params.put("installStatus", String.valueOf(statusId));// 21
      params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
      params.put("hidEntryId", String.valueOf(installResult.get("installEntryId")));
      params.put("hidCustomerId", String.valueOf(installResult.get("custId")));
      params.put("hidSalesOrderId", String.valueOf(installResult.get("salesOrdId")));
      params.put("hidTaxInvDSalesOrderNo", String.valueOf(installResult.get("salesOrdNo")));
      params.put("hidStockIsSirim", String.valueOf(installResult.get("isSirim")));
      params.put("hidStockGrade", installResult.get("stkGrad"));
      params.put("hidSirimTypeId", String.valueOf(installResult.get("stkCtgryId")));
      params.put("hiddeninstallEntryNo", String.valueOf(installResult.get("installEntryNo")));
      params.put("hidTradeLedger_InstallNo", String.valueOf(installResult.get("installEntryNo")));
      params.put("hidCallType", String.valueOf(installResult.get("typeId")));
      params.put("hidDocId", String.valueOf(installResult.get("docId")));
      params.put("CTID", String.valueOf(userId));
      params.put("installDate", "");
      params.put("updator", String.valueOf(userId));
      params.put("nextCallDate",
          String.valueOf(params.get("nxtCallDate")) != "" ? String.valueOf(params.get("nxtCallDate")) : todayPlusOne);
      params.put("refNo1", "0");
      params.put("refNo2", "0");
      params.put("codeId", String.valueOf(installResult.get("typeId")));
      params.put("failReason", String.valueOf(params.get("failReasonCode")));
      params.put("failLocCde", String.valueOf(params.get("failLocCde")));
      params.put("volt", String.valueOf(params.get("volt")));
      params.put("psiRcd", String.valueOf(params.get("psiRcd")));
      params.put("lpmRcd", String.valueOf(params.get("lpmRcd")));
      params.put("tds", String.valueOf(params.get("tds")));
      params.put("roomTemp", String.valueOf(params.get("roomTemp")));
      params.put("waterSourceTemp", String.valueOf(params.get("waterSourceTemp")));
      params.put("turbLvl", String.valueOf(params.get("turbLvl")));
      params.put("ntu", String.valueOf(params.get("ntu")));

      params.put("customerType", String.valueOf(installResult.get("custType")));
      params.put("waterSrcType", String.valueOf(params.get("waterSrcType")));

      params.put("remark", String.valueOf(params.get("remark")));
      params.put("failLct", String.valueOf(params.get("failLocCde")));
      params.put("failDeptChk", String.valueOf(params.get("failBfDepWH")));
      params.put("instAccLst", null);

      if (orderInfo != null) {
        params.put("hidOutright_Price", CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
      } else {
        params.put("hidOutright_Price", "0");
      }

      params.put("hidAppTypeId", installResult.get("codeId"));

      if (installResult.get("sirimNo") != null) {
        params.put("sirimNo", installResult.get("sirimNo"));
      } else {
        params.put("sirimNo", "");
      }
      if (installResult.get("serialNo") != null) {
        params.put("serialNo", installResult.get("serialNo"));
      } else {
        params.put("serialNo", "");
      }

      /*
       * params.put("hidStockIsSirim",String.valueOf(insTransLogs.get(i).get( "sirimNo"))); params.put("hidSerialNo",String.valueOf(insTransLogs.get(i).get( "serialNo"))); params.put("remark",insTransLogs.get(i).get("resultRemark"));
       */

      logger.debug("### INSTALLATION FAIL JOB REQUEST PARAM : " + params.toString());

      Map rtnValue = installationResultListService.insertInstallationResult(params, sessionVO1);

      if (null != rtnValue) {
        HashMap spMap = (HashMap) rtnValue.get("spMap");
        if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
          String procTransactionId = serviceNo;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "PRODUCT FAIL";
          String errorMsg = "PRODUCT FAIL";
          throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        } else {
          if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
            MSvcLogApiService.updateSuccessInsFailServiceLogs(resultSeq);
          }
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
          String procTransactionId = serviceNo;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "PRODUCT LOC NO DATA";
          String errorMsg = "PRODUCT LOC NO DATA";
          throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }

        //send sms
        Map<String, Object> smsResultValue = new HashMap<String, Object>();

        try{
        	if(CommonUtils.nvl(String.valueOf(params.get("hcInd"))).equals("Y")){
        		smsResultValue = hcInstallResultListService.hcInstallationSendSMS(params.get("hidAppTypeId").toString(), params);

        		EgovMap salesmanInfo = hcInstallResultListService.selectOrderSalesmanViewByOrderID(params);
        		params.put("hpPhoneNo",salesmanInfo.get("telMobile"));
        		params.put("hpMemId",salesmanInfo.get("memId"));
        		EgovMap failReason = hcInstallResultListService.selectFailReason(params);
        		params.put("resnDesc",failReason.get("resnDesc"));
        		params.put("resnCode",failReason.get("resnCode"));
        		String hpMsg = "COWAY: Order " + params.get("salesOrderNo") + "\n Name: " + params.get("resultCustName") + "\n Install Status: Failed"
        				+ "\n Failed Reason: " + params.get("resnDesc") ;
        		params.put("hpMsg",hpMsg);

        		smsResultValue = hcInstallResultListService.hcInstallationSendHPSMS(params);
        	}else{
        		smsResultValue = installationResultListService.installationSendSMS(params.get("hidAppTypeId").toString(), params);
        	}

      	}catch (Exception e){
      		logger.info("===smsResultValue===" + smsResultValue.toString());
      		logger.info("===Failed to send SMS to" + params.get("custMobileNo").toString() + "===");
      	}
      }
    } else {
      if (RegistrationConstants.IS_INSERT_INSFAIL_LOG) {
        MSvcLogApiService.updateInsFailServiceLogs(params);
      }
    }

    return ResponseEntity.ok(InstallFailJobRequestDto.create(serviceNo));
  }

  @Override
  public ResponseEntity<InstallationResultDto> installationDtResultProc(Map<String, Object> insApiresult)
      throws Exception {
    String transactionId = "";
    String serviceNo = "";

    SessionVO sessionVO1 = new SessionVO();

    Map<String, Object> params = insApiresult;

    transactionId = String.valueOf(params.get("transactionId"));
    serviceNo = String.valueOf(params.get("serviceNo"));

    // SAL0046D CHECK
    int isInsMemIdCnt = installationResultListService.insResultSync(params);

    if (isInsMemIdCnt > 0) {
      // SAL0046D CHECK (STUS_CODE_ID <> '1')
      int isInsCnt = installationResultListService.isInstallAlreadyResult(params);

      // MAKE SURE IT'S ALREADY PROCEEDED
      if (isInsCnt == 0) {
        String statusId = "4"; // INSTALLATION STATUS

        // DETAIL INFO SELECT (SALES_ORD_NO, INSTALL_ENTRY_NO)
        EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
        params.put("installEntryId", installResult.get("installEntryId"));

        // DETAIL INFO SELECT (installEntryId)
        EgovMap orderInfo = installationResultListService.getOrderInfo(params);

        logger.debug("### INSTALLATION STOCK : " + orderInfo.get("stkId"));
        if (orderInfo.get("stkId") != null || !("".equals(orderInfo.get("stkId")))) {
          // CHECK STOCK QUANTITY
          Map<String, Object> locInfoEntry = new HashMap<String, Object>();
          locInfoEntry.put("CT_CODE", CommonUtils.nvl(insApiresult.get("userId").toString()));
          locInfoEntry.put("STK_CODE", CommonUtils.nvl(orderInfo.get("stkId").toString()));

          logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

          // select FN_GET_SVC_AVAILABLE_INVENTORY(#{CT_CODE}, #{STK_CODE}) AVAIL_QTY from dual
          // 재고 수량 조회
          EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

          logger.debug("LOC. INFO. : {}" + locInfo);

          if (locInfo != null) {
            if (Integer.parseInt(locInfo.get("availQty").toString()) < 1) {
              Map<String, Object> m = new HashMap();
              m.put("APP_TYPE", "INS");
              m.put("SVC_NO", insApiresult.get("serviceNo"));
              m.put("ERR_CODE", "03");
              m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                  + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
              m.put("TRNSC_ID", transactionId);

              MSvcLogApiService.insert_SVC0066T(m);

              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "PRODUCT UNAVAILABLE";
              String errorMsg = "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                  + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString();
              logger.debug("exception param : " + procTransactionId);
              logger.debug("exception param : " + procName);
              logger.debug("exception param : " + procKey);
              logger.debug("exception param : " + procMsg);
              logger.debug("exception param : " + errorMsg);
              throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
            }
          } else {
            Map<String, Object> m = new HashMap();
            m.put("APP_TYPE", "INS");
            m.put("SVC_NO", insApiresult.get("serviceNo"));
            m.put("ERR_CODE", "03");
            m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] PRODUCT FOR ["
                + orderInfo.get("stkId").toString() + "] IS UNAVAILABLE. ");
            m.put("TRNSC_ID", transactionId);

            MSvcLogApiService.insert_SVC0066T(m);

            String procTransactionId = transactionId;
            String procName = "Installation";
            String procKey = serviceNo;
            String procMsg = "PRODUCT LOC NO DATA";
            String errorMsg = "PRODUCT LOC NO DATA";
            throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
          }
        }

        String userId = MSvcLogApiService.getUseridToMemid(params); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
        String installDate = MSvcLogApiService.getInstallDate(insApiresult); // SELECT TO_CHAR( TO_DATE(#{checkInDate} ,'YYYY/MM/DD') , 'DD/MM/YYYY' ) FROM DUAL

        params.put("installStatus", String.valueOf(statusId));
        params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
        params.put("hidEntryId", String.valueOf(installResult.get("installEntryId")));
        params.put("hidCustomerId", String.valueOf(installResult.get("custId")));
        params.put("hidSalesOrderId", String.valueOf(installResult.get("salesOrdId")));
        params.put("hidTaxInvDSalesOrderNo", String.valueOf(installResult.get("salesOrdNo")));
        params.put("hidStockIsSirim", String.valueOf(installResult.get("isSirim")));
        params.put("hidStockGrade", installResult.get("stkGrad"));
        params.put("hidSirimTypeId", String.valueOf(installResult.get("stkCtgryId")));
        params.put("hiddeninstallEntryNo", String.valueOf(installResult.get("installEntryNo")));
        params.put("hidTradeLedger_InstallNo", String.valueOf(installResult.get("installEntryNo")));
        params.put("hidCallType", String.valueOf(installResult.get("typeId")));
        params.put("installDate", installDate);
        params.put("CTID", String.valueOf(userId));
        params.put("updator", String.valueOf(userId));
        params.put("nextCallDate", "01-01-1999");
        params.put("refNo1", "0");
        params.put("refNo2", "0");
        params.put("codeId", String.valueOf(installResult.get("257")));
        params.put("checkCommission", 1);

        if (orderInfo != null) {
          params.put("hidOutright_Price", CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
        } else {
          params.put("hidOutright_Price", "0");
        }

        params.put("hidAppTypeId", installResult.get("codeId"));
        params.put("hidStockIsSirim", String.valueOf(insApiresult.get("sirimNo")));
        params.put("hidSerialNo", String.valueOf(insApiresult.get("serialNo")));
        params.put("remark", insApiresult.get("resultRemark"));
        params.put("dtPairCode", insApiresult.get("partnerCode"));
        params.put("EXC_CT_ID", String.valueOf(userId));

        params.put("hidSerialRequireChkYn", "Y");
        params.put("mobileYn", "Y");

        logger.debug("### INSTALLATION PARAM : " + params.toString());

        sessionVO1.setUserId(Integer.parseInt(userId));

        // INST. ACCS LIST START
        List<Map<String, Object>> paramsDetailInstAccLst = InstallationResultDetailForm.createMaps((List<InstallationResultDetailForm>) insApiresult.get("installAccList"));
        logger.debug("### INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString());
        //List lstStr = null;
        List<String> lstStr = new ArrayList<>();
        for (Map<String, Object> accLst : paramsDetailInstAccLst) {

        	logger.debug("accLst : " + accLst.size());
          if (accLst != null) {
            lstStr.add(String.valueOf(accLst.get("insAccPartId")));
            logger.debug("### insAccPartIdT : " + String.valueOf(accLst.get("insAccPartId")));
          }
        }
        logger.debug("### INST ACCS LIST SIZE : " + lstStr.size());

        params.put("instAccLst", lstStr);
        // INST. ACCS LIST END

        try {
          Map rtnValue = installationResultListService.insertInstallationResult(params, sessionVO1);

          if (null != rtnValue) {

            HashMap spMap = (HashMap) rtnValue.get("spMap");
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }

            params.put("scanSerial", String.valueOf(insApiresult.get("scanSerial")));
            params.put("salesOrdId", String.valueOf(installResult.get("salesOrdId")));
            params.put("reqstNo", String.valueOf(insApiresult.get("serviceNo")));
            params.put("delvryNo", null);
            params.put("callGbn", "INSTALL");
            params.put("mobileYn", "Y");
            params.put("userId", userId);
            params.put("pErrcode", "");
            params.put("pErrmsg", "");
            MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

            if (!"000".equals(params.get("pErrcode"))) {
              String procTransactionId = transactionId;
              String procName = "Installation";
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
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "Failed to Save";
              String errorMsg = "[API] " + errMsg;
              throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
            }

            Map<String, Object> smsResultValue = new HashMap<String, Object>();

            try{
              	smsResultValue = hcInstallResultListService.hcInstallationSendSMS(params.get("hidAppTypeId").toString(), params);
              	logger.info("===DONE SEND TO CUST===");
              	EgovMap salesmanInfo = hcInstallResultListService.selectOrderSalesmanViewByOrderID(params);
              	params.put("hpPhoneNo",salesmanInfo.get("telMobile"));
              	params.put("hpMemId",salesmanInfo.get("memId"));
        		String hpMsg = "COWAY: Order " + params.get("salesOrderNo") + "\n Name: " + params.get("resultCustName") + "Install Status: Completed" ;
        		params.put("hpMsg",hpMsg);
        		smsResultValue = hcInstallResultListService.hcInstallationSendHPSMS(params);
        		logger.info("===DONE SEND TO HP===");
  	      	}catch (Exception e){
  	      		logger.info("===smsResultValue===" + smsResultValue.toString());
  	      		logger.info("===Failed to send SMS to" + params.get("custMobileNo").toString() + "===");
  	      	}
          }
        } catch (Exception e) {
          String procTransactionId = transactionId;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }
      } else {
        // 대상이 없다면 정상 완료 처리
        // Insert Log Adapter. So Delete Log
        // if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
        // MSvcLogApiService.updateSuccessInstallStatus(String.valueOf(params.get("transactionId")));
        // }
      }
    } else {
      String procTransactionId = transactionId;
      String procName = "Installation";
      String procKey = serviceNo;
      String procMsg = "NoTarget Data";
      String errorMsg = "[API] [" + insApiresult.get("userId") + "] IT IS NOT ASSIGNED CT CODE.";
      throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    }

    logger.debug("### INSTALLATION FINAL PARAM : " + params.toString());

    return ResponseEntity.ok(InstallationResultDto.create(transactionId));
  }

  /*@Override
	public void installationResultProcSendEmail(Map<String, Object> params) {
	  logger.info("paramsSendEmail1111====" + params.toString() + "===");

	  try{
	  	installationResultListService.installationSendEmail(params);
  	  }catch (Exception e){
  		logger.info("===Failed to send e-mail to" + params.get("resultReportEmailNo").toString() + "===");
  	  }
   }*/

}
