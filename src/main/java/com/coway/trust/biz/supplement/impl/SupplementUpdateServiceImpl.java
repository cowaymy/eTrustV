package com.coway.trust.biz.supplement.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.velocity.app.VelocityEngine;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;

import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.supplement.impl.SupplementUpdateMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.cmmn.model.EmailVO;

import java.util.ArrayList;
import java.util.Arrays;
import com.coway.trust.biz.common.type.EmailTemplateType;

import java.io.IOException;
import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;

@Service("supplementUpdateService")
public class SupplementUpdateServiceImpl
  extends EgovAbstractServiceImpl
  implements SupplementUpdateService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementUpdateServiceImpl.class );

  @Resource(name = "supplementUpdateMapper")
  private SupplementUpdateMapper supplementUpdateMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private JavaMailSender mailSender;

  @Autowired
  private VelocityEngine velocityEngine;

  @Value("${mail.supplement.config.from}")
  private String from;

  @Override
  public List<EgovMap> selectPosJsonList( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.selectPosJsonList( params );
  }

  @Override
  public List<EgovMap> selectSupplementList( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.selectSupplementList( params );
  }

  @Override
  public List<EgovMap> selectSupRefStus() {
    return supplementUpdateMapper.selectSupRefStus();
  }

  @Override
  public List<EgovMap> selectSupRefStg() {
    return supplementUpdateMapper.selectSupRefStg();
  }

  @Override
  public List<EgovMap> selectSupDelStus() {
    return supplementUpdateMapper.selectSupDelStus();
  }

  @Override
  public List<EgovMap> selectSubmBrch() {
    return supplementUpdateMapper.selectSubmBrch();
  }

  public List<EgovMap> selectWhBrnchList()
    throws Exception {
    return supplementUpdateMapper.selectWhBrnchList();
  }

  @Override
  public List<EgovMap> getSupplementDetailList( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.getSupplementDetailList( params );
  }

  @Override
  public List<EgovMap> getDelRcdLst( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.getDelRcdLst( params );
  }

  @Override
  public List<EgovMap> getRtnItmRcdLst( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.getRtnItmRcdLst( params );
  }

  @Override
  public EgovMap selectOrderBasicInfo( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.selectOrderBasicInfo( params );
  }

  @Override
  public EgovMap selectCancDelInfo( Map<String, Object> params )
    throws Exception {
    return supplementUpdateMapper.selectCancDelInfo( params );
  }

  @Override
  public List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params ) {
    return supplementUpdateMapper.checkDuplicatedTrackNo( params );
  }

  @Override
  public List<EgovMap> selectPaymentMasterList( Map<String, Object> params ) {
    return supplementUpdateMapper.selectPaymentMasterList( params );
  }

  @Override
  public List<EgovMap> selectDocumentList( Map<String, Object> params ) {
    return supplementUpdateMapper.selectDocumentList( params );
  }

  public EgovMap selectOrderBasicLedgerInfo( Map<String, Object> params ) {
    return supplementUpdateMapper.selectOrderBasicLedgerInfo( params );
  }

  @SuppressWarnings("unchecked")
  @Override
  public List<EgovMap> getOderLdgr( Map<String, Object> params ) {
    supplementUpdateMapper.getOderLdgr( params );
    return (List<EgovMap>) params.get( "p1" );
  }

  @SuppressWarnings("unchecked")
  @Override
  public List<EgovMap> getOderOutsInfo( Map<String, Object> params ) {
    supplementUpdateMapper.getOderOutsInfo( params );
    return (List<EgovMap>) params.get( "p1" );
  }

  public Map<String, Object> updateRefStgStatus( Map<String, Object> params )
    throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    Map<String, Object> stoEntry = new HashMap<String, Object>();
    try {
      // int result = supplementUpdateMapper.updateRefStgStatus( params );
      supplementUpdateMapper.updateRefStgStatus( params );
      EgovMap stoSup = supplementUpdateMapper.getStoSup( params );
      stoEntry.put( "custName", params.get( "custName" ) );
      stoEntry.put( "supRefId", params.get( "supRefId" ) );
      stoEntry.put( "supRefNo", params.get( "supRefNo" ) );
      stoEntry.put( "reqstNo", stoSup.get( "reqstNo" ) );
      stoEntry.put( "userId", params.get( "userId" ) );
      params.put( "emailType", "1" );
      params.put( "deliveryAgent", "DHL" );
      params.put( "deliveryAgentUrl", "https://www.dhl.com/my-en/home/tracking.html" );
      stoPreSupp( stoEntry );
      rtnMap.put( "logError", "000" );
      this.sendEmail( params );
    }
    catch ( Exception e ) {
      supplementUpdateMapper.rollbackRefStgStatus( params );
      rtnMap.put( "logError", "99" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error updating parcel tracking number...", e );
    }
    return rtnMap;
  }

  private void stoPreSupp( Map<String, Object> params )
    throws Exception {
    Map<String, Object> logPram = new HashMap<>();
    logPram.put( "P_STO", params.get( "reqstNo" ) );
    logPram.put( "P_USER", params.get( "userId" ) );
    supplementUpdateMapper.SP_STO_PRE_SUPP( logPram );
    if ( !"000".equals( logPram.get( "p1" ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "SP_STO_PRC_SUPP - ERRCODE : " + logPram.get( "p1" ) );
      // throw new Exception("SP_STO_PRC_SUPP - ERRCODE : " + logPram.get("p1"));
    }
  }

  @SuppressWarnings("unchecked")
  @Override
  public EgovMap updOrdDelStatGdex( Map<String, Object> params )
    throws IOException, JSONException, ParseException {
    if ( CommonUtils.nvl( params.get( "ords" ) ).equals( "" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "NO ORDERS SELECTED TO PERFORM DELIVERY STATUS UPDATE." );
    }
    // LOOP SELECTED ORDERS
    List<Map<String, String>> ordsList = (List<Map<String, String>>) params.get( "ords" );
    int total = ordsList.size();
    int fail = 0;
    int success = 0;
    for ( Map<String, String> order : ordsList ) {
      String ordNo = order.get( "ordNo" ); // SUPPLEMENT ORDER NO.
      String trckNo = order.get( "trckNo" ); // SUPPLEMENT TRACKING NO.
      Map<String, Object> gDexPram = new HashMap<>();
      gDexPram.put( "consNo", CommonUtils.nvl( trckNo ) ); // CONSIGNMENT NO.
      gDexPram.put( "ordNo", CommonUtils.nvl( ordNo ) ); // SUPPLEMENT ORDER NO.
      // CALL GDEX GET DELIVERY STATUS AND DATE.
      EgovMap rtnData = commonService.getGdexShptDtl( gDexPram );
      if ( !"000".equals( rtnData.get( "status" ) ) ) {
        //throw new ApplicationException( AppConstants.FAIL, "gDEX - ERRCODE : " + rtnData.get( "message" ) );
        fail += 1;
        continue;
      }
      // UPDATE DELIVERY STATUS & DATE
      if ( CommonUtils.nvl( rtnData.get( "value" ) ).equals( "" ) ) {
        //throw new ApplicationException( AppConstants.FAIL, "GDEX RESPONE DOES NOT CONTAIN VALUE." );
        fail += 1;
        continue;
      }
      Map<String, Object> extractedValueMap = (Map<String, Object>) rtnData.get( "value" );
      extractedValueMap.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
      extractedValueMap.put( "ordNo", CommonUtils.nvl( order.get( "ordNo" ) ) );
      extractedValueMap.put( "consNo", CommonUtils.nvl( order.get( "trckNo" ) ) );
      if ( extractedValueMap.get( "latestEnumStatus" ).equals( "4" ) ) {
        extractedValueMap.put( "ordRefStat", "4" );
        extractedValueMap.put( "ordRefStg", "99" );
      }
      else {
        extractedValueMap.put( "latestConsignmentNoteLocation", null );
        extractedValueMap.put( "latestConsignmentNoteDate", null );
      }
      int count = supplementUpdateMapper.updOrdDelStat( extractedValueMap );
      if ( count > 0 ) {
        success += 1;
      }
      // SEND EMAIL TO CUSTOMER
      if ( extractedValueMap.get( "latestEnumStatus" ).equals( "4" ) ) {
        Map<String, Object> custEmailDtl = supplementUpdateMapper.getCustEmailDtl( extractedValueMap );
        custEmailDtl.put( "emailType", "2" );
        custEmailDtl.put( "deliveryAgent", "GDEX" );
        custEmailDtl.put( "deliveryAgentUrl", "https://gdexpress.com/tracking/" );
        this.sendEmail( custEmailDtl );
      }
      // INSERT DELIVERY LISTIN DETAIL HERE
      this.insertDelGdexListing( extractedValueMap );
    }
    EgovMap message = new EgovMap();
    message.put( "message",
                 String.format( "Total records processed: %d, Successful: %d, Failed: %d", total, success, fail ) );
    return message;
  }

  @SuppressWarnings("unchecked")
  @Override
  public EgovMap updOrdDelStatDhl( Map<String, Object> params )
    throws IOException, JSONException, ParseException {
    if ( CommonUtils.nvl( params.get( "ordNo" ) ).equals( "" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "NO ORDERS SELECTED TO PERFORM DELIVERY STATUS UPDATE." );
    }
    if ( CommonUtils.nvl( params.get( "consNo" ) ).equals( "" ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "NO SHIPMENT NO. SELECTED TO PERFORM DELIVERY STATUS UPDATE." );
    }
    // LOOP SELECTED ORDERS
    List<Map<String, String>> ordsList = (List<Map<String, String>>) params.get( "ordNo" );
    List<String> respCountList = new ArrayList<>();
    int total = ordsList.size();
    // int fail = 0;
    int success = 0;
    // CALL DHL GET DELIVERY STATUS AND DATE.
    EgovMap rtnData = commonService.getDhlShptDtl( params );
    if ( !"000".equals( rtnData.get( "status" ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "DHL - ERRCODE : " + rtnData.get( "message" ) );
    }
    if ( CommonUtils.nvl( rtnData.get( "value" ) ).equals( "" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "DHL RESPONE DOES NOT CONTAIN VALUE." );
    }
    Map<String, Object> extractedValueMap = (Map<String, Object>) rtnData.get( "value" );
    System.out.println( extractedValueMap.toString() );
    // MULTIPLE SHIPMENTS DETAILS RETURN
    List<Map<String, Object>> shipmentList = (List<Map<String, Object>>) extractedValueMap.get( "shipmentList" );
    if ( shipmentList != null ) {
      // LOOP SHIPMENTS DETAILS
      for ( Map<String, Object> shipment : shipmentList ) {
        Map<String, Object> dataValueMap = new HashMap<>();
        if ( !( CommonUtils.nvl( shipment.get( "subShipmentID" ) ).equals( "" ) ) ) {
          if ( !respCountList.contains( CommonUtils.nvl( shipment.get( "subShipmentID" ) ) ) ) {
            respCountList.add( CommonUtils.nvl( shipment.get( "subShipmentID" ) ) );
          }
        }
        dataValueMap.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
        dataValueMap.put( "ordNo", CommonUtils.nvl( shipment.get( "ordNo" ) ) );
        if (!(CommonUtils.nvl( shipment.get( "shipmentID" )).equals( "" ))) {
          dataValueMap.put( "consNo", CommonUtils.nvl( shipment.get( "shipmentID" )));
        } else {
          dataValueMap.put( "consNo", CommonUtils.nvl( shipment.get( "subShipmentID" )));
        }

        dataValueMap.put( "subConsNo", CommonUtils.nvl( shipment.get( "subShipmentID" ) ) );
        dataValueMap.put( "latestEnumStatus", CommonUtils.nvl( shipment.get( "latestEnumStatus" ) ) );
        dataValueMap.put( "deliveryHist", CommonUtils.nvl( shipment.get( "events" ) ) );
        if ( shipment.get( "latestEnumStatus" ).equals( "4" ) ) {
          dataValueMap.put( "ordRefStat", "4" );
          dataValueMap.put( "ordRefStg", "99" );
          dataValueMap.put( "latestConsignmentNoteDate",
                            CommonUtils.nvl( shipment.get( "latestConsignmentNoteDate" ) ) );
          dataValueMap.put( "latestConsignmentNoteLocation",
                            CommonUtils.nvl( shipment.get( "latestConsignmentNoteLocation" ) ) );
        }
        else {
          dataValueMap.put( "latestConsignmentNoteDate", null );
          dataValueMap.put( "latestConsignmentNoteLocation", null );
        }
        // int count = supplementUpdateMapper.updOrdDelDhlStat( dataValueMap );
        supplementUpdateMapper.updOrdDelDhlStat( dataValueMap );
        // INSERT DELIVERY LISTIN DETAIL HERE
        this.insertDelDhlListing( dataValueMap );
        // ITEMS DELIVERED TO CUSTOMER ONLY FIRE EMAIL
        if ( dataValueMap.get( "latestEnumStatus" ).equals( "4" ) ) {
          // SEND EMAIL TO CUSTOMER
          Map<String, Object> custEmailDtl = supplementUpdateMapper.getCustEmailDtl( dataValueMap );
          if ( custEmailDtl == null ) {
            // NO DATA RETRIEVED
            continue;
          }
          else {
            custEmailDtl.put( "emailType", "2" );
            custEmailDtl.put( "deliveryAgent", "DHL" );
            custEmailDtl.put( "deliveryAgentUrl", "https://www.dhl.com/my-en/home/tracking.html" );
            this.sendEmail( custEmailDtl );
          }
        }
      }
      // TOTAL OF NUMBER RESPONSE SUCCESS RETURN
      success = respCountList.size();
    }
    else {
      success = 0;
    }
    EgovMap message = new EgovMap();
    message.put( "message", String.format( "Total records processed: %d, Successful: %d, Failed: %d", total, success,
                                           ( total - success ) ) );
    return message;
  }

  public void insertDelGdexListing( Map<String, Object> params )
    throws JSONException {
    if ( params.get( "cnDetailStatusList" ) == null ) {
      // NO DATA FROM GDEX TO INSERT DELIVERY LISTING
      return;
    }
    // CONVERT STRING TO JSON ARRAY
    JSONArray jsonArray = new JSONArray( params.get( "cnDetailStatusList" ).toString() );
    if ( jsonArray.length() == 0 ) {
      // NO DATA FROM GDEX TO INSERT DELIVERY LISTING
      return;
    }
    Map<String, Object> updParam = new HashMap<>();
    updParam.put( "ordNo", CommonUtils.nvl( params.get( "ordNo" ) ) );
    updParam.put( "consNo", CommonUtils.nvl( params.get( "consNo" ) ) );
    updParam.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
    // SOFT REMOVE EXISTING LISTING DETAIL
    supplementUpdateMapper.updateDelLstDtl( updParam );
    for ( int i = 0; i < jsonArray.length(); i++ ) {
      JSONObject jsonObject = jsonArray.getJSONObject( i );
      Map<String, Object> insertParam = new HashMap<>();
      insertParam.put( "ordNo", CommonUtils.nvl( params.get( "ordNo" ) ) );
      insertParam.put( "consNo", CommonUtils.nvl( params.get( "consNo" ) ) );
      insertParam.put( "enumStatus", jsonObject.getInt( "enumStatus" ) );
      insertParam.put( "undelCode", jsonObject.getString( "undelCode" ) );
      insertParam.put( "consignmentNoteStatus", jsonObject.getString( "consignmentNoteStatus" ).toUpperCase() );
      insertParam.put( "statusDetail", jsonObject.getString( "statusDetail" ).toUpperCase() );
      insertParam.put( "location", jsonObject.getString( "location" ).toUpperCase() );
      insertParam.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
      // CONVERT DATE TO ORACLE ACCEPTABLE FORMAT
      Instant instant = Instant.parse( jsonObject.getString( "dateScan" ) );
      LocalDateTime dateTime = LocalDateTime.ofInstant( instant, ZoneId.of( "UTC" ) );
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern( "yyyy-MM-dd HH:mm:ss" );
      String formattedDateTime = dateTime.format( formatter );
      insertParam.put( "dateScan", CommonUtils.nvl( formattedDateTime ) );
      supplementUpdateMapper.insertDelLstDtl( insertParam );
    }
  }

  public void insertDelDhlListing( Map<String, Object> params )
    throws JSONException {
    if ( params.get( "deliveryHist" ) == null ) {
      // NO DATA FROM GDEX TO INSERT DELIVERY LISTING
      return;
    }
    System.out.println( params.get( "deliveryHist" ) );
    // CONVERT STRING TO JSON ARRAY
    JSONArray jsonArray = new JSONArray( params.get( "deliveryHist" ).toString() );
    if ( jsonArray.length() == 0 ) {
      // NO DATA FROM GDEX TO INSERT DELIVERY LISTING
      return;
    }
    if ( CommonUtils.nvl( params.get( "consNo" ) ).equals( "" ) ) {
      return;
    }
    Map<String, Object> updParam = new HashMap<>();
    //updParam.put( "ordNo", CommonUtils.nvl(params.get( "ordNo" )));
    updParam.put( "consNo", CommonUtils.nvl( params.get( "consNo" ) ) );
    updParam.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
    // SOFT REMOVE EXISTING LISTING DETAIL
    supplementUpdateMapper.updateDelLstDtl( updParam );
    for ( int i = 0; i < jsonArray.length(); i++ ) {
      JSONObject jsonObject = jsonArray.getJSONObject( i );
      Map<String, Object> insertParam = new HashMap<>();
      //insertParam.put( "ordNo", CommonUtils.nvl(params.get( "ordNo" )));
      insertParam.put( "consNo", CommonUtils.nvl( params.get( "consNo" ) ) );
      insertParam.put( "enumStatus", jsonObject.getInt( "status" ) );
      //insertParam.put( "undelCode", jsonObject.getString("undelCode"));
      insertParam.put( "consignmentNoteStatus", jsonObject.getString( "status" ) );
      insertParam.put( "statusDetail", jsonObject.getString( "description" ) );
      insertParam.put( "location", jsonObject.getString( "city" ) );
      insertParam.put( "userId", CommonUtils.nvl( params.get( "userId" ) ) );
      insertParam.put( "dateScan", jsonObject.getString( "dateTime" ) );
      supplementUpdateMapper.insertDelLstDtl( insertParam );
    }
  }

  @Override
  public EgovMap getStoSup( Map<String, Object> params ) {
    return supplementUpdateMapper.getStoSup( params );
  }

  @Override
  public EgovMap SP_STO_PRE_SUPP( Map<String, Object> params ) {
    return (EgovMap) supplementUpdateMapper.SP_STO_PRE_SUPP( params );
  }

  @Override
  public void sendEmail( Map<String, Object> params ) {
    EmailVO email = new EmailVO();
    String emailTitle = "";
    String content = "";
    List<String> emailNo = Arrays.asList( " " + CommonUtils.nvl( params.get( "custEmail" ) ) + " " );
    if ( CommonUtils.nvl( params.get( "emailType" ) ) == "1" ) {
      emailTitle = "Your Order Has Been Prepared and Is On Its Way!";
      content += "<html>" + "<body>"
        + "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/><br/>"
        + "Dear " + CommonUtils.nvl( params.get( "custName" ) ) + " ,<br/><br/>"
        + "We are excited to inform you that your order has been prepared and is ready for delivery. Your parcel will be delivered by "
        + CommonUtils.nvl( params.get( "deliveryAgent" ) ) + ". <br/><br/>" + "<b><u>Delivery Details:</u></b><br/>"
        + "<b>Order No. :</b>" + CommonUtils.nvl( params.get( "supRefNo" ) ) + "<br/>" + "<b>Tracking No. :</b>"
        + CommonUtils.nvl( params.get( "inputParcelTrackNo" ) ) + "<br/>" + "<b>Delivery Service : </b>"
        + CommonUtils.nvl( params.get( "deliveryAgent" ) ) + "<br/>"
        + "You can track the status of your delivery using the following link: "
        + CommonUtils.nvl( params.get( "deliveryAgentUrl" ) ) + "<br/><br/>"
        + "If you have any questions or concerns about your order, please feel free to contact our customer service team at callcenter@coway.com.my or 1800-888-111.<br/>"
        + "Thank you for shopping with us. We hope you enjoy your purchase!<br/><br/>" + "Best Regards, <br/>"
        + "Coway <br/><br/>"
        + "<span style='font-size: 12;'>Please do not reply to this email as this is a computer generated message.</span><br/>";
    }
    else if ( CommonUtils.nvl( params.get( "emailType" ) ) == "2" ) {
      emailTitle = "Your Parcel Has Been Delivered!";
      content += "<html>" + "<body>"
        + "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/><br/>"
        + "Dear " + CommonUtils.nvl( params.get( "custName" ) ) + " ,<br/><br/>"
        + "We are pleased to inform you that your parcel has been successfully delivered.<br/><br/>"
        + "<b><u>Delivery Details:</u></b><br/>" + "<b>Order No. :</b>" + CommonUtils.nvl( params.get( "supRefNo" ) )
        + "<br/>" + "<b>Delivery Address:</b><br/>" + CommonUtils.nvl( params.get( "addrLn1" ) ) + ", " + "<br/>";
      if ( !CommonUtils.nvl( params.get( "addrLn2" ) ).equals( "" ) ) {
        content += "" + CommonUtils.nvl( params.get( "addrLn2" ) ) + ", " + "<br/>";
      }
      content += "" + CommonUtils.nvl( params.get( "area" ) ) + ", " + "<br/>" + ""
        + CommonUtils.nvl( params.get( "postcode" ) ) + ", " + CommonUtils.nvl( params.get( "city" ) ) + ", " + "<br/>"
        + "" + CommonUtils.nvl( params.get( "state" ) ) + ", " + CommonUtils.nvl( params.get( "country" ) ) + ""
        + "<br/>" + "<b>Date of Delivery :</b>" + CommonUtils.nvl( params.get( "delDt" ) ) + "<br/><br/>"
        + "If you have any questions or concerns about your order, please feel free to contact our customer service team at callcenter@coway.com.my or 1800-888-111.<br/>"
        + "Thank you for shopping with us. We hope you enjoy your purchase!<br/><br/>" + "Best Regards, <br/>"
        + "Coway <br/><br/>"
        + "<span style='font-size: 12;'>Please do not reply to this email as this is a computer generated message.</span><br/>";
    }
    email.setText( content );
    // LOGGER.info( "[END] emailTitle: " + emailTitle + " " );
    // LOGGER.info( "[END] content " + content + " " );
    // LOGGER.info( "[END] Number of EMAIL SENT...: " + emailNo.size() + " " );
    if ( emailNo.size() > 0 ) {
      email.setTo( emailNo );
      email.setHtml( true );
      email.setSubject( emailTitle );
      email.setHasInlineImage( true );
      //boolean isResult = false;
      //isResult = adaptorService.sendEmail(email, false, null, null);
      //isResult = this.sendEmail( email, false, null, null );
      this.sendEmail( email, false, null, null );
    }
  }

  private boolean sendEmail( EmailVO email, boolean isTransactional, EmailTemplateType templateType,
                             Map<String, Object> params ) {
    boolean isSuccess = true;
    try {
      MimeMessage message = mailSender.createMimeMessage();
      boolean hasFile = email.getFiles().size() == 0 ? false : true;
      boolean hasInlineImage = email.getHasInlineImage();
      boolean isMultiPart = hasFile || hasInlineImage;
      MimeMessageHelper messageHelper = new MimeMessageHelper( message, isMultiPart, AppConstants.DEFAULT_CHARSET );
      messageHelper.setFrom( from );
      messageHelper.setTo( email.getTo().toArray( new String[email.getTo().size()] ) );
      messageHelper.setSubject( email.getSubject() );
      if ( templateType != null ) {
        messageHelper.setText( getMailTextByTemplate( templateType, params ), email.isHtml() );
      }
      else {
        messageHelper.setText( email.getText(), email.isHtml() );
      }
      if ( isMultiPart && email.getHasInlineImage() ) {
        try {
          messageHelper.addInline( "coway_header",
                                   new ClassPathResource( "template/stylesheet/images/coway_logo.png" ) );
        }
        catch ( Exception e ) {
          LOGGER.error( e.toString() );
          throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
        }
      }
      else if ( isMultiPart ) {
        email.getFiles().forEach( file -> {
          try {
            messageHelper.addAttachment( file.getName(), file );
          }
          catch ( Exception e ) {
            LOGGER.error( e.toString() );
            throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
          }
        } );
      }
      mailSender.send( message );
    }
    catch ( Exception e ) {
      isSuccess = false;
      LOGGER.error( e.getMessage() );
      if ( isTransactional ) {
        throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
      }
    }
    return isSuccess;
  }

  private String getMailTextByTemplate( EmailTemplateType templateType, Map<String, Object> params ) {
    return VelocityEngineUtils.mergeTemplateIntoString( velocityEngine, templateType.getFileName(),
                                                        AppConstants.DEFAULT_CHARSET, params );
  }

  @Override
  public List<EgovMap> getCustOrdDelInfo( Map<String, Object> params ) {
    return supplementUpdateMapper.getCustOrdDelInfo( params );
  }

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> updateDelStageInfo( Map<String, Object> params ) throws JsonProcessingException, IOException {
    Map<String, Object> rtnMap = new HashMap<>();
    List<Object> ordList = (List<Object>) params.get( "ordList" );

    for ( int idx = 0; idx < ordList.size(); idx++ ) {
      Map<String, Object> itemMap = (Map<String, Object>) ordList.get( idx );
      Map<String, Object> paramOrdInfo = new HashMap<String, Object>();

      paramOrdInfo.put( "ordNo", itemMap.get( "shipmDesc" ) );
      Map<String, Object> ordInfo = supplementUpdateMapper.getOrdInfo( paramOrdInfo );
      ordInfo.put( "userId", CommonUtils.nvl( params.get( "userId" ) ));
      ordInfo.put( "inputParcelTrackNo", "MYMEJ" + itemMap.get( "shipmOrdId" ) );

      try {
        this.updateRefStgStatus( ordInfo );
      }
      catch ( Exception e ) {
        e.printStackTrace();
        rtnMap.put( "logError", "99" );
        rtnMap.put( "message", "An error occurred: " + e.getMessage() );
        LOGGER.error( "Error updating parcel tracking number...", e );
      }
    }
    rtnMap.put( "logError", "000" );
    return rtnMap;
  }

}