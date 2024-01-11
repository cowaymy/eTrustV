package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.homecare.sales.order.HcPreBookingOrderService;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.mambership.impl.MembershipQuotationMapper;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.PreOrderServiceImpl;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreBookingOrderServiceImpl.java
 * @Description : Homecare Pre Booking Order ServiceImpl
 */

@Service("hcPreBookingOrderService")
public class HcPreBookingOrderServiceImpl extends EgovAbstractServiceImpl implements HcPreBookingOrderService {

  private static Logger logger = LoggerFactory.getLogger(PreOrderServiceImpl.class);

  @Resource(name = "hcPreBookingOrderMapper")
  private HcPreBookingOrderMapper hcPreBookingOrderMapper;

  @Resource(name = "hcOrderRegisterMapper")
  private HcOrderRegisterMapper hcOrderRegisterMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "membershipQuotationMapper")
  private MembershipQuotationMapper membershipQuotationMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "orderDetailMapper")
  private OrderDetailMapper orderDetailMapper;

  // Search Homecare Pre Booking Order List
  @Override
  public List<EgovMap> selectHcPreBookingOrderList(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectHcPreBookingOrderList(params);
  }

  // Homecare Register Pre Booking Order
  @Override
  public void registerHcPreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO)
      throws ParseException {
    try {

      // GET MEMBERSHIP LAST EXPIRE DATE
      EgovMap GetExpDate = orderRegisterMapper.selectSvcExpire(preBookingOrderVO.getSalesOrdIdOld());
      int discWaive = 0;
      if (GetExpDate != null) {
        discWaive = GetExpDate.get("monthBeforeExpired") != null ? ((BigDecimal) GetExpDate.get("monthBeforeExpired")).intValue() : 0;
        logger.info("[HcPreBookingOrderServiceImpl - registerHcPreBookingOrder] discWaive :: " + discWaive);
        if(discWaive >= 5 || discWaive <= 0){
          throw new ApplicationException(AppConstants.FAIL,"Pre Booking Order Register Failed - Promotion discount entitlement.");
        }
      } else {
        throw new ApplicationException(AppConstants.FAIL,"Pre Booking Order Register Failed - Membership warranty.");
      }

      // GET PRE BOOKING ORDER NO
      String preBookingOrdNo = commonMapper.selectDocNo("195");
      preBookingOrderVO.setPreBookOrdNo(preBookingOrdNo);
      preBookingOrderVO.setCrtUserId(sessionVO.getUserId());
      preBookingOrderVO.setUpdUserId(sessionVO.getUserId());
      preBookingOrderVO.setDiscWaive(discWaive);
      preBookingOrderVO.setCustVerifyStus(SalesConstants.STATUS_CODE_NAME_ACT); // Default ACT
      preBookingOrderVO.setStusId(SalesConstants.STATUS_ACTIVE); // Default ACT

      // INSERT INTO PRE-BOOK MASTER TABLE - SAL0404M
      hcPreBookingOrderMapper.insertPreBookingOrder(preBookingOrderVO);

      Map<String, Object> smsEntry = new HashMap<String, Object>();

      /*      String smsMessage = "RM0 COWAY: Order No. " + preBookingOrderVO.getSalesOrdNoOld()
          + " agree for Extrade Pre Booking under " + preBookingOrderVO.getMemCode()
          + ". To agree reply PREBOOK<space><Old Order No.> to XXXXX within 3 days. TQ";

      smsEntry.put("smsId", 0);
      smsEntry.put("smsMsg", smsMessage);
      smsEntry.put("smsMsisdn", preBookingOrderVO.getCustContactNumber());
      smsEntry.put("smsTypeId", 1);
      smsEntry.put("smsPrio", 1);
      smsEntry.put("smsRefNo", "");
      smsEntry.put("smsBatchUploadId", 0);
      smsEntry.put("smsRem", "Pre-Booking SMS via e-trust");
      smsEntry.put("smsStartDt", CommonUtils.getNowDate());
      smsEntry.put("smsExprDt", CommonUtils.getCalDate(3));
      smsEntry.put("smsStusId", SalesConstants.STATUS_ACTIVE);
      smsEntry.put("smsRetry", 0);
      smsEntry.put("userId", sessionVO.getUserId());
      smsEntry.put("smsVendorId", 1);*/

      // INSERT INTO SMS TABLE - MSC0015D
      //smsMapper.insertSmsEntry(smsEntry);

   /*   SmsVO sms = new SmsVO(sessionVO.getUserId(), 975);

      smsEntry.put("preBookNo", preBookingOrderVO.getPreBookOrdNo());
      smsEntry.put("salesOrdNoOld", preBookingOrderVO.getSalesOrdNoOld());
      smsEntry.put("postCode", preBookingOrderVO.getPostCode());
      smsEntry.put("memCode", preBookingOrderVO.getMemCode());
      smsEntry.put("salesOrderId", preBookingOrderVO.getSalesOrdIdOld());

      String smsTemplate = hcPreBookingOrderMapper.getHcPreBookSmsTemplate(smsEntry);
      EgovMap mailingInfo = orderDetailMapper.selectOrderMailingInfoByOrderID(smsEntry);

      if(mailingInfo.get("mailCntTelM") == null){
        throw new ApplicationException(AppConstants.FAIL,"Pre Booking Order Register Failed - Mailing Info - Mobile No is empty.");
      }

      sms.setMessage(CommonUtils.nvl(smsTemplate));
      sms.setMobiles(CommonUtils.nvl(mailingInfo.get("mailCntTelM")));
      sms.setRemark("Pre-Booking SMS VIA eTRUST");
      sms.setRefNo(CommonUtils.nvl(preBookingOrdNo));
      adaptorService.sendSMS4(sms);

*/

      // Update customer marketing message status(universal between HC/HA)
      Map<String, Object> params1 = new HashMap();
      params1.put("custId", preBookingOrderVO.getCustId());
      params1.put("updUserId", sessionVO.getUserId());
      params1.put("receivingMarketingMsgStatus", preBookingOrderVO.getReceivingMarketingMsgStatus());
      orderRegisterMapper.updateMarketingMessageStatus(params1);

    } catch (Exception e) {
      throw new ApplicationException(AppConstants.FAIL, "Pre Booking Order Register Failed.");
    }
  }

  @Override
  public List<EgovMap> selectHcPrevOrderNoList(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectHcPrevOrderNoList(params);
  }

  @Override
  public EgovMap checkOldOrderId(Map<String, Object> params) {

    EgovMap RESULT = new EgovMap();
    int getOldOrderID = 0;
    int extradeWoutPRCnt = 0;
    String ROOT_STATE = "";
    String isInValid = "";
    String msg = "";
    String txtInstSpecialInstruction = "";

    // GET PREVIOUS ORDER INFO
    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

    if (ordInfo != null) {
      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
    }

    if ("0".equals(getOldOrderID)) {
      ROOT_STATE = "ROOT_1";
    } else {
      // CHECK PREVIOUS ORDER OUTSTANDING AMOUNT
      String valiOutStandingAmt = String.valueOf(orderRegisterMapper.selectOutstandingAmt(getOldOrderID));
      if (!"".equals(CommonUtils.nvl(valiOutStandingAmt))) {
        msg = msg + " -Not allowed for Pre Booking with Outstanding amount. <br/>";
        isInValid = "InValid";
        ROOT_STATE = "ROOT_4";
      }
      // CHECK OUTRIGHT SVM ACTIVE QUOTATION
      params.put("ORD_NO", (String) params.get("salesOrdNo"));
      List<EgovMap> quotationInfo = membershipQuotationMapper.mActiveQuoOrder(params);
      if(!quotationInfo.isEmpty()){
        msg = msg + " -Not allowed for Pre Booking with Active Membership Quotation. <br/>";
        isInValid = "InValid";
        ROOT_STATE = "ROOT_4";
      }
    }

    RESULT.put("ROOT_STATE", ROOT_STATE);
    RESULT.put("IS_IN_VALID", isInValid);
    RESULT.put("MSG", msg);
    RESULT.put("OLD_ORDER_ID", getOldOrderID);
    RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);
    RESULT.put("EXTR_OPT_FLAG", extradeWoutPRCnt);

    return RESULT;
  }

  @Override
  public EgovMap selectHcPreBookingOrderInfo(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectHcPreBookingOrderInfo(params);
  }

  @Override
  public EgovMap selectPreBookOrderEligibleInfo(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectPreBookOrderEligibleInfo(params);
  }

  @Override
  public EgovMap selectPreBookOrderEligibleCheck(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectPreBookOrderEligibleCheck(params);
  }

  @Override
  public int updateHcPreBookOrderCancel(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    int rtnCnt = 0;
    try {
      params.put("updUserId", sessionVO.getUserId());
      params.put("stusId", SalesConstants.STATUS_CANCELLED);
      params.put("custVerifyStus", "N");
      // UPDATE PRE-BOOK STATUS - SAL0404M - STUS_ID
      rtnCnt = hcPreBookingOrderMapper.updateHcPreBookOrderStatus(params);
      if (rtnCnt <= 0) { // not updated
        throw new ApplicationException(AppConstants.FAIL, "Pre-Booking Update Failed.");
      }
    } catch (Exception e) {
      throw new ApplicationException(AppConstants.FAIL, "Pre-Booking Update Failed.");
    }
    return rtnCnt;
  }

  @Override
  public List<EgovMap> selectPreBookOrderCancelStatus(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectPreBookOrderCancelStatus(params);
  }

  @Override
  public EgovMap checkPreBookSalesPerson(Map<String, Object> params) {

    params.put("module", "HOMECARE");
    params.put("subModule", "PRE_BOOK");
    params.put("paramCode", "MEM_TYPE");

    // SYS0098M - PRE_BOOK - MEM_TYPE
    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
    if (!memType.isEmpty()) {
      params.put("memType", memType);
    }
    return hcPreBookingOrderMapper.selectPreBookSalesPerson(params);
  }

  @Override
  public EgovMap checkPreBookConfigurationPerson(Map<String, Object> params) {

    params.put("module", "HOMECARE");
    params.put("subModule", "PRE_BOOK");
    params.put("paramCode", "MEM_TYPE");

    // SYS0098M - PRE_BOOK - MEM_TYPE
    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
    if (!memType.isEmpty()) {
      params.put("memType", memType);
    }
    return hcPreBookingOrderMapper.selectPreBookConfigurationPerson(params);
  }

  @Override
  public EgovMap selectPreBookOrdDtlWA(Map<String, Object> params) {
    return hcPreBookingOrderMapper.selectPreBookOrdDtlWA(params);
  }
}
