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
import com.coway.trust.biz.supplement.SupplementSubmissionApplication;
import com.coway.trust.biz.supplement.SupplementSubmissionService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT
 * --------------------------------------------------------------------------------------------
 * 14/05/2024 TOMMY 1.0.1 - RE-STRUCTURE SupplementSubmissionController
 *********************************************************************************************/
@Controller
@RequestMapping(value = "/supplement")
public class SupplementSubmissionController {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementSubmissionController.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "supplementSubmissionService")
  private SupplementSubmissionService supplementSubmissionService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Autowired
  private SupplementSubmissionApplication supplementSubmissionApplication;

  @RequestMapping(value = "/supplementSubmissionList.do")
  public String selectSupplementSubmissionList( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    if ( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7 ) {
      EgovMap result = salesCommonService.getUserInfo( params );
      model.put( "orgCode", result.get( "orgCode" ) );
      model.put( "grpCode", result.get( "grpCode" ) );
      model.put( "deptCode", result.get( "deptCode" ) );
      model.put( "memCode", result.get( "memCode" ) );
    }
    String bfDay = CommonUtils.changeFormat( CommonUtils.getCalDate( -30 ), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1 );
    String toDay = CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT1 );
    model.put( "bfDay", bfDay );
    model.put( "toDay", toDay );
    return "supplement/supplementSubmissionList";
  }

  @RequestMapping(value = "/selectSupplementSubmissionJsonList")
  public ResponseEntity<List<EgovMap>> selectSupplementSubmissionJsonList( @RequestParam Map<String, Object> params, HttpServletRequest request )
    throws Exception {
    List<EgovMap> listMap = null;
    String branchArray[] = request.getParameterValues( "submissionBrnchId" );
    String statusArray[] = request.getParameterValues( "submissionStatusId" );
    params.put( "branchArray", branchArray );
    params.put( "statusArray", statusArray );
    listMap = supplementSubmissionService.selectSupplementSubmissionJsonList( params );
    return ResponseEntity.ok( listMap );
  }

  @RequestMapping(value = "/selectSupplementSubmissionItmList")
  public ResponseEntity<List<EgovMap>> selectSupplementSubmissionItmList( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementSubmissionService.selectSupplementSubmissionItmList( params );
    return ResponseEntity.ok( detailList );
  }

  @RequestMapping(value = "/supplementSubmissionAddPop.do")
  public String supplementSubmissionAddPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    model.put( "userBrnchId", sessionVO.getUserBranchId() );
    model.put( "userDefine1", params.get( "userDefine1" ) );
    return "supplement/supplementSubmissionAddPop";
  }

  @RequestMapping(value = "/selectExistSupplementSubmissionSofNo.do")
  public ResponseEntity<EgovMap> selectExistSupplementSubmissionSofNo( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    int cnt = supplementSubmissionService.selectExistSupplementSubmissionSofNo( params );
    EgovMap result = new EgovMap();
    result.put( "IS_EXIST", cnt > 0 ? "true" : "false" );
    return ResponseEntity.ok( result );
  }

  @RequestMapping(value = "/supplementSubmissionItemSearchPop.do")
  public String supplementSubmissionItemSearchPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    /* model.addAttribute("whBrnchId", params.get("whLocId")); */
    return "supplement/supplementSubmissionItemSearchPop";
  }

  @RequestMapping(value = "/selectSupplementItmList")
  public ResponseEntity<List<EgovMap>> selectSupplementItmList( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> codeList = null;
    codeList = supplementSubmissionService.selectSupplementItmList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/chkSupplementStockList")
  public ResponseEntity<List<EgovMap>> chkSupplementStockList( @RequestParam Map<String, Object> params, HttpServletRequest request )
    throws Exception {
    String stkId[] = request.getParameterValues( "itmLists" );
    params.put( "stkId", stkId );
    List<EgovMap> stokList = null;
    stokList = supplementSubmissionService.chkSupplementStockList( params );
    return ResponseEntity.ok( stokList );
  }

  @RequestMapping(value = "/selectMemBrnchByMemberCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectMemBrnchByMemberCode( @RequestParam Map<String, Object> params ) {
    EgovMap result = supplementSubmissionService.selectMemBrnchByMemberCode( params );
    return ResponseEntity.ok( result );
  }

  @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectMemberByMemberIDCode( @RequestParam Map<String, Object> params ) {
    EgovMap result = supplementSubmissionService.selectMemberByMemberIDCode( params );
    return ResponseEntity.ok( result );
  }

  @RequestMapping(value = "/supplementSubmissionRegister.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> supplementSubmissionRegister( @RequestBody Map<String, Object> params )
    throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    try {
      // Retrieve the current session user info
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put( "crtUsrId", sessionVO.getUserId() );
      // Call the service method
      Map<String, Object> returnMap = supplementSubmissionService.supplementSubmissionRegister( params );
      // Check the response and set the message accordingly
      if ( "000".equals( returnMap.get( "logError" ) ) ) {
        msg += "Supplement Submission successfully saved.<br />";
        msg += "SOF No : " + returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.SUCCESS );
      } else {
        msg += "Supplement Submission failed to save.<br />";
        msg += returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.FAIL );
      }
      message.setMessage( msg );
    }
    catch ( Exception e ) {
      LOGGER.error( "Error during supplement submission registration", e );
      msg += "An unexpected error occurred.<br />";
      message.setCode( AppConstants.FAIL );
      message.setMessage( msg );
    }
    return ResponseEntity.ok( message );
  }

  @RequestMapping(value = "/selectAttachList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachList( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    LOGGER.debug( "params {}", params );
    List<EgovMap> attachList = supplementSubmissionService.getAttachList( params );
    return ResponseEntity.ok( attachList );
  }

  @RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> attachFileUpload( MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO )
    throws Exception {
    String err = "";
    String code = "";
    List<String> seqs = new ArrayList<>();
    LocalDate date = LocalDate.now();
    String year = String.valueOf( date.getYear() );
    String month = String.format( "%02d", date.getMonthValue() );
    String subPath = File.separator + "supplement" + File.separator + "submission" + File.separator + year + File.separator + month + File.separator + CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT3 );
    try {
      Set set = request.getFileMap().entrySet();
      Iterator i = set.iterator();
      while ( i.hasNext() ) {
        Map.Entry me = (Map.Entry) i.next();
        String key = (String) me.getKey();
        seqs.add( key );
      }
      // List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles( request, uploadDir, subPath, AppConstants.UPLOAD_MIN_FILE_SIZE, true );
      params.put( CommonConstants.USER_ID, sessionVO.getUserId() );
      supplementSubmissionApplication.insertSupplementSubmissionAttachBiz( FileVO.createList( list ), FileType.WEB_DIRECT_RESOURCE, params, seqs );
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

  @RequestMapping(value = "/supplementSubmissionViewApprovalPop.do")
  public String preOrderModifyPop( @RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO ) throws Exception {
    model.put( "userBrnchId", sessionVO.getUserBranchId() );
    EgovMap result = supplementSubmissionService.selectSupplementSubmissionView( params );
    model.put( "supplement", result );
    model.put( "modValue", params.get( "modValue" ) );
    return "supplement/supplementSubmissionViewApprovalPop";
  }

  @RequestMapping(value = "/selectSupplementSubmissionView")
  public ResponseEntity<EgovMap> selectSupplementSubmissionView( @RequestParam Map<String, Object> params ) throws Exception {
    EgovMap detailList = null;
    detailList = supplementSubmissionService.selectSupplementSubmissionView( params );
    return ResponseEntity.ok( detailList );
  }

  @RequestMapping(value = "/selectSupplementSubmissionItmView")
  public ResponseEntity<List<EgovMap>> selectSupplementSubmissionItmView( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementSubmissionService.selectSupplementSubmissionItmView( params );
    return ResponseEntity.ok( detailList );
  }

  @RequestMapping(value = "/updateSubmissionApprovalStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateSubmissionApprovalStatus( @RequestBody Map<String, Object> params ) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    try {
      // Retrieve the current session user info
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put( "updUsrId", sessionVO.getUserId() );
      params.put( "crtUsrId", sessionVO.getUserId() );
      Map<String, Object> returnMap = supplementSubmissionService.updateSubmissionApprovalStatus( params );
      if ( "000".equals( returnMap.get( "logError" ) ) ) {
        msg += "Supplement Submission status successfully updated.<br />";
        msg += "Supplement Order No : " + returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.SUCCESS );
      }
      else if ( "001".equals( returnMap.get( "logError" ) ) ) {
        msg += "Supplement Submission status successfully updated.<br />";
        msg += "SOF No : " + returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.SUCCESS );
      }
      else {
        msg += "Supplement Submission failed to save.<br />";
        msg += returnMap.get( "message" ) + "<br />";
        message.setCode( AppConstants.FAIL );
      }
      message.setMessage( msg );
    }
    catch ( Exception e ) {
      LOGGER.error( "Error during updateSubmissionApprovalStatus", e );
      msg += "An unexpected error occurred.<br />";
      message.setCode( AppConstants.FAIL );
      message.setMessage( msg );
    }
    return ResponseEntity.ok( message );
  }
}
