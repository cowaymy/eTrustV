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

  @RequestMapping(value = "/customer/getCustomerAccountCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustomerAccountCode(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custAccountNo = apiService.selectAccountCode(request, params);
    return ResponseEntity.ok(custAccountNo);
  }

  @RequestMapping(value = "/customer/getCustTotalProductsCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustTotalProductsCount(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap custTotalProducts = apiService.selectCustTotalProductsCount(request, params);
    return ResponseEntity.ok(custTotalProducts);
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

  @RequestMapping(value = "/customer/getMembershipProgrammesList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getMembershipProgrammesList(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap membershipProgrammesList = apiService.selectMembershipProgrammesList(request, params);
    return ResponseEntity.ok(membershipProgrammesList);
  }

}
