package com.coway.trust.web.common;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.businessobjects.report.web.json.b;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.biz.services.as.ServiceMileageApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.DatabaseDrivenMessageSource;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovResourceCloseHelper;
import com.coway.trust.util.EgovWebUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonController {
  private static final Logger LOGGER = LoggerFactory.getLogger( CommonController.class );

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "hcPurchasePriceService")
  private HcPurchasePriceService hcPurchasePriceService;

  @Resource(name = "serviceMileageApiService")
  private ServiceMileageApiService serviceMileageApiService;

  @Autowired
  private DatabaseDrivenMessageSource dbMessageSource;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private MenuService menuService;

  @RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodeList( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "groupCode : {}", params );
    List<EgovMap> codeList = commonService.selectCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectCodeGroup.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodeGroup( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeGroup = commonService.selectCodeGroup( params );
    return ResponseEntity.ok( codeGroup );
  }

  @RequestMapping(value = "/selectHCMaterialCtgryList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCMaterialCtgryList( @RequestParam Map<String, Object> params ) {
    // Homecare material category list in MDN
    LOGGER.debug( "groupCode : {}", params );
    List<EgovMap> codeList = commonService.selectHCMaterialCtgryList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/main.do")
  public String main( @RequestParam Map<String, Object> params, ModelMap model ) {
    return "common/main";
  }

  @RequestMapping(value = "/mainExternal.do")
  public String mainExternal( @RequestParam Map<String, Object> params, ModelMap model ) {
    return "common/mainExternal";
  }

  @RequestMapping(value = "/unauthorized.do")
  public String unauthorized( @RequestParam Map<String, Object> params, ModelMap model ) {
    return "/error/unauthorized";
  }

  @RequestMapping(value = "/exportGrid.do")
  public void export( HttpServletRequest request, HttpServletResponse response )
    throws IOException, URISyntaxException {
    // AUIGrid 가 xlsx, csv, xml 등의 형식을 작성하여 base64 로 인코딩하여 data 파라메터로 post 요청을 합니다.
    // 해당 서버에서는 base64 로 인코딩 된 데이터를 디코드하여 다운로드 가능하도록 붙임으로 마무리합니다.
    // 참고로 org.apache.commons.codec.binary.Base64 클래스 사용을 위해는 commons-codec-1.4.jar 파일이 필요합니다.
    String pData = "data";
    String pExtension = "extension";
    String pFileName = "filename";
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    String data = request.getParameter( pData ); // 파라메터 data
    String extension = request.getParameter( pExtension ); // 파라메터 확장자
    String reqFileName = request.getParameter( pFileName ); // 파라메터 파일명
    if ( data == null ) {
      String body = EgovWebUtil.getBody( request );
      List<NameValuePair> bodyParams = URLEncodedUtils.parse( new URI( "tempUrl?" + body ),
                                                              AppConstants.DEFAULT_CHARSET );
      for ( NameValuePair nameValuePair : bodyParams ) {
        if ( pData.equals( nameValuePair.getName() ) ) {
          data = nameValuePair.getValue();
        }
        if ( pExtension.equals( nameValuePair.getName() ) ) {
          extension = nameValuePair.getValue();
        }
      }
    }
    byte[] dataByte = Base64.decodeBase64( data.getBytes() ); // 데이터 base64 디코딩
    // csv 를 엑셀에서 열기 위해서는 euc-kr 로 작성해야 함.
    try {
      if ( extension.equals( "csv" ) ) {
        String sting = new String( dataByte, AppConstants.DEFAULT_CHARSET );
        outputStream.write( sting.getBytes( "euc-kr" ) );
      }
      else {
        outputStream.write( dataByte );
      }
    }
    catch ( UnsupportedEncodingException e ) {
      throw new ApplicationException( e );
    }
    catch ( IOException e ) {
      throw new ApplicationException( e );
    }
    finally {
      EgovResourceCloseHelper.close( outputStream );
    }
    String fileName = "export." + extension; // 다운로드 될 파일명
    if ( CommonUtils.isNotEmpty( reqFileName ) ) {
      fileName = reqFileName + "." + extension;
    }
    response.reset();
    response.setContentType( "application/octet-stream" );
    response.setHeader( "Content-Disposition", "attachment; filename=" + fileName );
    response.setHeader( "Content-Length", String.valueOf( outputStream.size() ) );
    ServletOutputStream sos = null;
    try {
      sos = response.getOutputStream();
      sos.write( outputStream.toByteArray() );
      sos.flush();
      sos.close();
    }
    catch ( IOException e ) {
      throw new ApplicationException( e );
    }
    finally {
      EgovResourceCloseHelper.close( sos );
    }
  }

  @RequestMapping(value = "/db-messages/reload.do")
  public void reload( @RequestParam Map<String, Object> params ) {
    dbMessageSource.reload();
  }

  @RequestMapping(value = "/selectBranchCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBranchCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectBranchList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectUnitTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectUnitTypeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectUnitTypeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectBrandTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBrandTypeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectBrandTypeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectProductSizeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductSizeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectProductSizeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectProductSizeListSearch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductSizeListSearch( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectProductSizeListSearch( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectServiceTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectServiceTypeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectServiceTypeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectReasonCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectReasonCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectReasonCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  /**
   * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/getAccountList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAccountList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.getAccountList( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/getOrgCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getOrgCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.getOrgCodeList( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/getDeptCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDeptCodeList( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "param : " + params );
    List<EgovMap> resultList = commonService.getDeptCodeList( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/getGrpCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getGrpCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.getGrpCodeList( params );
    return ResponseEntity.ok( resultList );
  }

  /**
   * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/getBankAccountList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBankAccountList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.selectBankAccountList( params );
    return ResponseEntity.ok( resultList );
  }

  /**
   * IssuedBank 정보 조회
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/getIssuedBankList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getIssuedBankList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.selectBankList( params );
    return ResponseEntity.ok( resultList );
  }

  /**
   * Branch ID로 User 정보 조회
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/getUsersByBranch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getUsersByBranch( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = commonService.getUsersByBranch( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/selectCountryList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCountryList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> countryList = commonService.selectCountryList( params );
    return ResponseEntity.ok( countryList );
  }

  @RequestMapping(value = "/selectStateList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStateList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> stateList = commonService.selectStateList( params );
    return ResponseEntity.ok( stateList );
  }

  @RequestMapping(value = "/selectAreaList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAreaList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> AreaList = commonService.selectAreaList( params );
    return ResponseEntity.ok( AreaList );
  }

  @RequestMapping(value = "/selectPostCdList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPostCdList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> postCdList = commonService.selectPostCdList( params );
    return ResponseEntity.ok( postCdList );
  }

  @RequestMapping(value = "/selectAddrSelCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAddrSelCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectAddrSelCode( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectProductCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectInStckSelCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectInStckSelCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectInStckSelCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/searchPopList.do")
  public String searchPopList( @RequestParam Map<String, Object> params, ModelMap model ) {
    model.addAttribute( "url", params );
    // 호출될 화면
    return "/common/searchPop";
  }

  @RequestMapping(value = "/selectStockLocationList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStockLocationList( @RequestParam Map<String, Object> params,
                                                                ModelMap model ) {
    LOGGER.info( "selectStockLocationList: {}", params );
    List<EgovMap> codeList = commonService.selectStockLocationList( params );
    LOGGER.info( "selectStockLocationList: {}", codeList.toString() );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectStockLocationList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStockLocationList2( @RequestParam Map<String, Object> params,
                                                                 ModelMap model ) {
    LOGGER.info( "selectStockLocationList: {}", params );
    String searchgb = (String) params.get( "searchlocgb" );
    String[] searchgbvalue = searchgb.split( "∈" );
    LOGGER.debug( " :::: {}", searchgbvalue.length );
    params.put( "searchlocgb", searchgbvalue );
    List<EgovMap> codeList = commonService.selectStockLocationList( params );
    LOGGER.info( "selectStockLocationList: {}", codeList.toString() );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectStockLocationList3.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStockLocationList3( @RequestParam Map<String, Object> params,
                                                                 ModelMap model ) {
    LOGGER.info( "selectStockLocationList: {}", params );
    String searchgb = (String) params.get( "searchlocgb" );
    String[] searchgbvalue = searchgb.split( "∈" );
    int searchBranch = Integer.parseInt( (String) params.get( "searchBranch" ) );
    LOGGER.debug( " :::: {}", searchgbvalue.length );
    LOGGER.debug( " :::searchBranch: {}", searchBranch );
    params.put( "searchlocgb", searchgbvalue );
    params.put( "brnch", searchBranch );
    List<EgovMap> codeList = commonService.selectStockLocationList( params );
    LOGGER.info( "selectStockLocationList: {}", codeList.toString() );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectStockLocationList4.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStockLocationList4( @RequestParam Map<String, Object> params,
                                                                 HttpServletRequest request, ModelMap model ) {
    String[] dscBranchList = request.getParameterValues( "dscBranch" );
    params.put( "dscBranchList", dscBranchList );
    List<EgovMap> codeList = commonService.selectStockLocationList4( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/customerPop.do")
  public String customerPop( @RequestParam Map<String, Object> params, ModelMap model ) {
    model.put( "callPrgm", params.get( "callPrgm" ) );
    return "common/customerPop";
  }

  @RequestMapping(value = "/memberPop.do")
  public String memberPop( @RequestParam Map<String, Object> params, ModelMap model ) {
    model.put( "callPrgm", params.get( "callPrgm" ) );
    return "common/memberPop";
  }

  @RequestMapping(value = "/selectBrnchIdByPostCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectBrnchIdByPostCode( @RequestParam Map<String, Object> params ) {
    EgovMap result = commonService.selectBrnchIdByPostCode( params );
    return ResponseEntity.ok( result );
  }

  @RequestMapping(value = "/selectProductList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAppTypeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectProductList();
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectUniformSizeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectUniformSizeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectUniformSizeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectMuslimahScarftList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMuslimahScarftList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectMuslimahScarftList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectInnerTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectInnerTypeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectInnerTypeList( params );
    return ResponseEntity.ok( codeList );
  }

  /**
   * Payment - Adjustment CN/DN : Adjustment Reason 정보 조회
   *
   * @param params
   * @return
   */
  @RequestMapping(value = "/selectAdjReasontList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAdjReasonList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectAdjReasonList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/SysdateCall.do", method = RequestMethod.GET)
  public ResponseEntity<Map> SysdateCall( @RequestParam Map<String, Object> params ) {
    String rvalue = commonService.SysdateCall( params );
    Map<String, Object> rmap = new HashMap();
    rmap.put( "date", rvalue );
    return ResponseEntity.ok( rmap );
  }

  @RequestMapping(value = "/getPublicHolidayList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getPublicHolidayList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> holidayList = commonService.getPublicHolidayList( params );
    return ResponseEntity.ok( holidayList );
  }

  /**
   * select Homecare holiday list
   *
   * @Author KR-SH
   * @Date 2019. 11. 14.
   * @param params
   * @return
   */
  @RequestMapping(value = "/getHcHolidayList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getHcHolidayList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> holidayList = commonService.getHcHolidayList( params );
    return ResponseEntity.ok( holidayList );
  }

  /**
   * Get Vendor List
   *
   * @Author Hui Ding
   * @Date 2020-05-18
   * @param params
   * @return
   */
  public List<EgovMap> getVendorList( Map<String, Object> params )
    throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    List<EgovMap> vendorList = null;
    if ( sessionVO == null || sessionVO.getUserId() == 0 ) {
      throw new AuthException( HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase() );
    }
    LOGGER.debug( "###Login ID: " + sessionVO.getUserId() );
    LOGGER.debug( "###Current Menu Path: " + params.get( "CURRENT_MENU_PATH" ).toString() );
    params.put( "userId", sessionVO.getUserId() );
    params.put( "pgmPath", params.get( "CURRENT_MENU_PATH" ).toString() );
    PageAuthVO pageAuth = menuService.getPageAuth( params );
    if ( pageAuth != null ) {
      if ( pageAuth.getFuncUserDefine3() != null && pageAuth.getFuncUserDefine3().equals( "Y" ) ) { // isAdmin
        vendorList = hcPurchasePriceService.selectVendorList( null ); // get all vendor list
      }
      else {
        LOGGER.debug( "###access Admin no!" );
        // select only granted special access for vendors by user login.
        Map<String, Object> vendorParams = new HashMap<String, Object>();
        vendorParams.put( "isAdmin", "N" );
        vendorParams.put( "loginId", sessionVO.getUserId() );
        vendorParams.put( "menuCode", params.get( "CURRENT_MENU_CODE" ).toString() );
        vendorList = hcPurchasePriceService.selectVendorList( vendorParams );
      }
    }
    return vendorList;
  }

  @RequestMapping(value = "/selectMemTypeCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMemTypeCodeList( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "groupCode : {}", params );
    List<EgovMap> codeList = commonService.selectMemTypeCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectReasonCodeId.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectReasonCodeId( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "groupCode : {}", params );
    List<EgovMap> codeList = commonService.selectReasonCodeId( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectStatusCategoryCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStatusCategoryCodeList( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "groupCode1111 : {}", params );
    List<EgovMap> codeList = commonService.selectStatusCategoryCodeList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectDepartmentCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDepartmentCode( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "departmentCode : {}", params );
    List<EgovMap> codeList = commonService.selectDepartmentCode( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/selectStockLocationListByDept.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStockLocationListByDept( @RequestParam Map<String, Object> params ) {
    LOGGER.debug( "departmentCode : {}", params );
    List<EgovMap> codeList = commonService.selectStockLocationListByDept( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/mapPop.do")
  public String mapPop( @RequestParam Map<String, Object> params, ModelMap model ) {
    LOGGER.debug( "params : {}", params.toString() );
    LOGGER.debug( "params : {}", params.get( "latitude" ) );
    LOGGER.debug( "params : {}", params.get( "longitude" ) );
    List<EgovMap> mapProp = commonService.getMapProp( params );
    for ( int a = 0; a < mapProp.size(); a++ ) {
      params.put( mapProp.get( a ).get( "paramCode" ).toString(), mapProp.get( a ).get( "paramVal" ).toString() );
    }
    LOGGER.debug( "params : {}", params.toString() );
    model.addAttribute( "params", params );
    return "common/mapPop";
  }

  @RequestMapping(value = "/mileageInfoUpdatePop.do")
  public String mileageInfoUpdatePop( @RequestParam Map<String, Object> params, ModelMap model ) {
    LOGGER.debug( "params : {}", params.toString() );
    EgovMap info = null;
    if ( params.get( "indicator" ).equals( "INST" ) ) {
      info = commonService.getGeneralInstInfo( params );
    }
    else if ( params.get( "indicator" ).equals( "AS" ) ) {
      info = commonService.getGeneralASInfo( params );
    }
    else if ( params.get( "indicator" ).equals( "PR" ) ) {
      info = commonService.getGeneralPRInfo( params );
    }
    else if ( params.get( "indicator" ).equals( "HS" ) ) {
      info = commonService.getGeneralHSInfo( params );
    }
    info.put( "path", params.get( "path" ) );
    info.put( "jObj", params.get( "jObj" ) );
    List<EgovMap> timePick = commonService.selectTimePick();
    model.addAttribute( "timePick", timePick );
    model.addAttribute( "params", info );
    return "common/mileageInfoUpdatePop";
  }

  @RequestMapping(value = "/updateOnBehalfMileage.do", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> updateOnBehalfMileage( @RequestBody Map<String, Object> params,
                                                              SessionVO sessionVO )
    throws ParseException {
    LOGGER.debug( "params : {}", params.toString() );
    List<EgovMap> checkInMileageStat = null;
    try {
      // CONVERT DATE AND TIME INTO SINGLE DATE-TIME FORMAT
      SimpleDateFormat combinedFormat = new SimpleDateFormat( "dd/MM/yyyy hh:mm a" );
      Date combinedDateTime = combinedFormat.parse( params.get( "date" ).toString() + " "
        + params.get( "time" ).toString() );
      SimpleDateFormat oracleDateFormat = new SimpleDateFormat( "dd-MMM-yyyy HH:mm:ss" );
      String oracleDateStr = oracleDateFormat.format( combinedDateTime );
      params.put( "crtDt", oracleDateStr );
      SimpleDateFormat inputFormat = new SimpleDateFormat( "dd/MM/yyyy" );
      SimpleDateFormat outputFormat = new SimpleDateFormat( "yyyyMMdd" );
      Date date = inputFormat.parse( params.get( "date" ).toString() );
      params.put( "checkInDate", outputFormat.format( date ) );
      LOGGER.debug( "params : " + oracleDateStr );
      checkInMileageStat = serviceMileageApiService.checkInMileage( params );
    }
    catch ( Exception e ) {
      e.printStackTrace();
    }
    LOGGER.debug( "checkInMileageStat : " + checkInMileageStat.toString() );
    return ResponseEntity.ok( checkInMileageStat );
  }

  @RequestMapping(value = "/selectSystemDefectConfiguration.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectSystemDefectConfiguration( @RequestParam Map<String, Object> params ) {
    EgovMap result = commonService.selectSystemDefectConfiguration( params );
    return ResponseEntity.ok( result );
  }

  @RequestMapping(value = "/selectFilterList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectFilterList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = commonService.selectFilterList( params );
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/reqEghlPmtLink.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> reqEghlPmtLink( @RequestParam Map<String, Object> params ) throws IOException, JSONException {
    EgovMap rtnData = commonService.reqEghlPmtLink( params );
    return ResponseEntity.ok( rtnData );
  }

  @RequestMapping(value = "/getGdexShptDtl.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getGdexShptDtl( @RequestParam Map<String, Object> params ) throws IOException, JSONException, ParseException {
    EgovMap rtnData = commonService.getGdexShptDtl( params );
    return ResponseEntity.ok( rtnData );
  }
}
