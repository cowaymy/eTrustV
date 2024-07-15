package com.coway.trust.biz.supplement.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;
import org.apache.velocity.app.VelocityEngine;
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
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.impl.SupplementTagManagementMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementTagManagementService")
public class SupplementTagManagementImpl
  extends EgovAbstractServiceImpl
  implements SupplementTagManagementService {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementTagManagementImpl.class );

  @Resource(name = "supplementTagManagementMapper")
  private SupplementTagManagementMapper supplementTagManagementMapper;

  @Autowired
  private FileService fileService;

  @Autowired
  private FileMapper fileMapper;

  @Autowired
  private JavaMailSender mailSender;

  @Value("${mail.supplement.config.from}")
  private String from;

  @Autowired
  private VelocityEngine velocityEngine;

  @Override
  public List<EgovMap> selectTagStus() {
    return supplementTagManagementMapper.selectTagStus();
  }

  @Override
  public List<EgovMap> selectTagManagementList( Map<String, Object> params ) throws Exception {
    return supplementTagManagementMapper.selectTagManagementList( params );
  }

  @Override
  public List<EgovMap> getMainTopicList() {
    return supplementTagManagementMapper.getMainTopicList();
  }

  @Override
  public List<EgovMap> getInchgDeptList() {
    return supplementTagManagementMapper.getInchgDeptList();
  }

  @Override
  public List<EgovMap> getSubTopicList( Map<String, Object> params ) {
    return supplementTagManagementMapper.getSubTopicList( params );
  }

  @Override
  public List<EgovMap> getSubDeptList( Map<String, Object> params ) {
    return supplementTagManagementMapper.getSubDeptList( params );
  }

  @Override
  public EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception {
    return supplementTagManagementMapper.selectOrderBasicInfo( params );
  }

  @Override
  public List<EgovMap> searchOrderBasicInfo( Map<String, Object> params ) {
    return supplementTagManagementMapper.searchOrderBasicInfo( params );
  }

  @Override
  public EgovMap selectViewBasicInfo( Map<String, Object> params ) {
    return supplementTagManagementMapper.selectViewBasicInfo( params );
  }

  /* THIS FUNCTION TO GENERATE TAG NUMBER */
  private String getSupReqCancNo() {
    // GET RUNNING SEQUENCE NUMBER
    String seqNo = supplementTagManagementMapper.getDocNo(201);
    // COMBINE TOGETHER
    return seqNo;
  }

  private String getTagTokenNo() {
      /* PREFIX : "S" + YYYYMMDD + '6 DIGIT RUNNING NUMBER (DOC: 200)*/
      // STEP 1 : GET TODAY DATE IN YYYYMMDD
      LocalDate today = LocalDate.now();
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
      String formattedDate = today.format(formatter);

      // GET RUNNING SEQUENCE NUMBER
      String seqNo = supplementTagManagementMapper.getDocNo(200);

      // COMBINE TOGETHER
      return "S" + formattedDate + seqNo;
    }

  @Override
  public List<EgovMap> getResponseLst( Map<String, Object> params ) throws Exception {
    return supplementTagManagementMapper.getResponseLst( params );
  }

  @Override
  public void insertTagSubmissionAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
    int fileGroupKey = fileMapper.selectFileGroupKey();
    AtomicInteger i = new AtomicInteger(0);

    list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
    params.put("fileGroupKey", fileGroupKey);
  }

  public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {
      int atchFlId = supplementTagManagementMapper.selectNextFileId();

      FileGroupVO fileGroupVO = new FileGroupVO();

      Map<String, Object> flInfo = new HashMap<String, Object>();
      flInfo.put("atchFileId", atchFlId);
      flInfo.put("atchFileName", flVO.getAtchFileName());
      flInfo.put("fileSubPath", flVO.getFileSubPath());
      flInfo.put("physiclFileName", flVO.getPhysiclFileName());
      flInfo.put("fileExtsn", flVO.getFileExtsn());
      flInfo.put("fileSize", flVO.getFileSize());
      flInfo.put("filePassword", flVO.getFilePassword());
      flInfo.put("fileUnqKey", params.get("claimUn"));
      flInfo.put("fileKeySeq", seq);

      supplementTagManagementMapper.insertFileDetail(flInfo);

      fileGroupVO.setAtchFileGrpId(fileGroupKey);
      fileGroupVO.setAtchFileId(atchFlId);
      fileGroupVO.setChenalType(flType.getCode());
      fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
      fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

      fileMapper.insertFileGroup(fileGroupVO);
  }

  @Override
  public void insertAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
    // TODO Auto-generated method stub
    int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
    params.put("fileGroupKey", fileGroupKey);
  }

  @Override
  public Map<String, Object> supplementTagSubmission(Map<String, Object> params) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();

    try {
      int tagSeq = supplementTagManagementMapper.getSeqSUP0006M();

      params.put("salesOrdId", "0");
      params.put("TypeId", "260");
      params.put("seqM", tagSeq);
      params.put("tokenM", getTagTokenNo());
      params.put( "userId", CommonUtils.nvl(params.get("userId")));

      // Insert SUP0006M
     supplementTagManagementMapper.insertSupplementTagMaster(params);

      int ccr06Seq = supplementTagManagementMapper.getSeqCCR0006D();
      params.put("seqCcrId", ccr06Seq);
      params.put("ccr06Stus", "1");

      int ccr07Seq = supplementTagManagementMapper.getSeqCCR0007D();
      params.put("seqCcrResultId", ccr07Seq);

      // Insert CCR0006D
      supplementTagManagementMapper.insertCCRMain(params);

      // Insert CCR0007D
      supplementTagManagementMapper.insertCcrDetail(params);

      // SET SUCCESS RESPONSE
      rtnMap.put("logError", "000");

    } catch (Exception e) {
      System.err.println("Error during New Tag Submission : " + e.getMessage());
      e.printStackTrace();

      rtnMap.put("logError", "999");
      rtnMap.put("message", e.getMessage());
    }

    return rtnMap;
  }

  public Map<String, Object> updateTagInfo( Map<String, Object> params ) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();

    try {
      params.put( "userId", CommonUtils.nvl(params.get("userId")));

      int ccr07Seq = supplementTagManagementMapper.getSeqCCR0007D();
      params.put("seqCcrResultId", ccr07Seq);

      // INSERT CCR0007D
      supplementTagManagementMapper.insertTagCcrDetail( params );

      if (params.get("attachYN") == "Y"){
        supplementTagManagementMapper.updateSupHqAttch(params);
      }

      // ACTIVE EITHE CANCEL OR RESOLVED BUT NOT IN REQUEST REFUND
      if ((params.get("tagStus").equals ("1")) || (params.get("tagStus").equals ("10")) || ((params.get("tagStus").equals ("5")) && (!params.get("subTopicId").equals ("4001")) )){
        // UPDATE CCR0006D
        supplementTagManagementMapper.updateCcrMain(params);

        if (params.get("tagStus").equals ("10")) { // REJECT
          Map<String, Object> custEmailDtl = supplementTagManagementMapper.getCustEmailDtl( params );
          if ( custEmailDtl != null ) {
            this.sendEmail( custEmailDtl );
          }
        }
      }

      // SOLVED & REQUEST REFUND
      if ((params.get("tagStus").equals ("5")) && (params.get("subTopicId").equals ("4001"))){
        int sup07Seq = supplementTagManagementMapper.getSeqSUP0007M();
        params.put("seqCancId", sup07Seq);

        params.put("tokenSupReqCancNo", getSupReqCancNo());

        //  INSERT SUP0007M
        supplementTagManagementMapper.insertCancMain(params);

        // UPDATE CCR0006D
        supplementTagManagementMapper.updateCcrMainWithCid(params);

        // UPDATE SUP0001M STATUS AND STAGE
        supplementTagManagementMapper.updateMasterSuppStaStag(params);
      }
      rtnMap.put( "logError", "000" );
    } catch ( Exception e ) {
      // supplementTagManagementMapper.rollbackRefStgStatus( params );
      rtnMap.put( "logError", "99" );
      rtnMap.put( "message", "An error occurred: " + e.getMessage() );
      LOGGER.error( "Error in updating approval request", e );
    }
    return rtnMap;
  }

  @Override
  public void sendEmail( Map<String, Object> params ) {
    EmailVO email = new EmailVO();
    String emailTitle = "";
    String content = "";

    List<String> emailNo = Arrays.asList(" "+ CommonUtils.nvl(params.get("custEmail")) +" ");

      emailTitle = "Refund Request Status";
      content += "<html>" + "<body>"
        + "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/><br/>"
        + "Dear " + CommonUtils.nvl( params.get( "custName" ) ) + " ,<br/><br/>"
        + "After reviewing your refund request, we regret to inform you that it has been rejected.<br/><br/>"
        + "The reasons for this decision are as follows: </b><br/>"
        + "<br/>" + CommonUtils.nvl( params.get( "remark" ) ) + "<br/><br/>"
        + "We apologize for any inconvenience this may cause and appreciate your understanding.<br/><br/>"
        + "If you have any questions or concerns about your order, please feel free to contact our customer service team at callcenter@coway.com.my or 1800-888-111.<br/>"
        + "Best Regards, <br/>"
        + "Coway <br/><br/>"
        + "<span style='font-size: 12;'>Please do not reply to this email as this is a computer generated message.</span><br/>";

    email.setText( content );

    if ( emailNo.size() > 0 ) {
      email.setTo( emailNo );
      email.setHtml( true );
      email.setSubject( emailTitle );
      email.setHasInlineImage( true );
      this.sendEmail( email, false, null, null );
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
      } else {
        messageHelper.setText( email.getText(), email.isHtml() );
      }

      if ( isMultiPart && email.getHasInlineImage() ) {
        try {
          messageHelper.addInline( "coway_header", new ClassPathResource( "template/stylesheet/images/coway_logo.png" ) );
        } catch ( Exception e ) {
          throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
        }
      } else if ( isMultiPart ) {
        email.getFiles().forEach( file -> {
          try {
            messageHelper.addAttachment( file.getName(), file );
          } catch ( Exception e ) {
            throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
          }
        });
      }
      mailSender.send( message );
    } catch ( Exception e ) {
      isSuccess = false;
      if ( isTransactional ) {
        throw new ApplicationException( e, AppConstants.FAIL, e.getMessage() );
      }
    }
    return isSuccess;
  }

  private String getMailTextByTemplate( EmailTemplateType templateType, Map<String, Object> params ) {
    return VelocityEngineUtils.mergeTemplateIntoString( velocityEngine, templateType.getFileName(), AppConstants.DEFAULT_CHARSET, params );
  }

  @Override
  public List<EgovMap> getAttachListCareline(Map<String, Object> params) {
    return supplementTagManagementMapper.selectAttachListCareline(params);
  }

  @Override
  public List<EgovMap> getAttachListHq(Map<String, Object> params) {
    return supplementTagManagementMapper.selectAttachListHq(params);
  }
}
