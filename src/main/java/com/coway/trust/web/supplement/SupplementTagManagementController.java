package com.coway.trust.web.supplement;

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

import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement")
public class SupplementTagManagementController {
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementTagManagementController.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @Resource(name = "supplementTagManagementService")
  private SupplementTagManagementService supplementTagManagementService;

  @RequestMapping(value = "/supplementTagManagementList.do")
  public String selectSupplementTagManagementList( @RequestParam Map<String, Object> params, ModelMap model )
    throws Exception {
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
  public ResponseEntity<List<EgovMap>> selectSupplementList( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
    List<EgovMap> listMap = null;
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
    EgovMap tagInfoMap = null;

    List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();
    orderInfoMap = supplementUpdateService.selectOrderBasicInfo( params );
    tagInfoMap = supplementTagManagementService.selectOrderBasicInfo( params );
    params.put( "userId", sessionVO.getUserId() );
    model.put( "userBr", sessionVO.getUserBranchId() );

    model.addAttribute( "orderInfo", orderInfoMap );
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

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo( @RequestParam Map<String, Object> params, ModelMap model ) {
    LOGGER.debug( "===========================/searchOrderNo.do===============================" );
    LOGGER.debug( "== params " + params.toString() );
    LOGGER.debug( "===========================/searchOrderNo.do===============================" );
    EgovMap basicInfo = supplementTagManagementService.searchOrderBasicInfo( params );
    model.addAttribute( "orderInfo", basicInfo );
    return ResponseEntity.ok( basicInfo );
  }

  @RequestMapping(value = "/supplementViewBasicPop.do")
  public String supplementViewPop( @RequestParam Map<String, Object> params, ModelMap model ) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();
    EgovMap orderInfoMap = null;

    orderInfoMap = supplementTagManagementService.selectViewBasicInfo( params );
    model.addAttribute( "mainTopic", mainTopic );
    model.addAttribute( "inchgDept", inchgDept );
    params.put( "userId", sessionVO.getUserId() );
    model.put( "userBr", sessionVO.getUserBranchId() );
    model.addAttribute( "orderInfo", orderInfoMap );

    return "supplement/supplementTagManagementCreationPop";
  }

}
