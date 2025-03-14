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

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultDetailForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.logistics.stocks.impl.StockMapper;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.installation.ServiceApiInstallationDetailService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("serviceApiInstallationDetailService")
public class ServiceApiInstallationDetailServiceImpl
  extends EgovAbstractServiceImpl
  implements ServiceApiInstallationDetailService {
  private static final Logger logger = LoggerFactory.getLogger( ServiceApiInstallationDetailServiceImpl.class );

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

  @Resource(name = "stockMapper")
  private StockMapper stockMapper;

  @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
  @Override
  public ResponseEntity<InstallationResultDto> installationResultProc( Map<String, Object> insApiresult )
    throws Exception {
    String transactionId = "";
    String serviceNo = "";

    SessionVO sessionVO1 = new SessionVO();
    Map<String, Object> params = insApiresult;

    transactionId = String.valueOf( params.get( "transactionId" ) );
    serviceNo = String.valueOf( params.get( "serviceNo" ) );

    // SAL0046D CHECK
    int isInsMemIdCnt = installationResultListService.insResultSync( params );
    if ( isInsMemIdCnt > 0 ) {
      // SAL0046D CHECK (STUS_CODE_ID <> '1')
      int isInsCnt = installationResultListService.isInstallAlreadyResult( params );

      // MAKE SURE IT'S ALREADY PROCEEDED
      if ( isInsCnt == 0 ) {
        String statusId = "4"; // INSTALLATION STATUS
        // DETAIL INFO SELECT (SALES_ORD_NO, INSTALL_ENTRY_NO)
        EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID( params );

        params.put( "installEntryId", installResult.get( "installEntryId" ) );
        logger.debug( "### insApiresult :  " + insApiresult.toString() );

        // INST AS FILTER CHARGE PARTS
        List<Map<String, Object>> paramsDetail = InstallationResultDetailForm.createMaps( (List<InstallationResultDetailForm>) insApiresult.get( "partList" ) );
        logger.debug( "### INST AS PART INFO : " + paramsDetail.toString() );

        Map<String, Object> salesOrdId = new HashMap<String, Object>();
        salesOrdId.put( "salesOrdId", String.valueOf( installResult.get( "salesOrdId" ) ) );

        String beforeProductSerialNo = MSvcLogApiService.getBeforeProductSerialNo( salesOrdId ); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}

        // DETAIL INFO SELECT (installEntryId)
        EgovMap orderInfo = installationResultListService.getOrderInfo( params );
        logger.debug( "### INSTALLATION STOCK : " + orderInfo.get( "stkId" ) );

        if ( orderInfo.get( "stkId" ) != null || !( "".equals( orderInfo.get( "stkId" ) ) ) ) {
          // CHECK STOCK QUANTITY
          Map<String, Object> locInfoEntry = new HashMap<String, Object>();

          locInfoEntry.put( "CT_CODE", CommonUtils.nvl( insApiresult.get( "userId" ).toString() ) );
          locInfoEntry.put( "STK_CODE", CommonUtils.nvl( orderInfo.get( "stkId" ).toString() ) );

          logger.debug( "LOC. INFO. ENTRY : {}" + locInfoEntry );

          EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY( locInfoEntry );

          logger.debug( "LOC. INFO. : {}" + locInfo );

          if ( locInfo != null ) {
            if ( Integer.parseInt( locInfo.get( "availQty" ).toString() ) < 1 ) {
              MSvcLogApiService.updateSuccessErrInstallStatus( transactionId );
              Map<String, Object> m = new HashMap();
              m.put( "APP_TYPE", "INS" );
              m.put( "SVC_NO", insApiresult.get( "serviceNo" ) );
              m.put( "ERR_CODE", "03" );
              m.put( "ERR_MSG", "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " + locInfo.get( "availQty" ).toString() );
              m.put( "TRNSC_ID", transactionId );

              MSvcLogApiService.insert_SVC0066T( m );

              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "PRODUCT UNAVAILABLE";
              String errorMsg = "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " + locInfo.get( "availQty" ).toString();

              throw new BizException( "03", procTransactionId, procName, procKey, procMsg, errorMsg, null );
            }
          } else {
            MSvcLogApiService.updateSuccessErrInstallStatus( transactionId );

            Map<String, Object> m = new HashMap();
            m.put( "APP_TYPE", "INS" );
            m.put( "SVC_NO", insApiresult.get( "serviceNo" ) );
            m.put( "ERR_CODE", "03" );
            m.put( "ERR_MSG", "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " );
            m.put( "TRNSC_ID", transactionId );

            MSvcLogApiService.insert_SVC0066T( m );

            String procTransactionId = transactionId;
            String procName = "Installation";
            String procKey = serviceNo;
            String procMsg = "PRODUCT LOC NO DATA";
            String errorMsg = "PRODUCT LOC NO DATA";

            throw new BizException( "03", procTransactionId, procName, procKey, procMsg, errorMsg, null );
          }
        }

        String userId = MSvcLogApiService.getUseridToMemid( params ); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
        String installDate = MSvcLogApiService.getInstallDate( insApiresult ); // SELECT TO_CHAR( TO_DATE(#{checkInDate} ,'YYYY/MM/DD') , 'DD/MM/YYYY' ) FROM DUAL

        params.put( "installStatus", CommonUtils.nvl( statusId ) );
        params.put( "statusCodeId", Integer.parseInt( params.get( "installStatus" ).toString() ) );
        params.put( "hidEntryId", CommonUtils.nvl( installResult.get( "installEntryId" ) ) );
        params.put( "hidCustomerId", CommonUtils.nvl( installResult.get( "custId" ) ) );
        params.put( "hidSalesOrderId", CommonUtils.nvl( installResult.get( "salesOrdId" ) ) );
        params.put( "hidTaxInvDSalesOrderNo", CommonUtils.nvl( installResult.get( "salesOrdNo" ) ) );
        params.put( "hidStockIsSirim", CommonUtils.nvl( installResult.get( "isSirim" ) ) );
        params.put( "hidStockGrade", CommonUtils.nvl( installResult.get( "stkGrad" ) ) );
        params.put( "hidSirimTypeId", CommonUtils.nvl( installResult.get( "stkCtgryId" ) ) );
        params.put( "hiddeninstallEntryNo", CommonUtils.nvl( installResult.get( "installEntryNo" ) ) );
        params.put( "hidTradeLedger_InstallNo", CommonUtils.nvl( installResult.get( "installEntryNo" ) ) );
        params.put( "hidCallType", CommonUtils.nvl( installResult.get( "typeId" ) ) );
        // params.put("resultIcMobileNo", String.valueOf(insApiresult.get("resultIcMobileNo")));
        params.put( "installDate", CommonUtils.nvl( installDate ) );
        params.put( "CTID", CommonUtils.nvl( userId ) );
        params.put( "updator", CommonUtils.nvl( userId ) );
        params.put( "nextCallDate", "01-01-1999" );
        params.put( "refNo1", "0" );
        params.put( "refNo2", "0" );
        params.put( "codeId", CommonUtils.nvl( installResult.get( "257" ) ) );
        params.put( "checkCommission", 1 );
        params.put( "boosterPump", CommonUtils.nvl( insApiresult.get( "boosterPump" ) ) );
        params.put( "aftPsi", CommonUtils.nvl( insApiresult.get( "aftPsi" ) ) );
        params.put( "aftLpm", CommonUtils.nvl( insApiresult.get( "aftLpm" ) ) );
        params.put( "turbLvl", CommonUtils.nvl( insApiresult.get( "turbLvl" ) ) );
        params.put( "waterSrcType", CommonUtils.nvl( insApiresult.get( "waterSrcType" ) ) );
        params.put( "custMobileNo", CommonUtils.nvl( insApiresult.get( "custMobileNo" ) ) );
        params.put( "chkSMS", CommonUtils.nvl( insApiresult.get( "chkSMS" ) ) );
        params.put( "checkSend", CommonUtils.nvl( insApiresult.get( "checkSend" ) ) );
        params.put( "dtPairCode", CommonUtils.nvl( insApiresult.get( "partnerCode" ) ) );

        if ( orderInfo != null ) {
          params.put( "hidOutright_Price", CommonUtils.nvl( String.valueOf( orderInfo.get( "c5" ) ) ) );
        } else {
          params.put( "hidOutright_Price", "0" );
        }

        params.put( "hidAppTypeId", CommonUtils.nvl( installResult.get( "codeId" ) ) );
        params.put( "hidStockIsSirim", CommonUtils.nvl( insApiresult.get( "sirimNo" ) ) );
        params.put( "hidSerialNo", CommonUtils.nvl( insApiresult.get( "serialNo" ) ) );
        params.put( "remark", CommonUtils.nvl( insApiresult.get( "resultRemark" ) ) );
        params.put( "EXC_CT_ID", CommonUtils.nvl( userId ) );
        params.put( "hidSerialRequireChkYn", CommonUtils.nvl( insApiresult.get( "serialRequireChkYn" ) ) );
        params.put( "mobileYn", "Y" );
        logger.debug( "### INSTALLATION PARAM : " + params.toString() );

        sessionVO1.setUserId( Integer.parseInt( userId ) );

        List<Map<String, Object>> paramsDetailInstAccLst = InstallationResultDetailForm.createMaps( (List<InstallationResultDetailForm>) insApiresult.get( "installAccList" ) );
        logger.debug( "# INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString() );
        List<String> lstStr = new ArrayList<>();

        for ( Map<String, Object> accLst : paramsDetailInstAccLst ) {
          if ( accLst != null ) {
            lstStr.add( String.valueOf( accLst.get( "insAccPartId" ) ) );
          }
        }

        params.put( "instAccLst", lstStr );

        try {
          Map rtnValue = installationResultListService.insertInstallationResult( params, sessionVO1 );
          if ( null != rtnValue ) {
            HashMap spMap = (HashMap) rtnValue.get( "spMap" );

            if ( !"000".equals( spMap.get( "P_RESULT_MSG" ) ) ) {
              rtnValue.put( "logerr", "Y" );
            }

            if ( "Y".equals( String.valueOf( insApiresult.get( "serialRequireChkYn" ) ) ) ) {
              if ( "Y".equals( String.valueOf( insApiresult.get( "serialChk" ) ) ) ) {
                if ( "Y".equals( String.valueOf( insApiresult.get( "realAsExchangeYn" ) ) ) ) {
                  if ( beforeProductSerialNo != String.valueOf( insApiresult.get( "realBeforeProductSerialNo" ) ) ) {
                    params.put( "scanSerial", String.valueOf( insApiresult.get( "realBeforeProductSerialNo" ) ) );
                    params.put( "realBeforeProductSerialNo", beforeProductSerialNo );
                    params.put( "salesOrdId", String.valueOf( installResult.get( "salesOrdId" ) ) );
                    params.put( "itmCode", String.valueOf( insApiresult.get( "realBeforeProductCode" ) ) );
                    params.put( "reqstNo", String.valueOf( installResult.get( "installEntryNo" ) ) );
                    params.put( "callGbn", "EXCH_RETURN" );
                    params.put( "mobileYn", "Y" );
                    params.put( "userId", userId );
                    params.put( "pErrcode", "" );
                    params.put( "pErrmsg", "" );
                    MSvcLogApiService.SP_SVC_BARCODE_CHANGE( params );

                    if ( !"000".equals( params.get( "pErrcode" ) ) ) {
                      String procTransactionId = transactionId;
                      String procName = "Installation";
                      String procKey = serviceNo;
                      String procMsg = "Failed to Barcode Save";
                      String errorMsg = "[API] " + params.get( "pErrmsg" );
                      throw new BizException( "01", procTransactionId, procName, procKey, procMsg, errorMsg, null );
                    }
                  }
                }
              }

              params.put( "scanSerial", String.valueOf( insApiresult.get( "serialNo" ) ) );
              params.put( "salesOrdId", String.valueOf( installResult.get( "salesOrdId" ) ) );
              params.put( "reqstNo", String.valueOf( installResult.get( "installEntryNo" ) ) );
              params.put( "delvryNo", null );
              params.put( "callGbn", "INSTALL" );
              params.put( "mobileYn", "Y" );
              params.put( "userId", userId );
              params.put( "pErrcode", "" );
              params.put( "pErrmsg", "" );

              MSvcLogApiService.SP_SVC_BARCODE_SAVE( params );

              if ( !"000".equals( params.get( "pErrcode" ) ) ) {
                String procTransactionId = transactionId;
                String procName = "Installation";
                String procKey = serviceNo;
                String procMsg = "Failed to Barcode Save";
                String errorMsg = "[API] " + params.get( "pErrmsg" );
                throw new BizException( "01", procTransactionId, procName, procKey, procMsg, errorMsg, null );
              }

              spMap.put( "pErrcode", "" );
              spMap.put( "pErrmsg", "" );

              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL( spMap );

              String errCode = (String) spMap.get( "pErrcode" );
              String errMsg = (String) spMap.get( "pErrmsg" );

              if ( !"000".equals( errCode ) ) {
                String procTransactionId = transactionId;
                String procName = "Installation";
                String procKey = serviceNo;
                String procMsg = "Failed to Save";
                String errorMsg = "[API] " + errMsg;
                throw new BizException( "02", procTransactionId, procName, procKey, procMsg, errorMsg, null );
              }
            } else {
              servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST( spMap );
            }

            Map<String, Object> smsResultValue = new HashMap<String, Object>();
            try {
              smsResultValue = installationResultListService.installationSendSMS( params.get( "hidAppTypeId" ).toString(), params );
            } catch ( Exception e ) {
              logger.info( "===smsResultValue===" + smsResultValue.toString() );
              logger.info( "===Failed to send SMS to" + params.get( "custMobileNo" ).toString() + "===" );
            }
          }

          logger.info( "###insApiresult.get(chkCrtAs): " + insApiresult.get( "chkCrtAs" ) );
          // Added for inserting charge out filters and spare parts at AS. By Hui Ding, 06-04-2021
          if ( insApiresult.get( "chkCrtAs" ) != null && insApiresult.get( "chkCrtAs" ).toString().equals( "1" ) ) {
            int user_id_47 = 0;
            installResult.put( "ctId", String.valueOf( userId ) );

            if ( userId != null ) {
              Map<String, Object> p = new HashMap<String, Object>();
              p.put( "memId", String.valueOf( userId ) );
              EgovMap userIdResult = installationResultListMapper.selectUserByMemId( p );

              if ( userIdResult != null && userIdResult.get( "userId" ) != null ) {
                user_id_47 = Integer.valueOf( userIdResult.get( "userId" ).toString() );
              }
            }

            String appntDtFormatted = null;

            if ( installResult.get( "appntDt" ) != null ) {
              Date appntDtOri = new SimpleDateFormat( "yyyy-MM-dd" ).parse( installResult.get( "appntDt" ).toString() );
              appntDtFormatted = CommonUtils.getFormattedString( "dd/MM/yyyy", appntDtOri );
              installResult.put( "appntDt", appntDtFormatted ); // format date (in string) to dd/MM/yy  y format
            }

            logger.info( "### appointment date after: " + installResult.get( "appntDt" ) );
            logger.info( "### INS AS (filter param) : " + paramsDetail.toString() );

            /** Added for INS AS. Hui Ding, 2021-10-26 **/
            double totalPrice = 0.00;
            List<Map<String, Object>> newPartList = new ArrayList<Map<String, Object>>();
            Map<String, Object> newPart = null;
            Map<String, Object> filter = null;
            for ( Map<String, Object> part : paramsDetail ) {
              if ( part != null ) {
                newPart = new HashMap<String, Object>();
                filter = new HashMap<String, Object>();
                // to add stock code as filterStockCode. 02/10/2024, Hui Ding
                filter.put( "stkId", String.valueOf( part.get( "filterCode" ) ) );
                String filterStockCode = stockMapper.selectStkCodeById( filter );

                if ( filterStockCode != null && !filterStockCode.isEmpty() )
                  newPart.put( "filterStockCode", filterStockCode );
                // end. to add stock code as filterStockCode. 02/10/2024, Hui Ding
                newPart.put( "filterID", String.valueOf( part.get( "filterCode" ) ) );
                newPart.put( "srvFilterLastSerial", String.valueOf( part.get( "filterBarcdSerialNo" ) ) );
                newPart.put( "filterQty", String.valueOf( part.get( "filterChangeQty" ) ) );
                newPart.put( "stockTypeId", String.valueOf( part.get( "partsType" ) ) );
                newPart.put( "filterPrice", String.valueOf( part.get( "salesPrice" ) ) );
                newPart.put( "filterTotal", String.valueOf( part.get( "salesPrice" ) ) );
                newPart.put( "filterDesc", "API" );
                newPart.put( "filterExCode", 0 );
                newPart.put( "filterRemark", "NA" );

                totalPrice += ( part.get( "salesPrice" ) != null ? Double.parseDouble( part.get( "salesPrice" ).toString() ) : 0.00 );

                if ( part.get( "chargesFoc" ) != null && part.get( "chargesFoc" ).toString().equals( "1" ) ) {
                  newPart.put( "filterType", "FOC" );
                  totalPrice = 0.00;
                } else {
                  newPart.put( "filterType", "CHG" );
                }
                newPartList.add( newPart );
              }
            }

            params.put( "txtFilterCharge", totalPrice );
            params.put( "txtTotalCharge", totalPrice );
            params.put( "txtLabourCharge", 0.00 ); // temporary set foc
            installationResultListService.saveInsAsEntry( newPartList, params, installResult, user_id_47 );
          }
          // End of inserting charge out filters and spare parts at AS
        } catch ( Exception e ) {
          String procTransactionId = transactionId;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException( "02", procTransactionId, procName, procKey, procMsg, errorMsg, null );
        }
      }
      else {
        if ( RegistrationConstants.IS_INSERT_INSTALL_LOG ) {
          MSvcLogApiService.updateSuccessInstallStatus( String.valueOf( params.get( "transactionId" ) ) );
        }
      }
    } else {
      String procTransactionId = transactionId;
      String procName = "Installation";
      String procKey = serviceNo;
      String procMsg = "NoTarget Data";
      String errorMsg = "[API] [" + insApiresult.get( "userId" ) + "] IT IS NOT ASSIGNED CT CODE.";
      throw new BizException( "01", procTransactionId, procName, procKey, procMsg, errorMsg, null );
    }
    logger.debug( "### INSTALLATION FINAL PARAM : " + params.toString() );
    return ResponseEntity.ok( InstallationResultDto.create( transactionId ) );
  }

  @SuppressWarnings({ "rawtypes", "finally" })
  @Override
  public EgovMap installFailJobRequestProc( Map<String, Object> params ) throws Exception {
    Map<String, Object> errMap = new HashMap<String, Object>();
    EgovMap rtnResultMap = new EgovMap();

    String serviceNo = CommonUtils.nvl( params.get( "serviceNo" ) );
    SessionVO sessionVO = new SessionVO();

    int resultSeq = 0;

    rtnResultMap.put( "result", serviceNo );

    try {
      if ( RegistrationConstants.IS_INSERT_INSTALL_LOG ) {
        resultSeq = (Integer) params.get( "resultSeq" );
      }

      Date dt = new Date();
      Calendar cal = Calendar.getInstance();
      cal.setTime( dt );
      cal.add( Calendar.DATE, 1 );
      int year = cal.get( Calendar.YEAR );
      String month = String.format( "%02d", cal.get( Calendar.MONTH ) + 1 );
      String date = String.format( "%02d", cal.get( Calendar.DATE ) );
      String todayPlusOne = ( CommonUtils.nvl( date ) + '/' + CommonUtils.nvl( month ) + '/' + CommonUtils.nvl( year ) );

      int isInsCnt = installationResultListService.isInstallAlreadyResult( params ); // SAL0046D STATUS <> 1

      if ( isInsCnt == 0 ) { // INSTALLATION IS ACTIVE
        String statusId = "21"; // FAILL STATUS IS 21
        EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID( params ); // GET LIST OF INSTALLATION DETAILS BASED ON SALES ORDER NUMBER & INSTALLATION NO
        params.put( "installEntryId", installResult.get( "installEntryId" ) );
        String userId = CommonUtils.nvl( MSvcLogApiService.getUseridToMemid( params ) ); // GET USER ID FROM ORG0001D > MEM_ID

        if ( !"".equals( userId ) ) {
          sessionVO.setUserId( Integer.parseInt( userId ) ); // SET USER SESSION
        } else {
          errMap.put( "no", serviceNo );
          errMap.put( "exception", "User ID does not Exist (" + CommonUtils.nvl( params.get( "userId" ) ) + ") " );
          MSvcLogApiService.saveErrorToDatabase( errMap );
          throw new ApplicationException( AppConstants.FAIL, "User ID does not Exist (" + CommonUtils.nvl( params.get( "userId" ) ) + ") " );
        }

        params.put( "hidAppTypeId", CommonUtils.nvl( installResult.get( "codeId" ) ) );
        if ( installResult.get( "sirimNo" ) != null ) {
          params.put( "sirimNo", CommonUtils.nvl( installResult.get( "sirimNo" ) ) );
        } else {
          params.put( "sirimNo", "" );
        }

        if ( installResult.get( "serialNo" ) != null ) {
          params.put( "serialNo", CommonUtils.nvl( installResult.get( "serialNo" ) ) );
        } else {
          params.put( "serialNo", "" );
        }

        // ADDITTION PARAM(S) NEED TO ADD HERE
        params.put( "installStatus", CommonUtils.nvl( statusId ) );
        params.put( "statusCodeId", Integer.parseInt( CommonUtils.nvl( params.get( "installStatus" ).toString() ) ) );
        params.put( "hidEntryId", CommonUtils.nvl( installResult.get( "installEntryId" ) ) );
        params.put( "hidCustomerId", CommonUtils.nvl( installResult.get( "custId" ) ) );
        params.put( "hidSalesOrderId", CommonUtils.nvl( installResult.get( "salesOrdId" ) ) );
        params.put( "hidTaxInvDSalesOrderNo", CommonUtils.nvl( installResult.get( "salesOrdNo" ) ) );
        params.put( "hidStockIsSirim", CommonUtils.nvl( installResult.get( "isSirim" ) ) );
        params.put( "hidStockGrade", CommonUtils.nvl( installResult.get( "stkGrad" ) ) );
        params.put( "hidSirimTypeId", CommonUtils.nvl( installResult.get( "stkCtgryId" ) ) );
        params.put( "hiddeninstallEntryNo", CommonUtils.nvl( installResult.get( "installEntryNo" ) ) );
        params.put( "hidTradeLedger_InstallNo", CommonUtils.nvl( installResult.get( "installEntryNo" ) ) );
        params.put( "hidCallType", CommonUtils.nvl( installResult.get( "typeId" ) ) );
        params.put( "hidDocId", CommonUtils.nvl( installResult.get( "docId" ) ) );
        params.put( "CTID", CommonUtils.nvl( userId ) );
        params.put( "installDate", "" ); // NO INSTALLATION DATE DUE TO FAIL INSTALLATION
        params.put( "updator", CommonUtils.nvl( userId ) );
        params.put( "nextCallDate", CommonUtils.nvl( params.get( "nxtCallDate" ) ) != "" ? String.valueOf( params.get( "nxtCallDate" ) ) : todayPlusOne );
        params.put( "refNo1", "0" );
        params.put( "refNo2", "0" );
        params.put( "codeId", CommonUtils.nvl( installResult.get( "typeId" ) ) );
        params.put( "failReason", CommonUtils.nvl( params.get( "failReasonCode" ) ) );
        params.put( "failLocCde", CommonUtils.nvl( params.get( "failLocCde" ) ) );
        params.put( "volt", CommonUtils.nvl( params.get( "volt" ) ) );
        params.put( "psiRcd", CommonUtils.nvl( params.get( "psiRcd" ) ) );
        params.put( "lpmRcd", CommonUtils.nvl( params.get( "lpmRcd" ) ) );
        params.put( "tds", CommonUtils.nvl( params.get( "tds" ) ) );
        params.put( "roomTemp", CommonUtils.nvl( params.get( "roomTemp" ) ) );
        params.put( "waterSourceTemp", CommonUtils.nvl( params.get( "waterSourceTemp" ) ) );
        params.put( "turbLvl", CommonUtils.nvl( params.get( "turbLvl" ) ) );
        params.put( "ntu", CommonUtils.nvl( params.get( "ntu" ) ) );
        params.put( "customerType", CommonUtils.nvl( installResult.get( "custType" ) ) );
        params.put( "waterSrcType", CommonUtils.nvl( params.get( "waterSrcType" ) ) );
        params.put( "remark", CommonUtils.nvl( params.get( "remark" ) ) );
        params.put( "failLct", CommonUtils.nvl( params.get( "failLocCde" ) ) );
        params.put( "failDeptChk", CommonUtils.nvl( params.get( "failBfDepWH" ) ) );
        params.put( "chkInstallAcc", 'N' );
        params.put( "instAccLst", null );
        params.put( "mobileYn", 'Y' );
        EgovMap orderInfo = installationResultListService.getOrderInfo( params ); // GET LIST OF ORDER & INSTALLATION DETAILS INSTALLATION ENTRY ID

        if ( orderInfo != null ) {
          params.put( "hidOutright_Price", CommonUtils.nvl( orderInfo.get( "c5" ) ) );
        } else {
          params.put( "hidOutright_Price", "0" );
        }

        logger.debug( "= INSTALLATION FAIL JOB REQUEST PARAM : " + params.toString() );

        // START CALL ETRUST API BY PASSING PARAMS
        Map rtnValue = installationResultListService.insertInstallationResult( params, sessionVO );
        if ( null != rtnValue ) {
          HashMap spMap = (HashMap) rtnValue.get( "spMap" );

          if ( !"000".equals( spMap.get( "P_RESULT_MSG" ) ) ) {
            String procTransactionId = serviceNo;
            String procName = "Installation";
            String procKey = serviceNo;
            String procMsg = "PRODUCT FAIL";
            String errorMsg = "PRODUCT FAIL";
            errMap.put( "no", serviceNo );
            errMap.put( "exception", "PRODUCT INSTALLATION FAIL (" + CommonUtils.nvl( spMap.get( "P_RESULT_MSG" ) ) + ") " );
            MSvcLogApiService.saveErrorToDatabase( errMap );
            // SET RETURN VALUE SET AS FALSE DUE TO ERROR
            rtnResultMap.put( "status", false );
            throw new BizException( "03", procTransactionId, procName, procKey, procMsg, errorMsg, null );
          } else {
            if ( RegistrationConstants.IS_INSERT_INSTALL_LOG ) {
              MSvcLogApiService.updateSuccessInsFailServiceLogs( resultSeq );
              // SET RETURN VALUE SET AS TRUE
              rtnResultMap.put( "status", true );
            }
          }
        }
      } else { // INSTALLATION IS NOT ACTICE
        if ( RegistrationConstants.IS_INSERT_INSFAIL_LOG ) {
          // UPDATE ERROR LOG SVC0150D
          errMap.put( "no", serviceNo );
          errMap.put( "exception", "INSTALLATION STATUS NOT ACTIVE (" + CommonUtils.nvl( isInsCnt ) + ") " );
          MSvcLogApiService.saveErrorToDatabase( errMap );
          MSvcLogApiService.updateInsFailServiceLogs( params );
          // SET RETURN VALUE SET AS FALSE DUE TO ERROR
          rtnResultMap.put( "status", false );
        }
      }
    } catch ( Exception e ) {
      logger.error( e.getMessage() );
      errMap.put( "no", serviceNo );
      errMap.put( "exception", e );
      MSvcLogApiService.saveErrorToDatabase( errMap );
      // SET RETURN VALUE SET AS FALSE DUE TO ERROR
      rtnResultMap.put( "status", false );
      throw new ApplicationException( AppConstants.FAIL, e.getMessage() );
    } finally {
      return rtnResultMap;
    }
  }

  @SuppressWarnings({ "unused", "unchecked", "rawtypes" })
  @Override
  public ResponseEntity<InstallationResultDto> installationDtResultProc( Map<String, Object> insApiresult )
    throws Exception {
    String transactionId = "";
    String serviceNo = "";

    SessionVO sessionVO1 = new SessionVO();
    Map<String, Object> params = insApiresult;
    transactionId = String.valueOf( params.get( "transactionId" ) );
    serviceNo = String.valueOf( params.get( "serviceNo" ) );

    // SAL0046D CHECK
    int isInsMemIdCnt = installationResultListService.insResultSync( params );

    if ( isInsMemIdCnt > 0 ) {
      // SAL0046D CHECK (STUS_CODE_ID <> '1')
      int isInsCnt = installationResultListService.isInstallAlreadyResult( params );

      // MAKE SURE IT'S ALREADY PROCEEDED
      if ( isInsCnt == 0 ) {
        String statusId = "4"; // INSTALLATION STATUS
        // DETAIL INFO SELECT (SALES_ORD_NO, INSTALL_ENTRY_NO)
        EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID( params );

        params.put( "installEntryId", installResult.get( "installEntryId" ) );

        // DETAIL INFO SELECT (installEntryId)
        EgovMap orderInfo = installationResultListService.getOrderInfo( params );
        logger.debug( "### INSTALLATION STOCK : " + orderInfo.get( "stkId" ) );

        if ( orderInfo.get( "stkId" ) != null || !( "".equals( orderInfo.get( "stkId" ) ) ) ) {
          // CHECK STOCK QUANTITY
          Map<String, Object> locInfoEntry = new HashMap<String, Object>();
          locInfoEntry.put( "CT_CODE", CommonUtils.nvl( insApiresult.get( "userId" ).toString() ) );
          locInfoEntry.put( "STK_CODE", CommonUtils.nvl( orderInfo.get( "stkId" ).toString() ) );
          logger.debug( "LOC. INFO. ENTRY : {}" + locInfoEntry );
          EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY( locInfoEntry );
          logger.debug( "LOC. INFO. : {}" + locInfo );

          if ( locInfo != null ) {
            if ( Integer.parseInt( locInfo.get( "availQty" ).toString() ) < 1 ) {
              Map<String, Object> m = new HashMap();
              m.put( "APP_TYPE", "INS" );
              m.put( "SVC_NO", insApiresult.get( "serviceNo" ) );
              m.put( "ERR_CODE", "03" );
              m.put( "ERR_MSG", "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " + locInfo.get( "availQty" ).toString() );
              m.put( "TRNSC_ID", transactionId );

              MSvcLogApiService.insert_SVC0066T( m );
              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "PRODUCT UNAVAILABLE";
              String errorMsg = "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " + locInfo.get( "availQty" ).toString();

              throw new BizException( "03", procTransactionId, procName, procKey, procMsg, errorMsg, null );
            }
          } else {
            Map<String, Object> m = new HashMap();
            m.put( "APP_TYPE", "INS" );
            m.put( "SVC_NO", insApiresult.get( "serviceNo" ) );
            m.put( "ERR_CODE", "03" );
            m.put( "ERR_MSG", "[API] [" + insApiresult.get( "userId" ) + "] PRODUCT FOR [" + orderInfo.get( "stkId" ).toString() + "] IS UNAVAILABLE. " );
            m.put( "TRNSC_ID", transactionId );

            MSvcLogApiService.insert_SVC0066T( m );
            String procTransactionId = transactionId;
            String procName = "Installation";
            String procKey = serviceNo;
            String procMsg = "PRODUCT LOC NO DATA";
            String errorMsg = "PRODUCT LOC NO DATA";
            throw new BizException( "03", procTransactionId, procName, procKey, procMsg, errorMsg, null );
          }
        }
        String userId = MSvcLogApiService.getUseridToMemid( params ); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
        String installDate = MSvcLogApiService.getInstallDate( insApiresult ); // SELECT TO_CHAR( TO_DATE(#{checkInDate} ,'YYYY/MM/DD') , 'DD/MM/YYYY' ) FROM DUAL

        params.put( "installStatus", String.valueOf( statusId ) );
        params.put( "statusCodeId", Integer.parseInt( params.get( "installStatus" ).toString() ) );
        params.put( "hidEntryId", String.valueOf( installResult.get( "installEntryId" ) ) );
        params.put( "hidCustomerId", String.valueOf( installResult.get( "custId" ) ) );
        params.put( "hidSalesOrderId", String.valueOf( installResult.get( "salesOrdId" ) ) );
        params.put( "hidTaxInvDSalesOrderNo", String.valueOf( installResult.get( "salesOrdNo" ) ) );
        params.put( "hidStockIsSirim", String.valueOf( installResult.get( "isSirim" ) ) );
        params.put( "hidStockGrade", installResult.get( "stkGrad" ) );
        params.put( "hidSirimTypeId", String.valueOf( installResult.get( "stkCtgryId" ) ) );
        params.put( "hiddeninstallEntryNo", String.valueOf( installResult.get( "installEntryNo" ) ) );
        params.put( "hidTradeLedger_InstallNo", String.valueOf( installResult.get( "installEntryNo" ) ) );
        params.put( "hidCallType", String.valueOf( installResult.get( "typeId" ) ) );
        params.put( "installDate", installDate );
        params.put( "CTID", String.valueOf( userId ) );
        params.put( "updator", String.valueOf( userId ) );
        params.put( "nextCallDate", "01-01-1999" );
        params.put( "refNo1", "0" );
        params.put( "refNo2", "0" );
        params.put( "codeId", String.valueOf( installResult.get( "257" ) ) );
        params.put( "checkCommission", 1 );

        if ( orderInfo != null ) {
          params.put( "hidOutright_Price", CommonUtils.nvl( String.valueOf( orderInfo.get( "c5" ) ) ) );
        } else {
          params.put( "hidOutright_Price", "0" );
        }

        params.put( "hidAppTypeId", installResult.get( "codeId" ) );
        params.put( "hidStockIsSirim", String.valueOf( insApiresult.get( "sirimNo" ) ) );
        params.put( "hidSerialNo", String.valueOf( insApiresult.get( "serialNo" ) ) );
        params.put( "remark", insApiresult.get( "resultRemark" ) );
        params.put( "dtPairCode", insApiresult.get( "partnerCode" ) );
        params.put( "EXC_CT_ID", String.valueOf( userId ) );
        params.put( "hidSerialRequireChkYn", "Y" );
        params.put( "mobileYn", "Y" );
        logger.debug( "### INSTALLATION PARAM : " + params.toString() );

        sessionVO1.setUserId( Integer.parseInt( userId ) );

        // INST. ACCS LIST START
        List<Map<String, Object>> paramsDetailInstAccLst = InstallationResultDetailForm.createMaps( (List<InstallationResultDetailForm>) insApiresult.get( "installAccList" ) );
        logger.debug( "### INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString() );
        List<String> lstStr = new ArrayList<>();

        for ( Map<String, Object> accLst : paramsDetailInstAccLst ) {
          if ( accLst != null ) {
            lstStr.add( String.valueOf( accLst.get( "insAccPartId" ) ) );
          }
        }
        logger.debug( "### INST ACCS LIST SIZE : " + lstStr.size() );
        params.put( "instAccLst", lstStr );
        // INST. ACCS LIST END

        try {
          Map rtnValue = installationResultListService.insertInstallationResult( params, sessionVO1 );
          if ( null != rtnValue ) {
            HashMap spMap = (HashMap) rtnValue.get( "spMap" );

            if ( !"000".equals( spMap.get( "P_RESULT_MSG" ) ) ) {
              rtnValue.put( "logerr", "Y" );
            }

            params.put( "scanSerial", String.valueOf( insApiresult.get( "scanSerial" ) ) );
            params.put( "salesOrdId", String.valueOf( installResult.get( "salesOrdId" ) ) );
            params.put( "reqstNo", String.valueOf( insApiresult.get( "serviceNo" ) ) );
            params.put( "delvryNo", null );
            params.put( "callGbn", "INSTALL" );
            params.put( "mobileYn", "Y" );
            params.put( "userId", userId );
            params.put( "pErrcode", "" );
            params.put( "pErrmsg", "" );

            MSvcLogApiService.SP_SVC_BARCODE_SAVE( params );

            if ( !"000".equals( params.get( "pErrcode" ) ) ) {
              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "Failed to Barcode Save";
              String errorMsg = "[API] " + params.get( "pErrmsg" );
              throw new BizException( "02", procTransactionId, procName, procKey, procMsg, errorMsg, null );
            }
            spMap.put( "pErrcode", "" );
            spMap.put( "pErrmsg", "" );

            servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL( spMap );

            String errCode = (String) spMap.get( "pErrcode" );
            String errMsg = (String) spMap.get( "pErrmsg" );

            if ( !"000".equals( errCode ) ) {
              String procTransactionId = transactionId;
              String procName = "Installation";
              String procKey = serviceNo;
              String procMsg = "Failed to Save";
              String errorMsg = "[API] " + errMsg;
              throw new BizException( "02", procTransactionId, procName, procKey, procMsg, errorMsg, null );
            }
          }
        } catch ( Exception e ) {
          String procTransactionId = transactionId;
          String procName = "Installation";
          String procKey = serviceNo;
          String procMsg = "Failed to Save";
          String errorMsg = "[API] " + e.toString();
          throw new BizException( "02", procTransactionId, procName, procKey, procMsg, errorMsg, null );
        }
      } else {
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
      String errorMsg = "[API] [" + insApiresult.get( "userId" ) + "] IT IS NOT ASSIGNED CT CODE.";
      throw new BizException( "01", procTransactionId, procName, procKey, procMsg, errorMsg, null );
    }
    logger.debug( "### INSTALLATION FINAL PARAM : " + params.toString() );
    return ResponseEntity.ok( InstallationResultDto.create( transactionId ) );
  }

}
