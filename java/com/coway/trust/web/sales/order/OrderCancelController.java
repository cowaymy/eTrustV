package com.coway.trust.web.sales.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.OrderCancelVO;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderCancelController {

  private static final Logger logger = LoggerFactory.getLogger(OrderCancelController.class);

  @Resource(name = "orderCancelService")
  private OrderCancelService orderCancelService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Autowired
  private SessionHandler sessionHandler;

  /**
   * Order Cancellation List 초기화 화면
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/orderCancelList.do")
  public String orderCancelList(@ModelAttribute("orderCancelVO") OrderCancelVO orderCancelVO,
      @RequestParam Map<String, Object> params, ModelMap model) {

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    List<EgovMap> dscBranchList = orderCancelService.dscBranch(params);

    List<EgovMap> productRetReasonList = orderCancelService.productRetReason(params);

    List<EgovMap> rsoStatusList = orderCancelService.rsoStatus(params);

    model.addAttribute("dscBranchList", dscBranchList);
    model.addAttribute("productRetReasonList", productRetReasonList);
    model.addAttribute("rsoStatusList", rsoStatusList);

    return "sales/order/orderCancelList";
  }

  /**
   * Order Cancellation Status Code 데이터조회
   *
   * @param params
   * @param model
   * @return KV cancellation status
   */
  @RequestMapping(value = "/selectcancellationstatus.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> orderCancelStatus(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/orderCancelStatus.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/orderCancelStatus.do===============================");
    List<EgovMap> orderCancelStatus = orderCancelService.orderCancelStatus(params);
    /* logger.debug("BRANCH {}", orderCancelStatus); */
    return ResponseEntity.ok(orderCancelStatus);
  }

  /**
   * Order Cancellation Feedback Code 데이터조회
   *
   * @param params
   * @param model
   * @return KV cancellation status
   */
  @RequestMapping(value = "/selectcancellationfeedback.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> orderCancelFeedback(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/orderCancelFeedback.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/orderCancelFeedback.do===============================");
    List<EgovMap> orderCancelFeedback = orderCancelService.orderCancelFeedback(params);
    logger.debug("BRANCH {}", orderCancelFeedback);
    return ResponseEntity.ok(orderCancelFeedback);
  }

  /**
   * Order Cancellation List 데이터조회
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/orderCancelJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> orderCancelJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] appTypeId = request.getParameterValues("cmbAppTypeId");
    String[] callStusId = request.getParameterValues("callStusId");
    String[] reqStageId = request.getParameterValues("reqStageId");
    String[] dscBranchId = request.getParameterValues("cmbDscBranchId");
    String[] productRetReasonId = request.getParameterValues("cmbproductRetReasonId");
    String[] rsoStatusId = request.getParameterValues("cmbrsoStatusId");

	if(StringUtils.isEmpty(params.get("startCrtDt"))) params.put("startCrtDt", "01/01/1900");
	if(StringUtils.isEmpty(params.get("endCrtDt")))   params.put("endCrtDt",   "31/12/9999");

    params.put("typeIdList", appTypeId);
    params.put("stusIdList", callStusId);
    params.put("reqStageList", reqStageId);
    params.put("branchList", dscBranchId);
    params.put("productRetReasonList", productRetReasonId);
    params.put("rsoStatusList", rsoStatusId);
	params.put("startCrtDt", CommonUtils.changeFormat(String.valueOf(params.get("startCrtDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
	params.put("endCrtDt", CommonUtils.changeFormat(String.valueOf(params.get("endCrtDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    // String stDate = (String)params.get("startCrtDt");
    // if(stDate != null && stDate != ""){
    // String createStDate = stDate.substring(6) + "-" + stDate.substring(3, 5)
    // + "-" + stDate.substring(0, 2);
    // params.put("startCrtDt", createStDate);
    // }
    // String enDate = (String)params.get("endCrtDt");
    // if(enDate != null && enDate != ""){
    // String createEnDate = enDate.substring(6) + "-" + enDate.substring(3, 5)
    // + "-" + enDate.substring(0, 2);
    // params.put("endCrtDt", createEnDate);
    // }
    // String recallStDate = (String)params.get("startRecallDt");
    // if(recallStDate != null && recallStDate != ""){
    // String createStDate1 = recallStDate.substring(6) + "-" +
    // recallStDate.substring(3, 5) + "-" + recallStDate.substring(0, 2);
    // params.put("startRecallDt", createStDate1);
    // }
    // String recallEnDate = (String)params.get("endRecallDt");
    // if(recallEnDate != null && recallEnDate != ""){
    // String createEnDate1 = recallEnDate.substring(6) + "-" +
    // recallEnDate.substring(3, 5) + "-" + recallEnDate.substring(0, 2);
    // params.put("endRecallDt", createEnDate1);
    // }
    List<EgovMap> orderCancelList = orderCancelService.orderCancellationList(params);

    return ResponseEntity.ok(orderCancelList);
  }

  /**
   * 화면 호출. - Cancellation Request Information
   */
  @RequestMapping(value = "/cancelReqInfoPop.do")
  public String cancelReqInfoPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    logger.info("##### salesOrdId #####" + params.get("salesOrdId"));
    // order detail start
    int prgrsId = 0;
    EgovMap orderDetail = null;
    params.put("prgrsId", prgrsId);

    params.put("salesOrderId", params.get("salesOrdId"));
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    model.put("orderDetail", orderDetail);
    model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
    // order detail end

    String paramTypeId = (String) params.get("typeId");
    String paramDocId = (String) params.get("docId");
    String paramRefId = (String) params.get("refId");
    logger.info("##### paramRefId #####" + paramRefId);
    logger.info("##### paramRefId #####" + (String) params.get("refId"));
    EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);

    model.addAttribute("cancelReqInfo", cancelReqInfo);
    model.addAttribute("paramTypeId", paramTypeId);
    model.addAttribute("paramDocId", paramDocId);
    model.addAttribute("paramRefId", paramRefId);
    model.addAttribute("reqStageId", params.get("paramReqStageId"));

    return "sales/order/orderCancelDetailPop";

  }

  /**
   * Cancellation Log Transaction 데이터조회
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/cancelLogTransList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> cancelLogTransList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    // params.put("typeId", "296"); //임시 CT Assignment
    // params.put("docId", "101795"); //임시 CT Assignment

    params.put("typeId", "259"); // 임시 CT Assignment
    List<EgovMap> cancelLogTransList = orderCancelService.cancelLogTransctionList(params);

    return ResponseEntity.ok(cancelLogTransList);
  }

  /**
   * Product Return Transaction 데이터조회
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/productReturnTransList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> productReturnTransList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    // params.put("typeId", "296"); //임시 CT Assignment
    // params.put("refId", "8725"); //임시 CT Assignment

    List<EgovMap> productReturnTransList = orderCancelService.productReturnTransctionList(params);

    return ResponseEntity.ok(productReturnTransList);
  }

  @RequestMapping(value = "/saveCancel.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> saveCancel(@RequestParam Map<String, Object> params, ModelMap mode)
      throws Exception {

    ReturnMessage message = new ReturnMessage();

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    logger.info("##### sessionVO.getUserId() #####" + sessionVO.getUserId());
    logger.info("##### params ###############" + params.toString());
    // String retMsg = AppConstants.MSG_SUCCESS;
    String retMsg = "Record updated successfully.";

    Map<String, Object> map = new HashMap();
    int noRcd = orderCancelService.chkRcdTms(params);

    if (noRcd == 1) {
      orderCancelService.saveCancel(params);
      map.put("msg", retMsg);
    } else {
      map.put("msg",
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
    }

    return ResponseEntity.ok(map);
  }

  /**
   * 화면 호출. - Assignment CT Information
   */
  @RequestMapping(value = "/ctAssignmentInfoPop.do")
  public String ctAssignmentInfoPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    // order detail start
    int prgrsId = 0;
    EgovMap orderDetail = null;
    params.put("prgrsId", prgrsId);

    params.put("salesOrderId", params.get("salesOrdId"));
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    model.put("orderDetail", orderDetail);
    model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
    // order detail end

    String paramTypeId = (String) params.get("typeId");
    String paramDocId = (String) params.get("docId");
    String paramRefId = (String) params.get("refId");

    List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);

    EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);

    params.put("stusCodeId", 1);

    EgovMap ctAssignmentInfo = orderCancelService.ctAssignmentInfo(params);

    model.addAttribute("cancelReqInfo", cancelReqInfo);
    model.addAttribute("paramTypeId", paramTypeId);
    model.addAttribute("paramDocId", paramDocId);
    model.addAttribute("paramRefId", paramRefId);
    model.addAttribute("selectAssignCTList", selectAssignCTList);
    model.addAttribute("ctAssignmentInfo", ctAssignmentInfo);

    return "sales/order/orderCancelCTAssignmentPop";

  }

  /**
   * 화면 호출. - New Cancellation Log Result
   */
  @RequestMapping(value = "/cancelNewLogResultPop.do")
  public String cancelNewLogResultPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    // order detail start
    int prgrsId = 0;
    EgovMap orderDetail = null;
    params.put("prgrsId", prgrsId);

    params.put("salesOrderId", params.get("salesOrdId"));
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    model.put("orderDetail", orderDetail);
    model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
    // order detail end

    String paramTypeId = (String) params.get("typeId");
    String paramDocId = (String) params.get("docId");
    String paramRefId = (String) params.get("refId");

    EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
    List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);
    List<EgovMap> selectFeedback = orderCancelService.selectFeedback(params);

    model.addAttribute("cancelReqInfo", cancelReqInfo);
    model.addAttribute("paramTypeId", paramTypeId);
    model.addAttribute("paramDocId", paramDocId);
    model.addAttribute("paramRefId", paramRefId);
    model.addAttribute("selectAssignCTList", selectAssignCTList);
    model.addAttribute("selectFeedback", selectFeedback);
    model.addAttribute("reqStageId", params.get("paramReqStageId"));
    model.addAttribute("rcdTms", params.get("rcdTms"));

    logger.info("##### selectAssignCTList #####" + selectAssignCTList.get(0));
    logger.info("##### selectAssignCTList #####" + selectAssignCTList.get(1));

    return "sales/order/orderCancelDetailAddPop";

  }

  @RequestMapping(value = "/saveCtAssignment.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> saveCtAssignment(@RequestParam Map<String, Object> params, ModelMap mode)
      throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    logger.info("##### sessionVO.getUserId() #####" + sessionVO.getUserId());
    logger.info("##### params ###############" + params.toString());
    // String retMsg = AppConstants.MSG_SUCCESS;
    String retMsg = "SUCCESS";

    Map<String, Object> map = new HashMap();

    orderCancelService.saveCtAssignment(params);

    map.put("msg", retMsg);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/getRetReasonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getRetReasonList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderCancelService.getRetReasonList(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/getBranchList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBranchList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderCancelService.getBranchList(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/ctSearchPop.do")
  public String memberPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/order/orderCancelCTSearchPop";
  }

  @RequestMapping(value = "/orderCancelRequestRawDataPop.do")
  public String orderCancelRequestRawDataPop() {

    return "sales/order/orderCancelRequestRawDataPop";
  }

  @RequestMapping(value = "/orderCancelProductReturnRawPop.do")
  //public String orderCancelProductReturnRawPop() {
  public String orderCancelProductReturnRawPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.addAttribute("type", params.get("type"));
    model.addAttribute("ind", params.get("ind"));
    return "sales/order/orderCancelProductReturnRawPop";
  }

  @RequestMapping(value = "/orderCancelProductReturnLogBookListingPop.do")
  public String orderCancelProductReturnLogBookListingPop() {

    return "sales/order/orderCancelProductReturnLogBookListingPop";
  }

  @RequestMapping(value = "/orderCancelProductReturnNoteListingPop.do")
  public String orderCancelProductReturnNoteListingPop() {

    return "sales/order/orderCancelProductReturnNoteListingPop";
  }

  @RequestMapping(value = "/orderCancelProductReturnYellowSheetPop.do")
  public String orderCancelProductReturnYellowSheetPop() {

    return "sales/order/orderCancelProductReturnYellowSheetPop";
  }

  @RequestMapping(value = "/ctAssignBulkPop.do")
  public String ctAssignBulkPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> dscBranchList = orderCancelService.dscBranch(params);
    List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);

    model.addAttribute("dscBranchList", dscBranchList);
    model.addAttribute("selectAssignCTList", selectAssignCTList);

    return "sales/order/orderCancelCTAssignBulkPop";
  }

  @RequestMapping(value = "/orderCancelJsonBulk.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> orderCancelJsonBulk(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] pRTypeList = request.getParameterValues("cmbPRType");
    String[] appTypeBulkList = request.getParameterValues("cmbAppTypeBulk");
    List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);

    params.put("pRTypeList", pRTypeList);
    params.put("appTypeBulkList", appTypeBulkList);
    params.put("selectAssignCTList", selectAssignCTList);

    List<EgovMap> ctAssignBulkList = orderCancelService.ctAssignBulkList(params);

    return ResponseEntity.ok(ctAssignBulkList);
  }

  @RequestMapping(value = "/selectCTBulkJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTBulkJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> selectCTBulkList = orderCancelService.selectAssignCT(params);

    return ResponseEntity.ok(selectCTBulkList);
  }

  @RequestMapping(value = "/saveCancelBulk.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> saveCancelBulk(@RequestBody Map<String, Object> params, ModelMap mode)
      throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    logger.info("##### params ###############" + params.toString());

    String successMsg = "SUCCESS";
    String failMsg = "FAIL";

    // Return MSG
    // ReturnMessage message = new ReturnMessage();

    // message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    // return ResponseEntity.ok(message);

    Map<String, Object> map = new HashMap();

    int dataCnt = orderCancelService.saveCancelBulk(params);

    if (dataCnt > 0) {
      map.put("msg", successMsg);
      map.put("dataCnt", dataCnt);
    } else {
      map.put("msg", failMsg);
    }
    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkRcdTms(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/selRcdTms.do=======================");

    int noRcd = orderCancelService.selRcdTms(params);

    if (noRcd == 1) {
      message.setMessage("OK");
      message.setCode("1");
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selRcdTms2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkRcdTms2(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/selRcdTms.do=======================");

    int noRcd = orderCancelService.selRcdTms(params);

    if (noRcd == 1) {
      message.setMessage("OK");
      message.setCode("1");
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/select3MonthBlockList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> select3MonthBlockList(@RequestParam Map<String, Object> params) {
    EgovMap select3MonthBlockList = orderCancelService.select3MonthBlockList(params);
    return ResponseEntity.ok(select3MonthBlockList);
  }

  @RequestMapping(value = "/prSendEmail.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> prSendEmail(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) throws Exception{
    logger.debug("===========================/prSendEmail.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/prSendEmail.do===============================");

    ReturnMessage message = new ReturnMessage();
    message = orderCancelService.prSendEmail(params);

    return ResponseEntity.ok(message);
  }

}
