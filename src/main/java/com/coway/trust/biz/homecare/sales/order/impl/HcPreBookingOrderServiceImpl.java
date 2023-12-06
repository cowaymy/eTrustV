package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.SmsMapper;
import com.coway.trust.biz.homecare.sales.impl.htOrderRegisterMapper;
import com.coway.trust.biz.homecare.sales.order.HcPreBookingOrderService;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
//import com.coway.trust.biz.sales.order.impl.PreBookingOrderMapper;
import com.coway.trust.biz.sales.order.impl.PreOrderServiceImpl;
// import com.coway.trust.biz.sales.order.impl.PreBookingOrderMapper;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
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

/*  @Resource(name = "preBookingOrderMapper")
  private PreBookingOrderMapper preBookingOrderMapper;
*/
  @Resource(name = "hcOrderRegisterMapper")
  private HcOrderRegisterMapper hcOrderRegisterMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "htOrderRegisterMapper")
  private htOrderRegisterMapper htOrderRegisterMapper;

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Autowired
  private SmsMapper smsMapper;

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
      Calendar calNow = Calendar.getInstance();
      Calendar calExt = Calendar.getInstance();
      int discWaive;
      if (GetExpDate != null) {
        Date srvPrdExprDt = (Date) GetExpDate.get("srvPrdExprDt");
        calExt.setTime(srvPrdExprDt);

        int nowMonth = calNow.get(Calendar.YEAR) * 12 + calNow.get(Calendar.MONTH);
        int expMonth = calExt.get(Calendar.YEAR) * 12 + calExt.get(Calendar.MONTH);
        // CALCULATE PROMOTION DISCOUNT ENTITLEMENT = LAST EXPIRED MONTH - CURRENT PRE-BOOK MONTH
        discWaive = expMonth - nowMonth;

        logger.info("!@#### nowMonth:" + nowMonth);
        logger.info("!@#### expMonth:" + expMonth);
        logger.info("!@#### discWaive:" + discWaive);

      } else {
        discWaive = 0;
      }

      // GET PRE BOOKING ORDER NO
      String preBookingOrdNo = "";
      preBookingOrdNo = htOrderRegisterMapper.selectDocNo(195);
      preBookingOrderVO.setPreBookOrdNo(preBookingOrdNo);
      preBookingOrderVO.setCrtUserId(sessionVO.getUserId());
      preBookingOrderVO.setUpdUserId(sessionVO.getUserId());
      preBookingOrderVO.setDiscWaive(discWaive);
      preBookingOrderVO.setCustVerifyStus(SalesConstants.STATUS_CODE_NAME_ACT); // Default ACT
      preBookingOrderVO.setStusId(SalesConstants.STATUS_ACTIVE); // Default ACT

      // INSERT INTO PRE-BOOK MASTER TABLE - SAL0404M
      hcPreBookingOrderMapper.insertPreBookingOrder(preBookingOrderVO);

      Map<String, Object> smsEntry = new HashMap<String, Object>();

      String smsMessage = "RM0 COWAY: Order No. " + preBookingOrderVO.getSalesOrdNoOld()
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
      smsEntry.put("smsStusId",1);
      smsEntry.put("smsRetry",0);
      smsEntry.put("userId",sessionVO.getUserId());
      smsEntry.put("smsVendorId",1);

      // INSERT INTO SMS TABLE - MSC0015D
      smsMapper.insertSmsEntry(smsEntry);

      /*Map<String, Object> smsReply = new HashMap<String, Object>();

      smsReply.put("replyCode", "");
      smsReply.put("replyRem", "");
      smsReply.put("userId", sessionVO.getUserId());
      smsReply.put("replyFdbckId", "");

      smsMapper.insertGatewayReply(smsReply);*/


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
      // CHECK PREVIOUS ORDER RENTAL OUTSTANDING AMOUNT
      String valiOutStandingAmt = String.valueOf(orderRegisterMapper.selectRentAmt(getOldOrderID));

      if ("".equals(CommonUtils.nvl(valiOutStandingAmt))) {
        msg = msg + " -Not allowed for Pre Booking (Rental bill not found). <br/>";
        isInValid = "InValid";
        ROOT_STATE = "ROOT_4";
      } else {
        BigDecimal valiOutStanding = new BigDecimal(valiOutStandingAmt);
        valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
        if (valiOutStanding.compareTo(BigDecimal.ZERO) > 0) {
          msg = msg + " -Not allowed for Pre Booking with Outstanding amount. <br/>";
          isInValid = "InValid";
          ROOT_STATE = "ROOT_4";
        }
      }

/*      // CHECK PRE BOOK CONDITION
      EgovMap ValiRentInstNo = orderRegisterMapper.selectAccRentLedgers(getOldOrderID);
      EgovMap rentalPrd = orderRegisterMapper.getRentalPeriod(getOldOrderID);

      if (ValiRentInstNo == null) {
        msg = msg + " -Not allowed for Pre Booking (Rental bill not found). <br/>";
        isInValid = "InValid";
        ROOT_STATE = "ROOT_4";
      } else {
        int rentalContractPeriod = Integer.parseInt(String.valueOf(rentalPrd.get("cntrctRentalPriod")));
        int rentalInstPeriod = Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo")));
        // RENTAL CONTRACT PERIOD - RENT INST PERIOD (WITHIN 4 MONTHS ONLY ALLOW PRE-BOOK)
        int allowToPreBook = rentalContractPeriod - rentalInstPeriod;

        if (allowToPreBook > 4) {
          msg = msg + " -Not allowed for Pre Booking with Pre Book Condition. <br/>";
          isInValid = "InValid";
          ROOT_STATE = "ROOT_4";
        }
      }*/

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
  public EgovMap selectPreBookOrderVerifyStus(Map<String, Object> params) throws Exception {
    return hcPreBookingOrderMapper.selectPreBookOrderVerifyStus(params);
  }

  @Override
  public int updateHcPreBookOrderCancel(Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {
    int rtnCnt = 0;
    try {
      params.put("updUserId",sessionVO.getUserId());
      params.put("stusId",SalesConstants.STATUS_CANCELLED);
      // UPDATE PRE-BOOK STATUS - SAL0404M - STUS_ID
      rtnCnt = hcPreBookingOrderMapper.updateHcPreBookOrderCancel(params);
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

    //SYS0098M - PRE_BOOK - MEM_TYPE
    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
    if(!memType.isEmpty()){
    params.put("memType", memType);
    }
    return hcPreBookingOrderMapper.selectPreBookSalesPerson(params);
  }

  @Override
  public EgovMap checkPreBookConfigurationPerson(Map<String, Object> params) {

    params.put("module", "HOMECARE");
    params.put("subModule", "PRE_BOOK");
    params.put("paramCode", "MEM_TYPE");

    //SYS0098M - PRE_BOOK - MEM_TYPE
    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
    if(!memType.isEmpty()){
    params.put("memType", memType);
    }
    return hcPreBookingOrderMapper.selectPreBookConfigurationPerson(params);
  }

}
