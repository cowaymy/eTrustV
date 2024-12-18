package com.coway.trust.api.mobile.sales.ccpApi;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.biz.sales.ccpApi.PreCcpRegisterApiService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : PreCcpRegisterApiController.java
 * @Description : TO-DO Class Description
 */
@Api(value = "PreCcpRegisterApiController", description = "PreCcpRegisterApiController")
@RestController(value = "PreCcpRegisterApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/ccpApi")
public class PreCcpRegisterApiController {
  @Autowired
  private SessionHandler sessionHandler;

  private static final Logger LOGGER = LoggerFactory.getLogger( PreCcpRegisterApiController.class );

  @Resource(name = "PreCcpRegisterApiService")
  private PreCcpRegisterApiService preCcpRegisterApiService;

  @Resource(name = "preCcpRegisterService")
  private PreCcpRegisterService preCcpRegisterService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Autowired
  private AdaptorService adaptorService;

  @Value("${etrust.base.url}")
  private String etrustBaseUrl;

  @ApiOperation(value = "checkPreCcpResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkPreCcpResult", method = RequestMethod.GET)
  public ResponseEntity<List<PreCcpRegisterApiDto>> checkPreCcpResult( @ModelAttribute PreCcpRegisterApiForm param )
    throws Exception {
    try {
      List<EgovMap> preCcpResult = preCcpRegisterApiService.checkPreCcpResult( param );
      if ( preCcpResult == null ) {
        List<EgovMap> errorMsgReturn = new ArrayList<>();
        EgovMap errorMsg = new EgovMap();
        errorMsg.put( "success", 0 );
        errorMsg.put( "msg", "Record Not Found. Please proceed to check Pre-CCP in New Customer module." );
        errorMsgReturn.add( errorMsg );
        return ResponseEntity.ok( errorMsgReturn.stream().map( r -> PreCcpRegisterApiDto.create( r ) )
                                                .collect( Collectors.toList() ) );
      }
      if ( preCcpResult != null ) {
        Map<String, Object> detailsMap = new HashMap<String, Object>();
        detailsMap.put( "customerNric", param.getSelectKeyword() );
        detailsMap.put( "userId", preCcpResult.get( 0 ).get( "userId" ) );
        detailsMap.put( "custId", preCcpResult.get( 0 ).get( "custId" ) );
        detailsMap.put( "chsStatus", preCcpResult.get( 0 ).get( "chsStatus" ) );
        detailsMap.put( "chsRsn", preCcpResult.get( 0 ).get( "chsRsn" ) );
        detailsMap.put( "customerType", 7289 );
        int result = preCcpRegisterService.insertPreCcpSubmission( detailsMap );
      }
      return ResponseEntity.ok( preCcpResult.stream().map( r -> PreCcpRegisterApiDto.create( r ) )
                                            .collect( Collectors.toList() ) );
    }
    catch ( Exception e ) {
      List<EgovMap> errorMsgReturn = new ArrayList<>();
      EgovMap errorMsg = new EgovMap();
      errorMsg.put( "success", 0 );
      errorMsg.put( "msg", "Record Not Found. Please proceed to check Pre-CCP in New Customer module." );
      errorMsgReturn.add( errorMsg );
      return ResponseEntity.ok( errorMsgReturn.stream().map( r -> PreCcpRegisterApiDto.create( r ) )
                                              .collect( Collectors.toList() ) );
    }
  }

  @ApiOperation(value = "searchOrderSummaryList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/searchOrderSummaryList", method = RequestMethod.GET)
  public ResponseEntity<List<PreCcpRegisterApiDto>> searchOrderSummaryList( @ModelAttribute PreCcpRegisterApiForm param )
    throws Exception {
    List<EgovMap> orderSummary = preCcpRegisterApiService.searchOrderSummaryList( param );
    if ( LOGGER.isDebugEnabled() ) {
      for ( int i = 0; i < orderSummary.size(); i++ ) {
        LOGGER.debug( "orderSummary    값 : {}", orderSummary.get( i ) );
      }
    }
    return ResponseEntity.ok( orderSummary.stream().map( r -> PreCcpRegisterApiDto.create( r ) )
                                          .collect( Collectors.toList() ) );
  }

  @ApiOperation(value = "chkExistCust", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/chkExistCust", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> chkExistCust( @RequestParam Map<String, Object> params ) {
    ReturnMessage message = new ReturnMessage();
    EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer( params );
    EgovMap getRegisteredCust = preCcpRegisterService.getRegisteredCust( params );
    message.setCode( ( getExistCustomer == null && getRegisteredCust == null ) ? AppConstants.FAIL
                                                                               : AppConstants.SUCCESS );
    return ResponseEntity.ok( message );
  }

  public String getRandomNumber( int a ) {
    Random random = new Random();
    char[] chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".toCharArray();
    StringBuilder sb = new StringBuilder();
    for ( int i = 0; i < a; i++ ) {
      int num = random.nextInt( a );
      sb.append( chars[num] );
    }
    return sb.toString();
  }

  public Map<String, Object> triggerSms( @RequestParam Map<String, Object> params ) {
    Map<String, Object> message = new HashMap<String, Object>();
    try {
      EgovMap chkTime = preCcpRegisterService.chkSendSmsValidTime( params );
      BigDecimal defaultValidTime = new BigDecimal( "5" ),
        latestSendSmsTime = new BigDecimal( chkTime.get( "chkTime" ).toString() );;
      Integer compareResult = latestSendSmsTime.compareTo( defaultValidTime );
      EgovMap getCustInfo = preCcpRegisterService.getCustInfo( params );
      if ( getCustInfo == null ) {
        message.put( "success", 0 );
        message.put( "msg", "Fail to send SMS. Kindly contact system administrator or respective department." );
        return message;
      }
      if ( getCustInfo.get( "smsConsent" ).toString().equals( "1" ) ) {
        message.put( "success", 0 );
        message.put( "msg",
                     "Customer has confirmed the consent. No need try to send SMS again. Kindly refresh the page to get updated customer response." );
        return message;
      }
      if ( getCustInfo.get( "smsCount" ).toString().equals( "3" ) ) {
        message.put( "success", 0 );
        message.put( "msg", "You no longer have enough sms quota. Please try again on next day." );
        return message;
      }
      if ( getCustInfo.get( "smsCount" ).toString().equals( "0" ) || compareResult.equals( 1 ) ) {
        String smsMessage = "";
        smsMessage += "COWAY: Authorise Coway to check your credit standing for rental of a Coway appliance. Click ";
        smsMessage += etrustBaseUrl + "/sales/ccp/consent?d=" + getCustInfo.get( "tacNo" ).toString()
          + params.get( "preccpSeq" ).toString();
        smsMessage += ", check the box and submit. Thank you.";
        SmsVO sms = new SmsVO( 349, 7327 );
        sms.setMessage( smsMessage );
        sms.setMobiles( getCustInfo.get( "custMobileno" ).toString() );
        SmsResult smsResult = adaptorService.sendSMS3( sms );
        params.put( "smsId", smsResult.getSmsId() );
        params.put( "statusId", smsResult.getSmsStatus() );
        params.put( "failRsn", smsResult.getFailReason().toString() );
        params.put( "smsId", smsResult.getSmsId() );
        params.put( "userId", params.get( "userId" ) );
        preCcpRegisterService.insertSmsHistory( params );
        if ( smsResult.getSmsStatus() == 4 ) {
          preCcpRegisterService.updateSmsCount( params );
        }
        message.put( "success", smsResult.getSmsStatus() == 4 ? 1 : 0 );
        message.put( "msg",
                     smsResult.getSmsStatus() == 4 ? "The SMS Consent is successfully sent to customer."
                                                   : "Fail to send SMS. Kindly contact system administrator or respective department." );
        return message;
      }
      return message;
    }
    catch ( Exception e ) {
      message.put( "success", 0 );
      message.put( "msg", "Fail to send SMS. Kindly contact system administrator or respective department." );
      return message;
    }
  }

  @ApiOperation(value = "sendSms", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/sendSms", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> sendSms( @RequestBody Map<String, Object> params )
    throws Exception {
    Map<String, Object> message = new HashMap<String, Object>();
    EgovMap currentUser = preCcpRegisterService.currentUser( params );
    params.put( "userId", currentUser.get( "userId" ) );
    message = triggerSms( params );
    return ResponseEntity.ok( message );
  }

  @ApiOperation(value = "sendWhatsapp", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/sendWhatsapp", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> sendWhatsapp( @RequestBody Map<String, Object> params )
    throws Exception {
    ReturnMessage message = null;
    EgovMap currentUser = preCcpRegisterService.currentUser( params );
    params.put( "userId", currentUser.get( "userId" ) );
    message = preCcpRegisterService.sendWhatsApp( params );
    Map<String, Object> rtnMsg = new HashMap<String, Object>();
    rtnMsg.put( "success", message.getCode() );
    rtnMsg.put( "msg", message.getMessage() );
    return ResponseEntity.ok( rtnMsg );
  }

  @SuppressWarnings("unused")
  @ApiOperation(value = "submitPreCcpSubmission", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/submitPreCcpSubmission", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> submitPreCcpSubmission( @RequestBody Map<String, Object> params )
    throws Exception {
    Map<String, Object> message = new HashMap<String, Object>();
    try {
      EgovMap currentUser = preCcpRegisterService.currentUser( params );
      if ( currentUser == null ) {
        message.put( "success", 0 );
        message.put( "msg", "Requestor is not existed. Not allow to proceed Pre-CCP check" );
        return ResponseEntity.ok( message );
      }
      params.put( "userId", currentUser.get( "userId" ) );
      EgovMap getUserInfo = salesCommonService.getUserInfo( params );
      if ( currentUser == null ) {
        message.put( "success", 0 );
        message.put( "msg", "Only organization group member are allow to register Pre-CCP." );
        return ResponseEntity.ok( message );
      }
      Integer memType = Integer.parseInt( getUserInfo.get( "memType" ).toString() );
      if ( memType != 1 && memType != 2 && memType != 7 ) {
        message.put( "success", 0 );
        message.put( "msg", "Only organization group member are allow to register Pre-CCP." );
        return ResponseEntity.ok( message );
      }
      params.put( "customerType", 7290 );
      params.put( "userId", getUserInfo.get( "userId" ) );
      params.put( "orgCode", getUserInfo.get( "orgCode" ) );
      params.put( "grpCode", getUserInfo.get( "grpCode" ) );
      params.put( "deptCode", getUserInfo.get( "deptCode" ) );
      EgovMap chkQuota = preCcpRegisterService.chkQuota( params );
      if ( chkQuota == null || chkQuota.get( "chkQuota" ).toString().equals( "0" ) ) {
        message.put( "success", 0 );
        message.put( "msg", "Not enough quota to proceed do Pre-CCP Register." );
        return ResponseEntity.ok( message );
      }
      params.put( "tacNo", getRandomNumber( 6 ) );
      preCcpRegisterService.insertPreCcpSubmission( params );
      params.put( "preccpSeq", preCcpRegisterService.getSeqSAL0343D() );
      //triggerSms( params );
      preCcpRegisterService.sendWhatsApp( params );
      message.put( "success", 1 );
      message.put( "msg", "Your Pre-CCP request has been saved successfully." );
      return ResponseEntity.ok( message );
    }
    catch ( BizException bizException ) {
      throw new ApplicationException( AppConstants.FAIL, bizException.getProcMsg() );
    }
  }

  @ApiOperation(value = "chkDuplicated", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/chkDuplicated", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> chkDuplicated( @RequestParam Map<String, Object> params ) {
    String chkDate = preCcpRegisterService.chkSmsResetFlag().get( "chkDate" ).toString(),
      chkResetSmsFlag = preCcpRegisterService.chkSmsResetFlag().get( "resetFlag" ).toString();
    if ( chkResetSmsFlag.equals( "1" ) && chkResetSmsFlag.equals( "1" ) ) {
      params.put( "flag", 0 );
      preCcpRegisterService.updateResetFlag( params );
    }
    if ( chkResetSmsFlag.equals( "0" ) ) {
      if ( preCcpRegisterService.resetSmsConsent() >= 1 ) {
        params.put( "flag", 1 );
        preCcpRegisterService.updateResetFlag( params );
      }
    }
    ReturnMessage message = new ReturnMessage();
    message.setData( preCcpRegisterService.chkDuplicated( params ) );
    return ResponseEntity.ok( message );
  }

  @ApiOperation(value = "chkSmsResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/chkSmsResult", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> chkSmsResult( @RequestParam Map<String, Object> params ) {
    Map<String, Object> message = new HashMap<String, Object>();
    try {
      EgovMap chkSmsResult = preCcpRegisterService.chkSmsResult( params );
      if ( chkSmsResult == null ) {
        message.put( "success", 0 );
        message.put( "msg", "No result." );
      }
      else {
        message.put( "success", 1 );
        message.put( "name", chkSmsResult.get( "custName" ).toString() );
        message.put( "smsCount", Integer.parseInt( chkSmsResult.get( "smsCount" ).toString() ) );
        message.put( "smsConsent", chkSmsResult.get( "smsConsent" ).toString() );
        message.put( "preccpId", Integer.parseInt( chkSmsResult.get( "preccpSeq" ).toString() ) );
      }
    }
    catch ( Exception e ) {
      message.put( "success", 0 );
      message.put( "msg", "Failed to check this customer. Kindly please raise ticket to TrustDesk team." );
    }
    return ResponseEntity.ok( message );
  }

  @ApiOperation(value = "checkNewCustomerResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkNewCustomerResult", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> checkNewCustomerResult( @RequestParam Map<String, Object> params ) {
    Map<String, Object> message = new HashMap<String, Object>();
    try {
      EgovMap checkNewCustomerResult = preCcpRegisterService.checkNewCustomerResult( params );
      if ( checkNewCustomerResult == null ) {
        message.put( "success", 0 );
        message.put( "msg", "No result." );
      }
      else {
        message.put( "success", 1 );
        message.put( "custName", checkNewCustomerResult.get( "custName" ).toString() );
        message.put( "status", checkNewCustomerResult.get( "status" ).toString() );
        message.put( "reason", checkNewCustomerResult.get( "reason" ).toString() );
      }
    }
    catch ( Exception e ) {
      message.put( "success", 0 );
      message.put( "msg", "Failed to check this customer. Kindly please raise ticket to TrustDesk team." );
    }
    return ResponseEntity.ok( message );
  }

  @ApiOperation(value = "getCustId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getCustId", method = RequestMethod.GET)
  public ResponseEntity<String> getCustId( @RequestParam Map<String, Object> params ) {
    String custID = preCcpRegisterService.getCustId( params );

    return ResponseEntity.ok( custID );
  }
}
