package com.coway.trust.web.common;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.ApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/api")
public class ApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiController.class);

  @Resource(name = "apiService")
  private ApiService apiService;

  @RequestMapping(value = "/customer/getCowayCustByNricOrPassport.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayCustByNricOrPassport(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap cowayCustDetails = apiService.selectCowayCustNricOrPassport(request, params);
    return ResponseEntity.ok(cowayCustDetails);
  }

  @RequestMapping(value = "/customer/isNricOrPassportMatchInvoiceNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isNricOrPassportMatchInvoiceNo(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap isNricOrPassportMatchInvoiceNo = apiService.isNricOrPassportMatchInvoiceNo(request, params);
    return ResponseEntity.ok(isNricOrPassportMatchInvoiceNo);
  }

  @RequestMapping(value = "/customer/getInvoiceSubscriptionsList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceSubscriptionsList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custInvoiceSubscriptionsList = apiService.selectInvoiceSubscriptionsList(request, params);
    return ResponseEntity.ok(custInvoiceSubscriptionsList);
  }

  @RequestMapping(value = "/customer/getCustTotalProductsCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustTotalProductsCount(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custTotalProducts = apiService.selectCustTotalProductsCount(request, params);
    return ResponseEntity.ok(custTotalProducts);
  }

  @RequestMapping(value = "/customer/getCustomerAccountCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustomerAccountCode(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custAccountNo = apiService.selectAccountCode(request, params);
    return ResponseEntity.ok(custAccountNo);
  }

  @RequestMapping(value = "/customer/getIndividualLastPayment.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getIndividualLastPayment(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap lastPayment = apiService.selectLastPayment(request, params);
    return ResponseEntity.ok(lastPayment);
  }

  @RequestMapping(value = "/customer/getCustTotalOutstanding.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustTotalOutstanding(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custOutStand = apiService.getCustTotalOutstanding(request, params);
    return ResponseEntity.ok(custOutStand);
  }

  @RequestMapping(value = "/customer/getTotalMembershipExpired.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTotalMembershipExpired(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap totalMembershipExpired = apiService.getTotalMembershipExpired(request, params);
    return ResponseEntity.ok(totalMembershipExpired);
  }

  @RequestMapping(value = "/customer/getCustVirtualAccountNumber.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustVirtualAccountNumber(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custVANo = apiService.selectCustVANo(request, params);
    return ResponseEntity.ok(custVANo);
  }

  @RequestMapping(value = "/customer/getAutoDebitEnrolmentsList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getAutoDebitEnrolmentsList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap autoDebitEnrolmentsList = apiService.selectAutoDebitEnrolmentsList(request, params);
    return ResponseEntity.ok(autoDebitEnrolmentsList);
  }

  @RequestMapping(value = "/customer/getCowayAccountProductPreviewList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayAccountProductPreviewList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap cowayAccountProductPreviewList = apiService.selectCowayAccountProductPreviewList(request, params);
    return ResponseEntity.ok(cowayAccountProductPreviewList);
  }

  @RequestMapping(value = "/customer/getCowayAccountProductPreviewListByAccountCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayAccountProductPreviewListByAccountCode(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap cowayAccountProductPreviewList = apiService.selectCowayAccountProductPreviewListByAccountCode(request, params);
    return ResponseEntity.ok(cowayAccountProductPreviewList);
  }

  @RequestMapping(value = "/customer/getProductDetail.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getProductDetail(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap productDetail = apiService.selectProductDetail(request, params);
    return ResponseEntity.ok(productDetail);
  }

  @RequestMapping(value = "/customer/getHeartServiceList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getHeartServiceList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap heartServiceList = apiService.selectHeartServiceList(request, params);
    return ResponseEntity.ok(heartServiceList);
  }

  @RequestMapping(value = "/customer/getTechnicianServicesList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTechnicianServicesList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap technicianServicesList = apiService.selectTechnicianServicesList(request, params);
    return ResponseEntity.ok(technicianServicesList);
  }

  @RequestMapping(value = "/customer/isUserHasOrdNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isUserHasOrdNo(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap isUserHasOrdNo = apiService.isUserHasOrdNo(request, params);
    return ResponseEntity.ok(isUserHasOrdNo);
  }

  @RequestMapping(value = "/customer/getInvoiceListByOrderNumber.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceListByOrderNumber(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap invoiceListByOrderNumber = apiService.selectInvoiceListByOrderNumber(request, params);
    return ResponseEntity.ok(invoiceListByOrderNumber);
  }

  @RequestMapping(value = "/customer/getTransactionHistoryList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTransactionHistoryList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap transactionHistoryList = apiService.selectTransactionHistoryList(request, params);
    return ResponseEntity.ok(transactionHistoryList);
  }

  @RequestMapping(value = "/customer/getInvoiceDetailByTaxInvoiceRefNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceDetailByTaxInvoiceRefNo(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap getinvoiceDetailByTaxInvoiceRefNo = apiService.selectInvoiceDetailByTaxInvoiceRefNo(request, params);
    return ResponseEntity.ok(getinvoiceDetailByTaxInvoiceRefNo);
  }

  @RequestMapping(value = "/customer/isUserHasTaxInvoiceRefNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isUserHasTaxInvoiceRefNo(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap isUserHasTaxInvoiceRefNo = apiService.isUserHasTaxInvoiceRefNo(request, params);
    return ResponseEntity.ok(isUserHasTaxInvoiceRefNo);
  }

  @RequestMapping(value = "/customer/getMembershipProgrammesList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getMembershipProgrammesList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap membershipProgrammesList = apiService.selectMembershipProgrammesList(request, params);
    return ResponseEntity.ok(membershipProgrammesList);
  }

  @RequestMapping(value = "/customer/getOrderNumbersList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getOrderNumbersList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap orderNumberList = apiService.selectOrderNumberList(request, params);
    return ResponseEntity.ok(orderNumberList);
  }

  @RequestMapping(value = "/customer/getProductList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getProductList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap productList = apiService.selectProductList(request, params);
    return ResponseEntity.ok(productList);
  }

  @RequestMapping(value = "/customer/addOrEditPersonInCharge.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> addOrEditPersonInCharge(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap addOrEditPersonInCharge = apiService.addOrEditPersonInCharge(request, params);
    return ResponseEntity.ok(addOrEditPersonInCharge);
  }

  @RequestMapping(value = "/customer/addOrEditCustomerInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> addOrEditCustomerInfo(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap addOrEditCustomerInfo = apiService.addOrEditCustomerInfo(request, params);
    return ResponseEntity.ok(addOrEditCustomerInfo);
  }

  @RequestMapping(value = "/customer/addEInvoiceSubscription.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> addEInvoiceSubscription(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap addEInvoiceSubscription = apiService.addEInvoiceSubscription(request, params);
    return ResponseEntity.ok(addEInvoiceSubscription);
  }

}
