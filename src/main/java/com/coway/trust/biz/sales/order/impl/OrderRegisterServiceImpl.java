/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.math.*;
import java.io.*;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.impl.EcommApiMapper;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.homecare.sales.order.impl.HcPreBookingOrderMapper;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.vo.ASEntryVO;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CcpDecisionMVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigSettingVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigurationVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderRegisterService")
public class OrderRegisterServiceImpl extends EgovAbstractServiceImpl implements OrderRegisterService {

  private static Logger logger = LoggerFactory.getLogger(OrderRegisterServiceImpl.class);

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "orderRequestMapper")
  private OrderRequestMapper orderRequestMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "preOrderMapper")
  private PreOrderMapper preOrderMapper;

  @Resource(name = "EcommApiMapper")
  private EcommApiMapper ecommApiMapper;

  @Resource(name = "orderLedgerMapper")
  private OrderLedgerMapper orderLedgerMapper;

  @Resource(name = "hcPreBookingOrderMapper")
  private HcPreBookingOrderMapper hcPreBookingOrderMapper;

  @Resource(name = "voucherMapper")
  private VoucherMapper voucherMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  @Override
  public EgovMap selectSrvCntcInfo(Map<String, Object> params) {

    EgovMap custAddInfo = orderRegisterMapper.selectSrvCntcInfo(params);

    return custAddInfo;
  }

  @Override
  public EgovMap selectStockPrice(Map<String, Object> params) {

    EgovMap priceInfo = orderRegisterMapper.selectStockPrice(params);

    BigDecimal orderPrice, orderPV, orderRentalFees;

    if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer.parseInt(String.valueOf(params.get("appTypeId")))) {
      // orderPrice = "₩" +
      // ((BigDecimal)priceInfo.get("rentalDeposit")).toString();
      // orderPV = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
      // orderRentalFees = "₩" +
      // ((BigDecimal)priceInfo.get("monthlyRental")).toString();
      orderPrice = (BigDecimal) priceInfo.get("rentalDeposit");
      orderPV = (BigDecimal) priceInfo.get("pv");
      orderRentalFees = (BigDecimal) priceInfo.get("monthlyRental");
    } else {
      // orderPrice = "₩" +
      // ((BigDecimal)priceInfo.get("normalPrice")).toString();
      // orderPV = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
      orderPrice = (BigDecimal) priceInfo.get("normalPrice");
      orderPV = (BigDecimal) priceInfo.get("pv");
      orderRentalFees = BigDecimal.ZERO;
    }

    priceInfo.put("orderPrice", new DecimalFormat("0.00").format(orderPrice));
    priceInfo.put("orderPV", new DecimalFormat("0.00").format(orderPV));
    priceInfo.put("orderRentalFees", new DecimalFormat("0.00").format(orderRentalFees));

    return priceInfo;
  }

  @Override
  public List<EgovMap> selectDocSubmissionList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return orderRegisterMapper.selectDocSubmissionList(params);
  }

  @Override
  public List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params) {
    // TODO Auto-generated method stub

    params.put("appTypeId", CommonUtils.changePromoAppTypeId(Integer.parseInt((String) params.get("appTypeId"))));

    return orderRegisterMapper.selectPromotionByAppTypeStock(params);
  }

  @Override
  public List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params) {
    // TODO Auto-generated method stub

    int apptypeid = Integer.parseInt((String) params.get("appTypeId"));

    if (apptypeid == 145) {
      params.put("appTypeId", apptypeid);

    } else {
      params.put("appTypeId", CommonUtils.changePromoAppTypeId(Integer.parseInt((String) params.get("appTypeId"))));
    }
    return orderRegisterMapper.selectPromotionByAppTypeStock2(params);
  }

  @Override
  public List<EgovMap> selectPromotionByAppTypeStockESales(Map<String, Object> params) {
    // TODO Auto-generated method stub

    params.put("appTypeId", CommonUtils.changePromoAppTypeId(CommonUtils.intNvl(params.get("appTypeId"))));

    return orderRegisterMapper.selectPromotionByAppTypeStockESales(params);
  }


@Override
  public EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params) {

    BigDecimal orderPricePromo = BigDecimal.ZERO, orderPVPromo = BigDecimal.ZERO, orderPVPromoGST = BigDecimal.ZERO,
        orderRentalFeesPromo = BigDecimal.ZERO, normalRentalFees = BigDecimal.ZERO;
    logger.info("@@@@@@@@@@@@@@@@@@@@@@:: " + params.toString());
    EgovMap priceInfo = null;
    EgovMap priceAnoStkIdInfo= null;

    int srvPacId = CommonUtils.intNvl(params.get("srvPacId"));
    int promoId = CommonUtils.intNvl(params.get("promoId"));
    int stkId = CommonUtils.intNvl(params.get("stkId"));
    int ordAppType =  CommonUtils.intNvl(params.get("orderAppType"));
    String anoStkId = orderRequestMapper.selectAnoStkIDWithBundleID(params);


    if (!StringUtils.isEmpty(params.get("promoId"))) {

      EgovMap promoMap = orderRegisterMapper.selectPromoDesc(Integer.parseInt((String) params.get("promoId")));

      int isNew = CommonUtils.intNvl(promoMap.get("isNew"));

      if (isNew == 1) {
        if (srvPacId == 4) {
          priceInfo = orderRegisterMapper.selectProductPromotionPriceByPromoStockIDNewCorp(params); // New                                                                 // Data(2018.01.01~)
        } else {
          priceInfo = orderRegisterMapper.selectProductPromotionPriceByPromoStockIDNew(params); // New

          if(anoStkId !=null){
        	  params.put("anoStkId", anoStkId);
              priceAnoStkIdInfo = orderRegisterMapper.selectProductPromotionPriceByPromoAnoStockIDNew(params);
          }
        }

        if (priceInfo != null) {
          if (SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer
              .parseInt(String.valueOf((BigDecimal) priceInfo.get("promoAppTypeId")))) { // Rental

        	 orderPricePromo = (BigDecimal) priceInfo.get("promoPrcRpf");

            orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
            orderPVPromoGST = (BigDecimal) priceInfo.get("promoItmPvGst");
            orderRentalFeesPromo = (BigDecimal) priceInfo.get("promoAmt");

            normalRentalFees = (BigDecimal) priceInfo.get("amt");
          } else {

            if (promoId == 31834 && stkId == 892 && srvPacId == 0) {
              orderPricePromo = BigDecimal.valueOf(3540);
            } else {
              orderPricePromo = (BigDecimal) priceInfo.get("promoAmt");

              if (priceInfo != null &&priceAnoStkIdInfo!=null) {
              	BigDecimal b1, b2;
              	 b1 =(BigDecimal) priceInfo.get("promoAmt") ;
                 b2 = (BigDecimal) priceAnoStkIdInfo.get("promoAmt") ;
                 int SumPrice = b1.intValue()+b2.intValue();
                 orderPricePromo = BigDecimal.valueOf(SumPrice);
              }
              else{
            	    orderPricePromo = (BigDecimal) priceInfo.get("promoAmt");
              }
            }
            orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
            orderPVPromoGST = (BigDecimal) priceInfo.get("promoItmPvGst");
            orderRentalFeesPromo = BigDecimal.ZERO;

            normalRentalFees = BigDecimal.ZERO;
          }

          priceInfo.put("orderPricePromo", new DecimalFormat("0.00").format(orderPricePromo));
          priceInfo.put("orderPVPromo", new DecimalFormat("0.00").format(orderPVPromo));
          priceInfo.put("orderPVPromoGST", new DecimalFormat("0.00").format(orderPVPromoGST));
          priceInfo.put("orderRentalFeesPromo", new DecimalFormat("0.00").format(orderRentalFeesPromo));
          priceInfo.put("promoDiscPeriodTp", promoMap.get("promoDiscPeriodTp"));
          priceInfo.put("promoDiscPeriod", promoMap.get("promoDiscPeriod"));
          priceInfo.put("normalRentalFees", new DecimalFormat("0.00").format(normalRentalFees));

        } else {


        	// App Type == AUX & EDU
        	if(ordAppType == SalesConstants.APP_TYPE_CODE_ID_AUX || ordAppType == SalesConstants.APP_TYPE_CODE_ID_EDUCATION ) {
        		priceInfo = new EgovMap();
        	   	 logger.info("0000000");
        		priceInfo.put("orderPricePromo", "0.00");
                priceInfo.put("orderPVPromo", "0.00");
                priceInfo.put("orderPVPromoGST", "0.00");
                priceInfo.put("orderRentalFeesPromo", "0.00");
                priceInfo.put("promoDiscPeriodTp", "");
                priceInfo.put("promoDiscPeriod", "");
                priceInfo.put("normalRentalFees", "0.00");
        	}
        }
      } else {
        priceInfo = orderRegisterMapper.selectProductPromotionPriceByPromoStockID(params); // AS-IS
                                                                                           // Data(~2017.12.31)

        if (priceInfo != null) {

      	orderPricePromo = (BigDecimal) priceInfo.get("promoItmPrc");

          orderPVPromo = (BigDecimal) priceInfo.get("promoItmPv");
          orderRentalFeesPromo = ((BigDecimal) priceInfo.get("promoItmRental")).compareTo(BigDecimal.ZERO) > 0
              ? (BigDecimal) priceInfo.get("promoItmRental") : BigDecimal.ZERO;

          priceInfo.put("orderPricePromo", new DecimalFormat("0.00").format(orderPricePromo));
          priceInfo.put("orderPVPromo", new DecimalFormat("0.00").format(orderPVPromo));
          priceInfo.put("orderRentalFeesPromo", new DecimalFormat("0.00").format(orderRentalFeesPromo));
          priceInfo.put("promoDiscPeriodTp", promoMap.get("promoDiscPeriodTp"));
          priceInfo.put("promoDiscPeriod", promoMap.get("promoDiscPeriod"));
          priceInfo.put("normalPricePromo", new DecimalFormat("0.00").format(normalRentalFees));
        }
      }
    }

    return priceInfo;
  }

  @Override
  public EgovMap selectOldOrderId(Map<String, Object> params) {
    return orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));
  }

  @Override
  public EgovMap checkOldOrderId(Map<String, Object> params) {

    int getOldOrderID = 0;
    int custId = 0, promoId = 0 ,extradeWoutPRCnt =0;
    String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";
    String monthExpired = "";
    String preBook = "";

    logger.info("!@#### custId:" + (String) params.get("custId"));
    logger.info("!@#### salesOrdNo:" + (String) params.get("salesOrdNo"));

    custId = Integer.parseInt((String) params.get("custId"));
    promoId = Integer.parseInt((String) params.get("promoId"));

    EgovMap RESULT = new EgovMap();
    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

    if (ordInfo != null) {
      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
    }

    EgovMap GetExpDate = orderRegisterMapper.selectSvcExpire(getOldOrderID);

    if (getOldOrderID <= 0) {
      ROOT_STATE = "ROOT_1";
    } else {

    //Check for Pre-booking
      params.put("custId", custId);
      params.put("salesOrdIdOld", getOldOrderID);
      EgovMap preBookInfo = hcPreBookingOrderMapper.selectPreBookOrderEligibleCheck(params);

      if(preBookInfo != null){
        preBook = "1";
      }else{
        preBook = "0";
      }

      if (this.isVerifyOldSalesOrderNoValidity(getOldOrderID)) {

        // EgovMap resultMap = this.selectSalesOrderM(getOldOrderID,
        // SalesConstants.APP_TYPE_CODE_ID_SERVICE); // 2018-09-13 - Disabled
        // extrade for Education and Free Trial
        EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
        EgovMap promoMap = orderRegisterMapper.selectPromoDesc(promoId);

        String appTypId = "";
        if (resultMap != null)
          appTypId = resultMap.get("appTypeId").toString();

        // if(resultMap != null) {
        // //if(so.VerifyOldSalesOrderNotServiceType(getOldOrderID)
        if ("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 -
                                                                // Disabled
                                                                // extrade for
                                                                // Education and
                                                                // Free Trial
          ROOT_STATE = "ROOT_2";
        }
        // }
        else {
          if (GetExpDate == null) {
            ROOT_STATE = "ROOT_3";
          } else {
            monthExpired = GetExpDate.get("monthExpired").toString();
            msg = "-SVM End Date : <b>" + (String) GetExpDate.get("srvPrdExprDtMmyy") + "</b> <br/>";

//            if(!"Y".equals(GetExpDate.get("extradeAllowFlg").toString())) {
//            	//svm expired within one month, just able to do extrade, else block.
//                logger.debug("@####:InValid");
//                isInValid = "InValid";
//                ROOT_STATE = "ROOT_3";
//            } else {
                logger.debug("@####:not InValid");

                EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

                // Renatal
                if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer
                    .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

                  if (this.isVerifyOldSalesOrderRentalScheme(getOldOrderID, 0)) { // chia
                                                                                  // chia
                                                                                  // --18/01/2016
                                                                                  // --ex-trade
                                                                                  // only
                                                                                  // allow
                                                                                  // rental
                                                                                  // status
                                                                                  // REG
                                                                                  // ||
                                                                                  // INV
                                                                                  // ||
                                                                                  // SUS

                    BigDecimal valiOutStanding = (BigDecimal) orderRegisterMapper.selectRentAmt(getOldOrderID);
                    valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

                    if (valiOutStanding.compareTo(BigDecimal.ZERO) > 0) {
                      msg = msg + " -With Outstanding payment not allowed for Ex-Trade promo. <br/>";
                      isInValid = "InValid";
                    }

//                    EgovMap ValiRentInstNo = orderRegisterMapper.selectAccRentLedgers(getOldOrderID);

//                    EgovMap exTradeConfig = orderRegisterMapper.getExTradeConfig();
//                    int exTrade_mth = Integer.parseInt(String.valueOf(exTradeConfig.get("exTradeMth")));

                	//** Start exTrade Neo to Neo Plus **//
//                    if((params.get("prodId").toString()).equals(exTradeConfig.get("exTradeNeoPlusId").toString()) &&
//                    	(params.get("stkId").toString()).equals(exTradeConfig.get("exTradeNeoId").toString())){
//                    	if(Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) < exTrade_dur){
//                    		  msg = msg + " -Below "+ exTrade_dur +" months not allowed to entitle Ex-Trade Promo. <br/>";
//                              isInValid = "InValid";
//                    	}
//                    } else{
//                        if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) < 57) { // Ex-Trade
//                                                                                                       // can
//                                                                                                       // be
//                                                                                                       // done
//                                                                                                       // 4
//                                                                                                       // month
//                                                                                                       // early
//                          msg = msg + " -Below 57th months not allowed to entitle Ex-Trade Promo. <br/>";
//                          isInValid = "InValid";
//                        }
//                    }
                	//** End exTrade Neo to Neo Plus **//

//                    EgovMap rentalPrd = orderRegisterMapper.getRentalPeriod(getOldOrderID);
//                    int rentalPeriod = Integer.parseInt(String.valueOf(rentalPrd.get("cntrctRentalPriod")));

//                    int allowToExTrade = rentalPeriod - exTrade_mth;

                    /*if(Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) < allowToExTrade){
                    	   msg = msg + " -Not allow early ex-trade before end of contract. <br/>";
                           isInValid = "InValid";
                    }*/

                    if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
                      msg = msg + " -Different Customer is not allowed.";
                      isInValid = "InValid";
                    }

                    //special - extrade whether need product return
                    //old order which fall under rental type, 60-66 months after starter package and AP type.
                    extradeWoutPRCnt = orderRegisterMapper.chkCanExtradeWoutPR(getOldOrderID);

                    ROOT_STATE = "ROOT_4";

                    txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
                        + (String) (promoMap != null ? promoMap.get("promoDesc") : "NO PROMOTION")
                        + " , SVM expired : "+ (String) GetExpDate.get("srvPrdExprDtMmyy");
                  } else {
                    ROOT_STATE = "ROOT_5";
                  }
                } else if (SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer
                    .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
                    || SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer
                        .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { // outright,Installment

                		msg = "-SVM End Date : <b>" + (String) GetExpDate.get("srvPrdExprDtMmyy") + "</b>  SVM Expired Date : <b>"
                            + (String) GetExpDate.get("srvPrdExprDtMmyyAdd") + "</b> <br/>";

                        if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
                          msg = msg + " -Different Customer is not allowed.";
                          isInValid = "InValid";
                        }

                        ROOT_STATE = "ROOT_6";

                        txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
                                + (String) (promoMap != null ? promoMap.get("promoDesc") : "NO PROMOTION")
                                + " , SVM expired : " + (String) GetExpDate.get("srvPrdExprDtMmyy");
                } else {
                  ROOT_STATE = "ROOT_7";

                  txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
                      + (String) (promoMap != null ? promoMap.get("promoDesc") : "NO PROMOTION")
                      + " , SVM expired : "+ (String) GetExpDate.get("srvPrdExprDtMmyy");

                }
            //}
          }
        }
      } else {
        ROOT_STATE = "ROOT_8";
      }
    }

    RESULT.put("ROOT_STATE", ROOT_STATE);
    RESULT.put("IS_IN_VALID", isInValid);
    RESULT.put("MSG", msg);
    RESULT.put("OLD_ORDER_ID", getOldOrderID);
    RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);
    RESULT.put("EXTR_OPT_FLAG", extradeWoutPRCnt);
    RESULT.put("MONTH_EXPIRED", monthExpired);
    RESULT.put("PRE_BOOK", preBook);

    return RESULT;
  }

  @Override
  public EgovMap checkOldOrderIdICare(Map<String, Object> params) {

    int getOldOrderID = 0;
    int custId = 0, promoId = 0;
    String ROOT_STATE = "", isInValid = "", msg = "", txtInstSpecialInstruction = "";

    logger.info("!@#### custId:" + (String) params.get("custId"));
    logger.info("!@#### salesOrdNo:" + (String) params.get("salesOrdNo"));
    logger.info("!@#### all params :" + (String) params.toString());

    custId = Integer.parseInt((String) params.get("custId"));
    promoId = Integer.parseInt((String) params.get("promoId"));

    EgovMap RESULT = new EgovMap();
    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

    if (ordInfo != null) {
      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
    }

    if (getOldOrderID <= 0) {
      ROOT_STATE = "ROOT_1";
    } else {
      if (this.isVerifyOldSalesOrderNoValidityICare(getOldOrderID)) {

        EgovMap resultMap = this.selectSalesOrderM(getOldOrderID, 0);
        EgovMap promoMap = orderRegisterMapper.selectPromoDesc(promoId);

        String appTypId = "";
        if (resultMap != null)
          appTypId = resultMap.get("appTypeId").toString();

        if ("144".equals(appTypId) || "145".equals(appTypId)) { // 2018-09-13 -
                                                                // Disabled
                                                                // extrade for
                                                                // Education and
                                                                // Free Trial
          ROOT_STATE = "ROOT_2";
        }

        else {
          EgovMap validateRentOutright = this.selectSalesOrderM(getOldOrderID, 0);

          // Renatal
          if (SalesConstants.APP_TYPE_CODE_ID_RENTAL == Integer
              .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) {

            if (this.isVerifyOldSalesOrderRentalScheme(getOldOrderID, 1)) { // Kit
                                                                            // --ex-trade
                                                                            // only
                                                                            // allow
                                                                            // rental
                                                                            // status
                                                                            // REG

              params.put("ordId", getOldOrderID);
              orderLedgerMapper.getOderOutsInfo(params);
              EgovMap map = (EgovMap) ((ArrayList) params.get("p1")).get(0);

              BigDecimal valiOutStanding = new BigDecimal((String) map.get("ordOtstndMth"));
              valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

              if (valiOutStanding.compareTo(BigDecimal.ZERO) > 2) {
                msg = msg + " -Outstanding payment more than 2 months not allowed for I-Care promo. <br/>";
                isInValid = "InValid";
              }

              EgovMap ValiRentInstNo = orderRegisterMapper.selectRentalInstNo(getOldOrderID);

              if (ValiRentInstNo != null) {
                if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) <= 6) {
                  msg = msg + " -Below 6th months not allowed to entitle I-Care Promo. <br/>";
                  isInValid = "InValid";
                } else if (Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))) > 60) {
                  msg = msg + " -Above 60th months not allowed to entitle I-Care Promo. <br/>";
                  isInValid = "InValid";
                }
              }

              if (Integer.parseInt(String.valueOf(validateRentOutright.get("typeId"))) != 964) {
                msg = msg + " -Only Individual Customer is allowed.";
                isInValid = "InValid";
              }

              if (custId != Integer.parseInt(String.valueOf(validateRentOutright.get("custId")))) {
                msg = msg + " -Different Customer is not allowed.";
                isInValid = "InValid";
              }

              ROOT_STATE = (isInValid.equals("InValid")) ? "ROOT_9" : "ROOT_7";

              txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
                  + (String) (promoMap != null ? promoMap.get("promoDesc") : "NO PROMOTION");
            } else {
              ROOT_STATE = "ROOT_5";
            }
          } else if (SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT == Integer
              .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))
              || SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT == Integer
                  .parseInt(String.valueOf(validateRentOutright.get("appTypeId")))) { // outright,Installment

            ROOT_STATE = "ROOT_10";
            msg = msg + " -Outright and Installment Order are not eligable for I-Care Programme.<br/>";
            isInValid = "InValid";

          }

          else {
            ROOT_STATE = "ROOT_7";

            txtInstSpecialInstruction = "(Old order No.)" + (String) params.get("salesOrdNo") + " , "
                + (String) (promoMap != null ? promoMap.get("promoDesc") : "NO PROMOTION");

          }
        }
      } else {
        ROOT_STATE = "ROOT_8";
      }
    }

    RESULT.put("ROOT_STATE", ROOT_STATE);
    RESULT.put("IS_IN_VALID", isInValid);
    RESULT.put("MSG", msg);
    RESULT.put("OLD_ORDER_ID", getOldOrderID);
    RESULT.put("INST_SPEC_INST", txtInstSpecialInstruction);

    return RESULT;
  }

  private boolean isVerifyOldSalesOrderNoValidity(int getOldOrderID) {
    EgovMap result = orderRegisterMapper.selectVerifyOldSalesOrderNoValidity(getOldOrderID);
    return result == null ? true : false;
  }

  private boolean isVerifyOldSalesOrderNoValidityICare(int getOldOrderID) {
    EgovMap result = orderRegisterMapper.selectVerifyOldSalesOrderNoValidityICare(getOldOrderID);
    return result == null ? true : false;
  }

  private boolean isVerifyOldSalesOrderRentalScheme(int getOldOrderID, int iCare) {
    Map<String, Object> params = new HashMap<String, Object>();

    params.put("value", getOldOrderID);
    params.put("iCare", iCare);

    EgovMap result = orderRegisterMapper.selectSalesOrderRentalScheme(params);
    return result != null ? true : false;
  }

  private EgovMap selectSalesOrderM(int getOldOrderID, int appTypeId) {
    Map<String, Object> params = new HashMap<String, Object>();

    params.put("salesOrdId", getOldOrderID);
    params.put("appTypeId", appTypeId);

    EgovMap result = orderRegisterMapper.selectSalesOrderM(params);

    return result;
  }

  @Override
  public EgovMap selectTrialNo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return orderRegisterMapper.selectTrialNo(params);
  }

  @Override
  public EgovMap selectLoginInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    EgovMap map = new EgovMap();

    map.put("userName", (String) params.get("loginUserName"));
    map.put("userPassWord", (String) params.get("userPassword"));

    return orderRegisterMapper.selectLoginInfo(map);
  }

  @Override
  public EgovMap selectCheckAccessRight(Map<String, Object> params, SessionVO sessionVO) {
    return orderRegisterMapper.selectCheckAccessRight(params);
  }

  @Override
  public EgovMap selectMemberByMemberIDCode(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return orderRegisterMapper.selectMemberByMemberIDCode(params);
  }

  @Override
  public List<EgovMap> selectMemberList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    //params.put("stus", 1);
	logger.debug("@#### params:" + params);
    if ((params.get("status")) != null && (params.get("status")).equals("")) {
      params.put("stus", "");
    } else {
      params.put("stus", 1);
    }
    return orderRegisterMapper.selectMemberList(params);
  }

  @Override
  public EgovMap checkRC(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return orderRegisterMapper.checkRC(params);
  }

  private void preprocSalesOrderMaster(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) {

    salesOrderMVO.setSalesOrdId(0);
    salesOrderMVO.setSalesOrdNo("");
    salesOrderMVO.setBrnchId(sessionVO.getUserBranchId());
    salesOrderMVO.setDscntAmt(BigDecimal.ZERO);
    salesOrderMVO.setTaxAmt(BigDecimal.ZERO);
    salesOrderMVO.setCcPromoId(0);
    salesOrderMVO.setPromoId(salesOrderMVO.getPromoId());
    salesOrderMVO.setPvMonth(0);
    salesOrderMVO.setPvYear(0);
    salesOrderMVO.setStusCodeId(salesOrderMVO.getAppTypeId() == 143 ? 4 : 1);
    salesOrderMVO.setUpdUserId(sessionVO.getUserId());
    salesOrderMVO.setSyncChk(0);
    salesOrderMVO.setRenChkId(salesOrderMVO.getAppTypeId() == 66 ? 122 : 0);
    salesOrderMVO.setInstPriod(salesOrderMVO.getAppTypeId() == 68 ? salesOrderMVO.getInstPriod() : 0);
    salesOrderMVO.setDoNo("");
    salesOrderMVO.setSalesOrdIdOld(salesOrderMVO.getSalesOrdIdOld());
    salesOrderMVO.setEditTypeId(0);
    salesOrderMVO.setMthRentAmt(salesOrderMVO.getAppTypeId() == 66 ? salesOrderMVO.getMthRentAmt() : BigDecimal.ZERO);
    salesOrderMVO.setLok(0);
    salesOrderMVO.setAeonStusId(0);
    salesOrderMVO.setCommDt(SalesConstants.DEFAULT_DATE2);
    salesOrderMVO.setCrtUserId(sessionVO.getUserId());
    salesOrderMVO.setPayComDt(SalesConstants.DEFAULT_DATE2);
    salesOrderMVO.setRefDocId(0);
    salesOrderMVO.setRentPromoId(0);
  }

  private void preprocSalesOrderDetails(SalesOrderDVO salesOrderDVO, SessionVO sessionVO) {

    salesOrderDVO.setSalesOrdId(0);
    salesOrderDVO.setItmNo(1);
    // salesOrderDVO.ItemStkID = int.Parse(cmbOrderProduct.SelectedValue);
    // salesOrderDVO.ItemPriceID = int.Parse(hiddenOrderPriceID.Value);
    salesOrderDVO.setItmQty(1);
    // salesOrderDVO.setItmTax(0);
    salesOrderDVO.setItmDscnt(0);
    // salesOrderDVO.ItemPrice = double.Parse(txtOrderPrice.Text.Trim());
    // salesOrderDVO.ItemPV = double.Parse(txtOrderPV.Text.Trim());
    salesOrderDVO.setStusCodeId(1);
    salesOrderDVO.setUpdUserId(sessionVO.getUserId());
    salesOrderDVO.setEditTypeId(0);
    salesOrderDVO.setItmId(0);
    salesOrderDVO.setItmCallEntryId(0);
  }

  private String convert24Tm(String TM) {
    String ampm = "", HH = "", MI = "", cvtTM = "";

    if (CommonUtils.isNotEmpty(TM)) {
      ampm = CommonUtils.right(TM, 2);
      HH = CommonUtils.left(TM, 2);
      MI = TM.substring(3, 5);

      if ("PM".equals(ampm)) {
        cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
      } else {
        cvtTM = HH + ":" + MI + ":00";
      }
    }
    return cvtTM;
  }

  private void preprocInstallationMaster(InstallationVO installationVO, SessionVO sessionVO) {

    logger.info("!@###### preprocInstallationMaster START ");

    installationVO.setInstallId(0);
    installationVO.setSalesOrdId(0);
    installationVO.setPreTm(this.convert24Tm(installationVO.getPreTm()));
    installationVO.setActDt(SalesConstants.DEFAULT_DATE2);
    installationVO.setActTm(SalesConstants.DEFAULT_TM);
    installationVO.setStusCodeId(1);
    installationVO.setUpdUserId(sessionVO.getUserId());
    installationVO.setEditTypeId(0);
    installationVO.setInstallId(0);
    /*
     * installationMaster.InstalltionID = 0; installationMaster.SalesOrderID =
     * 0; installationMaster.AddID =
     * int.Parse(txtHiddenInstAddressID.Text.Trim()); installationMaster.CntID =
     * int.Parse(txtHiddenInstContactID.Text.Trim());
     * installationMaster.PreCallDate = PreInstDate.AddDays(-1);
     * installationMaster.PreDate = PreInstDate; installationMaster.PreTime =
     * tpPreferInstTime.SelectedTime; installationMaster.ActDate = defaultDate;
     * installationMaster.ActTime = defaultTime; installationMaster.StatusCodeID
     * = 1; installationMaster.Instruction =
     * txtInstSpecialInstruction.Text.Trim(); installationMaster.Updated =
     * DateTime.Now; installationMaster.Updator = li.UserID;
     * installationMaster.BranchID = int.Parse(cmbDSCBranch.SelectedValue);
     * installationMaster.EditTypeID = 0; installationMaster.IsTradeIn = false;
     */
  }

  private void preprocRentPaySetMaster(RentPaySetVO rentPaySetVO, SessionVO sessionVO) {

    logger.info("!@###### preprocRentPaySetMaster START ");

    rentPaySetVO.setRentPayId(0);
    rentPaySetVO.setSalesOrdId(0);
    rentPaySetVO.setFailResnId(0);
    rentPaySetVO.setUpdUserId(sessionVO.getUserId());
    rentPaySetVO.setStusCodeId(1);
    rentPaySetVO.setEditTypeId(0);
    rentPaySetVO.setAeonCnvr(0);
    rentPaySetVO.setRem("");
    rentPaySetVO.setLastApplyUser(sessionVO.getUserId());
    rentPaySetVO.setPayTrm(0);

    /*
     * rentPaySetMaster.RentPayID = 0; rentPaySetMaster.SalesOrderID = 0;
     * rentPaySetMaster.ModeID = int.Parse(cmbRentPaymode.SelectedValue);
     * rentPaySetMaster.CustCRCID = int.Parse(cmbRentPaymode.SelectedValue) ==
     * 131 ? int.Parse(txtHiddenRentPayCRCID.Text.Trim()) : 0;
     * rentPaySetMaster.CustAccID = int.Parse(cmbRentPaymode.SelectedValue) ==
     * 132 ? int.Parse(txtHiddenRentPayBankAccID.Text.Trim()) : 0;
     * rentPaySetMaster.BankID = int.Parse(cmbRentPaymode.SelectedValue) == 131
     * ? int.Parse(hiddenRentPayCRCBankID.Value) :
     * int.Parse(cmbRentPaymode.SelectedValue) == 132 ?
     * int.Parse(hiddenRentPayBankAccBankID.Value) : 0;
     * rentPaySetMaster.DDApplyDate = DateTime.Now;
     * rentPaySetMaster.DDSubmitDate = defaultDate; rentPaySetMaster.DDStartDate
     * = defaultDate; rentPaySetMaster.DDRejectDate = defaultDate;
     * rentPaySetMaster.FailReasonID = 0; rentPaySetMaster.Updated =
     * DateTime.Now; rentPaySetMaster.Updator = li.UserID;
     * rentPaySetMaster.StatusCodeID = 1; rentPaySetMaster.Is3rdParty =
     * btnThirdParty.Checked ? true : false; rentPaySetMaster.CustomerID =
     * btnThirdParty.Checked ? int.Parse(txtHiddenThirdPartyID.Text.Trim()) :
     * int.Parse(txtHiddenCustID.Text.Trim()); rentPaySetMaster.EditTypeID = 0;
     * rentPaySetMaster.NRICOld = txtRentPayIC.Text.Trim();
     * rentPaySetMaster.IssuedNRIC =
     * (!string.IsNullOrEmpty(txtRentPayIC.Text.Trim())) ?
     * txtRentPayIC.Text.Trim() : btnThirdParty.Checked ?
     * txtThirdPartyNRIC.Text.Trim() : txtCustIC.Text.Trim();
     * rentPaySetMaster.AeonConvert = false; rentPaySetMaster.Remark = "";
     * rentPaySetMaster.LastApplyUser = li.UserID; rentPaySetMaster.PayTerm = 0;
     */
  }

  private void preprocCustomerBillMaster(CustBillMasterVO custBillMasterVO, SessionVO sessionVO) {

    custBillMasterVO.setCustBillId(0);
    ;
    custBillMasterVO.setCustBillSoId(0);
    custBillMasterVO.setCustBillStusId(SalesConstants.STATUS_ACTIVE);
    custBillMasterVO.setCustBillUpdUserId(sessionVO.getUserId());
    custBillMasterVO.setCustBillGrpNo("");
    custBillMasterVO.setCustBillCrtUserId(sessionVO.getUserId());
    custBillMasterVO.setCustBillPayTrm(0);
    custBillMasterVO.setCustBillInchgMemId(0);
    //custBillMasterVO.setCustBillIsEstm(0);

    /*
     * customerBillMaster.CustBillID = 0; customerBillMaster.CustBillSOID = 0;
     * customerBillMaster.CustBillCustID =
     * int.Parse(txtHiddenCustID.Text.Trim()); customerBillMaster.CustBillCntID
     * = int.Parse(txtHiddenContactID.Text.Trim());
     * customerBillMaster.CustBillAddID =
     * int.Parse(txtHiddenAddressID.Text.Trim());
     * customerBillMaster.CustBillStatusID = 1;
     * customerBillMaster.CustBillRemark = txtBillGroupRemark.Text.Trim();
     * customerBillMaster.CustBillUpdateAt = DateTime.Now;
     * customerBillMaster.CustBillUpdateBy = li.UserID;
     * customerBillMaster.CustBillGrpNo = "";
     * customerBillMaster.CustBillCreateAt = DateTime.Now;
     * customerBillMaster.CustBillCreateBy = li.UserID;
     * customerBillMaster.CustBillPayTerm = 0;
     * customerBillMaster.CustBillInchargeMemID = 0;
     * customerBillMaster.CustBillEmail = txtBillGroupEmail_1.Text.Trim();
     * customerBillMaster.CustBillIsEstatement = false;
     * customerBillMaster.CustBillIsSMS = btnBillGroupSMS_1.Checked == true ?
     * true : false; customerBillMaster.CustBillIsSMS_2 =
     * btnBillGroupSMS_2.Checked == true ? true : false;
     * customerBillMaster.CustBillIsPost = btnBillGroupPost.Checked == true ?
     * true : false; customerBillMaster.CustBillEmail_Addtional =
     * txtBillGroupEmail_2.Text.Trim(); customerBillMaster.CustBillCustCareCntID
     * = null; customerBillMaster.CustBillIsWebPortal =
     * btnBillGroupWebPortal.Checked == true ? true : false;
     * customerBillMaster.CustBillWebPortalUrl =
     * txtBillGroupWebAddress.Text.Trim();
     * customerBillMaster.CustBillCustCareCntID =
     * string.IsNullOrEmpty(txtHiddenBPCareID.Text) ? 0 :
     * int.Parse(txtHiddenBPCareID.Text.Trim());
     */
  }

  private void preprocRentalSchemeMaster(RentalSchemeVO rentalSchemeVO, SessionVO sessionVO) {

    logger.info("!@###### preprocRentalSchemeMaster START ");

    rentalSchemeVO.setRenSchId(0);
    rentalSchemeVO.setSalesOrdId(0);
    rentalSchemeVO.setStusCodeId(SalesConstants.STATUS_CODE_NAME_ACT);
    rentalSchemeVO.setRenSchTerms(0);
    rentalSchemeVO.setIsSync(0);
    /*
     * rentalSchemeMaster.RenSchID = 0; rentalSchemeMaster.SalesOrderID = 0;
     * rentalSchemeMaster.StatusCodeID = "ACT"; rentalSchemeMaster.RenSchDate =
     * DateTime.Now; rentalSchemeMaster.RenSchTerms = 0;
     * rentalSchemeMaster.IsSync = false;
     */
  }

  private void preprocClaimAdtMaster(AccClaimAdtVO accClaimAdtVO, RentPaySetVO rentPaySetVO, SessionVO sessionVO) {

    logger.info("!@###### preprocRentalSchemeMaster START ");

    int issueBankId = rentPaySetVO.getBankId();

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("bankId", issueBankId);
    EgovMap bankInfo = null;

    if (issueBankId > 0) {
      bankInfo = orderRegisterMapper.selectBankById(params);
    }

    accClaimAdtVO.setAccClSoId(0);
    accClaimAdtVO.setAccClSvcCntrctId(0); // TODO 소스상에 없음. 확인필요
    accClaimAdtVO.setAccClPromo(0);
    accClaimAdtVO.setAccClBankCode(bankInfo != null ? (String) bankInfo.get("code") : "");
    accClaimAdtVO.setAccDecBankAccNo("");
    accClaimAdtVO.setAccClReqstMCode("");
    accClaimAdtVO.setAccClRejctId("");
    accClaimAdtVO.setAccClStusId(SalesConstants.STATUS_CODE_NAME_ACT);
    accClaimAdtVO.setAccClUpdUserId(sessionVO.getUserId());
    accClaimAdtVO.setAccClPromoChkId("0");
    accClaimAdtVO.setAccClSplClmAmt(BigDecimal.ZERO);
    accClaimAdtVO.setAccClSoNo("");
    accClaimAdtVO.setAccClUserName(sessionVO.getUserName());
    accClaimAdtVO.setAccClBankId(issueBankId);
    accClaimAdtVO.setAccClClmLimit(0);
    accClaimAdtVO.setAccClBillDt(5);
    /*
     * claimAdtMaster.AccCLSOID = 0; claimAdtMaster.AccCLBillClaimAmt =
     * double.Parse(txtOrderRentalFees.Text.Trim());
     * claimAdtMaster.AccCLClaimAmt =
     * double.Parse(txtOrderRentalFees.Text.Trim()); claimAdtMaster.AccCLPromo =
     * 0; claimAdtMaster.AccCLBankCode = bankInfo.Code != null ? bankInfo.Code :
     * ""; claimAdtMaster.AccCLBankAccNo = AccNo; claimAdtMaster.AccDecBankAccNo
     * = ""; claimAdtMaster.AccCLRequestMcode = "";
     * claimAdtMaster.AccCLApplyDate = DateTime.Now;
     * claimAdtMaster.AccCLSubMitDate = defaultDate;
     * claimAdtMaster.AccCLApproveDate = defaultDate;
     * claimAdtMaster.AccCLRejectDate = defaultDate;
     * claimAdtMaster.AccCLRejectID = ""; claimAdtMaster.AccCLStatusID = "ACT";
     * claimAdtMaster.AccCLUpdateAt = DateTime.Now; claimAdtMaster.AccCLUpdateBy
     * = li.UserID; claimAdtMaster.AccCLPromoCheckID = "0";
     * claimAdtMaster.AccCLPromoStartDate = defaultDate;
     * claimAdtMaster.AccCLAcctName = AccName; claimAdtMaster.AccCLAccNRIC =
     * (!string.IsNullOrEmpty(txtRentPayIC.Text.Trim())) ?
     * txtRentPayIC.Text.Trim() : btnThirdParty.Checked ?
     * txtThirdPartyNRIC.Text.Trim() : txtCustIC.Text.Trim();
     * claimAdtMaster.AccCLSpLClaimamt = 0; claimAdtMaster.AccCLSOno = "";
     * claimAdtMaster.AccCLUserName = li.LoginID; claimAdtMaster.AccCLPayMode =
     * AdtPayMode; claimAdtMaster.AccCLPayModeID =
     * int.Parse(cmbRentPaymode.SelectedValue); claimAdtMaster.AccCLBankID =
     * IssueBankID; claimAdtMaster.AccCLClaimLimit = 0;
     * claimAdtMaster.AccClBillDate = 5; claimAdtMaster.AccCLInsertDate =
     * DateTime.Now;
     */
  }

  private void preprocEStatementRequest(EStatementReqVO eStatementReqVO, SessionVO sessionVO) {

    logger.info("!@###### preprocEStatementRequest START ");

    eStatementReqVO.setReqId(0);
    eStatementReqVO.setStusCodeId(5);
    eStatementReqVO.setCustBillId(0);
    eStatementReqVO.setCnfmCode(CommonUtils.getRandomNumber(10));
    eStatementReqVO.setCrtUserId(sessionVO.getUserId());
    eStatementReqVO.setUpdUserId(sessionVO.getUserId());
    eStatementReqVO.setEmailFailInd(0);
    eStatementReqVO.setEmailFailDesc("");
    eStatementReqVO.setRefNo("");

    /*
     * EStatementRequest.ReqID = 0; EStatementRequest.StatusCodeID = 5;
     * EStatementRequest.CustBillID = 0; //Update later EStatementRequest.Email
     * = txtBillGroupEmail_1.Text.Trim(); EStatementRequest.EmailAdditional =
     * txtBillGroupEmail_2.Text.Trim(); EStatementRequest.ConfirmCode =
     * CommonFunction.GetRandomNumber(10); EStatementRequest.Created =
     * DateTime.Now; EStatementRequest.Creator = li.UserID;
     * EStatementRequest.ConfirmDate = DateTime.Now; EStatementRequest.Updated =
     * DateTime.Now; EStatementRequest.Updator = li.UserID;
     * EStatementRequest.EmailFailInd = false; EStatementRequest.EmailFailDesc =
     * ""; EStatementRequest.RefNo = ""; //Update later
     */
  }

  private void preprocCcpMaster(CcpDecisionMVO ccpDecisionMVO, int custTypeId, int custRaceId, String custNric, SessionVO sessionVO) {

    logger.info("!@###### preprocCcpMaster START ");

    int statusId = 1, ccpSchemeTypeId;
    String remark = "";

    if (custTypeId == SalesConstants.CUST_TYPE_CODE_ID_IND && custRaceId == 14) {
      // KOREAN --> PASSED CCP
      statusId = 5;
      remark = "CCP Korean bypass.";
    }

    ccpSchemeTypeId = custTypeId == SalesConstants.CUST_TYPE_CODE_ID_IND ? SalesConstants.CCP_SCHEME_TYPE_CODE_ID_ICS
        : SalesConstants.CCP_SCHEME_TYPE_CODE_ID_CCS;

    EgovMap shiInfo = orderRegisterMapper.selectShiIndexInfo(custNric);

    logger.info("####### Get Shi Info " + shiInfo);
    ccpDecisionMVO.setCcpId(5);
    ccpDecisionMVO.setCcpSalesOrdId(0);
    ccpDecisionMVO.setCcpSchemeTypeId(ccpSchemeTypeId);
    ccpDecisionMVO.setCcpTypeId(972);
    ccpDecisionMVO.setCcpIncomeRangeId(0);
    ccpDecisionMVO.setCcpTotScrePoint(BigDecimal.ZERO);
    ccpDecisionMVO.setCcpStusId(statusId);
    ccpDecisionMVO.setCcpResnId(0);
    ccpDecisionMVO.setCcpRem(remark);
    ccpDecisionMVO.setCcpRjStusId(0);
    ccpDecisionMVO.setCcpUpdUserId(sessionVO.getUserId());
    ccpDecisionMVO.setCcpIsLou(SalesConstants.IS_FALSE);
    ccpDecisionMVO.setCcpIsSaman(SalesConstants.IS_FALSE);
    ccpDecisionMVO.setCcpIsSync(SalesConstants.IS_FALSE);
    ccpDecisionMVO.setCcpPncRem("");
    ccpDecisionMVO.setCcpHasGrnt(SalesConstants.IS_FALSE);
    ccpDecisionMVO.setCcpIsHold(SalesConstants.IS_FALSE);

    if(shiInfo != null) {
        ccpDecisionMVO.setCcpOpcMemId(CommonUtils.intNvl(shiInfo.get("memId")));
        ccpDecisionMVO.setCcpOpcShi(CommonUtils.intNvl(shiInfo.get("shiIdx")));
    }


    /*
     * CcpMaster.CcpID = 0; CcpMaster.CcpSalesOrderID = 0;
     * CcpMaster.CcpSchemeTypeID = int.Parse(hiddenCustTypeID.Value) == 964 ?
     * 969 : 970; CcpMaster.CcpTypeID = 972; CcpMaster.CcpIncomeRangeID = 0;
     * CcpMaster.CcpTotalScorePoint = 0; CcpMaster.CcpStatusID = StatusID;
     * CcpMaster.CcpReasonID = 0; CcpMaster.CcpRemark = Remark;
     * CcpMaster.CcpRjStatusID = 0; CcpMaster.CcpUpdateAt = DateTime.Now;
     * CcpMaster.CcpUpdateBy = li.UserID; CcpMaster.CcpIsLOU = false;
     * CcpMaster.CcpIsSaman = false; CcpMaster.CcpIsSync = false;
     * CcpMaster.CcpPNCRemark = ""; CcpMaster.CcpHasGuarantee = false;
     * CcpMaster.CcpIshold = false;
     */
  }

  private void preprocSalesOrderContract(SalesOrderContractVO salesOrderContractVO, SalesOrderMVO salesOrderMVO,
      SessionVO sessionVO) {

    logger.info("!@###### preprocSalesOrderContract START ");

    EgovMap inMap = new EgovMap();

    inMap.put("srvCntrctPacId", salesOrderMVO.getSrvPacId());

    EgovMap outMap = orderRegisterMapper.selectServiceContractPackage(inMap);

    salesOrderContractVO.setCntrctId(0);
    salesOrderContractVO.setCntrctSalesOrdId(0);
    // salesOrderContractVO.setCntrctRentalPriod(60);
    // salesOrderContractVO.setCntrctObligtPriod(36);
    salesOrderContractVO.setCntrctRentalPriod(CommonUtils.intNvl(outMap.get("srvCntrctPacDur")));
    salesOrderContractVO.setCntrctObligtPriod(CommonUtils.intNvl(outMap.get("obligtPriod")));
    salesOrderContractVO.setCntrctRcoPriod(CommonUtils.intNvl(outMap.get("rcoPriod")));
    salesOrderContractVO.setCntrctStusId(SalesConstants.STATUS_ACTIVE);
    salesOrderContractVO.setCntrctRem("");
    salesOrderContractVO.setCntrctCrtUserId(sessionVO.getUserId());
    salesOrderContractVO.setCntrctUpdUserId(sessionVO.getUserId());
    /*
     * salesOrderContract.ContractID = 0;
     * salesOrderContract.ContractSalesOrderID = 0;
     * salesOrderContract.ContractRentalPeriod = 60;
     * salesOrderContract.ContractObligationPeriod = obligationPeriod;
     * salesOrderContract.ContractStatusID = 1;
     * salesOrderContract.ContractRemark = "";
     * salesOrderContract.ContractCreated = DateTime.Now;
     * salesOrderContract.ContractCreator = li.UserID;
     * salesOrderContract.ContractUpdated = DateTime.Now;
     * salesOrderContract.ContractUpdator = li.UserID;
     */
  }

  private void preprocDocumentList(List<DocSubmissionVO> updateDocList, SessionVO sessionVO) {

    logger.info("!@###### preprocDocumentList START ");

    for (int i = updateDocList.size() - 1; i >= 0; i--) {

      DocSubmissionVO docVO = updateDocList.get(i);

      if (docVO.getChkfield() == 1) {
        docVO.setDocSubId(0);
        docVO.setDocSubTypeId(SalesConstants.CCP_DOC_SUB_CODE_ID_ICS);
        docVO.setDocTypeId(docVO.getCodeId());
        docVO.setDocSoId(0);
        docVO.setDocMemId(0);
        docVO.setDocCopyQty(1);
        docVO.setStusId(1);
        docVO.setCrtUserId(sessionVO.getUserId());
        docVO.setUpdUserId(sessionVO.getUserId());
        docVO.setDocSubBatchId(0);
        docVO.setDocSubBrnchId(sessionVO.getUserBranchId());
      } else {
        updateDocList.remove(i);
      }
    }
  }

  private void preprocCallEntryMaster(CallEntryVO callEntryVO, int orderAppType, String installDate,
      SessionVO sessionVO) throws ParseException {

    logger.info("!@###### preprocCallEntryMaster START ");

    int statusCodeId = 1;
    // DateTime CallDate =
    // ((DateTime)dpPreferInstDate.SelectedDate).AddDays(-1);
    String callDate = installDate;
    logger.debug("@#### callDate:" + callDate);
    // APP TYPE = SERVICES
    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
      statusCodeId = 20;
    } else {
      callDate = CommonUtils.getAddDay(callDate, -1, SalesConstants.DEFAULT_DATE_FORMAT1);
    }

    logger.debug("@#### callDate2:" + callDate);

    // callDate = CommonUtils.changeFormat(callDate,
    // SalesConstants.DEFAULT_DATE_FORMAT1,
    // SalesConstants.DEFAULT_DATE_FORMAT2);

    callEntryVO.setCallEntryId(0);
    callEntryVO.setSalesOrdId(0);
    callEntryVO.setTypeId(257);
    callEntryVO.setStusCodeId(statusCodeId);
    callEntryVO.setResultId(0);
    callEntryVO.setDocId(0);
    callEntryVO.setCrtUserId(sessionVO.getUserId());
    callEntryVO.setCallDt(callDate);
    callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
    callEntryVO.setHapyCallerId(0);
    callEntryVO.setUpdUserId(sessionVO.getUserId());
    callEntryVO.setOriCallDt(callDate);

    /*
     * callEntryMaster.CallEntryID = 0; callEntryMaster.SalesOrderID = 0;
     * callEntryMaster.TypeID = 257; callEntryMaster.StatusCodeID =
     * StatusCodeID; callEntryMaster.ResultID = 0; callEntryMaster.DocID = 0;
     * callEntryMaster.Created = DateTime.Now; callEntryMaster.Creator =
     * li.UserID; callEntryMaster.CallDate = CallDate;
     * callEntryMaster.IsWaitForCancel = false; callEntryMaster.HappyCallerID =
     * 0; callEntryMaster.Updated = DateTime.Now; callEntryMaster.Updator =
     * li.UserID; callEntryMaster.OriCallDate = CallDate;
     */
  }

  private void preprocCallResultDetails(CallResultVO callResultVO, String dInstallDate, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocCallResultDetails START ");

    callResultVO.setCallResultId(0);
    callResultVO.setCallEntryId(0);
    callResultVO.setCallStusId(20);
    callResultVO.setCallActnDt(dInstallDate);
    callResultVO.setCallFdbckId(0);
    callResultVO.setCallCtId(0);
    callResultVO.setCallRem("");
    callResultVO.setCallCrtUserId(sessionVO.getUserId());
    callResultVO.setCallCrtUserIdDept(0);
    callResultVO.setCallHcId(0);
    callResultVO.setCallRosAmt(BigDecimal.ZERO);
    callResultVO.setCallSms(SalesConstants.IS_FALSE);
    callResultVO.setCallSmsRem("");
    /*
     * CallResultDetails.CallResultID = 0; CallResultDetails.CallEntryID = 0;
     * CallResultDetails.CallStatusID = 20; CallResultDetails.CallCallDate =
     * CallDate; CallResultDetails.CallActionDate = CallDate;
     * CallResultDetails.CallFeedBackID = 0; CallResultDetails.CallCTID = 0;
     * CallResultDetails.CallRemark = ""; CallResultDetails.CallCreateBy =
     * li.UserID; CallResultDetails.CallCreateAt = DateTime.Now;
     * CallResultDetails.CallCreateByDept = 0; CallResultDetails.CallHCID = 0;
     * CallResultDetails.CallROSAmt = 0; CallResultDetails.CallSMS = false;
     * CallResultDetails.CallSMSRemark = "";
     */
  }

  private void preprocInstallEntryMaster(InstallEntryVO installEntryVO, String dInstallDate, int itmStkId,
      SessionVO sessionVO) throws ParseException {

    logger.info("!@###### preprocInstallEntryMaster START ");

    installEntryVO.setInstallEntryId(0);
    installEntryVO.setInstallEntryNo("");
    installEntryVO.setSalesOrdId(0);
    installEntryVO.setStusCodeId(4);
    installEntryVO.setCtId(0);
    installEntryVO.setInstallDt(dInstallDate);
    installEntryVO.setCallEntryId(0);
    installEntryVO.setInstallStkId(itmStkId);
    installEntryVO.setInstallResultId(0);
    installEntryVO.setCrtUserId(sessionVO.getUserId());
    installEntryVO.setAllowComm(SalesConstants.IS_FALSE);
    installEntryVO.setUpdUserId(sessionVO.getUserId());
    installEntryVO.setRevId(0);
    /*
     * InstallEntryMaster.InstallEntryID = 0; InstallEntryMaster.InstallEntryNo
     * = ""; InstallEntryMaster.SalesOrderID = 0;
     * InstallEntryMaster.StatusCodeID =4; InstallEntryMaster.CTID = 0;
     * InstallEntryMaster.InstallDate = InstallDate;
     * InstallEntryMaster.CallEntryID = 0; InstallEntryMaster.InstallStkID =
     * int.Parse(cmbOrderProduct.SelectedValue);
     * InstallEntryMaster.InstallResultID = 0; InstallEntryMaster.Created =
     * DateTime.Now; InstallEntryMaster.Creator = li.UserID;
     * InstallEntryMaster.AllowComm = false; InstallEntryMaster.IsTradeIn =
     * false; InstallEntryMaster.CTGroup = ""; InstallEntryMaster.Updated =
     * DateTime.Now; InstallEntryMaster.Updator = li.UserID;
     * InstallEntryMaster.RevID = 0;
     */
  }

  private void preprocInstallResultDetails(InstallResultVO installResultVO, String dInstallDate, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocInstallResultDetails START ");

    installResultVO.setResultId(0);
    installResultVO.setEntryId(0);
    installResultVO.setStusCodeId(4);
    installResultVO.setCtId(999999);
    installResultVO.setInstallDt(dInstallDate);
    installResultVO.setRem("");
    installResultVO.setGlPost(1);
    installResultVO.setCrtUserId(sessionVO.getUserId());
    installResultVO.setSirimNo("");
    installResultVO.setSerialNo("");
    installResultVO.setFailId(0);
    installResultVO.setAllowComm(SalesConstants.IS_FALSE);
    installResultVO.setIsTradeIn(SalesConstants.IS_FALSE);
    installResultVO.setRequireSms(SalesConstants.IS_FALSE);
    installResultVO.setDocRefNo1("");
    installResultVO.setDocRefNo2("");
    installResultVO.setUpdUserId(sessionVO.getUserId());
    installResultVO.setAdjAmt(BigDecimal.ZERO);

    /*
     * InstallResultDetails.ResultID = 0; InstallResultDetails.EntryID = 0;
     * InstallResultDetails.StatusCodeID = 4; InstallResultDetails.CTID =
     * 999999; //modified by chia // cant save 0
     * InstallResultDetails.InstallDate = InstallDate;
     * InstallResultDetails.Remark = ""; InstallResultDetails.GLPost = 1;
     * InstallResultDetails.Created = DateTime.Now; InstallResultDetails.Creator
     * = li.UserID; InstallResultDetails.SirimNo = "";
     * InstallResultDetails.SerialNo = ""; InstallResultDetails.FailID = 0;
     * InstallResultDetails.NextCallDate = defaultDate;
     * InstallResultDetails.AllowComm = false; InstallResultDetails.IsTradeIn =
     * false; InstallResultDetails.RequireSMS = false;
     * InstallResultDetails.DocRefNo1 = ""; InstallResultDetails.DocRefNo2 = "";
     * InstallResultDetails.Updated = DateTime.Now; InstallResultDetails.Updator
     * = li.UserID; InstallResultDetails.AdjAmount = 0;
     */
  }

  private void preprocMembershipSalesMaster(SrvMembershipSalesVO srvMembershipSalesVO, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocMembershipSalesMaster START ");

    srvMembershipSalesVO.setSrvMemId(0);
    srvMembershipSalesVO.setSrvMemQuotId(0);
    srvMembershipSalesVO.setSrvSalesOrdId(0);
    srvMembershipSalesVO.setSrvMemNo("");
    srvMembershipSalesVO.setSrvMemBillNo("");
    srvMembershipSalesVO.setSrvMemPacId(10);
    srvMembershipSalesVO.setSrvMemPacAmt(BigDecimal.ZERO);
    srvMembershipSalesVO.setSrvMemBsAmt(BigDecimal.ZERO);
    srvMembershipSalesVO.setSrvMemPv(0);
    srvMembershipSalesVO.setSrvFreq(2);
    srvMembershipSalesVO.setSrvDur(1);
    srvMembershipSalesVO.setSrvStusCodeId(4);
    srvMembershipSalesVO.setSrvRem("");
    srvMembershipSalesVO.setSrvCrtUserId(sessionVO.getUserId());
    srvMembershipSalesVO.setSrvUpdUserId(sessionVO.getUserId());
    srvMembershipSalesVO.setSrvMemBs12Amt(BigDecimal.ZERO);
    srvMembershipSalesVO.setSrvMemIsSynch(SalesConstants.IS_FALSE);
    srvMembershipSalesVO.setSrvMemSalesMemId(0);
    srvMembershipSalesVO.setSrvMemCustCntId(0);
    srvMembershipSalesVO.setSrvMemQty(0);
    srvMembershipSalesVO.setSrvBsQty(0);
    srvMembershipSalesVO.setSrvMemPromoId(0);
    srvMembershipSalesVO.setSrvMemPvMonth(0);
    srvMembershipSalesVO.setSrvMemPvYear(0);
    srvMembershipSalesVO.setSrvMemIsMnl(SalesConstants.IS_FALSE);
    srvMembershipSalesVO.setSrvMemBrnchId(sessionVO.getUserBranchId());

    /*
     * MembershipSalesMaster.SrvMemID = 0; MembershipSalesMaster.SrvMemQuotID =
     * 0; MembershipSalesMaster.SrvSalesOrderID = 0;
     * MembershipSalesMaster.SrvMemNo = ""; MembershipSalesMaster.SrvMemBillNo =
     * ""; MembershipSalesMaster.SrvMemPacID = 10;
     * MembershipSalesMaster.SrvMemPacAmt = 0; MembershipSalesMaster.SrvMemBSAmt
     * = 0; MembershipSalesMaster.SrvMemPV = 0; MembershipSalesMaster.SrvFreq =
     * 2; MembershipSalesMaster.SrvStartDate =
     * CommonFunction.GetFirstDayOfMonth(DateTime.Now);
     * MembershipSalesMaster.SrvExpireDate =
     * CommonFunction.GetLastDayOfMonth(DateTime.Now);
     * MembershipSalesMaster.SrvDuration = 1;
     * MembershipSalesMaster.SrvStatusCodeID = 4;
     * MembershipSalesMaster.SrvRemark = ""; MembershipSalesMaster.SrvCreateAt =
     * DateTime.Now; MembershipSalesMaster.SrvCreateBy = li.UserID;
     * MembershipSalesMaster.SrvUpdateAt = DateTime.Now;
     * MembershipSalesMaster.SrvUpdateBy = li.UserID;
     * MembershipSalesMaster.SrvMemBS12Amt = 0;
     * MembershipSalesMaster.SrvMemIsSynch = false;
     * MembershipSalesMaster.SrvMemSalesMemID = 0;
     * MembershipSalesMaster.SrvMemCustCntID = 0;
     * MembershipSalesMaster.SrvMemQty = 0; MembershipSalesMaster.SrvBSQty = 0;
     * MembershipSalesMaster.SrvMemPromoID = 0;
     * MembershipSalesMaster.SrvMemPVMonth = 0;
     * MembershipSalesMaster.SrvMemPVYear = 0;
     * MembershipSalesMaster.SrvMemIsManual = false;
     * MembershipSalesMaster.SrvMemBranchID = li.BranchID;
     */
  }

  private void preprocConfigMaster(SrvConfigurationVO srvConfigurationVO, String dInstallDate, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocConfigMaster START ");

    srvConfigurationVO.setSrvConfigId(0);
    srvConfigurationVO.setSrvSoId(0);
    srvConfigurationVO.setSrvCodyId(0);
    srvConfigurationVO.setSrvPrevDt(dInstallDate);
    srvConfigurationVO.setSrvRem("");
    srvConfigurationVO.setSrvBsGen(SalesConstants.IS_FALSE);
    srvConfigurationVO.setSrvCrtUserId(sessionVO.getUserId());
    srvConfigurationVO.setSrvUpdUserId(sessionVO.getUserId());
    srvConfigurationVO.setSrvStusId(1);
    srvConfigurationVO.setSrvBsWeek(0);

    /*
     * ConfigMaster.SrvConfigID = 0; ConfigMaster.SrvSOID = 0;
     * ConfigMaster.SrvCodyID = 0; ConfigMaster.SrvPreviousDate = InstallDate;
     * ConfigMaster.SrvRemark = ""; ConfigMaster.SrvBSGen = false;
     * ConfigMaster.SrvCreateAt = DateTime.Now; ConfigMaster.SrvCreateBy =
     * li.UserID; ConfigMaster.SrvUpdateAt = DateTime.Now;
     * ConfigMaster.SrvUpdateBy = li.UserID; ConfigMaster.SrvStatusID = 1;
     * ConfigMaster.SrvBSWeek = 0;
     */
  }

  private void preprocConfigSettingList(List<SrvConfigSettingVO> srvConfigSettingVOList, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocConfigSettingList START ");

    SrvConfigSettingVO cnfigSetVO = null;

    for (int i = 279; i <= 280; i++) {
      cnfigSetVO = new SrvConfigSettingVO();

      cnfigSetVO.setSrvSettId(0);
      cnfigSetVO.setSrvConfigId(0);
      cnfigSetVO.setSrvSettTypeId(i);
      cnfigSetVO.setSrvSettStusId(1);
      cnfigSetVO.setSrvSettRem("");
      cnfigSetVO.setSrvSettCrtUserId(sessionVO.getUserId());

      srvConfigSettingVOList.add(cnfigSetVO);
    }
  }

  private void preprocConfigPeriod(SrvConfigPeriodVO srvConfigPeriodVO, SessionVO sessionVO) throws ParseException {

    logger.info("!@###### preprocConfigPeriod START ");

    srvConfigPeriodVO.setSrvPrdId(0);
    srvConfigPeriodVO.setSrvConfigId(0);
    srvConfigPeriodVO.setSrvMbrshId(0);
    srvConfigPeriodVO.setSrvPrdDur(2);
    srvConfigPeriodVO.setSrvPrdStusId(1);
    srvConfigPeriodVO.setSrvPrdRem("");
    srvConfigPeriodVO.setSrvPrdCrtUserId(sessionVO.getUserId());
    srvConfigPeriodVO.setSrvPrdUpdUserId(sessionVO.getUserId());

    /*
     * ConfigPeriod.SrvPrdID = 0; ConfigPeriod.SrvConfigID = 0;
     * ConfigPeriod.SrvMembershipID = 0; ConfigPeriod.SrvPrdStartDate =
     * CommonFunction.GetFirstDayOfMonth(DateTime.Now);
     * ConfigPeriod.SrvPrdExpireDate =
     * CommonFunction.GetLastDayOfMonth(DateTime.Now);
     * ConfigPeriod.SrvPrdDuration = 2; ConfigPeriod.SrvPrdStatusID = 1;
     * ConfigPeriod.SrvPrdRemark = ""; ConfigPeriod.SrvPrdCreateAt =
     * DateTime.Now; ConfigPeriod.SrvPrdCreateBy = li.UserID;
     * ConfigPeriod.SrvPrdUpdateAt = DateTime.Now; ConfigPeriod.SrvPrdUpdateBy =
     * li.UserID;
     */
  }

  private List<SrvConfigFilterVO> preprocConfigFilterList(String dInstallDate, int itmStkId, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocConfigFilterList START ");

    List<SrvConfigFilterVO> srvConfigFilterVOList = null;
    SrvConfigFilterVO srvConfigFilterVO = null;

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("bomStkId", itmStkId);
    List<EgovMap> bomInfoList = orderRegisterMapper.selectBOMList(params);

    if (bomInfoList != null && bomInfoList.size() > 0) {

      srvConfigFilterVOList = new ArrayList<SrvConfigFilterVO>();

      for (EgovMap bomInfo : bomInfoList) {

        srvConfigFilterVO = new SrvConfigFilterVO();

        srvConfigFilterVO.setSrvFilterId(0);
        srvConfigFilterVO.setSrvConfigId(0);
        srvConfigFilterVO.setSrvFilterStkId(Integer.parseInt(String.valueOf((BigDecimal) bomInfo.get("bomPartId"))));
        srvConfigFilterVO.setSrvFilterPriod(Integer.parseInt(String.valueOf((BigDecimal) bomInfo.get("bomPartPriod"))));
        srvConfigFilterVO.setSrvFilterPrvChgDt(dInstallDate);
        srvConfigFilterVO.setSrvFilterStusId(1);
        srvConfigFilterVO.setSrvFilterRem("");
        srvConfigFilterVO.setSrvFilterCrtUserId(sessionVO.getUserId());
        srvConfigFilterVO.setSrvFilterUpdUserId(sessionVO.getUserId());

        srvConfigFilterVOList.add(srvConfigFilterVO);
      }
    }

    return srvConfigFilterVOList;
  }

  private void preprocOrderLog(List<SalesOrderLogVO> salesOrderLogVOList, int orderAppType, int custTypeId,
      int custRaceId, SessionVO sessionVO) throws ParseException {

    logger.info("!@###### preprocOrderLogList START ");

    SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();

    int progressId = 0;
    int isLock = SalesConstants.IS_TRUE;

    // if((orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL)
    // || (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL && custTypeId
    // == SalesConstants.CUST_TYPE_CODE_ID_IND && custRaceId == 14)) {
    if (orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
      // APP TYPE != RENTAL || APP TYPE == RENTAL && RACE == KOREAN
      if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
        // APP TYPE == SERVICES
        // PROGRESS : CUSTOMER IN-USE
        progressId = 5;
        isLock = SalesConstants.IS_FALSE;
      } else {
        // APP TYPE == OTHER THAT SERVICES
        // PROGRESS : INSTALLATION CALL-LOG (NEW INSTALLATION)
        progressId = 2;

      }
    } else {
      // APP TYPE == RENTAL && RACE!= KOREAN
      // PROGRESS : CCP RESULT
      progressId = 1;
    }

    salesOrderLogVO.setLogId(0);
    salesOrderLogVO.setSalesOrdId(0);
    salesOrderLogVO.setPrgrsId(progressId);
    salesOrderLogVO.setRefId(0);
    salesOrderLogVO.setIsLok(isLock);
    salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());

    salesOrderLogVOList.add(salesOrderLogVO);
  }

  private void preprocGSTCertificate(GSTEURCertificateVO gSTEURCertificateVO, int orderAppType, SessionVO sessionVO)
      throws ParseException {

    logger.info("!@###### preprocGSTCertificate START ");

    int reliefTypeId = 0;

    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
      reliefTypeId = 1374; // Foreign Mission And International Organization
    } else if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT
        || orderAppType == SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
      reliefTypeId = 1373; // Government Sector
    }

    gSTEURCertificateVO.setEurcRliefTypeId(reliefTypeId);
    gSTEURCertificateVO.setEurcRliefAppTypeId(orderAppType);
    gSTEURCertificateVO.setEurcStusCodeId(SalesConstants.STATUS_ACTIVE);
    gSTEURCertificateVO.setEurcCrtUserId(sessionVO.getUserId());
    gSTEURCertificateVO.setEurcUpdUserId(sessionVO.getUserId());
  }

  private void preprocASEntry(ASEntryVO aSEntryVO, SessionVO sessionVO) throws ParseException {

    logger.info("!@###### preprocASEntry START ");

    aSEntryVO.setAsId(0);
    aSEntryVO.setAsNo("");
    aSEntryVO.setAsSoId(0);
    aSEntryVO.setAsMemId(0);
    aSEntryVO.setAsMemGrp(null);
    // aSEntryVO.setAsReqstDt();
    // aSEntryVO.setAsReqstTm();
    // aSEntryVO.setAsAppntDt();
    // aSEntryVO.setAsAppntTm();
    aSEntryVO.setAsBrnchId(0);
    aSEntryVO.setAsMalfuncId(9001700);
    aSEntryVO.setAsMalfuncResnId(5);
    aSEntryVO.setAsRemReqster("");
    aSEntryVO.setAsRemReqsterCntc("");
    aSEntryVO.setAsCalllogId(0);
    aSEntryVO.setAsStusId(1);
    aSEntryVO.setAsSms(0);
    aSEntryVO.setAsCrtUserId(sessionVO.getUserId());
    // aSEntryVO.setAsCrtDt();
    aSEntryVO.setAsUpdUserId(sessionVO.getUserId());
    // aSEntryVO.setAsUpdDt("");
    aSEntryVO.setAsEntryIsSynch(0);
    aSEntryVO.setAsEntryIsEdit(0);
    aSEntryVO.setAsTypeId(3154);
    aSEntryVO.setAsReqsterTypeId(0);
    aSEntryVO.setAsIsBSWithin30days(0);
    aSEntryVO.setAsAllowComm(0);
    aSEntryVO.setAsPrevMemId(0);
    aSEntryVO.setAsRemAddCntc(null);
    aSEntryVO.setAsRemReqsterCntcSms(0);
    aSEntryVO.setAsRemAddCntcSms(0);
    aSEntryVO.setAsSesionCode("");
    aSEntryVO.setCallMem("0");
    aSEntryVO.setRefReqst(null);
    aSEntryVO.setPrevCompSvc(null);
    aSEntryVO.setNextCompSvc(null);
    // aSEntryVO.setSignDtTime("");
    // aSEntryVO.setCompDtSeq(0);
    // aSEntryVO.setDistance(0);
    aSEntryVO.setFirst(null);
    aSEntryVO.setLast(null);
    aSEntryVO.setHome(null);
    aSEntryVO.setAsMobileReqstId(null);
    aSEntryVO.setAsRqstRem(null);
    aSEntryVO.setPrevSvcArea(null);
    aSEntryVO.setNextSvcArea(null);
    aSEntryVO.setAsIfFlag(null);

  }

  @Override
  public void registerOrder(OrderVO orderVO, SessionVO sessionVO) throws ParseException {

    logger.info("!@###### OrderRegisterServiceImpl.registerOrder");

    OrderVO regOrderVO = new OrderVO();

    SalesOrderMVO salesOrderMVO = orderVO.getSalesOrderMVO();
    SalesOrderDVO salesOrderDVO = orderVO.getSalesOrderDVO(); // SALES ORDER
                                                              // DETAILS
    InstallationVO installationVO = orderVO.getInstallationVO(); // INSTALLATION
                                                                 // MASTER
    RentPaySetVO rentPaySetVO = orderVO.getRentPaySetVO(); // RENT PAY SET
    CustBillMasterVO custBillMasterVO = orderVO.getCustBillMasterVO(); // CUSTOMER
                                                                       // BILL
                                                                       // MASTER
    RentalSchemeVO rentalSchemeVO = orderVO.getRentalSchemeVO(); // RENTAL
                                                                 // SCHEME
    AccClaimAdtVO accClaimAdtVO = orderVO.getAccClaimAdtVO(); // CLAIM ADT

    EStatementReqVO eStatementReqVO = orderVO.geteStatementReqVO(); // CCP
                                                                    // DETAILS

    GSTEURCertificateVO gSTEURCertificateVO = orderVO.getgSTEURCertificateVO();

    GridDataSet<DocSubmissionVO> documentList = orderVO.getDocSubmissionVOList();

    List<DocSubmissionVO> docSubVOList = documentList.getUpdate(); // 수정 리스트 얻기

    int orderAppType = salesOrderMVO.getAppTypeId();
    int custTypeId = orderVO.getCustTypeId();
    int custRaceId = orderVO.getRaceId();
    String billGrp = orderVO.getBillGrp(); // new, exist
    String sInstallDate = installationVO.getPreDt();
    int itmStkId = salesOrderDVO.getItmStkId();
    int itmCompId = salesOrderDVO.getItmCompId();
    int brnchId = installationVO.getBrnchId();
    String custNric = orderVO.getRentPaySetVO().getIssuNric();

    // SET BNDL_ID
    salesOrderMVO.setBndlId(orderVO.getBndlId());

    DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    // Date dInstallDate = (Date)formatter.parse(sInstallDate);
    String dInstallDate = sInstallDate;

    regOrderVO.setOrderAppType(orderAppType);
    regOrderVO.setCustTypeId(custTypeId);
    regOrderVO.setRaceId(custRaceId);
    regOrderVO.setsInstallDate(sInstallDate);
    regOrderVO.setdInstallDate(dInstallDate);

    this.preprocSalesOrderMaster(salesOrderMVO, sessionVO);
    this.preprocSalesOrderDetails(salesOrderDVO, sessionVO);
    this.preprocInstallationMaster(installationVO, sessionVO);

    /*
     * Voucher checking before creating order as PRE-ORDER does not consume voucher usage
     */
    if(CommonUtils.isEmpty(salesOrderMVO.getVoucherCode()) == false){
        Map<String, Object> voucherInfo = new HashMap<String, Object>();
        voucherInfo.put("voucherCode", salesOrderMVO.getVoucherCode());
        int validVoucher = voucherMapper.isVoucherValidToApply(voucherInfo);

        if(validVoucher == 0)
        {
        	throw new ApplicationException(AppConstants.FAIL,
					"Voucher applied is either used or not a valid voucher : " + salesOrderMVO.getVoucherCode() + ". Please recheck.");
        }
    }
    // ------------------------------------------------------------------------------
    // START
    // ------------------------------------------------------------------------------
    logger.debug("@#### salesOrderMVO.getTotAmt()    :" + salesOrderMVO.getTotAmt());
    logger.debug("@#### salesOrderMVO.getMthRentAmt():" + salesOrderMVO.getMthRentAmt());
    logger.debug("@#### salesOrderMVO.getTotPv()     :" + salesOrderMVO.getTotPv());

    int promoId = CommonUtils.intNvl(salesOrderMVO.getPromoId());
    int srvPacId = CommonUtils.intNvl(salesOrderMVO.getSrvPacId());

    EgovMap specialPromoMap = new EgovMap();
    if (promoId > 0) {

      Map<String, Object> iMap = new HashMap<String, Object>();

      iMap.put("promoId", Integer.toString(promoId));
      iMap.put("stkId", salesOrderDVO.getItmStkId());
      if (orderAppType == 67 || orderAppType == 68) {
        iMap.put("srvPacId", 0);
      } else {
        iMap.put("srvPacId", Integer.toString(srvPacId));
      }
      iMap.put("orderAppType", orderAppType);

      EgovMap oMap = this.selectProductPromotionPriceByPromoStockID(iMap);
      specialPromoMap = oMap;

      BigDecimal totAmt = new BigDecimal((String) oMap.get("orderPricePromo"));
      BigDecimal mthRentAmt = new BigDecimal((String) oMap.get("orderRentalFeesPromo"));
      BigDecimal totPv = new BigDecimal((String) oMap.get("orderPVPromo"));

      if("Y".equals(CommonUtils.nvl(orderVO.getHcSetOrdYn()))) {   // homecare order (Mattress + Frame)
    	  mthRentAmt = salesOrderMVO.getMthRentAmt();
      }else{
        logger.debug("@#### totAmt    :" + totAmt);
        logger.debug("@#### mthRentAmt:" + mthRentAmt);
        logger.debug("@#### totPv     :" + totPv);

        salesOrderMVO.setTotAmt(totAmt);
        salesOrderMVO.setMthRentAmt(mthRentAmt);
        salesOrderMVO.setDscntAmt(mthRentAmt);
      }

      // [07/11/2018]ONGHC - REMOVE TO SOLVE PV ISSUE
      // if(CommonUtils.intNvl(salesOrderMVO.getGstChk()) == 1) {
      // totAmt = totAmt.multiply(new BigDecimal(1/1.06)).setScale(0,
      // BigDecimal.ROUND_FLOOR);
      // mthRentAmt = mthRentAmt.multiply(new BigDecimal(1/1.06)).setScale(0,
      // BigDecimal.ROUND_FLOOR);
      // totAmt = totAmt.multiply(new BigDecimal(1/1.00)).setScale(0,
      // BigDecimal.ROUND_FLOOR);
      // mthRentAmt = mthRentAmt.multiply(new BigDecimal(1/1.00)).setScale(0,
      // BigDecimal.ROUND_FLOOR);
      // totPv = new BigDecimal((String)oMap.get("orderPVPromoGST"));

      // if(orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
      // totAmt = totAmt.divide(new BigDecimal(10), 0,
      // BigDecimal.ROUND_FLOOR).multiply(new BigDecimal(10));
      // }
      // }
    }
    // ------------------------------------------------------------------------------
    // END
    // ------------------------------------------------------------------------------

    // regOrderVO.setSalesOrderMVO(salesOrderMVO);
    regOrderVO.setSalesOrderDVO(salesOrderDVO);
    regOrderVO.setInstallationVO(installationVO);

    // this.preprocCustomerBillMaster(custBillMasterVO, sessionVO);

    if ("new".equals(billGrp)) {
      this.preprocCustomerBillMaster(custBillMasterVO, sessionVO);
      regOrderVO.setCustBillMasterVO(custBillMasterVO);

      this.preprocEStatementRequest(eStatementReqVO, sessionVO);
      regOrderVO.seteStatementReqVO(eStatementReqVO);
    }

    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL
        || orderAppType == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS) {

      this.preprocRentPaySetMaster(rentPaySetVO, sessionVO);
      regOrderVO.setRentPaySetVO(rentPaySetVO);

      if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
        this.preprocRentalSchemeMaster(rentalSchemeVO, sessionVO);
        regOrderVO.setRentalSchemeVO(rentalSchemeVO);
      }

      // CLAIM ADT
      this.preprocClaimAdtMaster(accClaimAdtVO, rentPaySetVO, sessionVO);
      regOrderVO.setAccClaimAdtVO(accClaimAdtVO);

      // CCP MASTER
      CcpDecisionMVO ccpDecisionMVO = new CcpDecisionMVO();
      this.preprocCcpMaster(ccpDecisionMVO, custTypeId, custRaceId, custNric, sessionVO);
      regOrderVO.setCcpDecisionMVO(ccpDecisionMVO);

      if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
        // SALES ORDER CONTRACT
        SalesOrderContractVO salesOrderContractVO = new SalesOrderContractVO();
        this.preprocSalesOrderContract(salesOrderContractVO, salesOrderMVO, sessionVO);
        regOrderVO.setSalesOrderContractVO(salesOrderContractVO);
      }
    }

    this.preprocDocumentList(docSubVOList, sessionVO);
    regOrderVO.setDocSubVOList(docSubVOList);

    if ((orderAppType != SalesConstants.APP_TYPE_CODE_ID_RENTAL
        && orderAppType != SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS)
    // || (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL && custTypeId
    // == SalesConstants.CUST_TYPE_CODE_ID_IND && custRaceId == 14)
    ) {
    	// Mattress Order - App Type : Rental AND Order App Type : Aux
    	if(CommonUtils.intNvl(orderVO.getMatAppTyId()) == SalesConstants.APP_TYPE_CODE_ID_RENTAL
	       && orderAppType == SalesConstants.APP_TYPE_CODE_ID_AUX) {
    		// CCP MASTER
    		CcpDecisionMVO ccpDecisionMVO = new CcpDecisionMVO();
    		this.preprocCcpMaster(ccpDecisionMVO, custTypeId, custRaceId, custNric, sessionVO);
    		regOrderVO.setCcpDecisionMVO(ccpDecisionMVO);

    	} else {
    		CallEntryVO callEntryVO = new CallEntryVO();
    		this.preprocCallEntryMaster(callEntryVO, orderAppType, sInstallDate, sessionVO);
    		regOrderVO.setCallEntryVO(callEntryVO);
    	}
    }

    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {

      CallResultVO callResultVO = new CallResultVO();
      this.preprocCallResultDetails(callResultVO, dInstallDate, sessionVO);
      regOrderVO.setCallResultVO(callResultVO);

      InstallEntryVO installEntryVO = new InstallEntryVO();
      this.preprocInstallEntryMaster(installEntryVO, dInstallDate, itmStkId, sessionVO);
      regOrderVO.setInstallEntryVO(installEntryVO);

      InstallResultVO installResultVO = new InstallResultVO();
      this.preprocInstallResultDetails(installResultVO, dInstallDate, sessionVO);
      regOrderVO.setInstallResultVO(installResultVO);

      SrvMembershipSalesVO srvMembershipSalesVO = new SrvMembershipSalesVO();
      this.preprocMembershipSalesMaster(srvMembershipSalesVO, sessionVO);
      regOrderVO.setSrvMembershipSalesVO(srvMembershipSalesVO);

      SrvConfigurationVO srvConfigurationVO = new SrvConfigurationVO();
      this.preprocConfigMaster(srvConfigurationVO, dInstallDate, sessionVO);
      regOrderVO.setSrvConfigurationVO(srvConfigurationVO);

      List<SrvConfigSettingVO> srvConfigSettingVOList = new ArrayList<SrvConfigSettingVO>();
      this.preprocConfigSettingList(srvConfigSettingVOList, sessionVO);
      regOrderVO.setSrvConfigSettingVOList(srvConfigSettingVOList);

      SrvConfigPeriodVO srvConfigPeriodVO = new SrvConfigPeriodVO();
      this.preprocConfigPeriod(srvConfigPeriodVO, sessionVO);
      regOrderVO.setSrvConfigPeriodVO(srvConfigPeriodVO);

      List<SrvConfigFilterVO> srvConfigFilterVOList = this.preprocConfigFilterList(dInstallDate, itmStkId, sessionVO);
      regOrderVO.setSrvConfigFilterVOList(srvConfigFilterVOList);
    }

    // SALES ORDER LOG
    List<SalesOrderLogVO> salesOrderLogVOList = new ArrayList<SalesOrderLogVO>();
    this.preprocOrderLog(salesOrderLogVOList, orderAppType, custTypeId, custRaceId, sessionVO);
    regOrderVO.setSalesOrderLogVOList(salesOrderLogVOList);

    // GST CERTIFICATE
    if (gSTEURCertificateVO != null && gSTEURCertificateVO.getAtchFileGrpId() > 0) {
      this.preprocGSTCertificate(gSTEURCertificateVO, orderAppType, sessionVO);
      regOrderVO.setgSTEURCertificateVO(gSTEURCertificateVO);
    }

    // AS ENTRY
    int count = orderRegisterMapper.chkCrtAS(salesOrderDVO);
    if (count > 0) {
      ASEntryVO aSEntryVO = new ASEntryVO();
      this.preprocASEntry(aSEntryVO, sessionVO);
      String asNo = orderRegisterMapper.selectDocNo(DocTypeConstants.AS_ENTRY);
      aSEntryVO.setAsNo(asNo);
      aSEntryVO.setAsAppntDt(installationVO.getPreDt());
      aSEntryVO.setAsBrnchId(brnchId);

      regOrderVO.setASEntryVO(aSEntryVO);
      orderVO.setASEntryVO(aSEntryVO);
    }

    // GET ORDER NUMBER
    String salesOrdNo = "";
    String newOrdNoFirst = "";
    int copyQty = orderVO.getCopyQty();

    if ("Y".equals(orderVO.getCopyOrderBulkYN())) {

      logger.debug("Multi Order Create Start!!!");

      Map<String, Object> pMap = new HashMap<String, Object>();

      pMap.put("copyQty", orderVO.getCopyQty());

      if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
        pMap.put("docNoId", DocTypeConstants.CSALES_NO);
      } else {
        pMap.put("docNoId", DocTypeConstants.SALES_NO);
      }

      salesOrdNo = orderRegisterMapper.selectDocNoS(pMap);

      int newOrdNo = 0;

      for (int i = 0; i < copyQty; i++) {
        newOrdNo = Integer.valueOf(salesOrdNo) - copyQty + i;

        if (i == 0)
          newOrdNoFirst = String.valueOf(newOrdNo);

        logger.debug("newOrdNo:" + CommonUtils.intNvl(newOrdNo));

        salesOrderMVO.setSalesOrdNo(Integer.toString(newOrdNo));

        regOrderVO.setSalesOrderMVO(salesOrderMVO);

        this.doSaveOrder(regOrderVO);
      }

      orderVO.setSalesOrdNoFirst(newOrdNoFirst);
    } else {
      logger.debug("Sigle Order Create Start!!!");

      if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
        salesOrdNo = orderRegisterMapper.selectDocNo(DocTypeConstants.CSALES_NO);
      } else {
        salesOrdNo = orderRegisterMapper.selectDocNo(DocTypeConstants.SALES_NO);
      }

      salesOrderMVO.setSalesOrdNo(salesOrdNo);

      if ("Y".equals(orderVO.getPreOrderYN()))
        salesOrderMVO.setPreOrdId(orderVO.getPreOrdId());

      logger.info("!@#### GET NEW ORDER_NO  :" + salesOrdNo);

      regOrderVO.setSalesOrderMVO(salesOrderMVO);

      this.doSaveOrder(regOrderVO);
    }

    int salesOrdId = CommonUtils.intNvl(regOrderVO.getSalesOrderMVO().getSalesOrdId());

    if ("Y".equals(orderVO.getPreOrderYN())) {
      PreOrderVO preOrderVO = new PreOrderVO();

      preOrderVO.setPreOrdId(orderVO.getPreOrdId());
      preOrderVO.setUpdUserId(sessionVO.getUserId());
      preOrderVO.setStusId(SalesConstants.STATUS_COMPLETED);
      preOrderVO.setSalesOrdId(salesOrdId);

      preOrderMapper.updatePreOrderStatus(preOrderVO);
    }else if(CommonUtils.nvl(salesOrderMVO.getEcommOrdId()) != ""){
      ecommApiMapper.updateEcommOrderStatus(salesOrderMVO);
    }

    // Set Sales_Order_ID - KR-SH
    salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(salesOrdId));

    // SAL0408D SPECIAL PROMOTION - DISCOUNT ON BILLING
    if (CommonUtils.intNvl(specialPromoMap.get("promoDiscOnBillCode")) > 01 && orderAppType != SalesConstants.APP_TYPE_CODE_ID_AUX) {
      EgovMap params = new EgovMap();
      params.put("custId", salesOrderMVO.getCustId());
      params.put("salesOrdIdOld", salesOrderMVO.getSalesOrdIdOld());
      //EgovMap preBookInfo = hcPreBookingOrderMapper.selectPreBookOrderEligibleCheck(params);

    	if(CommonUtils.intNvl(specialPromoMap.get("promoDiscOnBillCode"))  == 02){
    		EgovMap map1 = new EgovMap();
    		map1.put("salesOrdId",salesOrderMVO.getSalesOrdId());
    		map1.put("fromPeriod",2);
    		map1.put("toPeriod",7);
    		map1.put("promoId",CommonUtils.intNvl(salesOrderMVO.getPromoId()));
    		map1.put("percentage",50);
    		BigDecimal CNamt = salesOrderMVO.getMthRentAmt().divide(new BigDecimal(2),0,RoundingMode.DOWN);
    		map1.put("cnAmt",CNamt);
    		map1.put("status",1);
    		map1.put("userId",sessionVO.getUserId());

    		orderRegisterMapper.insertSalesSpecialPromotion(map1);

    	}
    	else if(CommonUtils.intNvl(specialPromoMap.get("promoDiscOnBillCode"))  == 04){
    		EgovMap map1 = new EgovMap();
    		map1.put("salesOrdId",salesOrderMVO.getSalesOrdId());
    		map1.put("fromPeriod",1);
    		map1.put("toPeriod",6);
    		map1.put("promoId",CommonUtils.intNvl(salesOrderMVO.getPromoId()));
    		map1.put("percentage",50);
    		BigDecimal CNamt = salesOrderMVO.getMthRentAmt().divide(new BigDecimal(2),0,RoundingMode.DOWN);
    		map1.put("cnAmt",CNamt);
    		map1.put("status",1);
    		map1.put("userId",sessionVO.getUserId());
    		orderRegisterMapper.insertSalesSpecialPromotion(map1);
    	}
    	//SAL0408D SPECIAL PROMOTION - DISCOUNT ON BILLING (PRE-BOOK EXTRADE)
//    	else if(CommonUtils.intNvl(specialPromoMap.get("promoDiscOnBillCode"))  == 02 && preBookInfo != null){
//    		int preBookId = CommonUtils.intNvl(preBookInfo.get("preBookId"));
//            int discWaive = CommonUtils.intNvl(preBookInfo.get("discWaive"));
//            String custVerifyStus = CommonUtils.nvl(preBookInfo.get("custVerifyStus"));
//            //int preBookPeriod = CommonUtils.intNvl(preBookInfo.get("preBookPeriod"));
//
//            if (custVerifyStus.equals("Y") && salesOrderMVO.getAppTypeId() == SalesConstants.APP_TYPE_CODE_ID_RENTAL ) {
//              params.put("module", "PRE_BOOK");
//              params.put("subModule", "PRE_BOOK");
//              if (discWaive == 4) {
//                params.put("paramCode", "DISC_WAIVE_4MTH");
//              } else if (discWaive == 3) {
//                params.put("paramCode", "DISC_WAIVE_3MTH");
//              } else if (discWaive == 2) {
//                params.put("paramCode", "DISC_WAIVE_2MTH");
//              } else if (discWaive == 1) {
//                params.put("paramCode", "DISC_WAIVE_1MTH");
//              } else{
//                // NOT ELIGIBLE FOR PRE BOOK PROMOTION DISCOUNT
//                params.put("paramCode", "DISC_WAIVE_0MTH");
//              }
//              // GET DISCOUNT PERIOD FROM SYS0098M
//              int discountPeriod = commonMapper.selectSystemConfigurationParamValue(params);
//
//              if(discountPeriod != 0){
//              EgovMap params2 = new EgovMap();
//              params2.put("salesOrdId",salesOrderMVO.getSalesOrdId());
//              params2.put("fromPeriod",2);
//              params2.put("toPeriod",discountPeriod + 1);
//              params2.put("promoId",CommonUtils.intNvl(salesOrderMVO.getPromoId()));
//              params2.put("percentage",50);
//              BigDecimal cnAmt = salesOrderMVO.getMthRentAmt().divide(new BigDecimal(2),0,RoundingMode.DOWN);
//              params2.put("cnAmt",cnAmt);
//              params2.put("status",SalesConstants.STATUS_ACTIVE);
//              params2.put("userId",salesOrderMVO.getCrtUserId());
//
//              // INSERT INTO SAL0408D FOR RENT DISCOUNT
//              orderRegisterMapper.insertSalesSpecialPromotion(params2);
//
//              params.put("updUserId", salesOrderMVO.getCrtUserId());
//              params.put("stusId", SalesConstants.STATUS_COMPLETED);
//              params.put("preBookId", preBookId);
//              params.put("rem", "Complete extrade with New Sales Order No :" + salesOrderMVO.getSalesOrdNo());
//              // UPDATE SAL0404M STUS TO COMPLETE
//              int rtnCnt = 0;
//              rtnCnt = hcPreBookingOrderMapper.updateHcPreBookOrderStatus(params);
//
//              if (rtnCnt <= 0) { // not updated
//                throw new ApplicationException(AppConstants.FAIL, "Order Register Failed. - Pre Book");
//              }
//            }
//           }
//    	}
    }
  }

  private void doSaveOrder(OrderVO orderVO) {

    logger.info("!@###### OrderRegisterServiceImpl.doSaveOrder");

    SalesOrderMVO salesOrderMVO = orderVO.getSalesOrderMVO();
    SalesOrderDVO salesOrderDVO = orderVO.getSalesOrderDVO();
    InstallationVO installationVO = orderVO.getInstallationVO();
    RentPaySetVO rentPaySetVO = orderVO.getRentPaySetVO();
    CustBillMasterVO custBillMasterVO = orderVO.getCustBillMasterVO();
    EStatementReqVO eStatementReqVO = orderVO.geteStatementReqVO();
    AccClaimAdtVO accClaimAdtVO = orderVO.getAccClaimAdtVO();
    RentalSchemeVO rentalSchemeVO = orderVO.getRentalSchemeVO();
    CcpDecisionMVO ccpDecisionMVO = orderVO.getCcpDecisionMVO();
    List<DocSubmissionVO> docSubVOList = orderVO.getDocSubVOList();
    CallEntryVO callEntryVO = orderVO.getCallEntryVO();
    CallResultVO callResultVO = orderVO.getCallResultVO();
    InstallEntryVO installEntryVO = orderVO.getInstallEntryVO();
    InstallResultVO installResultVO = orderVO.getInstallResultVO();
    SrvMembershipSalesVO srvMembershipSalesVO = orderVO.getSrvMembershipSalesVO();
    SrvConfigurationVO srvConfigurationVO = orderVO.getSrvConfigurationVO();
    List<SrvConfigSettingVO> srvConfigSettingVOList = orderVO.getSrvConfigSettingVOList();
    SrvConfigPeriodVO srvConfigPeriodVO = orderVO.getSrvConfigPeriodVO();
    List<SrvConfigFilterVO> srvConfigFilterVOList = orderVO.getSrvConfigFilterVOList();
    List<SalesOrderLogVO> salesOrderLogVOList = orderVO.getSalesOrderLogVOList();
    GSTEURCertificateVO gSTEURCertificateVO = orderVO.getgSTEURCertificateVO();
    SalesOrderContractVO salesOrderContractVO = orderVO.getSalesOrderContractVO();
    ASEntryVO asEntryVO = orderVO.getASEntryVO();

    int orderAppType = orderVO.getOrderAppType();

    int salesOrdId = 0;

    int compId = salesOrderDVO.getItmCompId();

    String installDate = installationVO.getPreDt();

    // SALES ORDER MASTER
    logger.info("!@#### ORDER_ID  :" + salesOrderMVO.getSalesOrdId());
    orderRegisterMapper.insertSalesOrderM(salesOrderMVO);
    logger.info("!@#### GET NEW ORDER_ID  :" + salesOrderMVO.getSalesOrdId());

    salesOrdId = (int) salesOrderMVO.getSalesOrdId();

    // SALES ORDER DETAILS
    salesOrderDVO.setSalesOrdId(salesOrdId);
    orderRegisterMapper.insertSalesOrderD(salesOrderDVO);

    // is Mattress
   // Homecare orders insert CS table automatically by Hui Ding, 17/03/2023
    EgovMap stkMap = orderRegisterMapper.getCtgryCode(salesOrderDVO.getItmStkId());
    String catCode = CommonUtils.nvl(stkMap.get("stkCatCode"));

    if (catCode.equalsIgnoreCase(HomecareConstants.HC_CTGRY_CD.MAT)
    	|| (catCode.equalsIgnoreCase(HomecareConstants.HC_CTGRY_CD.FRM) && orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL)
    	|| catCode.equalsIgnoreCase(HomecareConstants.HC_CTGRY_CD.ACI)
    	|| catCode.equalsIgnoreCase(HomecareConstants.HC_CTGRY_CD.MC)
    	) {

    	salesOrderMVO.setSalesProdSz(CommonUtils.nvl(stkMap.get("stkSize")));
    	orderRegisterMapper.insert_SAL0225D(salesOrderMVO);

    	// Homecare Air Con Combo package orders by Fannie, 09/05/2023
    	if(catCode.equalsIgnoreCase(HomecareConstants.HC_CTGRY_CD.ACI))
    	{
    	     Map<String, Object> acMap = new HashMap<String, Object>();
    	     logger.info("[OrderRegisterServiceImpl - doSaveOrder - HC_CTGRY_CD.ACI ] getComboOrdBind :: " + salesOrderMVO.getComboOrdBind());

    	     int packageBindingId = salesOrderMVO.getComboOrdBind();

    	     if(packageBindingId > 0)
    	     {
    	           acMap.put("salesOrdId", salesOrderMVO.getComboOrdBind());
    	           acMap.put("subSalesOrdId", salesOrderMVO.getSalesOrdId());

    	     }else {
    	          acMap.put("salesOrdId", salesOrderMVO.getSalesOrdId());
    	          acMap.put("subSalesOrdId", salesOrderMVO.getSalesOrdId());
    	     }

    	     acMap.put("promoNo", salesOrderMVO.getPromoId());
    	     acMap.put("prod", salesOrderDVO.getItmStkId());
    	     acMap.put("custId", salesOrderMVO.getCustId());
    	     acMap.put("crtUserId", salesOrderMVO.getCrtUserId());
    	     acMap.put("updUserId", salesOrderMVO.getUpdUserId());

    	     logger.info("[OrderRegisterServiceImpl - doSaveOrder - HC_CTGRY_CD.ACI ] acMap :: {} " + acMap);
    	     int mstOrdCmb = orderRegisterMapper.chkPromoCboMst(acMap);
    	     int subOrdCmb = orderRegisterMapper.chkPromoCboSub(acMap);

    	     if(mstOrdCmb > 0 || subOrdCmb > 0){
    	         orderRegisterMapper.insert_SAL0349D(acMap);
    	    }
    	}
    }

    // INSTALLATION
    installationVO.setSalesOrdId(salesOrdId);
    orderRegisterMapper.insertInstallation(installationVO);

    // CUSTOMER BILL MASTER
    if (custBillMasterVO != null && custBillMasterVO.getCustBillCustId() > 0) {
      String billGroupNo = orderRegisterMapper.selectDocNo(DocTypeConstants.BILLGROUP_NO);

      custBillMasterVO.setCustBillGrpNo(billGroupNo);
      custBillMasterVO.setCustBillSoId(salesOrdId);
      orderRegisterMapper.insertCustBillMaster(custBillMasterVO);

      logger.info("!@#### GET NEW CUST_BILL_ID  :" + custBillMasterVO.getCustBillId());

      salesOrderMVO.setCustBillId(custBillMasterVO.getCustBillId());
      orderRegisterMapper.updateCustBillId(salesOrderMVO);
    }

    if (eStatementReqVO != null && eStatementReqVO.getStusCodeId() > 0) {
      String eStatementReqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.ESTATEMENT_REQ);

      eStatementReqVO.setRefNo(eStatementReqNo);
      eStatementReqVO.setCustBillId(salesOrderMVO.getCustBillId());
      orderRegisterMapper.insertEStatementReq(eStatementReqVO);
    }

    // APP TYPE = RENTAL
    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {

      // RENTAL PAY SETTING
      if (rentPaySetVO != null && rentPaySetVO.getModeId() > 0) {
        rentPaySetVO.setSalesOrdId(salesOrdId);
        orderRegisterMapper.insertRentPaySet(rentPaySetVO);
      }

      // CLAIM ADT
      if (accClaimAdtVO != null && accClaimAdtVO.getAccClPayModeId() > 0) {
        accClaimAdtVO.setAccClSoId(salesOrdId);
        orderRegisterMapper.insertAccClaimAdt(accClaimAdtVO);
      }

      // RENTAL SCHEME
      if (rentalSchemeVO != null && CommonUtils.isNotEmpty(rentalSchemeVO.getStusCodeId())) {
        rentalSchemeVO.setSalesOrdId(salesOrdId);
        orderRegisterMapper.insertRentalScheme(rentalSchemeVO);
      }

      // CCP DECISION MASTER
      if (ccpDecisionMVO != null && ccpDecisionMVO.getCcpStusId() > 0) {
        ccpDecisionMVO.setCcpSalesOrdId(salesOrdId);
        orderRegisterMapper.insertCcpDecisionM(ccpDecisionMVO);
        orderRegisterMapper.updatePreccpScore(ccpDecisionMVO);
      }

      // SALES ORDER CONTRACT
      if (salesOrderContractVO != null && salesOrderContractVO.getCntrctStusId() > 0) {
        salesOrderContractVO.setCntrctSalesOrdId(salesOrdId);
        orderRegisterMapper.insertSalesOrderContract(salesOrderContractVO);
      }
    }

    // APP TYPE = AUX -  Add KR-SH
    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_AUX) {
      // CCP DECISION MASTER
      if (ccpDecisionMVO != null && ccpDecisionMVO.getCcpStusId() > 0) {
        ccpDecisionMVO.setCcpSalesOrdId(salesOrdId);
        orderRegisterMapper.insertCcpDecisionM(ccpDecisionMVO);
        orderRegisterMapper.updatePreccpScore(ccpDecisionMVO);
      }
    }

    // DOCUMENT SUBMISSION
    if (docSubVOList != null && docSubVOList.size() > 0) {
      for (DocSubmissionVO docSubVO : docSubVOList) {
        docSubVO.setDocSoId(salesOrdId);
        orderRegisterMapper.insertDocSubmission(docSubVO);
      }
    }

    // CALL ENTRY MASTER
    if (callEntryVO != null && (int) callEntryVO.getStusCodeId() > 0) {
      callEntryVO.setSalesOrdId(salesOrdId);
      callEntryVO.setDocId(salesOrdId);
      orderRegisterMapper.insertCallEntry(callEntryVO);
    }

    // APP TYPE = SERVICE
    if (orderAppType == SalesConstants.APP_TYPE_CODE_ID_SERVICE) {
      // CALL RESULT
      if (callResultVO != null && callResultVO.getCallStusId() > 0) {
        callResultVO.setCallEntryId(callEntryVO.getCallEntryId());
        orderRegisterMapper.insertCallResult(callResultVO);

        callEntryVO.setResultId(callResultVO.getCallResultId());
        // TODO callEntryVO UPDATE
      }

      // INSTALL ENTRY
      if (installEntryVO != null && installEntryVO.getStusCodeId() > 0) {
        String installNo = orderRegisterMapper.selectDocNo(DocTypeConstants.INSTALL_NO);

        installEntryVO.setCallEntryId(callEntryVO.getCallEntryId());
        installEntryVO.setInstallEntryNo(installNo);
        installEntryVO.setSalesOrdId(salesOrdId);
        orderRegisterMapper.insertInstallEntry(installEntryVO);
      }

      // INSTALL RESULT
      if (installResultVO != null && installResultVO.getStusCodeId() > 0) {
        installResultVO.setEntryId(installEntryVO.getInstallEntryId());
        orderRegisterMapper.insertInstallResult(installResultVO);

        installEntryVO.setInstallResultId(installResultVO.getResultId());
        // TODO installEntryVO UPDATE
      }

      // MEMBERSHIP SALES
      if (srvMembershipSalesVO != null && srvMembershipSalesVO.getSrvStusCodeId() > 0) {
        String membershipNo = orderRegisterMapper.selectDocNo(DocTypeConstants.MEMBERSHIP_NO);

        srvMembershipSalesVO.setSrvMemNo(membershipNo);
        srvMembershipSalesVO.setSrvSalesOrdId(salesOrdId);
        orderRegisterMapper.insertSrvMembershipSales(srvMembershipSalesVO);
      }

      // CONFIGURATION
      if (srvConfigurationVO != null && srvConfigurationVO.getSrvStusId() > 0) {
        srvConfigurationVO.setSrvSoId(salesOrdId);
        orderRegisterMapper.insertSrvConfiguration(srvConfigurationVO);
      }

      // CONFIG SETTING
      if (srvConfigSettingVOList != null && srvConfigSettingVOList.size() > 0) {
        for (SrvConfigSettingVO srvConfigSettingVO : srvConfigSettingVOList) {
          srvConfigSettingVO.setSrvConfigId(srvConfigurationVO.getSrvConfigId());
          orderRegisterMapper.insertSrvConfigSetting(srvConfigSettingVO);
        }
      }

      // CONFIG PERIOD
      if (srvConfigPeriodVO != null && srvConfigPeriodVO.getSrvPrdStusId() > 0) {
        srvConfigPeriodVO.setSrvConfigId(srvConfigurationVO.getSrvConfigId());
        orderRegisterMapper.insertSrvConfigPeriod(srvConfigPeriodVO);
      }

      // CONFIG FILTER
      if (srvConfigFilterVOList != null && srvConfigFilterVOList.size() > 0) {
        for (SrvConfigFilterVO srvConfigFilterVO : srvConfigFilterVOList) {
          srvConfigFilterVO.setSrvConfigId(srvConfigurationVO.getSrvConfigId());
          orderRegisterMapper.insertSrvConfigFilter(srvConfigFilterVO);
        }

      }
    }

    // INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
    if (salesOrderLogVOList != null && salesOrderLogVOList.size() > 0) {
      for (SalesOrderLogVO salesOrderLogVO : salesOrderLogVOList) {
        if (salesOrderLogVO.getPrgrsId() == 1) {
          salesOrderLogVO.setRefId(ccpDecisionMVO.getCcpId());
        } else if (salesOrderLogVO.getPrgrsId() == 2) {
          if (callEntryVO != null) {
            salesOrderLogVO.setRefId(CommonUtils.intNvl(callEntryVO.getCallEntryId()));
          } else {
            salesOrderLogVO.setRefId(0);
          }
        } else if (salesOrderLogVO.getPrgrsId() == 5) {
          salesOrderLogVO.setRefId(installEntryVO.getInstallEntryId());
        }
        salesOrderLogVO.setSalesOrdId(salesOrdId);
        orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
      }
    }

    // INSERT GST CERTIFICATE
    if (gSTEURCertificateVO != null) {
      gSTEURCertificateVO.setEurcSalesOrdId(salesOrdId);
      orderRegisterMapper.insertGSTEURCertificate(gSTEURCertificateVO);
    }

    //if (compId == 2 || compId == 3 || compId == 4) {
      if (asEntryVO != null) {
        // String asNo =
        // orderRegisterMapper.selectDocNo(DocTypeConstants.AS_ENTRY);
        // asEntryVO.setAsNo(asNo);
        asEntryVO.setAsSoId(salesOrdId);
        orderRegisterMapper.insertASEntry(asEntryVO);
      }
    //}

      	//Update customer marketing message status(universal between HC/HA)
      	Map<String, Object> params = new HashMap();
        params.put("custId",salesOrderMVO.getCustId());
        params.put("updUserId", salesOrderMVO.getUpdUserId());
        params.put("receivingMarketingMsgStatus", salesOrderMVO.getReceivingMarketingMsgStatus());
        orderRegisterMapper.updateMarketingMessageStatus(params);

		/*
		 * If got voucher, updated voucher to use state
		 */
		if(CommonUtils.isEmpty(salesOrderMVO.getVoucherCode()) == false){
			Map<String,Object> voucherParam = new HashMap();
			voucherParam.put("voucherCode", salesOrderMVO.getVoucherCode());
			voucherParam.put("salesOrdNo", salesOrderMVO.getSalesOrdNo());
			voucherParam.put("updBy", salesOrderMVO.getUpdUserId());
			voucherParam.put("isUsed", 1);
			voucherMapper.updateVoucherCodeUseStatus(voucherParam);
		}

      try{
    	Map<String,Object> preccpParam = new HashMap();
    	preccpParam.put("salesOrdId", salesOrderMVO.getSalesOrdId());
    	EgovMap checkPreCcp= orderRegisterMapper.checkPreCcp(preccpParam);
    	if(checkPreCcp != null){
    		if(checkPreCcp.get("preccpChk").toString().equals("1")){
    			 orderRegisterMapper.automatedCcpProcess(preccpParam);
    		}
    	}
      }catch(Exception e){

      }
  }

  @Override
  public List<EgovMap> selectProductCodeList(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return orderRegisterMapper.selectProductCodeList(params);
  }

  @Override
  public List<EgovMap> selectServicePackageList(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return orderRegisterMapper.selectServicePackageList(params);
  }

  @Override
  public List<EgovMap> selectServicePackageList2(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return orderRegisterMapper.selectServicePackageList2(params);
  }

  @Override
  public List<EgovMap> selectPrevOrderNoList(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return orderRegisterMapper.selectPrevOrderNoList(params);
  }

  public List<EgovMap> selectProductComponent(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return orderRegisterMapper.selectProductComponent(params);
  }

  public List<EgovMap> selectPromoBsdCpnt(Map<String, Object> params) {
    return orderRegisterMapper.selectPromoBsdCpnt(params);
  }

  public List<EgovMap> selectPromoBsdCpntESales(Map<String, Object> params) {
	    return orderRegisterMapper.selectPromoBsdCpntESales(params);
	  }

  @Override
  public EgovMap selectProductComponentDefaultKey(Map<String, Object> params) {
    EgovMap cpntKey = orderRegisterMapper.selectProductComponentDefaultKey(params);
    return cpntKey;
  }

  @Override
  public EgovMap selectEKeyinSofCheck(Map<String, Object> params) {
    return orderRegisterMapper.selectEKeyinSofCheck(params);
  }

  @Override
  public List<EgovMap> mailAddrViewHistoryAjax(Map<String, Object> params) {
    List<EgovMap> lst = orderRegisterMapper.mailAddrViewHistoryAjax(params);
    return lst;
  }

  @Override
  public List<EgovMap> instAddrViewHistoryAjax(Map<String, Object> params) {
    List<EgovMap> lst = orderRegisterMapper.instAddrViewHistoryAjax(params);
    return lst;
  }

  @Override
  public int chkPromoCboMst(Map<String, Object> params) {
    /*
     * CODE              DESCRIPTION
     * ----------------------------------------
     * 1                 IS NORMAL PROMOTION NO RELATED TO COMBO SET
     * 2                 IS MASTER COMBO PACKAGE
     * 3                 HAVE MASTER COMBO ORDER TO MAP
     * 4                 PLEASE CREATE A MASTER COMBP TO MAP
     *
     * 99                SELECTED PROMOTION CODE ARE NOT FOR NEW SALES (FOR CANCELLATION)
     */

    // CHECK SELECTED PROMO. ARE USED FOR CANCELLATION
    int canCnt = orderRegisterMapper.chkPromoCboCan(params);

    if (canCnt == 0) {

      int mstCnt = orderRegisterMapper.chkPromoCboMst(params);
      int subCnt;
      int canMapCnt;
      if (mstCnt > 0) { // IS MASTER COMBO SELECTION
        // PASS
        return 2;
      } else { // MAYBE IS SUB COMBO OR NOT COMBO PACKAGE
        subCnt = orderRegisterMapper.chkPromoCboSub(params);
        if (subCnt > 0) { // IS SUB COMBO
          // CHECH CUSTOMER HAVE ANY MASTER COMBO
          canMapCnt = orderRegisterMapper.chkCanMapCnt(params);

          if (canMapCnt > 0) {
            // PASS
            return 3;
          } else {
            // FAIL
            return 4;
          }
        } else { // IS NORMAL PROMOTION
          // PASS
          return 1;
        }
      }
    } else {
      return 99;
    }
  }

  @Override
  public int chkCboBindOrdNo(Map<String, Object> params) {
     return orderRegisterMapper.chkCboBindOrdNo(params);
  }


  @Override
  public List<EgovMap> selectComboOrderJsonList(Map<String, Object> params) {
    List<EgovMap> lst = orderRegisterMapper.selectComboOrderJsonList(params);
    return lst;
  }

  @Override
  public List<EgovMap> selectComboOrderJsonList_2(Map<String, Object> params) {
    List<EgovMap> lst = orderRegisterMapper.selectComboOrderJsonList_2(params);
    return lst;
  }

  @Override
  public int checkCboPromByOrdNo(Map<String, Object> params) {
    /*
     * CODE              DESCRIPTION
     * ----------------------------------------
     * MASTER
     * 10                 IS NORMAL PROMOTION NO RELATED TO COMBO SET
     * SUB
     * 20                ORDER ARE SUB COMBO PACKAGE PRODUCT AND HAVE LINKAGE WITH ORDER. REQUEST APPROVE.
     * ERROR
     * 98                SELECTED ORDER'S PROMOTION ARE UNDER COMBO PACKAGE PROMOTION BUT DOES NOT HAVE ANY LINKAGE WITH OTHER ORDER. REQUEST DENY.
     * 99                SELECTED ORDER'S PROMOTION ARE NOT COMBO PACKAGE PROMOTION. REQUEST DENY.
     */

    // CHECK SELECTED PROMO. ARE USED FOR CANCELLATION
    String cboTyp = (String) CommonUtils.nvl(orderRegisterMapper.chkPromoCboByOrd(params));

    if (!cboTyp.equals("")) {
      /*
       * COMBO TYPE
       * -----------------------------------
       *  M                MASTER PRODUCT
       *  S                SUB PRODUCT
       */

      if (cboTyp.equals("M")) {
        return 10;
      } else if (cboTyp.equals("S")) {
        int cntOrdLnk = orderRegisterMapper.chkOrdLink(params);
        if (cntOrdLnk > 0) {
          return 20;
        } else {
          return 98;
        }
      } else {
        return 99;
      }
    } else {
      return 99;
    }
  }

  @Override
  public EgovMap getOrdInfo(Map<String, Object> params) {
    EgovMap ordInfo = orderRegisterMapper.getOrdInfo(params);
    return ordInfo;
  }

  @Override
  public List<EgovMap> selectPrevMatOrderNoList(Map<String, Object> params) {
    return orderRegisterMapper.selectPrevMatOrderNoList(params);
  }

  @Override
  public String selectPrevMatOrderAppTypeId(Map<String, Object> params) {
	  return orderRegisterMapper.selectPrevMatOrderAppTypeId(params);
  }

  @Override
  public EgovMap selectShiIndexInfo(String params) {
	  return orderRegisterMapper.selectShiIndexInfo(params);
  }

  @Override
  public EgovMap getExTradeConfig(){
	  EgovMap exTradeConfig = orderRegisterMapper.getExTradeConfig();
	  return exTradeConfig;
  }

  @Override
  public EgovMap getCtgryCode(Map<String, Object> params){
	  EgovMap stkMap = orderRegisterMapper.getCtgryCode(Integer.parseInt(params.get("stkId").toString()));
	  String catCode = CommonUtils.nvl(stkMap.get("stkCatCode"));
	  EgovMap catCodeMap = new EgovMap();
	  catCodeMap.put("catCode", catCode);
	  return catCodeMap;
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
    return orderRegisterMapper.selectPreBookSalesPerson(params);
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
    return orderRegisterMapper.selectPreBookConfigurationPerson(params);
  }

  @Override
  public EgovMap checkOldOrderServiceExpiryMonth(Map<String, Object> params){
	    int getOldOrderID = 0;
	    EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("salesOrdNo"));

	    if (ordInfo != null) {
	      getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
	    }

	    EgovMap orderExpiryMonth = orderRegisterMapper.selectSvcExpire(getOldOrderID);

	    return orderExpiryMonth;
  }

  @Override
  public ReturnMessage checkExtradeWithPromoOrder(Map<String, Object> params){
	ReturnMessage result = new ReturnMessage();
	int getOldOrderID = 0;

	EgovMap ordInfo = orderRegisterMapper.selectOldOrderId((String) params.get("oldOrderNo"));
	if (ordInfo != null) {
		getOldOrderID = CommonUtils.intNvl(Integer.parseInt(String.valueOf(ordInfo.get("salesOrdId"))));
		params.put("oldOrdId", getOldOrderID);
	}
	else{
		result.setCode("99");
		result.setMessage("No Order found for " + params.get("oldOrderNo").toString());
		return result;
	}

	EgovMap getExpDate = orderRegisterMapper.selectSvcExpire(getOldOrderID);
	if (getExpDate == null) {
		result.setCode("99");
		result.setMessage("No SVM found for order no. " + params.get("oldOrderNo").toString());
		return result;
	}

	if(params.get("isHomeCare") != null && params.get("isHomeCare").equals('Y')){
		if(!"Y".equals(getExpDate.get("extradeAllowFlg").toString())) {
			//svm expired within one month, just able to do extrade, else block.

			result.setCode("99");
			result.setMessage("Not able to extrade as SVM is not expired within 1 month. Please choose another order");
			return result;
		}
	}
	else{
    	if(params.get("appTypeId").equals("66") && params.get("extradeId").equals("1")){ //RENTAL APPTYPE WITH EXTRADE ONLY
    		//promoId
    		//oldOrderNo
    		//oldOrdId
    		//extradeId
    		EgovMap promoInfo = orderRegisterMapper.getPromotionInfoExtradeAppType(params);
    		if(promoInfo != null){
    			String promoExtradeAppTypeCode = CommonUtils.nvl(promoInfo.get("code"));
    			if(promoExtradeAppTypeCode == ""){
    				result.setCode("99");
    				result.setMessage("Promotion Extrade App Type is not set. Please contact relavent department");
    				return result;
    			}
    			if(promoExtradeAppTypeCode.equals("1") && !ordInfo.get("appTypeId").toString().equals("66")){
    				result.setCode("99");
    				result.setMessage("Promotion selected is only for extrade rental order");
    				return result;
    			}

    			if(promoExtradeAppTypeCode.equals("2") && ordInfo.get("appTypeId").toString().equals("66")){
    				result.setCode("99");
    				result.setMessage("Promotion selected is only for extrade non-rental order");
    				return result;
    			}
    		}
    		else{
				result.setCode("99");
				result.setMessage("Promotion not found. Please contact relavant department");
				return result;
    		}


    		if(ordInfo.get("appTypeId").toString().equals("66")){ //Old order must be rental && promotion extradeAppType = Rental(1)
    			EgovMap eligibleResult = orderRegisterMapper.rentalExtradeEligibility(params);

    			if(eligibleResult != null && eligibleResult.get("result").toString().equals("Y")){
    				result.setCode("1");
    				result.setMessage("Extrade can be proceed");
    			}
    			else{
    				result.setCode("99");
    				result.setMessage("Order is not eligible for current promotion selected");
    				return result;
    			}
    		}
    		else{
    			if(!"Y".equals(getExpDate.get("extradeAllowFlg").toString())) {
    				//svm expired within one month, just able to do extrade, else block.

    				result.setCode("99");
    				result.setMessage("Not able to extrade as SVM is not expired within 1 month. Please choose another order");
    				return result;
    			}
    		}
    	}else{
    		if(!"Y".equals(getExpDate.get("extradeAllowFlg").toString())) {
    			//svm expired within one month, just able to do extrade, else block.

    			result.setCode("99");
    			result.setMessage("Not able to extrade as SVM is not expired within 1 month. Please choose another order");
    			return result;
    		}
    	}
	}
		return result;
  }
}
