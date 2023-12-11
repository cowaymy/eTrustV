/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.PreBookingOrderService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.SmsMapper;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.impl.PreBookingOrderMapper;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("preBookingOrderService")
public class PreBookingOrderServiceImpl extends EgovAbstractServiceImpl implements PreBookingOrderService {

	private static Logger logger = LoggerFactory.getLogger(PreBookingOrderServiceImpl.class);

	@Resource(name = "preBookingOrderMapper")
  private PreBookingOrderMapper preBookingOrderMapper;

	@Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "orderLedgerMapper")
	 private OrderLedgerMapper orderLedgerMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

	@Autowired
  private SmsMapper smsMapper;

	@Autowired
	private AdaptorService adaptorService;

 @Override
  public List<EgovMap> selectPreBookingOrderList(Map<String, Object> params) {
    return preBookingOrderMapper.selectPreBookingOrderList(params);
  }

  @Override
  public EgovMap selectPreBookOrderVerifyStus(Map<String, Object> params) throws Exception {
    return preBookingOrderMapper.selectPreBookOrderVerifyStus(params);
  }

	@Override
  public List<EgovMap> selectPrevOrderNoList(Map<String, Object> params) {
    return preBookingOrderMapper.selectPrevOrderNoList(params);
  }

	@Override
	public EgovMap checkOldOrderId(Map<String, Object> params){
	  logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] START");
	  EgovMap RESULT = new EgovMap();
    int getOldOrderID = 0;
    int extradeWoutPRCnt = 0;
    String ROOT_STATE = "";
    String isInValid = "";
    String msg = "";
    String txtInstSpecialInstruction = "";

    // GET PREVIOUS ORDER INFO
    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));
    logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] ordInfo :: {} " + ordInfo);

    if (ordInfo != null) {
      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
    }

    if ("0".equals(getOldOrderID)) {
      ROOT_STATE = "ROOT_1";
    } else {
      // CHECK PREVIOUS ORDER RENTAL OUTSTANDING AMOUNT
      String valiOutStandingAmt = String.valueOf(orderRegisterMapper.selectRentAmt(getOldOrderID));
      logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] valiOutStandingAmt :: {} " + valiOutStandingAmt);

      if ("".equals(CommonUtils.nvl(valiOutStandingAmt))) {
        msg = msg + " -Not allowed for Pre Booking (Rental bill not found). <br/>";
        isInValid = "InValid";
        ROOT_STATE = "ROOT_4";
      } else {
        logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] valiOutStandingAmt != empty or null ");
        BigDecimal valiOutStanding = new BigDecimal(valiOutStandingAmt);
        valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

        logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] valiOutStanding :: " + valiOutStanding);
        if (valiOutStanding.compareTo(BigDecimal.ZERO) > 0) {
          msg = msg + " -Not allowed for Pre Booking with Outstanding amount. <br/>";
          isInValid = "InValid";
          ROOT_STATE = "ROOT_4";
        }
      }
    }
    logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] getOldOrderID :: " + getOldOrderID);
    RESULT.put("ROOT_STATE", ROOT_STATE);
    RESULT.put("IS_IN_VALID", isInValid);
    RESULT.put("MSG", msg);
    RESULT.put("OLD_ORDER_ID", getOldOrderID);
    RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);
    RESULT.put("EXTR_OPT_FLAG", extradeWoutPRCnt);

    logger.info("[PreBookingOrderServiceImpl - checkOldOrderId] END");
	  return RESULT;
	}

	@Override
  public void insertPreBooking(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO){
     try{
	      logger.info("[PreBookingOrderServiceImpl - insertPreBooking] START!!");
	      logger.info("[PreBookingOrderServiceImpl - insertPreBooking] preBookingOrderVO :: {} " + preBookingOrderVO);

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

	        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] nowMonth :: " + nowMonth);
	        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] expMonth :: " + expMonth);
	        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] discWaive :: " + discWaive);
	      } else{
	        discWaive = 0;
	      }

	      String preBookingNo = preBookingOrderMapper.selectNextPreBookingNo();
	      logger.info("[PreBookingOrderServiceImpl - insertPreBooking] - preBookingNo :: {}" +preBookingNo);

	      Map<String, Object> docNoList = new HashMap();
        String docNo = preBookingNo.substring(2);
        docNoList.put("preBookingNo",docNo);
        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] - docNoList :: {}" +docNoList);

        preBookingOrderMapper.updatePreBookingNo(docNoList);

	      preBookingOrderVO.setPreBookOrdNo(preBookingNo);
	      preBookingOrderVO.setCrtUserId(sessionVO.getUserId());
	      preBookingOrderVO.setUpdUserId(sessionVO.getUserId());
	      preBookingOrderVO.setDiscWaive(discWaive);
	      preBookingOrderVO.setCustVerifyStus(SalesConstants.STATUS_CODE_NAME_ACT); // Default ACT
	      preBookingOrderVO.setStusId(SalesConstants.STATUS_ACTIVE); // Default ACT
	      logger.info("[PreBookingOrderServiceImpl - insertPreBooking] - preBookingOrderVO.getPreBookOrdNo() :: {}" +preBookingOrderVO.getPreBookOrdNo());
	       // INSERT INTO PRE-BOOK MASTER TABLE - SAL0404M
	      preBookingOrderMapper.insertPreBooking(preBookingOrderVO);

	      Map<String, Object> smsList = new HashMap<String, Object>();

        Map<String, Object> smsOrdAreaMemInfoList = new HashMap();
        smsOrdAreaMemInfoList = preBookingOrderMapper.getOrdAreaMemInfo(preBookingOrderVO.getSalesOrdIdOld());

        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] - smsOrdAreaMemInfoList :: {}" +smsOrdAreaMemInfoList);

        String smsMessage = "RM0 COWAY: Order No. " + preBookingOrderVO.getSalesOrdNoOld()
                                        + " of postcode " +  smsOrdAreaMemInfoList.get("postcode")
                                        + " agree for ex-Trade Pre Booking under " + preBookingOrderVO.getMemCode()
                                        + ". To agree reply COWAYPREBOOK "+ preBookingOrderVO.getSalesOrdNoOld()
                                        + " to 8794567 within 3 days.TQ.";

        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] customer contact number :: {} " + preBookingOrderVO.getCustContactNumber());

        SmsVO sms = new SmsVO(sessionVO.getUserId(), 976);
        sms.setMessage(smsMessage);
        sms.setMobile((String) preBookingOrderVO.getCustContactNumber());
        sms.setSmsType(1);
        sms.setPriority(1);
        sms.setRemark("Pre-Booking SMS via e-trust");
        sms.setExpireDayAdd(Integer.parseInt(CommonUtils.getCalDate(3).toString()));
        sms.setRetryNo(0);
        sms.setUserId(sessionVO.getUserId());
        SmsResult smsResult = adaptorService.sendSMS4(sms);

        // Update customer marketing message status(universal between HC/HA)
        Map<String, Object> params1 = new HashMap();
        params1.put("custId", preBookingOrderVO.getCustId());
        params1.put("updUserId", sessionVO.getUserId());
        params1.put("receivingMarketingMsgStatus", preBookingOrderVO.getReceivingMarketingMsgStatus());
        orderRegisterMapper.updateMarketingMessageStatus(params1);

        logger.info("[PreBookingOrderServiceImpl - insertPreBooking] END !!");
     }catch(Exception e){
       throw new ApplicationException(AppConstants.FAIL,"Pre Booking Order Register Failed.");
     }
  }

	  public EgovMap selectPreBookingOrderInfo(Map<String, Object> params) {
	    return preBookingOrderMapper.selectPreBookingOrderInfo(params);
	  }

	  @Override
	  public int updatePreBookOrderCancel(Map<String, Object> params, SessionVO sessionVO)
	      throws ParseException {
	    int rtnCnt = 0;
	    try {
	      params.put("updUserId",sessionVO.getUserId());
	      params.put("stusId",SalesConstants.STATUS_CANCELLED);
	      // UPDATE PRE-BOOK STATUS - SAL0404M - STUS_ID
	      rtnCnt = preBookingOrderMapper.updatePreBookOrderCancel(params);
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
	    return preBookingOrderMapper.selectPreBookOrderCancelStatus(params);
	  }


	  @Override
	  public EgovMap checkPreBookSalesPerson(Map<String, Object> params) {

	    params.put("module", "SALES");
	    params.put("subModule", "PRE_BOOK");
	    params.put("paramCode", "MEM_TYPE");

	    //SYS0098M - PRE_BOOK - MEM_TYPE
	    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
	    if(!memType.isEmpty()){
	    params.put("memType", memType);
	    }
	    return preBookingOrderMapper.selectPreBookSalesPerson(params);
	  }

	  @Override
	  public EgovMap checkPreBookConfigurationPerson(Map<String, Object> params) {

	    params.put("module", "SALES");
	    params.put("subModule", "PRE_BOOK");
	    params.put("paramCode", "MEM_TYPE");

	    //SYS0098M - PRE_BOOK - MEM_TYPE
	    List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
	    if(!memType.isEmpty()){
	    params.put("memType", memType);
	    }
	    return preBookingOrderMapper.selectPreBookConfigurationPerson(params);
	  }


}
