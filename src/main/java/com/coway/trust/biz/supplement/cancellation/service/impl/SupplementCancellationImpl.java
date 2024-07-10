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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.cmmn.model.EmailVO;

import java.util.ArrayList;
import java.util.Arrays;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.supplement.cancellation.service.SupplementCancellationService;

import java.io.IOException;
import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Service("supplementCancellationService")
public class SupplementCancellationImpl
  extends EgovAbstractServiceImpl
  implements SupplementCancellationService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementCancellationImpl.class );

  @Resource(name = "supplementCancellationMapper")
  private SupplementCancellationMapper supplementCancellationMapper;

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
    try {
      supplementCancellationMapper.updateRefStgStatus( params );
      emailMap = supplementCancellationMapper.getCustomerInfo( params );
      emailMap.put( "parcelRtnTrackNo", params.get( "parcelRtnTrackNo" ) );
      rtnMap.put( "logError", "000" );
      this.sendEmail( emailMap );
    }
    catch ( Exception e ) {
      supplementCancellationMapper.rollbackRefStgStatus( params );
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

    email.setText( content );

    LOGGER.debug( emailNo.toString() );
    LOGGER.debug( content );
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

  @Override
  public Map<String, Object> updateReturnGoodsQty( Map<String, Object> params )
    throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    Map<String, Object> emailMap = new HashMap<>();
    try {
      supplementCancellationMapper.updateReturnGoodsQty( params );
      emailMap = supplementCancellationMapper.getCustomerInfo( params );
      emailMap.put( "parcelRtnTrackNo", params.get( "parcelRtnTrackNo" ) );
      rtnMap.put( "logError", "000" );
      //this.sendEmail( emailMap );
    }
    catch ( Exception e ) {
      supplementCancellationMapper.rollbackRefStgStatus( params );
      rtnMap.put( "logError", "99" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error updating parcel tracking number...", e );
    }
    return rtnMap;
  }
}