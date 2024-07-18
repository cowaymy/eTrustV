package com.coway.trust.web.supplement;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement")
public class SupplementManagementController {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementManagementController.class);

  @Autowired
  private SessionHandler sessionHandler;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @RequestMapping(value = "/supplementManagementList.do")
  public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    List<EgovMap> supRefStus = supplementUpdateService.selectSupRefStus();
    List<EgovMap> supRefStg = supplementUpdateService.selectSupRefStg();
    List<EgovMap> supDelStus = supplementUpdateService.selectSupDelStus();
    List<EgovMap> submBrch = supplementUpdateService.selectSubmBrch();

    model.addAttribute("supRefStus", supRefStus);
    model.addAttribute("supRefStg", supRefStg);
    model.addAttribute("supDelStus", supDelStus);
    model.addAttribute("submBrch", submBrch);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
      EgovMap result =  salesCommonService.getUserInfo(params);
      model.put("orgCode", result.get("orgCode"));
      model.put("grpCode", result.get("grpCode"));
      model.put("deptCode", result.get("deptCode"));
      model.put("memCode", result.get("memCode"));
    }

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "supplement/supplementManagement";
  }

  @RequestMapping(value = "/selectWhBrnchList")
  public ResponseEntity<List<EgovMap>> selectWhBrnchList() throws Exception {
    List<EgovMap> codeList = null;
    codeList = supplementUpdateService.selectWhBrnchList();
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectSupplementList")
  public ResponseEntity<List<EgovMap>> selectSupplementList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
    List<EgovMap> listMap = null;

    String[] delStatArray = request.getParameterValues("supDelStus");
    String[] supRefStgArray = request.getParameterValues("supRefStg");
    String[] supSubmBrArray = request.getParameterValues("_brnchId");
    String[] supSubmRefStatArray = request.getParameterValues("supRefStus");

    params.put("delStatArray", delStatArray);
    params.put("supRefStgArray", supRefStgArray);
    params.put("supSubmBrArray", supSubmBrArray);
    params.put("supSubmRefStatArray", supSubmRefStatArray);

    listMap = supplementUpdateService.selectSupplementList(params);

    return ResponseEntity.ok(listMap);
  }

  @RequestMapping(value = "/getSupplementDetailList")
  public ResponseEntity<List<EgovMap>> getSupplementDetailList(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementUpdateService.getSupplementDetailList(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/getDelRcdLst")
  public ResponseEntity<List<EgovMap>> getDelRcdLst(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementUpdateService.getDelRcdLst(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/getRtnItmRcdLst")
  public ResponseEntity<List<EgovMap>> getRtnItmRcdLst(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> detailList = null;
    detailList = supplementUpdateService.getRtnItmRcdLst(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/supplementTrackNoPop.do")
  public String supplementTrackNoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    params.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    return "supplement/supplementTrackNoPop";
  }

  @RequestMapping(value = "/supplementViewPop.do")
  public String supplementViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;
    EgovMap cancellationDelInfoMap = null;

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    cancellationDelInfoMap = supplementUpdateService.selectCancDelInfo(params);

    params.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("cancellationDelInfo", cancellationDelInfoMap);

    return "supplement/supplementViewPop";
  }

  @RequestMapping(value = "/orderLedgerViewPop.do")
  public String orderLedgerViewPop(@RequestParam Map<String, Object>params, ModelMap model, HttpServletRequest request){
    if(CommonUtils.isEmpty(params.get("CutOffDate"))){
      params.put("CutOffDate", "01/01/1900");
    }

    // SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    // params.put("userId", sessionVO.getUserId());
    // model.put("userBr", sessionVO.getUserBranchId());

    EgovMap orderInfo = supplementUpdateService.selectOrderBasicLedgerInfo(params);
    model.addAttribute("orderInfo", orderInfo);

    List<EgovMap> orderLdgrList = supplementUpdateService.getOderLdgr(params);
    double balance = 0;

    for(int i = 0; i < orderLdgrList.size(); i++) {
      EgovMap result = orderLdgrList.get(i);
      if (result.get("docType") == "B/F") {
        balance = Double.parseDouble(result.get("balanceamt").toString());
      } else {
        balance = balance + Double.parseDouble(result.get("debitamt").toString()) + Double.parseDouble(result.get("creditamt").toString());
      }
      result.put("balanceamt", balance);
  }

    model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));
    List<EgovMap> ordOutInfoList = supplementUpdateService.getOderOutsInfo(params);

    EgovMap ordOutInfo = ordOutInfoList.get(0);
    model.addAttribute("ordOutInfo", ordOutInfo);

    return "supplement/orderLedgerPop";
  }

  @RequestMapping(value = "/checkDuplicatedTrackNo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> checkDuplicatedTrackNo (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{
    List<EgovMap> itemList = null;
    Map<String, Object> transactionId = null;

    itemList = supplementUpdateService.checkDuplicatedTrackNo(params);

    // transactionId.put("supRefId", (params.get("supRefId")));
    // supplementUpdateService.updateRefStgStatus(transactionId);
    return ResponseEntity.ok(itemList);
  }

  /*
  @RequestMapping(value = "/updateRefStgStatus", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> updateRefStgStatus (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{
    List<EgovMap> itemList = null;
    Map<String, Object> transactionId = null;

    transactionId.put("supRefId", (params.get("supRefId")));
    supplementUpdateService.updateRefStgStatus(transactionId);

    return ResponseEntity.ok(itemList);
  }
  */

  @Transactional
  @RequestMapping(value = "/updateRefStgStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateRefStgStatus(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    params.put("userId", sessionVO.getUserId());

    try {
      Map<String, Object> returnMap = supplementUpdateService.updateRefStgStatus(params);
      if ("000".equals(returnMap.get("logError"))) {
        msg += "Parcel tracking number update successfully.";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Parcel tracking number failed to update. <br />";
        msg += "Errorlogs : " + returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
      LOGGER.debug(" params returnMap result =======>"+returnMap);
    } catch (Exception e) {
      LOGGER.error("Error during update Parcel Tracking Number.", e);
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  /*
   @RequestMapping(value = "/selectPosJsonList")
  public ResponseEntity<List<EgovMap>> selectPosJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
    List<EgovMap> listMap = null;

    String systemArray[] = request.getParameterValues("posTypeId");
    String statusArray[] = request.getParameterValues("posStatusId");

    params.put("systemArray", systemArray);
    params.put("statusArray", statusArray);

    listMap = posService.selectPosJsonList(params);

    return ResponseEntity.ok(listMap);
  }
  */

  @RequestMapping(value = "/updOrdDelStatGdex.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updOrdDelStat(@RequestBody Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) throws ParseException, IOException, JSONException {
    ReturnMessage message = new ReturnMessage();
    // SET USER ID
    params.put("userId", sessionVO.getUserId());

    EgovMap rtnData = supplementUpdateService.updOrdDelStatGdex(params);
    message.setCode( "000" );
    message.setMessage(CommonUtils.nvl(rtnData.get( "message" )));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updOrdDelStatDhl.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updOrdDelStaDhlt(@RequestBody Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) throws ParseException, IOException, JSONException {
    ReturnMessage message = new ReturnMessage();
    // SET USER ID
    params.put("userId", sessionVO.getUserId());

    EgovMap rtnData = supplementUpdateService.updOrdDelStatDhl(params);
    message.setCode( "000" );
    message.setMessage(CommonUtils.nvl(rtnData.get( "message" )));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectPaymentJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPaymentJsonList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> paymentList = supplementUpdateService.selectPaymentMasterList(params);
    return ResponseEntity.ok(paymentList);
  }

  @RequestMapping(value = "/selectDocumentJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDocumentJsonList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> docList = supplementUpdateService.selectDocumentList(params);
    return ResponseEntity.ok(docList);
  }

  @RequestMapping(value = "/supplementCustDelInfo.do")
  public String supplementCustDelInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    model.put("userId", sessionVO.getUserId());

    model.addAttribute("userId", sessionVO.getUserId());
    model.addAttribute("ind", params.get( "ind" ));

    return "supplement/supplementCustDelInfoPop";
  }

  @RequestMapping(value = "/getCustOrdDelInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCustOrdDelInfo(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> custOrdDelInfo = supplementUpdateService.getCustOrdDelInfo(params);
    return ResponseEntity.ok(custOrdDelInfo);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/updateDelStageInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateDelStageInfo(@RequestBody Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) throws ParseException, IOException, JSONException {
    ReturnMessage message = new ReturnMessage();
    String msg = "";

    // SET USER ID
    params.put("userId", sessionVO.getUserId());

    try {
      Map<String, Object> returnMap = supplementUpdateService.updateDelStageInfo(params);
      if ("000".equals(returnMap.get("logError"))) {
        msg += "Parcel tracking number update successfully.";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Parcel tracking number failed to update. <br />";
        msg += "Errorlogs : " + returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
    } catch (Exception e) {
      LOGGER.error("Error during update Parcel Tracking Number.", e);
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

}
