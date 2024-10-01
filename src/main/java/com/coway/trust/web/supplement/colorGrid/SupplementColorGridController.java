package com.coway.trust.web.supplement.colorGrid;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.supplement.colorGrid.service.SupplementColorGridService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement/colorGrid")
public class SupplementColorGridController {
  private static final Logger logger = LoggerFactory.getLogger( SupplementColorGridController.class );

  @Resource(name = "supplementColorGridService")
  private SupplementColorGridService supplementColorGridService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Autowired
  private SessionHandler sessionHandler;

  @RequestMapping(value = "/supplementColorGridList.do")
  public String supplementColorGridList( @RequestParam Map<String, Object> params, ModelMap model ) {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put( "userId", sessionVO.getUserId() );

    if ( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7 ) {
      EgovMap getUserInfo = salesCommonService.getUserInfo( params );
      model.put( "memType", getUserInfo.get( "memType" ) );
      model.put( "orgCode", getUserInfo.get( "orgCode" ) );
      model.put( "grpCode", getUserInfo.get( "grpCode" ) );
      model.put( "deptCode", getUserInfo.get( "deptCode" ) );
      model.put( "memCode", getUserInfo.get( "memCode" ) );
    }

    List<EgovMap> appTypeList = supplementColorGridService.selectCodeList();
    model.addAttribute( "appTypeList", appTypeList );

    List<EgovMap> productList = supplementColorGridService.colorGridCmbProduct();
    model.addAttribute( "productList", productList );

    List<EgovMap> productCategoryList = supplementColorGridService.selectProductCategoryList();
    model.addAttribute( "productCategoryList", productCategoryList );

    List<EgovMap> supRefStus = supplementColorGridService.selectSupRefStus();
    model.addAttribute( "supRefStus", supRefStus);

    return "supplement/colorGrid/supplementColorGridList";
  }

  @RequestMapping(value = "/supplementColorGridJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> supplementColorGridJsonList( @RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ) {
    logger.info("[SupplementColorGridController - supplementColorGridJsonList] params :: {} " + params);
    String[] cmbAppTypeList = request.getParameterValues( "cmbAppType" );
    String[] cmbCustomerType = request.getParameterValues( "cmbCustomerType" );
    String[] cmbProductCtgry = request.getParameterValues( "cmbProductCtgry" );
    String[] cmbProduct = request.getParameterValues( "cmbProduct" );
    String[] supSubmRefStatArray = request.getParameterValues("supRefStus");
    logger.info("[SupplementColorGridController - supplementColorGridJsonList] supSubmRefStatArray :: {} " + supSubmRefStatArray);

    if ( params.get( "memCode" ) != null && !params.get( "memCode" ).toString().equalsIgnoreCase( "" ) ) {
      String memID = supplementColorGridService.getMemID( params );
      params.put( "memID", memID );
    }

    if ( cmbCustomerType != null ) {
      for ( int i = 0; i < cmbCustomerType.length; i++ ) {
        int tmp = Integer.parseInt( cmbCustomerType[i].toString() );
        if ( tmp == 964 ) {
          params.put( "Individual", "individual" );
        }
      }
      params.put( "cmbCustomerType", cmbCustomerType );
    } else {
      params.put( "cmbCustomerType", "" );
    }

    params.put( "cmbAppTypeList", cmbAppTypeList );
    params.put( "cmbProduct", cmbProduct );
    params.put( "cmbProductCtgry", cmbProductCtgry );
    params.put("supSubmRefStatArray", supSubmRefStatArray);

    List<EgovMap> colorGridList = supplementColorGridService.colorGridList( params );
    logger.info("[SupplementColorGridController - supplementColorGridJsonList] colorGridList :: {} " + colorGridList);

    return ResponseEntity.ok( colorGridList );
  }

  @RequestMapping(value = "/getSupplementDetailList")
  public ResponseEntity<List<EgovMap>> getSupplementDetailList( @RequestParam Map<String, Object> params ) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementColorGridService.getSupplementDetailList( params );
    return ResponseEntity.ok( detailList );
  }
}
