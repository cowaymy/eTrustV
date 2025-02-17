package com.coway.trust.web.sales.order;

import java.util.Calendar;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderExchangeService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderExchangeController {

  private static final Logger logger = LoggerFactory.getLogger(OrderExchangeController.class);

  @Resource(name = "orderExchangeService")
  private OrderExchangeService orderExchangeService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  /**
   * Order Exchange List 초기화 화면
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/orderExchangeList.do")
  public String orderExchangeList(@RequestParam Map<String, Object> params, ModelMap model) {
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    return "sales/order/orderExchangeList";
  }

  @RequestMapping(value = "/orderExchangeJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> orderExchangeList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] arrExcType = request.getParameterValues("cmbExcType");
    String[] arrExcStatus = request.getParameterValues("cmbExcStatus");
    String[] arrAppType = request.getParameterValues("cmbAppType"); // Application
                                                                    // Type

    params.put("arrExcType", arrExcType);
    params.put("arrExcStatus", arrExcStatus);
    params.put("arrAppType", arrAppType);

    List<EgovMap> orderExchangeList = orderExchangeService.orderExchangeList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(orderExchangeList);
  }

  /**
   * Exchange Information. - Product Exchange Type
   */
  @RequestMapping(value = "/orderExchangeDetailPop.do")
  public String orderExchangeDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    // order detail start
    int prgrsId = 0;
    EgovMap orderDetail = null;
    params.put("prgrsId", prgrsId);

    params.put("salesOrderId", params.get("salesOrderId"));
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    model.put("orderDetail", orderDetail);
    model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
    // order detail end

    logger.info("##### cmbExcType #####" + params.get("exchgType"));
    logger.info("##### exchgStus #####" + params.get("exchgStus"));
    EgovMap exchangeDetailInfo = orderExchangeService.exchangeInfoProduct(params);

    params.put("soExchgOldCustId", exchangeDetailInfo.get("soExchgOldCustId"));
    params.put("soExchgNwCustId", exchangeDetailInfo.get("soExchgNwCustId"));

    EgovMap exchangeInfoOwnershipFr = orderExchangeService.exchangeInfoOwnershipFr(params);
    EgovMap exchangeInfoOwnershipTo = orderExchangeService.exchangeInfoOwnershipTo(params);

    model.addAttribute("exchangeDetailInfo", exchangeDetailInfo);
    model.addAttribute("initType", params.get("exchgType"));
    model.addAttribute("exchgStus", params.get("exchgStus"));
    model.addAttribute("exchgCurStusId", params.get("exchgCurStusId"));
    model.addAttribute("soExchgIdDetail", exchangeDetailInfo.get("soExchgId"));
    model.addAttribute("exchangeInfoOwnershipFr", exchangeInfoOwnershipFr);
    model.addAttribute("exchangeInfoOwnershipTo", exchangeInfoOwnershipTo);

    return "sales/order/orderExchangeDetailPop";

  }

  /**
   * Exchange Information. - Product Exchange Type
   */
  @RequestMapping(value = "/orderExchangeRemPop.do")
  public String orderExchangeRemPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("initType", params.get("initType"));
    model.addAttribute("exchgStus", params.get("exchgStus"));
    model.addAttribute("exchgCurStusId", params.get("exchgCurStusId"));
    model.addAttribute("salesOrderId", params.get("salesOrderId"));
    model.addAttribute("soExchgIdDetail", params.get("soExchgIdDetail"));

    return "sales/order/orderExchangeRemPop";

  }

  @RequestMapping(value = "/saveCancelReq.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> saveCancelReq(@RequestParam Map<String, Object> params, ModelMap mode)
      throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    String retMsg = AppConstants.MSG_SUCCESS;

    Map<String, Object> map = new HashMap();

    orderExchangeService.saveCancelReq(params);

    map.put("msg", retMsg);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/orderExchangeRawDataPop.do")
  public String orderExchangeRawDataPop() {

    return "sales/order/orderExchangeRawDataPop";
  }

  @RequestMapping(value = "/orderExchangeProductReturnPop.do")
  public String orderExchangeProductReturnPop(ModelMap model) {

    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.DATE, calendar.getActualMinimum(Calendar.DATE));
    Date startDate = calendar.getTime();
    calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
    Date endDate = calendar.getTime();

    model.put("startDate", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1, startDate));
    model.put("endDate", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1, endDate));

    logger.info(
        "startDay : " + model.get("startDate").toString() + ". endDay : " + model.get("endDate").toString() + ". ");
    return "sales/order/orderExchangeProductReturnPop";
  }

  @RequestMapping(value = "/orderExchangeRawData2Pop.do")
  public String orderExchangeRawData2Pop(ModelMap model) {
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    return "sales/order/orderExchangeRawData2Pop";
  }

  @RequestMapping(value = "/pexSendEmail.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> pexSendEmail(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) throws Exception{
    logger.debug("===========================/pexSendEmail.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/pexSendEmail.do===============================");

    ReturnMessage message = new ReturnMessage();
    message = orderExchangeService.pexSendEmail(params);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/cnfmProductExchangeDetailPop.do")
  public String cnfmProductExchangeDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "sales/order/cnfmProductExchangeDetailPop";
  }
}
