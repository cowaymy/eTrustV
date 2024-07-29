package com.coway.trust.biz.supplement.cancellation.service.impl;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.cmmn.model.EmailVO;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.supplement.cancellation.service.SupplementCancellationService;
import com.coway.trust.biz.supplement.impl.SupplementSubmissionMapper;

@Service("supplementCancellationService")
public class SupplementCancellationImpl
  extends EgovAbstractServiceImpl
  implements SupplementCancellationService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementCancellationImpl.class );

  @Resource(name = "supplementCancellationMapper")
  private SupplementCancellationMapper supplementCancellationMapper;

  @Resource(name = "supplementSubmissionMapper")
  private SupplementSubmissionMapper supplementSubmissionMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private JavaMailSender mailSender;

  @Autowired
  private VelocityEngine velocityEngine;

  @Value("${mail.supplement.config.from}")
  private String from;

  @Override
  public List<EgovMap> selectSupRefStus() {
    return supplementCancellationMapper.selectSupRefStus();
  }

  @Override
  public List<EgovMap> selectSupRtnStus() {
    return supplementCancellationMapper.selectSupRtnStus();
  }

  @Override
  public List<EgovMap> selectSupRefStg() {
    return supplementCancellationMapper.selectSupRefStg();
  }

  @Override
  public List<EgovMap> selectSupDelStus() {
    return supplementCancellationMapper.selectSupDelStus();
  }

  @Override
  public List<EgovMap> selectSupplementCancellationJsonList( Map<String, Object> params ) throws Exception {
    return supplementCancellationMapper.selectSupplementCancellationJsonList( params );
  }

  @Override
  public List<EgovMap> selectSupplementItmList( Map<String, Object> params ) throws Exception {
    return supplementCancellationMapper.selectSupplementItmList( params );
  }

  @Override
  public EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception {
    return supplementCancellationMapper.selectOrderBasicInfo( params );
  }

  @Override
  public List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params ) {
    return supplementCancellationMapper.checkDuplicatedTrackNo( params );
  }

  @Override
  public Map<String, Object> updateRefStgStatus( Map<String, Object> params )
    throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    Map<String, Object> emailMap = new HashMap<>();
    String rtnSeqNo = "";
    try {
      // UPDATE SUP0007M
      supplementCancellationMapper.updateRefStgStatus( params );
      // UPDATE SUP0001M
      supplementCancellationMapper.updateMasterRefStgStatus( params );

      rtnSeqNo = supplementCancellationMapper.getRtnSeqNo();
      params.put( "rtnSeqNo", rtnSeqNo );
      // UPDATE DEL_FLG TO Y PREVIOUS RECORDS IF EXISTS
      supplementCancellationMapper.updateExistingReturn( params );
      // INSERT SUP0008M
      supplementCancellationMapper.insertGoodsReturnMaster( params );

      emailMap = supplementCancellationMapper.getCustomerInfo( params );
      emailMap.put( "parcelRtnTrackNo", params.get( "parcelRtnTrackNo" ) );
      emailMap.put( "emailType", "1" );
      rtnMap.put( "logError", "000" );
      this.sendEmail( emailMap );
    }
    catch ( Exception e ) {
      supplementCancellationMapper.rollbackRefStgStatus( params );
      supplementCancellationMapper.rollbackMasterRefStgStatus( params );
      supplementCancellationMapper.removeGoodsReturnMaster( params );
      rtnMap.put( "logError", "99" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error updating parcel tracking number...", e );
    }
    return rtnMap;
  }

  public void sendEmail( Map<String, Object> params ) {
    EmailVO email = new EmailVO();
    String emailTitle = "";
    String content = "";
    List<String> emailNo = Arrays.asList( " " + CommonUtils.nvl( params.get( "email" ) ) + " " );

    if (CommonUtils.nvl( params.get( "emailType" )).equals( "1" )){
      emailTitle = "Your Refund Request (" + CommonUtils.nvl( params.get( "supReqCancNo" ) ) + ") Has Been Approved";
      content += "<html>" + "<body>"
          + "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/><br/>"
          + "Dear " + CommonUtils.nvl( params.get( "name" ) ) + " ,<br/><br/>"
          + "We are pleased to inform you that your refund request has been approved.<br/><br/>"
          + "Please be reminded that only unopened product(s) will be accepted. Ensure the product is safe and in good condition during delivery by using the original carton box or wrapping it with bubble wrap when returning the product."
          + "Coway reserves the right to reject any returned products that are deemed spoiled, opened, or in bad condition.<br/><br/>"
          + "Please follow the instructions below:<br/><br/>"
          + "Drop off the package at a DHL Branch (not Network Partner). Here is a list of DHL Branches:<br/><br/>"
          + "Link: https://www.dhl.com/discover/en-my/ship-with-dhl/dhl-express-locations<br/>"
          + "Return code:" + CommonUtils.nvl( params.get( "parcelRtnTrackNo" ) ) +"<br/>"
          + "Ensure the package is in good condition before passing it to our courier partner.<br/>"
          + "Your return package delivery fee is borne by Coway. Do not make any payment to our courier partner.<br/><br/>"
          + "Best Regards, <br/>"
          + "Coway <br/><br/>"
          + "<span style='font-size: 12;'>Please do not reply to this email as this is a computer generated message.</span><br/>";
    } else if (CommonUtils.nvl( params.get( "emailType" )).equals( "2" )) {
      emailTitle = "Your Returned Package (" + CommonUtils.nvl( params.get( "supReqCancNo" ) ) + ") Has Been Received";
      content += "<html>" + "<body>"
          + "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/><br/>"
          + "Dear " + CommonUtils.nvl( params.get( "name" ) ) + " ,<br/><br/>"
          + "We have received your returned package!<br/><br/>"
          + "Order Number: " + CommonUtils.nvl( params.get( "supRefNo" ) ) +"<br/>"
          + "Your refund will be processed as follows:<br/><br/>"
          + "Online Transfer: Please allow 6 working days.<br/>"
          + "Credit/Debit Card: Please allow 16-21 working days.<br/><br/>"
          + "Thank you for your support.<br/>"
          + "Best Regards, <br/>"
          + "Coway <br/><br/>"
          + "<span style='font-size: 12;'>Please do not reply to this email as this is a computer generated message.</span><br/>";
    } else {
      return;
    }

    email.setText( content );

    if ( emailNo.size() > 0 ) {
      email.setTo( emailNo );
      email.setHtml( true );
      email.setSubject( emailTitle );
      email.setHasInlineImage( true );
      boolean status = this.sendEmail( email, false, null, null );
      LOGGER.debug( Boolean.toString(status) );
    }
  }

  private boolean sendEmail( EmailVO email, boolean isTransactional, EmailTemplateType templateType, Map<String, Object> params ) {
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
  public EgovMap selectOrderStockQty( Map<String, Object> params ) throws Exception {
    return supplementCancellationMapper.selectOrderStockQty( params );
  }

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> updateReturnGoodsQty( Map<String, Object> params )
    throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    Map<String, Object> emailMap = new HashMap<>();
    try {
      List<Object> supplementItemGrid = (List<Object>) params.get( "rtnItmList" );
      supplementCancellationMapper.updateReturnGoodsQty( params );

      for ( int idx = 0; idx < supplementItemGrid.size(); idx++ ) {
        Map<String, Object> itemMap = (Map<String, Object>) supplementItemGrid.get( idx );
        int rtnItmSeq = supplementCancellationMapper.getRtnItmSeq();
        itemMap.put( "cancId", CommonUtils.nvl(params.get( "canReqId" )) );
        itemMap.put( "supRtnId", CommonUtils.nvl(params.get( "supRtnId" )) );
        itemMap.put( "rtnItmId", rtnItmSeq);
        itemMap.put( "userId", CommonUtils.nvl(params.get( "userId" )) );
        supplementCancellationMapper.insertGoodsReturnSub( itemMap );
      }

      // LOGISTIC CALL HERE
      Map<String, Object> rtnLogPrm = new HashMap<>();
      String ordNo = supplementCancellationMapper.getOrdNo( params );
      rtnLogPrm.put( "S_NO", CommonUtils.nvl(ordNo) );
      rtnLogPrm.put( "RETYPE", "US93" );
      rtnLogPrm.put( "P_LOC", CommonUtils.nvl(supplementSubmissionMapper.getWhLocId(SalesConstants.SUPPLEMENT_WH_LOC_CODE)) );
      rtnLogPrm.put( "P_TYPE", "OD93" );
      rtnLogPrm.put( "P_USER", params.get( "userId" ) );
      this.supRtnSp( rtnLogPrm );

      supplementCancellationMapper.updateMasterSupplementStat( params );

      emailMap = supplementCancellationMapper.getCustomerInfo( params );
      emailMap.put( "emailType", "2" );
      rtnMap.put( "logError", "000" );
      this.sendEmail( emailMap );
    }
    catch ( Exception e ) {
      supplementCancellationMapper.rollbackReturnGoodsQty( params );
      supplementCancellationMapper.rollbackMasterSupplementStat( params );
      supplementCancellationMapper.rollbackReturnQty( params );
      rtnMap.put( "logError", "99" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error updating parcel return quantity...", e );
    }
    return rtnMap;
  }

  @Override
  public List<EgovMap> getSupplementRtnItmDetailList( Map<String, Object> params )
    throws Exception {
    return supplementCancellationMapper.getSupplementRtnItmDetailList( params );
  }

  @SuppressWarnings("unchecked")
  @Override
  public EgovMap updOrdDelStatDhl( Map<String, Object> params ) throws IOException, JSONException, ParseException {
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
        dataValueMap.put( "latestConsignmentNoteDate", null );
        dataValueMap.put( "latestConsignmentNoteLocation", null );

        // INSERT DELIVERY LISTIN DETAIL HERE
        this.insertDelDhlListing( dataValueMap );
      }
      // TOTAL OF NUMBER RESPONSE SUCCESS RETURN
      success = respCountList.size();
    } else {
      success = 0;
    }
    EgovMap message = new EgovMap();
    message.put( "message", String.format( "Total records processed: %d, Successful: %d, Failed: %d", total, success,
                                           ( total - success ) ) );
    return message;
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
    supplementCancellationMapper.updateDelLstDtl( updParam );
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
      supplementCancellationMapper.insertDelLstDtl( insertParam );
    }
  }

  private void supRtnSp( Map<String, Object> params )
    throws Exception {
    supplementCancellationMapper.SP_LOGISTIC_RETURN_SUPP( params );
    if ( !"000".equals( params.get( "p1" ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "SP_LOGISTIC_RETURN_SUPP - ERRCODE : " + params.get( "p1" ) );
      // throw new Exception("SP_STO_PRC_SUPP - ERRCODE : " + logPram.get("p1"));
    }
  }

}