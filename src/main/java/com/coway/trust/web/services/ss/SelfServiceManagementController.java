package com.coway.trust.web.services.ss;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.ss.SelfServiceManagementService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/ss")
public class SelfServiceManagementController {
  private static final Logger LOGGER = LoggerFactory.getLogger(SelfServiceManagementController.class);

  @Resource(name = "selfServiceManagementService")
  private SelfServiceManagementService selfServiceManagementService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @RequestMapping(value = "/initSsManagementList.do")
  public String initSsManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    LOGGER.debug("getUserBranchId : {}", sessionVO.getUserBranchId());

    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== initSsManagementList params{} ", params);
    LOGGER.debug("=======================================================================================");

    List<EgovMap> ssDelStus = supplementUpdateService.selectSupDelStus();

    model.addAttribute("ssDelStus", ssDelStus);
    model.addAttribute("userName", sessionVO.getUserName());
    model.addAttribute("memberLevel", sessionVO.getMemberLevel());
    model.addAttribute("userType", sessionVO.getUserTypeId());

    return "services/ss/selfServiceManagementList";
  }

  @RequestMapping(value = "/selectSelfServiceJsonList")
  public ResponseEntity<List<EgovMap>> selectSelfServiceJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {
    List<EgovMap> listMap = null;
    String deliveryStatusArray[] = request.getParameterValues("ssDelStus");
    params.put("deliveryStatusArray", deliveryStatusArray);

    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== selectSelfServiceJsonList params{} ", params);
    LOGGER.debug("=======================================================================================");

    listMap = selfServiceManagementService.selectSelfServiceJsonList(params);
    return ResponseEntity.ok(listMap);
  }

  @RequestMapping(value = "/selectSelfServiceFilterItmList")
  public ResponseEntity<List<EgovMap>> selectSelfServiceFilterItmList(@RequestParam Map<String, Object> params)
      throws Exception {
    List<EgovMap> detailList = null;
    detailList = selfServiceManagementService.selectSelfServiceFilterItmList(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/saveSelfServiceResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveSelfServiceResult(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== saveSelfServiceResult params : {}", params);
    LOGGER.debug("=======================================================================================");

    try {
      params.put("crtUsrId", sessionVO.getUserId());
      Map<String, Object> returnMap = selfServiceManagementService.saveSelfServiceResult(params);

      if ("000".equals(returnMap.get("logError"))) {
        msg += "Self Service successfully saved.<br />";
        msg += returnMap.get("message") + "<br />";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Self Service failed to save.<br />";
        msg += returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
    } catch (Exception e) {
      LOGGER.error("Error during Self Service save", e);
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "selfServiceManagementViewDetailPop")
  public String selfServiceManagementViewDetailPop(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== selfServiceManagementViewDetailPop params : {}", params);
    LOGGER.debug("=======================================================================================");

    EgovMap basicinfo = null;
    EgovMap orderDetail = null;
    EgovMap orderInfo = null;

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    basicinfo = hsManualService.selectHsViewBasicInfo(params);
    orderInfo = selfServiceManagementService.selectSelfServiceResultInfo(params);

    model.addAttribute("ssResultId", params.get("ssResultId"));
    model.addAttribute("salesOrdId", params.get("salesOrderId"));
    model.addAttribute("schdulId", params.get("schdulId"));
    model.addAttribute("basicinfo", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("orderInfo", orderInfo);

    return "services/ss/selfServiceManagementViewDetailPop";
  }

  @RequestMapping(value = "selfServiceStatusUpdatePop")
  public String selfServiceStatusUpdatePop(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== selfServiceStatusUpdatePop params : {}", params);
    LOGGER.debug("=======================================================================================");

    EgovMap basicinfo = null;
    EgovMap orderDetail = null;
    EgovMap orderInfo = null;

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    basicinfo = hsManualService.selectHsViewBasicInfo(params);
    orderInfo = selfServiceManagementService.selectSelfServiceResultInfo(params);
    List<EgovMap> failReasonList = hsManualService.failReasonList(params);

    model.addAttribute("ssResultId", params.get("ssResultId"));
    model.addAttribute("salesOrdId", params.get("salesOrderId"));
    model.addAttribute("schdulId", params.get("schdulId"));
    model.addAttribute("basicinfo", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("orderInfo", orderInfo);
    model.addAttribute("failReasonList", failReasonList);

    return "services/ss/selfServiceStatusUpdatePop";
  }

  @RequestMapping(value = "selfServiceReturnQtyUpdatePop")
  public String selfServiceReturnQtyUpdatePop(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== selfServiceReturnQtyUpdatePop params : {}", params);
    LOGGER.debug("=======================================================================================");

    EgovMap basicinfo = null;
    EgovMap orderDetail = null;
    EgovMap orderInfo = null;

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    basicinfo = hsManualService.selectHsViewBasicInfo(params);
    orderInfo = selfServiceManagementService.selectSelfServiceResultInfo(params);

    model.addAttribute("ssResultId", params.get("ssResultId"));
    model.addAttribute("salesOrdId", params.get("salesOrderId"));
    model.addAttribute("schdulId", params.get("schdulId"));
    model.addAttribute("basicinfo", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("orderInfo", orderInfo);
    model.addAttribute("hsNo", params.get("hsNo"));

    return "services/ss/selfServiceReturnQtyUpdatePop";
  }

  @RequestMapping(value = "/updateSelfServiceResultStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateSelfServiceResultStatus(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== updateSelfServiceResultStatus params : {}", params);
    LOGGER.debug("=======================================================================================");

    // For handling Case - DHL Successfully delivery to Customer , but Customer lost parcel. Required to Fail current month SS Status for next month generation
    try {
      params.put("updUsrId", sessionVO.getUserId());
      Map<String, Object> returnMap = selfServiceManagementService.updateSelfServiceResultStatus(params);
      if ("000".equals(returnMap.get("logError"))) {
        msg += "Self Service successfully update status.<br />";
        msg += returnMap.get("message") + "<br />";
        message.setCode(AppConstants.SUCCESS);
      } else {
        msg += "Self Service failed to update.<br />";
        msg += returnMap.get("message") + "<br />";
        message.setCode(AppConstants.FAIL);
      }
      message.setMessage(msg);
    } catch (Exception e) {
      LOGGER.error("Error during Update Self Service status", e);
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getSelfServiceFilterList")
  public ResponseEntity<List<EgovMap>> getSelfServiceFilterList(@RequestParam Map<String, Object> params)
      throws Exception {
    List<EgovMap> detailList = null;
    detailList = selfServiceManagementService.getSelfServiceFilterList(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/getSelfServiceDelivryList")
  public ResponseEntity<List<EgovMap>> getSelfServiceDelivryList(@RequestParam Map<String, Object> params)
      throws Exception {
    List<EgovMap> detailList = null;
    detailList = selfServiceManagementService.getSelfServiceDelivryList(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/getSelfServiceRtnItmDetailList")
  public ResponseEntity<List<EgovMap>> getSelfServiceRtnItmDetailList(@RequestParam Map<String, Object> params)
      throws Exception {
    List<EgovMap> detailList = null;
    detailList = selfServiceManagementService.getSelfServiceRtnItmDetailList(params);
    return ResponseEntity.ok(detailList);
  }

  @Transactional
  @RequestMapping(value = "/updateReturnGoodsQty.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateReturnGoodsQty(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    String msg = "";
    LOGGER.debug("=======================================================================================");
    LOGGER.debug("============== updateReturnGoodsQty params : {}", params);
    LOGGER.debug("=======================================================================================");

    try {
      params.put("crtUsrId", sessionVO.getUserId());
      Map<String, Object> returnMap = selfServiceManagementService.updateReturnGoodsQty(params);
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
      msg += "An unexpected error occurred.<br />";
      message.setCode(AppConstants.FAIL);
      message.setMessage(msg);
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getSelfServiceRtnItmList")
  public ResponseEntity<List<EgovMap>> getSelfServiceRtnItmList(@RequestParam Map<String, Object> params)
      throws Exception {
    List<EgovMap> detailList = null;
    detailList = selfServiceManagementService.getSelfServiceRtnItmList(params);
    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/saveValidation.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> saveValidation(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws ParseException {
    int resultValue = selfServiceManagementService.saveValidation(params);
    return ResponseEntity.ok(resultValue);
  }

}
