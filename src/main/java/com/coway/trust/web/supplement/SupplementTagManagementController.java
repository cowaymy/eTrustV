package com.coway.trust.web.supplement;

import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement")
public class SupplementTagManagementController {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementTagManagementController.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @Resource(name = "supplementTagManagementService")
  private SupplementTagManagementService supplementTagManagementService;

  @RequestMapping(value = "/supplementTagManagementList.do")
  public String selectSupplementTagManagementList( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
    List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    model.addAttribute( "tagStus", tagStus );
    model.addAttribute( "mainTopic", mainTopic );
    model.addAttribute( "inchgDept", inchgDept );

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    String bfDay = CommonUtils.changeFormat( CommonUtils.getCalMonth( -1 ), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1 );
    String toDay = CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT1 );
    model.put( "bfDay", bfDay );
    model.put( "toDay", toDay );

    return "supplement/supplementTagManagementList";
  }

  @RequestMapping(value = "/selectTagManagementList")
  public ResponseEntity<List<EgovMap>> selectSupplementList( @RequestParam Map<String, Object> params, HttpServletRequest request )
    throws Exception {
    List<EgovMap> listMap = null;

    String supTagStusArray[] = request.getParameterValues( "tagStus" );
    params.put( "supTagStusArray", supTagStusArray );

    listMap = supplementTagManagementService.selectTagManagementList( params );
    return ResponseEntity.ok( listMap );
  }

  @RequestMapping(value = "/getSubTopicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubTopicList( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    List<EgovMap> getSubTopicList = supplementTagManagementService.getSubTopicList( params );
    return ResponseEntity.ok( getSubTopicList );
  }

  @RequestMapping(value = "/getSubDeptList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDeptList( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    List<EgovMap> getSubDeptList = supplementTagManagementService.getSubDeptList( params );
    return ResponseEntity.ok( getSubDeptList );
  }

  @RequestMapping(value = "/tagMngApprovalPop.do")
  public String supplementTagManagementApproval( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;
    EgovMap tagInfoMap = null;

    List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo( params );
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);
    tagInfoMap = supplementTagManagementService.selectOrderBasicInfo( params );

    params.put( "userId", sessionVO.getUserId() );
    model.put( "userBr", sessionVO.getUserBranchId() );

    model.addAttribute( "orderInfo", orderInfoMap );
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);
    model.addAttribute( "tagInfo", tagInfoMap );
    model.addAttribute( "tagStus", tagStus );
    model.addAttribute( "inchgDept", inchgDept );

    return "supplement/supplementTagManagementApprovalPop";
  }

  @RequestMapping(value = "/newTagRequestPop.do")
  public String newTagRequestPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    model.addAttribute( "mainTopic", mainTopic );
    model.addAttribute( "inchgDept", inchgDept );

    model.put( "userBr", sessionVO.getUserBranchId() );
    params.put( "userId", sessionVO.getUserId() );

    return "supplement/supplementTagManagementCreationPop";
  }

  @RequestMapping(value = "/searchOrdNoPop.do")
  public String searchOrdNoPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    model.put( "userId", sessionVO.getUserId() );

    return "supplement/include/ordSlctPop";
  }

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderNo( @RequestParam Map<String, Object> params, ModelMap model ) {
    List<EgovMap> listMap = null;
    listMap = supplementTagManagementService.searchOrderBasicInfo( params );
    return ResponseEntity.ok( listMap );
  }

  @RequestMapping(value = "/supplementViewBasicPop.do")
  public String supplementViewPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementTagManagementService.selectViewBasicInfo( params );
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    model.addAttribute( "mainTopic", mainTopic );
    model.addAttribute( "inchgDept", inchgDept );
    model.addAttribute( "orderInfo", orderInfoMap );
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    params.put( "userId", sessionVO.getUserId() );
    model.put( "userBr", sessionVO.getUserBranchId() );

    return "supplement/supplementTagManagementCreationPop";
  }

  @RequestMapping(value = "/getResponseLst")
  public ResponseEntity<List<EgovMap>> getResponseLst( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> responceList = null;
    responceList = supplementTagManagementService.getResponseLst( params );
    return ResponseEntity.ok( responceList );
  }

  @SuppressWarnings("rawtypes")
  @RequestMapping(value = "/attachFileUploadId.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> attachFileUpload( MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO ) throws Exception {
    String err = "";
    String code = "";
    List<String> seqs = new ArrayList<>();
    LocalDate date = LocalDate.now();
    String year = String.valueOf( date.getYear() );
    String month = String.format( "%02d", date.getMonthValue() );
    String subPathName = (String) params.get( "attchFilePathName" );
    String subPath = File.separator + "supplement" + File.separator + subPathName + File.separator + year + File.separator + month + File.separator + CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT3 );
    try {
      Set<?> set = request.getFileMap().entrySet();
      Iterator<?> i = set.iterator();

      while ( i.hasNext() ) {
        Map.Entry me = (Map.Entry) i.next();
        String key = (String) me.getKey();
        seqs.add( key );
      }

      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles( request, uploadDir, subPath, AppConstants.UPLOAD_MIN_FILE_SIZE, true );
      LOGGER.debug( "list.size : {}", list.size() );
      params.put( CommonConstants.USER_ID, sessionVO.getUserId() );
      supplementTagManagementService.insertTagSubmissionAttachBiz( FileVO.createList( list ), FileType.WEB_DIRECT_RESOURCE, params, seqs );
      params.put( "attachFiles", list );
      code = AppConstants.SUCCESS;
    } catch ( ApplicationException e ) {
      err = e.getMessage();
      code = AppConstants.FAIL;
    }

    ReturnMessage message = new ReturnMessage();
    message.setCode( code );
    message.setData( params );
    message.setMessage( err );
    return ResponseEntity.ok( message );
  }

  @RequestMapping(value = "/supplementTagSubmission.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> supplementTagSubmission( @RequestBody Map<String, Object> params ) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";

    try {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put( "userId", sessionVO.getUserId() );

      Map<String, Object> returnMap = supplementTagManagementService.supplementTagSubmission( params );
      if ( "000".equals( returnMap.get( "logError" ) ) ) {
        msg += "New Tag Submission successfully saved.<br />";
        message.setCode( AppConstants.SUCCESS );
      }
      else {
        msg += "New Tag Submission failed to save.<br />";
        msg += returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.FAIL );
      }
      message.setMessage( msg );
    } catch ( Exception e ) {
      LOGGER.error( "Error during New Tag Submission", e );
      msg += "An unexpected error occurred.<br />";
      message.setCode( AppConstants.FAIL );
      message.setMessage( msg );
    }
    return ResponseEntity.ok( message );
  }

  @Transactional
  @RequestMapping(value = "/updateTagInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateRefStgStatus( @RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO ) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";

    params.put( "userId", sessionVO.getUserId() );

    try {
      Map<String, Object> returnMap = supplementTagManagementService.updateTagInfo( params );
      if ( "000".equals( returnMap.get( "logError" ) ) ) {
        msg += "Selected tag ticket update successfully.";
        message.setCode( AppConstants.SUCCESS );
      }
      else {
        msg += "Selected tag ticket failed to update. <br />";
        msg += "Errorlogs : " + returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.FAIL );
      }
      message.setMessage( msg );
    }
    catch ( Exception e ) {
      LOGGER.error( "Error during update tag approval details.", e );
      msg += "An unexpected error occurred.<br />";
      message.setCode( AppConstants.FAIL );
      message.setMessage( msg );
    }
    return ResponseEntity.ok( message );
  }

  @RequestMapping(value = "/selectAttachListCareline.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachListCareline( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    List<EgovMap> attachList = supplementTagManagementService.getAttachListCareline( params );
    return ResponseEntity.ok( attachList );
  }

  @RequestMapping(value = "/selectAttachListHq.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachListHq( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    List<EgovMap> attachList = supplementTagManagementService.getAttachListHq( params );
    return ResponseEntity.ok( attachList );
  }

  @RequestMapping(value = "/checkRcdExistCancellation.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> checkRcdExistCancellation( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    int list = supplementTagManagementService.checkRcdExistCancellation( params );
    return ResponseEntity.ok( list );
  }


}
