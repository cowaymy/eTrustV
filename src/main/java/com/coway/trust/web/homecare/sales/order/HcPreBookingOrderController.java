package com.coway.trust.web.homecare.sales.order;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcPreBookingOrderService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
//import com.coway.trust.biz.sales.order.PreBookingOrderService;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.impl.PreOrderServiceImpl;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreBookingOrderController.java
 * @Description : Homecare Pre Booking Order Controller
 *
 * @History
 *
 *
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcPreBookingOrderController {
  private static Logger logger = LoggerFactory.getLogger(PreOrderServiceImpl.class);

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "hcPreBookingOrderService")
  private HcPreBookingOrderService hcPreBookingOrderService;

/*  @Resource(name = "preBookingOrderService")
  private PreBookingOrderService preBookingOrderService;
*/
  @Resource(name = "hcOrderListService")
  private HcOrderListService hcOrderListService;

  @Resource(name = "preOrderService")
  private PreOrderService preOrderService;

  // Homecare Pre OrderList
  @RequestMapping(value = "/hcPreBookingOrderList.do")
  public String hcPreBookingOrderList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws ParseException {

    if (sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7) {
      params.put("userId", sessionVO.getUserId());

      EgovMap result = salesCommonService.getUserInfo(params);

      model.put("orgCode", result.get("orgCode"));
      model.put("grpCode", result.get("grpCode"));
      model.put("deptCode", result.get("deptCode"));
      model.put("memCode", result.get("memCode"));
    }

    int userTypeId = 14;

    if (sessionVO.getUserTypeId() == 1) { // HP
      userTypeId = 29;
    } else if (sessionVO.getUserTypeId() == 2) { // CODY
      userTypeId = 28;
    }

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    // BranchCodeList
    params.clear();
    params.put("groupCode", 1);
    List<EgovMap> branchCdList = commonService.selectBranchList(params);

    // code List
    params.clear();
    params.put("groupCode", 8);
    List<EgovMap> codeList_8 = commonService.selectCodeList(params);

    // product
    List<EgovMap> productList_1 = hcOrderListService.selectProductCodeList();

    model.put("fromDay", CommonUtils.getAddDay(toDay, -1, SalesConstants.DEFAULT_DATE_FORMAT1));
    model.put("toDay", toDay);
    model.put("isAdmin", "true");
    model.put("isAdmin", "true");
    params.put("userId", sessionVO.getUserId());
    EgovMap branchTypeRes = salesCommonService.getUserBranchType(params);

    if (branchTypeRes != null) {
      model.put("branchType", branchTypeRes.get("codeId"));
    }

    model.put("userTypeId", userTypeId);
    model.put("branchCdList", branchCdList);
    model.put("codeList_8", codeList_8);
    model.put("productList_1", productList_1);

    return "homecare/sales/order/hcPreBookingOrderList";
  }

  // Search Homecare PreBookingOrderList
  @RequestMapping(value = "/selectHcPreBookOrderList.do")
  public ResponseEntity<List<EgovMap>> selectHcPreOrderList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] arrAppType = request.getParameterValues("_appTypeId"); // Application Type
    String[] arrPreOrdStusId = request.getParameterValues("_preStusId"); // Pre-Book Order Status
    String[] arrPreBookPeriod = request.getParameterValues("_preBookPeriod"); // Application Type


    if (arrAppType != null && !CommonUtils.containsEmpty(arrAppType))
      params.put("arrAppType", arrAppType);
    if (arrPreOrdStusId != null && !CommonUtils.containsEmpty(arrPreOrdStusId))
      params.put("arrPreOrdStusId", arrPreOrdStusId);
    if (arrPreBookPeriod != null && !CommonUtils.containsEmpty(arrPreBookPeriod))
      params.put("arrPreBookPeriod", arrPreBookPeriod);

    logger.debug("params : " + params);;
    List<EgovMap> result = hcPreBookingOrderService.selectHcPreBookingOrderList(params);

    return ResponseEntity.ok(result);
  }

  // Homecare Pre Book Order Register Popup
  @RequestMapping(value = "/hcPreBookOrderRegisterPop.do")
  public String hcPreOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {

    // Search BranchCodeList
    model.put("branchCdList_1", commonService.selectBranchList("1", "-"));
    //model.put("branchCdList_5", commonService.selectBranchList("5", "-"));
    model.put("nextDay", CommonUtils.getAddDay(CommonUtils.getDateToFormat(SalesConstants.DEFAULT_DATE_FORMAT1), 1,
        SalesConstants.DEFAULT_DATE_FORMAT1));

    EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

    String dayFrom = "", dayTo = "";

    if (checkExtradeSchedule != null) {
      dayFrom = checkExtradeSchedule.get("startDate").toString();
      dayTo = checkExtradeSchedule.get("endDate").toString();
    } else {
      dayFrom = "20"; // default 20-{month-1}
      dayTo = "02"; // default 2-{month}
    }

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("hsBlockDtFrom", dayFrom);
    model.put("hsBlockDtTo", dayTo);
    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "homecare/sales/order/hcPreBookOrderRegisterPop";
  }

  @RequestMapping(value = "/registerHcPreBookingOrder.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> registerHcPreBookingOrder(@RequestBody PreBookingOrderVO preBookingOrderVO,
      SessionVO sessionVO) throws Exception {

    hcPreBookingOrderService.registerHcPreBookingOrder(preBookingOrderVO, sessionVO);
    String preBookingOrderNo = preBookingOrderVO.getPreBookOrdNo();

    String msg = "Pre-Booking Order No : " + preBookingOrderNo + ".<br />";

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(msg);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hcPreBookOrderNoPrevPop.do")
  public String prevOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("custId", params.get("custId"));

    return "homecare/sales/order/hcPreBookOrderNoPrevPop";
  }

  @RequestMapping(value = "/selectHcPrevOrderNoList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHcPrevOrderNoList(@RequestParam Map<String, Object> params) {
    List<EgovMap> result = hcPreBookingOrderService.selectHcPrevOrderNoList(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
    EgovMap RESULT;
    RESULT = hcPreBookingOrderService.checkOldOrderId(params);

    // 데이터 리턴.
    return ResponseEntity.ok(RESULT);
  }

  @RequestMapping(value = "/hcPreBookOrderReqCancelPop.do")
  public String hcPreBookOrderReqCancelPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    // Search Pre Book Order Info
    EgovMap preBookOrderInfo = hcPreBookingOrderService.selectHcPreBookingOrderInfo(params);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    model.put("preBookOrderInfo", preBookOrderInfo);

    return "homecare/sales/order/hcPreBookOrderReqCancelPop";
  }

  @RequestMapping(value = "/hcPreBookOrderDetailPop.do")
  public String hcPreBookOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    // Search Pre Book Order Info
    EgovMap preBookOrderInfo = hcPreBookingOrderService.selectHcPreBookingOrderInfo(params);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    model.put("preBookOrderInfo", preBookOrderInfo);

    return "homecare/sales/order/hcPreBookOrderDetailPop";
  }

  @RequestMapping(value = "/selectPreBookOrderVerifyStus.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectPreBookOrderVerifyStus(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    params.put("type", 1); // HC
    EgovMap result = hcPreBookingOrderService.selectPreBookOrderEligibleInfo(params);

    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/hcRequestCancelPreBookOrder.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateHcPreBookOrderCancel(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
    // 주문 수정
    hcPreBookingOrderService.updateHcPreBookOrderCancel(params, sessionVO);

    String msg = "Pre-Booking Cancel successfully.<br />";

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(msg);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectPreBookOrderCancelStatus.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPreBookOrderCancelStatus( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

    List<EgovMap> result = hcPreBookingOrderService.selectPreBookOrderCancelStatus(params) ;

    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/checkPreBookSalesPerson.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkPreBookSalesPerson(@RequestParam Map<String, Object> params) {

    EgovMap result = hcPreBookingOrderService.checkPreBookSalesPerson(params);

    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/checkPreBookConfigurationPerson.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkPreBookConfigurationPerson(@RequestParam Map<String, Object> params) {

    EgovMap result = hcPreBookingOrderService.checkPreBookConfigurationPerson(params);

    return ResponseEntity.ok(result);
  }

}
