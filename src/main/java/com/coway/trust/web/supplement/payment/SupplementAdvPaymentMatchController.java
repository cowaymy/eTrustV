package com.coway.trust.web.supplement.payment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.supplement.payment.service.SupplementAdvPaymentMatchService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement/payment")
public class SupplementAdvPaymentMatchController {
  @SuppressWarnings("unused")
  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementAdvPaymentMatchController.class );

  @Resource(name = "supplementAdvPaymentMatchService")
  private SupplementAdvPaymentMatchService supplementAdvPaymentMatchService;

  @RequestMapping(value = "/initAdvPaymentMatch.do")
  public String initAdvPaymentMatch( @RequestParam Map<String, Object> params, ModelMap model ) {
    String bfDay = CommonUtils.changeFormat( CommonUtils.getCalDate( -30 ), SalesConstants.DEFAULT_DATE_FORMAT3,
                                             SalesConstants.DEFAULT_DATE_FORMAT1 );
    String toDay = CommonUtils.getFormattedString( SalesConstants.DEFAULT_DATE_FORMAT1 );
    model.put( "bfDay", bfDay );
    model.put( "toDay", toDay );
    return "/supplement/payment/supplementAdvPaymentMatch";
  }

  @RequestMapping(value = "/selectPaymentMatchList.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> selectPaymentMatchList( @ModelAttribute("searchVO") ReconciliationSearchVO searchVO,
                                                                     @RequestBody Map<String, Object> params,
                                                                     ModelMap model ) {
    Map<String, Object> resultMap = new HashMap<String, Object>();
    List<EgovMap> keyInList = supplementAdvPaymentMatchService.selectAdvKeyInList( params );
    List<EgovMap> stateList = supplementAdvPaymentMatchService.selectBankStateMatchList( params );
    resultMap.put( "keyInList", keyInList );
    resultMap.put( "stateList", stateList );
    return ResponseEntity.ok( resultMap );
  }

  @RequestMapping(value = "/initDetailGrpPaymentPop.do")
  public String initRequestDCFPop( @RequestParam Map<String, Object> params, ModelMap model ) {
    model.put( "groupSeq", params.get( "groupSeq" ) );
    return "supplement/payment/supplementViewGroupPaymentKeyListPop";
  }

  @RequestMapping(value = "/selectPaymentListByGroupSeq.do")
  public ResponseEntity<List<EgovMap>> selectPaymentListByGroupSeq( @RequestBody Map<String, Object> params,
                                                                    ModelMap model ) {
    String[] groupSeqList = params.get( "groupSeq" ).toString().replace( "\"", "" ).split( "," );
    params.put( "groupSeq", groupSeqList );

    List<EgovMap> resultList = supplementAdvPaymentMatchService.selectPaymentListByGroupSeq( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/saveAdvPaymentMapping.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveAdvPaymentMapping( @RequestBody Map<String, Object> params, ModelMap model,
                                                              SessionVO sessionVO ) {
    String groupSeq = params.get( "groupSeq" ).toString();
    String groupSeqArr[];
    if ( groupSeq.contains( "," ) ) {
      groupSeqArr = groupSeq.split( "," );
      params.put( "groupSeqArr", groupSeqArr );
    }

    params.put( "userId", sessionVO.getUserId() );
    supplementAdvPaymentMatchService.saveAdvPaymentMapping( params );

    ReturnMessage message = new ReturnMessage();
    message.setCode( AppConstants.SUCCESS );
    message.setMessage( "Saved Successfully" );
    return ResponseEntity.ok( message );
  }

  @RequestMapping(value = "/saveAdvPaymentDebtor.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveAdvPaymentDebtor( @RequestBody Map<String, Object> params, ModelMap model,
                                                             SessionVO sessionVO ) {

    params.put( "userId", sessionVO.getUserId() );
    params.put( "groupSeq", params.get( "debtorGroupSeq" ) );
    params.put( "fTrnscId", 0 );
    params.put( "accCode", 0 );
    supplementAdvPaymentMatchService.saveAdvPaymentDebtor( params );

    ReturnMessage message = new ReturnMessage();
    message.setCode( AppConstants.SUCCESS );
    message.setMessage( "Saved Successfully" );
    return ResponseEntity.ok( message );
  }

  @RequestMapping(value = "/getAccountList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAccountList( @RequestParam Map<String, Object> params ) {
    List<EgovMap> resultList = supplementAdvPaymentMatchService.getAccountList( params );
    return ResponseEntity.ok( resultList );
  }

  @RequestMapping(value = "/selectAdvKeyInReport.do")
  public ResponseEntity<List<EgovMap>> selectAdvKeyInReport( @RequestBody Map<String, Object> params, ModelMap model ) {
    List<EgovMap> resultList = supplementAdvPaymentMatchService.selectAdvKeyInReport( params );
    return ResponseEntity.ok( resultList );
  }
}
