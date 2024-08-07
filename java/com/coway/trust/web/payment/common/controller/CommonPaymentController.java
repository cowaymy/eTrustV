package com.coway.trust.web.payment.common.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpRequest;
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
import com.coway.trust.biz.payment.billinggroup.service.BillingTaxInvoiceService;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.CommonPopupPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/common")
public class CommonPaymentController {

  private static final Logger LOGGER = LoggerFactory.getLogger(CommonPaymentController.class);

  @Resource(name = "commonPaymentService")
  private CommonPaymentService commonPaymentService;

  /**
   * Payment - Order Info 조회 : order No로 Order ID 조회하기
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectOrdIdByNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrdIdByNo(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    EgovMap resultMap = commonPaymentService.selectOrdIdByNo(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultMap);
  }

  /******************************************************
   * Payment - Order Info Rental
   *****************************************************/
  /**
   * Payment - Order Info Rental 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public List
   *         <RentalOrderView> GetRentalOrders(int orderId, bool
   *         getBillingGroup)
   */
  @RequestMapping(value = "/selectOrderInfoRental.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderInfoRental(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectOrderInfoRental(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /**
   * Payment - Order Info Rental Mega Deal여부 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectMegaDealByOrderId.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectMegaDealByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    EgovMap resultMap = commonPaymentService.selectMegaDealByOrderId(params);

    if (resultMap == null || resultMap.get("megaDeal") == null) {
      resultMap = new EgovMap();
      resultMap.put("megaDeal", 0);
    }

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultMap);
  }

  /******************************************************
   * Payment - Bill Info Rental
   *****************************************************/
  /**
   * Payment - Bill Info Rental 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectBillInfoRental.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBillInfoRental(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectBillInfoRental(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /******************************************************
   * Payment - Order Info Non - Rental
   *****************************************************/
  /**
   * Payment - Order Info Non - Rental 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public List
   *         <RentalOrderView> GetOutInstOrders(int orderId)
   */
  @RequestMapping(value = "/selectOrderInfoNonRental.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderInfoNonRental(@RequestParam Map<String, Object> params,
      ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectOrderInfoNonRental(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectHTOrderInfoNonRental.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHTOrderInfoNonRental(@RequestParam Map<String, Object> params,
      ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectHTOrderInfoNonRental(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /******************************************************
   * Payment - Order Info Membership Service
   *****************************************************/
  /**
   * Payment - Order Info Membership Service 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectOrderInfoSVM.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderInfoSVM(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    commonPaymentService.selectOrderInfoSVM(params);
    List<EgovMap> resultMapList = (List<EgovMap>) params.get("resultMemSvm"); // 결과
                                                                              // 뿌려보기
                                                                              // :
                                                                              // 프로시저에서
                                                                              // resultMemSvm
                                                                              // 이란
                                                                              // key값으로
                                                                              // 객체를
                                                                              // 반환한다.

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultMapList);
  }

  /******************************************************
   * Payment - Order Info Rental Membership
   *****************************************************/
  /**
   * Payment - Order Info Rental Membership 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectOrderInfoSrvc.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderInfoSrvc(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectOrderInfoSrvc(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /**
   * Payment - Bill Info Rental Membership 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectBillInfoSrvc.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBillInfoSrvc(@RequestParam Map<String, Object> params, ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectBillInfoSrvc(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /******************************************************
   * Payment - Order Info Bill Payment
   *****************************************************/
  /**
   * Payment - Order Info Rental Payment 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectOrderInfoBillPayment.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderInfoBillPayment(@RequestParam Map<String, Object> params,
      ModelMap model) {

    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectOrderInfoBillPayment(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /******************************************************
   * Payment - Outright Membership
   *****************************************************/
  /**
   * Payment - Outright Membership Order Info 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectOutSrvcOrderInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOutSrvcOrderInfo(@RequestParam Map<String, Object> params,
      ModelMap model) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectOutSrvcOrderInfo(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /**
   * Payment 처리
   *
   * @param Map
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/savePayment", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> savePayment(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model,
      SessionVO sessionVO) {
    List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터
                                                                  // 가져오기
    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

    Map<String, Object> formInfo = new HashMap<String, Object>();
    if (formList.size() > 0) {
      for (Object obj : formList) {
        Map<String, Object> map = (Map<String, Object>) obj;
        formInfo.put((String) map.get("name"), map.get("value"));
      }
    }

    // User ID 세팅
    formInfo.put("userid", sessionVO.getUserId());

    // Credit Card일때
    if ("107".equals(String.valueOf(formInfo.get("keyInPayType")))) {
      formInfo.put("keyInIsOnline", "1299".equals(String.valueOf(formInfo.get("keyInCardMode"))) ? 0 : 1);
      formInfo.put("keyInIsLock", 0);
      formInfo.put("keyInIsThirdParty", 0);
      formInfo.put("keyInStatusId", 1);
      formInfo.put("keyInIsFundTransfer", 0);
      formInfo.put("keyInSkipRecon", 0);
      formInfo.put("keyInPayItmCardType", formInfo.get("keyCrcCardType"));
      formInfo.put("keyInPayItmCardMode", formInfo.get("keyInCardMode"));
    }

    // 저장
    List<EgovMap> resultList = commonPaymentService.savePayment(formInfo, gridList);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);

  }

  /**
   * Payment 처리
   *
   * @param Map
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/saveNormalPayment", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> saveNormalPayment(@RequestBody Map<String, ArrayList<Object>> params,
      ModelMap model, SessionVO sessionVO) {
    String message = "";

    List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터
                                                                  // 가져오기
    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

    LOGGER.debug("params : {} ", params);
    List<Object> tmpKey = params.get("key"); // BankStatement의 id값 가져오기
    int key = Integer.parseInt(String.valueOf(tmpKey.get(0)));

    Map<String, Object> formInfo = new HashMap<String, Object>();
    if (formList.size() > 0) {
      for (Object obj : formList) {
        Map<String, Object> map = (Map<String, Object>) obj;
        formInfo.put((String) map.get("name"), map.get("value"));
      }
    }

    // User ID 세팅
    formInfo.put("userid", sessionVO.getUserId());

    if (formInfo.get("chargeAmount") == null || formInfo.get("chargeAmount").equals("")) {
      formInfo.put("chargeAmount", 0);
    }

    if (formInfo.get("bankAcc") == null || formInfo.get("bankAcc").equals("")) {
      formInfo.put("bankAcc", 0);
    }
    formInfo.put("payItemIsLock", false);
    formInfo.put("payItemIsThirdParty", false);
    formInfo.put("payItemStatusId", 1);
    formInfo.put("isFundTransfer", false);
    formInfo.put("skipRecon", false);
    formInfo.put("payItemCardTypeId", 0);

    // 저장
    Map<String, Object> resultList = commonPaymentService.saveNormalPayment(formInfo, gridList, key);

    LOGGER.debug("resultList : " + resultList);
    // 결과 만들기.
    ReturnMessage msg = new ReturnMessage();
    msg.setCode(AppConstants.SUCCESS);
    msg.setMessage(message);
    return ResponseEntity.ok(resultList);
  }

  /**
   * Payment - Order Info Rental Payment 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @RequestMapping(value = "/selectProcessPaymentResult.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProcessPaymentResult(@RequestParam Map<String, Object> params,
      ModelMap model) {

    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectProcessPaymentResult(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectProcessCSPaymentResult.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProcessCSPaymentResult(@RequestParam Map<String, Object> params,
      ModelMap model) {

    // 조회.
    List<EgovMap> resultList = commonPaymentService.selectProcessCSPaymentResult(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/checkOrderOutstanding.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkOrderOutstanding(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
    EgovMap RESULT;

    RESULT = commonPaymentService.checkOrderOutstanding(params);

    return ResponseEntity.ok(RESULT);
  }

  @RequestMapping(value = "/checkHTOrderOutstanding.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkHTOrderOutstanding(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
    EgovMap RESULT;

    RESULT = commonPaymentService.checkHTOrderOutstanding(params);

    return ResponseEntity.ok(RESULT);
  }

  @RequestMapping(value = "/checkBatchPaymentExist.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkBatchPaymentExist(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
    EgovMap result = commonPaymentService.checkBatchPaymentExist(params);

    return ResponseEntity.ok(result);
  }



}