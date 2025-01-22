package com.coway.trust.web.services.svcCodeConfig;

import java.text.ParseException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.biz.services.svcCodeConfig.svcCodeConfigService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/svcCodeConfig")
public class svcCodeConfigController {
  private static final Logger logger = LoggerFactory.getLogger( svcCodeConfigController.class );

  @Value("${app.name}")
  private String appName;

  @Resource(name = "svcCodeConfigService")
  private svcCodeConfigService svcCodeConfigService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "promotionService")
  private PromotionService promotionService;

  @RequestMapping(value = "/svcCodeConfigList.do")
  public String svcCodeConfigList( @RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO ) {
    List<EgovMap> codeStatus = svcCodeConfigService.selectStatusCategoryCodeList();
    List<EgovMap> prodCatList = svcCodeConfigService.selectProductCategoryList();
    model.addAttribute( "codeStatus", codeStatus );
    model.addAttribute( "prodCatList", prodCatList );
    return "services/svcCodeConfig/svcCodeConfigList";
  }

  @RequestMapping(value = "/selectSvcCodeConfigList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodeMgmtList( @RequestParam Map<String, Object> params,
                                                           HttpServletRequest request, ModelMap model,
                                                           SessionVO sessionVO ) {
    String[] arrProdCat = request.getParameterValues( "productCtgry" ); //Product Category
    String[] arrCodeStus = request.getParameterValues( "codeStatusBrw" ); //Code Status

    if ( arrProdCat != null && !CommonUtils.containsEmpty( arrProdCat ) )
      params.put( "arrProdCat", arrProdCat );
    if ( arrCodeStus != null && !CommonUtils.containsEmpty( arrCodeStus ) )
      params.put( "arrCodeStus", arrCodeStus );

    List<EgovMap> codeConfigList = null;
    codeConfigList = svcCodeConfigService.selectSvcCodeConfigList( params );
    return ResponseEntity.ok( codeConfigList );
  }

  @RequestMapping(value = "/selectProductCategoryList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductCategoryList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = svcCodeConfigService.selectProductCategoryList();
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/selectStatusCategoryCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStatusCategoryCodeList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> codeList = svcCodeConfigService.selectStatusCategoryCodeList();
    return ResponseEntity.ok( codeList );
  }

  @RequestMapping(value = "/addEditSvcCodeConfigPop.do")
  public String addEditSvcCodeConfigPop( @RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO )
    throws Exception {
    model.put( "viewType", (String) params.get( "viewType" ) );
    if ( params.get( "viewType" ).equals( "2" ) || params.get( "viewType" ).equals( "3" ) ) {
      EgovMap codeMgmtMap = svcCodeConfigService.selectCodeConfigList( params );
      List<EgovMap> codeList = svcCodeConfigService.selectStatusCategoryCodeList();
      model.put( "defectId", (String) params.get( "defectId" ) );
      model.put( "hidTypeId", (String) params.get( "hidTypeId" ) );
      model.addAttribute( "codeMgmtMap", codeMgmtMap );
    }
    return "services/svcCodeConfig/addEditSvcCodeConfigPop";
  }

  @RequestMapping(value = "/saveNewCode.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveNewCode( @RequestBody Map<String, Object> params, SessionVO sessionVO )
    throws ParseException {
    ReturnMessage message = new ReturnMessage();
    Map<String, Object> newCodeMap = (Map<String, Object>) params.get( "newDpCodeConfig" );
    newCodeMap.put( "dftType", "DP" );
    newCodeMap.put( "creator", sessionVO.getUserId() );
    newCodeMap.put( "updator", sessionVO.getUserId() );
    if ( newCodeMap.get( "viewType" ).equals( "1" ) ) {
      newCodeMap.put( "stus", "1" );
      svcCodeConfigService.saveNewCode( newCodeMap, sessionVO );
      message.setCode( AppConstants.SUCCESS );
      message.setMessage( "Successfully configured code " + newCodeMap.get( "dftPrtCde" ) + "-" + newCodeMap.get( "dftPrtDesc" ) );
    } else  {
      svcCodeConfigService.updateSvcCode( newCodeMap, sessionVO );
      message.setCode( AppConstants.SUCCESS );
      message.setMessage( "Successfully update code " + newCodeMap.get( "dftPrtCde" ) + "-" + newCodeMap.get( "dftPrtDesc" ) );
    }
    return ResponseEntity.ok( message );
  }
}
