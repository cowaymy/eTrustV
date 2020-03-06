package com.coway.trust.biz.common.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.ApiService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.AppConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("apiService")
public class ApiServiceImpl implements ApiService {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiServiceImpl.class);

  @Autowired
  private ApiMapper apiMapper;

  @Override
  public EgovMap displayResponseMessage(HttpServletRequest request, Map<String, Object> params, List<EgovMap> custDetails) {

    EgovMap response = new EgovMap();
    //EgovMap custDetails = new EgovMap();
    String respTm = null;
    String pgmPath = StringUtils.defaultString(request.getRequestURI()) + "?" + StringUtils.defaultString(request.getQueryString());

    try {

      StopWatch stopWatch = new StopWatch();
      stopWatch.reset();
      stopWatch.start();
      //custDetails = apiMapper.selectCowayCustNricOrPassport(params);
      stopWatch.stop();
      respTm = stopWatch.toString();

      if (!request.getQueryString().equals(null)) {
        if (custDetails.size() < 1) {
          params.put("respCde", AppConstants.RESPONSE_CODE_NOT_FOUND);
          params.put("respDesc", AppConstants.RESPONSE_DESC_NOT_FOUND);
        } else {
          params.put("respCde", AppConstants.RESPONSE_CODE_SUCCESS);
          params.put("respDesc", AppConstants.RESPONSE_DESC_SUCCESS);
        }
        params.put("errMsg", "");

      } else {

        params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
        params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
        params.put("errMsg", "No paramater");

      }
    } catch (Exception e) {

      params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
      params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
      params.put("errMsg", StringUtils.substring(e.getMessage(), 0, 4000));

    } finally {
      params.put("reqParam", params.toString());
      params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", custDetails != null ? custDetails.toString().length() >= 4000 ? custDetails.toString().substring(0,4000) : custDetails.toString() : custDetails);

      apiMapper.insertApiAccessLog(params);

      response.put("response", params.get("respCde").toString() + " - " + params.get("respDesc").toString());
      if(custDetails.size() > 0) response.put("custDetails", custDetails);
    }

    return response;
  }

  @Override
  public EgovMap displayResponseMessage(HttpServletRequest request, Map<String, Object> params, EgovMap custDetails) {

    EgovMap response = new EgovMap();
    //EgovMap custDetails = new EgovMap();
    String respTm = null;
    String pgmPath = StringUtils.defaultString(request.getRequestURI()) + "?" + StringUtils.defaultString(request.getQueryString());
    try {

      StopWatch stopWatch = new StopWatch();
      stopWatch.reset();
      stopWatch.start();
      //custDetails = apiMapper.selectCowayCustNricOrPassport(params);
      stopWatch.stop();
      respTm = stopWatch.toString();

      if (!request.getQueryString().equals(null)) {

        if (custDetails == null) {
          params.put("respCde", AppConstants.RESPONSE_CODE_NOT_FOUND);
          params.put("respDesc", AppConstants.RESPONSE_DESC_NOT_FOUND);
        } else {
          params.put("respCde", AppConstants.RESPONSE_CODE_SUCCESS);
          params.put("respDesc", AppConstants.RESPONSE_DESC_SUCCESS);
        }
        params.put("errMsg", "");

      } else {

        params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
        params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
        params.put("errMsg", "No paramater");

      }
    } catch (Exception e) {

      params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
      params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
      params.put("errMsg", StringUtils.substring(e.getMessage(), 0, 4000));

    } finally {
      params.put("reqParam", params.toString());
      params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", custDetails != null ? custDetails.toString() : custDetails);

      apiMapper.insertApiAccessLog(params);

      response.put("response", params.get("respCde").toString() + " - " + params.get("respDesc").toString());
      if(custDetails != null) response.put("custDetails", custDetails);

      if(pgmPath.contains("tokenizationProcess")) {
          response.remove("custDetails");
      }
    }

    return response;
  }

  @Override
  public EgovMap selectCowayCustNricOrPassport(HttpServletRequest request, Map<String, Object> params) {
    EgovMap custDetails = apiMapper.selectCowayCustNricOrPassport(params);
    return displayResponseMessage(request, params,custDetails);
  }

  @Override
  public EgovMap isNricOrPassportMatchInvoiceNo(HttpServletRequest request, Map<String, Object> params) {
    EgovMap isNricOrPassportMatchInvoiceNo = apiMapper.isNricOrPassportMatchInvoiceNo(params);
    return displayResponseMessage(request, params,isNricOrPassportMatchInvoiceNo);
  }

  @Override
  public EgovMap selectInvoiceSubscriptionsList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> custInvoiceSubscription = apiMapper.selectInvoiceSubscriptionsList(params);
    return displayResponseMessage(request, params,custInvoiceSubscription);
  }

  @Override
  public EgovMap selectAccountCode(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> custAccountCode = apiMapper.selectAccountCode(params);
    return displayResponseMessage(request, params,custAccountCode);
  }

  @Override
  public EgovMap selectCustTotalProductsCount(HttpServletRequest request, Map<String, Object> params) {
    EgovMap custProductCount = apiMapper.selectCustTotalProductsCount(params);
    return displayResponseMessage(request, params,custProductCount);
  }

  @Override
  public EgovMap selectLastPayment(HttpServletRequest request, Map<String, Object> params) {
    EgovMap lastPayment = apiMapper.selectLastPayment(params);
    return displayResponseMessage(request, params,lastPayment);
  }

  @Override
  public EgovMap getCustTotalOutstanding(HttpServletRequest request, Map<String, Object> params) {
    EgovMap custTotalStanding = apiMapper.getCustTotalOutstanding(params);
    return displayResponseMessage(request, params,custTotalStanding);
  }

  @Override
  public EgovMap getTotalMembershipExpired(HttpServletRequest request, Map<String, Object> params) {
    EgovMap totalMembershipExpired = apiMapper.getTotalMembershipExpired(params);
    return displayResponseMessage(request, params,totalMembershipExpired);
  }
  @Override
  public EgovMap selectCustVANo(HttpServletRequest request, Map<String, Object> params) {
    EgovMap custVANo = apiMapper.selectCustVANo(params);
    return displayResponseMessage(request, params,custVANo);
  }

  @Override
  public EgovMap selectAutoDebitEnrolmentsList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> autoDebitEnrolmentsList = apiMapper.selectAutoDebitEnrolmentsList(params);
    return displayResponseMessage(request, params,autoDebitEnrolmentsList);
  }

  @Override
  public EgovMap selectCowayAccountProductPreviewList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> cowayAccountProductPreviewList = apiMapper.selectCowayAccountProductPreviewList(params);

    cowayAccountProductPreviewList.forEach(obj -> {
      Map<String, Object> map = (Map<String, Object>) obj;
      EgovMap membershipExpiredDate = apiMapper.selectMembershipExpiredDate(map);
      if(membershipExpiredDate != null)
        map.put("membershipExpiryDate",membershipExpiredDate.get("membershipExpiryDate"));
    });

    return displayResponseMessage(request, params,cowayAccountProductPreviewList);
  }

  @Override
  public EgovMap selectCowayAccountProductPreviewListByAccountCode(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> cowayAccountProductPreviewListByAccountCode = apiMapper.selectCowayAccountProductPreviewListByAccountCode(params);

    cowayAccountProductPreviewListByAccountCode.forEach(obj -> {
      Map<String, Object> map = (Map<String, Object>) obj;
      EgovMap membershipExpiredDate = apiMapper.selectMembershipExpiredDate(map);
      if(membershipExpiredDate != null)
        map.put("membershipExpiryDate",membershipExpiredDate.get("membershipExpiryDate"));
    });

    return displayResponseMessage(request, params,cowayAccountProductPreviewListByAccountCode);
  }

  @Override
  public EgovMap selectProductDetail(HttpServletRequest request, Map<String, Object> params) {

    EgovMap productDetail = apiMapper.selectProductDetail(params);
    EgovMap memDetail = apiMapper.selectLatestMembership(params);
    if(memDetail != null)
      productDetail.putAll(memDetail);
    return displayResponseMessage(request, params,productDetail);
  }

  @Override
  public EgovMap selectHeartServiceList(HttpServletRequest request, Map<String, Object> params) {
    EgovMap heartServiceList = apiMapper.selectHeartServiceList(params);
    return displayResponseMessage(request, params,heartServiceList);
  }

  @Override
  public EgovMap selectTechnicianServicesList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> technicianServicesList = apiMapper.selectTechnicianServicesList(params);
    return displayResponseMessage(request, params,technicianServicesList);
  }

  @Override
  public EgovMap isUserHasOrdNo(HttpServletRequest request, Map<String, Object> params) {
    EgovMap isUserHasOrdNo = apiMapper.isUserHasOrdNo(params);
    return displayResponseMessage(request, params,isUserHasOrdNo);
  }

  @Override
  public EgovMap selectInvoiceListByOrderNumber(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> invoiceListByOrderNumber = apiMapper.selectInvoiceListByOrderNumber(params);
    return displayResponseMessage(request, params,invoiceListByOrderNumber);
  }

  @Override
  public EgovMap selectTransactionHistoryList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> transactionHistoryList = apiMapper.selectTransactionHistoryList(params);
    return displayResponseMessage(request, params,transactionHistoryList);
  }

  @Override
  public EgovMap selectInvoiceDetailByTaxInvoiceRefNo(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> selectInvoiceDetailByTaxInvoiceRefNo = apiMapper.selectInvoiceDetailByTaxInvoiceRefNo(params);
    return displayResponseMessage(request, params,selectInvoiceDetailByTaxInvoiceRefNo);
  }

  @Override
  public EgovMap isUserHasTaxInvoiceRefNo(HttpServletRequest request, Map<String, Object> params) {
    EgovMap isUserHasTaxInvoiceRefNo = apiMapper.isUserHasTaxInvoiceRefNo(params);
    return displayResponseMessage(request, params,isUserHasTaxInvoiceRefNo);
  }

  @Override
  public EgovMap selectMembershipProgrammesList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> membershipProgrammesList = apiMapper.selectMembershipProgrammesList(params);
    return displayResponseMessage(request, params,membershipProgrammesList);
  }

  @Override
  public EgovMap selectProductList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> membershipProgrammesList = apiMapper.selectProductList(params);
    return displayResponseMessage(request, params,membershipProgrammesList);
  }

  @Override
  public EgovMap selectOrderNumberList(HttpServletRequest request, Map<String, Object> params) {
    List<EgovMap> orderNumberList = apiMapper.selectOrderNumberList(params);
    return displayResponseMessage(request, params,orderNumberList);
  }

  @Override
  public EgovMap addOrEditPersonInCharge(HttpServletRequest request, Map<String, Object> params) {

    int customerPortalSeq = apiMapper.customerPortalSeq();

    params.put("customerPortalSeq", customerPortalSeq);

    int updatedResult = apiMapper.addOrEditPersonInCharge(params);
    EgovMap picInfoUpdateResult = new EgovMap();
    if(updatedResult < 1){
      picInfoUpdateResult.put("status", "Failed");
    }else{

      int update = apiMapper.updatePersonInChargeContact(params);
      if(update < 1)
        picInfoUpdateResult.put("status", "Failed while updating customer contact");
      else
        picInfoUpdateResult.put("status", "Success");
        picInfoUpdateResult.put("customerPortalSeq", customerPortalSeq);

    }
    return displayResponseMessage(request, params,picInfoUpdateResult);
  }

  @Override
  public EgovMap addOrEditCustomerInfo(HttpServletRequest request, Map<String, Object> params) {

    int customerPortalSeq = apiMapper.customerPortalSeq();

    params.put("customerPortalSeq", customerPortalSeq);

    int updatedResult = apiMapper.addOrEditCustomerInfo(params);
    EgovMap custInfoUpdateResult = new EgovMap();
    if(updatedResult < 1){
      custInfoUpdateResult.put("status", "Failed");
    }else{
      custInfoUpdateResult.put("customerPortalSeq", customerPortalSeq);
      custInfoUpdateResult.put("status", "Success");
    }
    return displayResponseMessage(request, params,custInfoUpdateResult);
  }

  @Override
  public EgovMap addEInvoiceSubscription(HttpServletRequest request, Map<String, Object> params) {

    int customerPortalSeq = apiMapper.customerPortalSeq();

    params.put("customerPortalSeq", customerPortalSeq);

    int updatedResult = apiMapper.addEInvoiceSubscription(params);
    EgovMap invoiceUpdateResult = new EgovMap();
    if(updatedResult < 1){
      invoiceUpdateResult.put("status", "Failed");
    }else{
      invoiceUpdateResult.put("status", "Success");
    }
    return displayResponseMessage(request, params,invoiceUpdateResult);
  }

  @Override
  public EgovMap verify(HttpServletRequest request, Map<String, Object> params) {

    /*
     * Code     Description
     * 5502     Person In Charge
     * 5503     Customer Info
     * 5504     Invoice Subscription
    */

    EgovMap selectCustomerPortalTemp = apiMapper.selectCustomerPortalTemp(params);

    EgovMap updateResult = new EgovMap();

    if(selectCustomerPortalTemp != null){

      int type = Integer.parseInt(selectCustomerPortalTemp.get("cpTypeId").toString());

      params.put("stus",SalesConstants.STATUS_ACTIVE);
      params.put("userId", 100910); //Customer Portal

      if(type == 5503){
        params.put("custId", selectCustomerPortalTemp.get("custId").toString());
        params.put("name", selectCustomerPortalTemp.get("custName").toString());
        params.put("custMobile", selectCustomerPortalTemp.get("custMobile").toString());
        params.put("email", selectCustomerPortalTemp.get("custEmail").toString());

        apiMapper.insertCustomerNewContact(params);

        params.put("stusId", 4);
      }
      else if(type == 5504){

      }


      apiMapper.updateStatus(params);
      updateResult.put("status", "Success");

    }else{
      updateResult.put("status", "Failed");
    }

    return displayResponseMessage(request, params,updateResult);
  }

  @Override
  public EgovMap tokenizationProcess(HttpServletRequest request, Map<String, Object> params) {

      EgovMap result = new EgovMap();
      if(params.containsKey("errMsg")) {
          params.put("stusID", "21");
      } else {
          params.put("stusID", "4");
      }

      if(apiMapper.updateTokenStaging(params) != 1) {
          result.put("status", "Failed");
      } else {
          result.put("status", "Success");
      }

      return displayResponseMessage(request, params, result);
  }

}
