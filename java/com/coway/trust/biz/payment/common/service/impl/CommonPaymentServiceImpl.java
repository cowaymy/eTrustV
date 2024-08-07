package com.coway.trust.biz.payment.common.service.impl;

import java.math.BigDecimal;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.sales.impl.htOrderListServiceImpl;
import com.coway.trust.biz.homecare.sales.htOrderRegisterService;
import com.coway.trust.biz.homecare.sales.impl.htOrderRegisterMapper;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.common.service.CommonPopupPaymentService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonPaymentService")
public class CommonPaymentServiceImpl extends EgovAbstractServiceImpl implements CommonPaymentService {

  private static Logger logger = LoggerFactory.getLogger(CommonPaymentServiceImpl.class);

  @Resource(name = "commonPaymentMapper")
  private CommonPaymentMapper commonPaymentMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "htOrderRegisterMapper")
  private htOrderRegisterMapper htOrderRegisterMapper;

  /**
   * Payment - Order Info 조회 : order No로 Order ID 조회하기
   *
   * @param params
   * @param model
   * @return
   *
   */
  @Override
  public EgovMap selectOrdIdByNo(Map<String, Object> params) {
    return commonPaymentMapper.selectOrdIdByNo(params);
  }

  /*****************************************************************************
   * Rental
   *
   ******************************************************************************/
  /**
   * Payment - Order Info Rental 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public List
   *         <RentalOrderView> GetRentalOrders(int orderId, bool
   *         getBillingGroup)
   */
  @Override
  public List<EgovMap> selectOrderInfoRental(Map<String, Object> params) {

    int rpfCnt = 0;
    int rpfCharge = 0;

    int rpfCn = 0;
    int rpfDn = 0;

    List<EgovMap> rcList = commonPaymentMapper.selectOrderInfoRental(params);

    Map<String, Object> newParams = null;
    EgovMap rpfCnMap = null;
    EgovMap rpfDnMap = null;
    Map<String, Object> billInfo = null;

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {

        newParams = new HashMap<String, Object>();
        newParams.put("orderId", obj.get("salesOrdId"));

        rpfCnt = Integer.parseInt(String.valueOf(obj.get("rpfCnt")));
        rpfCharge = Integer.parseInt(String.valueOf(obj.get("rpfCharge")));

        // rpfCnt 가 0보다 크면 CN/DN 값을 조회한다.
        if (rpfCnt > 0) {
          rpfCnMap = commonPaymentMapper.selectRPFCN(newParams);
          rpfDnMap = commonPaymentMapper.selectRPFDN(newParams);

          if (rpfCnMap != null && rpfCnMap.get("cnAmt") != null) {
            rpfCn = Integer.parseInt(String.valueOf(rpfCnMap.get("cnAmt")));
          }

          if (rpfDnMap.get("dnAmt") != null) {
            rpfDn = Integer.parseInt(String.valueOf(rpfDnMap.get("dnAmt")));
          }

          rpfCharge = rpfCharge + rpfCn + rpfDn;

          obj.put("totAmt", rpfCharge);
        }

        billInfo = this.getRentalPayInfoV2(newParams);

        obj.put("rpf", billInfo.get("rpf"));
        obj.put("lastPayment", billInfo.get("lastPayment"));
        obj.put("balance", billInfo.get("balance"));
        obj.put("rpfPaid", billInfo.get("rpfPaid"));
        obj.put("unBilledAmount", billInfo.get("unBilledAmount"));
        obj.put("unBilledCount", billInfo.get("unBilledCount"));
      }
    }

    return rcList;
  }

  /**
   * Payment - Order Info Rental Mega Deal여부 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @Override
  public EgovMap selectMegaDealByOrderId(Map<String, Object> params) {
    return commonPaymentMapper.selectMegaDealByOrderId(params);
  }

  /**
   * Payment - Order Info Rental Billing 정보 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public RentalPaymentInfo GetRentalPayInfoV2(int
   *         orderId)
   */
  public Map<String, Object> getRentalPayInfoV2(Map<String, Object> params) {

    double rpfCNAmount = 0.0D;
    double rpfNewCNAmount = 0.0D;
    double rpfDnAmount = 0.0D;
    double payTotal = 0.0D;
    double rpfTotalBill = 0.0D;
    double rpfReversed = 0.0D;
    double revPaymentAmt = 0.0D;

    double rpf = 0.0D;
    double rf = 0.0D;
    double rpfPaid = 0.0D;
    String lastPayDt = "1900-01-01";
    int currentInstallment = 0;
    int unbillCount = 0;
    int lastBilledInstallment = 0;
    double unbillAmount = 0.0D;
    double billTotal = 0.0D;
    double totalAmt = 0.0D;
    String orderRentalAccntStatus = "";

    /*********************************************************
     * rpfTotal Bill Amount값 계산
     *********************************************************/
    EgovMap rpfTotBillMap = commonPaymentMapper.selectRpfTotBillAmount(params);

    if (rpfTotBillMap != null && rpfTotBillMap.get("rpfTotBill") != null) {
      rpfTotalBill = Double.parseDouble(String.valueOf(rpfTotBillMap.get("rpfTotBill")));
    }

    /*********************************************************
     * CN값 계산
     *********************************************************/
    EgovMap rpfCnMap = commonPaymentMapper.selectRpfCnAmount(params);
    EgovMap rpfNewCnMap = commonPaymentMapper.selectRpfCnNewAmount(params);

    if (rpfCnMap != null && rpfCnMap.get("cnAmt") != null) {
      rpfCNAmount = Double.parseDouble(String.valueOf(rpfCnMap.get("cnAmt")));
    }

    if (rpfNewCnMap != null && rpfNewCnMap.get("cnNewAmt") != null) {
      rpfNewCNAmount = Double.parseDouble(String.valueOf(rpfNewCnMap.get("cnNewAmt")));
    }

    // CN 값 계산
    rpfCNAmount = rpfCNAmount + rpfNewCNAmount;

    /*********************************************************
     * DN값 계산
     *********************************************************/
    EgovMap rpfDnMap = commonPaymentMapper.selectRPFDN(params);

    if (rpfDnMap != null && rpfDnMap.get("dnAmt") != null) {
      rpfDnAmount = Double.parseDouble(String.valueOf(rpfDnMap.get("dnAmt")));
    }

    /*********************************************************
     * Pay Total 값 계산
     *********************************************************/
    EgovMap payTotalMap = commonPaymentMapper.selectPayTotalAmount(params);

    if (payTotalMap != null && payTotalMap.get("payTotal") != null) {
      payTotal = Double.parseDouble(String.valueOf(payTotalMap.get("payTotal")));
    }

    /*********************************************************
     * rpf Reversed 값 계산
     *********************************************************/
    EgovMap reversedMap = commonPaymentMapper.selectReversedAmount(params);

    if (reversedMap != null && reversedMap.get("revAmt") != null) {
      rpfReversed = Double.parseDouble(String.valueOf(reversedMap.get("revAmt")));
    }

    /*********************************************************
     * Reverse Payment Amount 값 계산
     *********************************************************/
    EgovMap revPaymentMap = commonPaymentMapper.selectRevPaymentAmount(params);

    if (revPaymentMap != null && revPaymentMap.get("revPaymentAmt") != null) {
      revPaymentAmt = Double.parseDouble(String.valueOf(revPaymentMap.get("revPaymentAmt")));
    }

    payTotal = payTotal + revPaymentAmt;

    double validPayTotal = payTotal;

    /*********************************************************
     * Bill List 조회
     *********************************************************/
    List<EgovMap> billList = commonPaymentMapper.selectBills(params);

    if (billList != null && billList.size() > 0) {
      for (EgovMap obj : billList) {
        payTotal = payTotal + Double.parseDouble(String.valueOf(obj.get("rentAmt")));

      }
    }

    double balance = payTotal;

    /*********************************************************
     * Order Status 정보 조회 : Status 값에 따라 rpf 값을 설정한다.
     *
     *********************************************************/
    EgovMap order = commonPaymentMapper.selectOrderInfoForBills(params);

    if (order.get("stusCodeId").equals("1")) {
      totalAmt = Double.parseDouble(String.valueOf(order.get("totAmt")));
      rpf = Double.parseDouble(String.valueOf(order.get("totAmt")));
    } else {
      rpf = rpfTotalBill - rpfCNAmount + rpfDnAmount;
    }

    rf = Double.parseDouble(String.valueOf(order.get("mthRentAmt")));

    /*********************************************************
     * RPF Paid Amount 값 계산
     *********************************************************/
    EgovMap rpfPaidMap = commonPaymentMapper.selectRpfPaidAmount(params);

    if (rpfPaidMap != null && rpfPaidMap.get("rpfPaid") != null) {
      rpfPaid = Double.parseDouble(String.valueOf(rpfPaidMap.get("rpfPaid")));
    }

    /*********************************************************
     * Last Payment Date 조회
     *********************************************************/
    EgovMap lastPayDtMap = commonPaymentMapper.selectLastPaymentDt(params);

    if (lastPayDtMap != null && lastPayDtMap.get("rentDtTm") != null) {
      lastPayDt = String.valueOf(lastPayDtMap.get("rentDtTm"));
    }

    /*********************************************************
     * Current Installment 값 조회
     *********************************************************/
    EgovMap currInstNoMap = commonPaymentMapper.selectRentInstNo(params);

    if (currInstNoMap != null && currInstNoMap.get("rentInstNo") != null) {
      currentInstallment = Integer.parseInt(String.valueOf(currInstNoMap.get("rentInstNo")));
    }

    /*********************************************************
     * Last Installment and Totabl Bill Amount 값 조회
     *********************************************************/
    EgovMap lastInstNoMap = commonPaymentMapper.selectLastBilledInstNo(params);

    if (lastInstNoMap != null && lastInstNoMap.get("lastRentInstNo") != null) {
      lastBilledInstallment = Integer.parseInt(String.valueOf(lastInstNoMap.get("lastRentInstNo")));
    }

    if (lastInstNoMap != null && lastInstNoMap.get("totBillAmt") != null) {
      billTotal = Double.parseDouble(String.valueOf(lastInstNoMap.get("totBillAmt")));
    }

    if (currentInstallment > 0) {
      unbillCount = currentInstallment - lastBilledInstallment;
      if (unbillCount > 0)
        unbillAmount = unbillCount * rf;
    }
    orderRentalAccntStatus = commonPaymentMapper.selectOrderRentalAccntStatus(params);
    if ("TER".equals(orderRentalAccntStatus) || "WOF_1".equals(orderRentalAccntStatus)) {
    	unbillAmount = 0.0D;
    }

    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("billTotal", billTotal);
    resultMap.put("lastPayment", lastPayDt);
    resultMap.put("orderId", params.get("orderId"));
    resultMap.put("paidTotal", validPayTotal);
    resultMap.put("productPrice", totalAmt);
    resultMap.put("reverseAmount", revPaymentAmt);
    resultMap.put("rpf", rpf);
    resultMap.put("rpfPaid", (rpfPaid * -1) + rpfReversed);
    resultMap.put("unBilledCount", unbillCount);
    resultMap.put("unBilledAmount", unbillAmount);
    resultMap.put("balance", billTotal - (validPayTotal < 0 ? (validPayTotal * -1) : validPayTotal));

    if (rpfTotBillMap != null) {
      resultMap.put("rpfBillIsExisting", true);
    } else {
      resultMap.put("rpfBillIsExisting", false);
    }

    return resultMap;

  }

  /**
   * Payment - Bill Info Rental 조회
   *
   * @param params
   * @param model
   * @return BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int
   *         orderId, bool excludeRPFBill)
   */
  @Override
  @DataSource(value = DataSourceType.LONG_TIME)
  public List<EgovMap> selectBillInfoRental(Map<String, Object> params) {

    double balRPF = 0.0D;
    double rpfPaid = 0.0D;
    double rpfRev = 0.0D;
    double rpfCN = 0.0D;
    double rpfDN = 0.0D;

    double balRental = 0.0D;
    double rentalPaid = 0.0D;
    double rentalRev = 0.0D;

    double balPenalty = 0.0D;
    double penaltyPaid = 0.0D;
    double penaltyRev = 0.0D;

    double rhfPaid = 0.0D;
    double rhfRev2 = 0.0D;
    double rhfCN1 = 0.0D;
    double rhfCNOld = 0.0D;

    double rhfRev = 0.0D;
    double balRHF = 0.0D;

    List<EgovMap> rcList = commonPaymentMapper.selectBillInfoRental(params);

    if ("N".equals(String.valueOf(params.get("excludeRPF")))) {

      /*********************************************************
       * RPF Paid Amount 값 조회
       *********************************************************/
      EgovMap rpfPaidMap = commonPaymentMapper.selectBillRpfPaid(params);

      if (rpfPaidMap != null && rpfPaidMap.get("rpfPaid") != null) {
        rpfPaid = Double.parseDouble(String.valueOf(rpfPaidMap.get("rpfPaid")));
      }

      /*********************************************************
       * RPF Rev Amount 값 조회
       *********************************************************/
      EgovMap rpfRevMap = commonPaymentMapper.selectBillRpfRev(params);

      if (rpfRevMap != null && rpfRevMap.get("rpfRev") != null) {
        rpfRev = Double.parseDouble(String.valueOf(rpfRevMap.get("rpfRev")));
      }

      /*********************************************************
       * Adjustment CN / DN 값 조회
       *********************************************************/
      params.put("adjType", "CN");
      EgovMap adjCnMap = commonPaymentMapper.selectBillAdjAmount(params);

      if (adjCnMap != null && adjCnMap.get("memoAdjTotAmt") != null) {
        rpfCN = Double.parseDouble(String.valueOf(adjCnMap.get("memoAdjTotAmt")));
      }

      params.put("adjType", "DN");
      EgovMap adjDnMap = commonPaymentMapper.selectBillAdjAmount(params);

      if (adjDnMap != null && adjDnMap.get("memoAdjTotAmt") != null) {
        rpfDN = Double.parseDouble(String.valueOf(adjDnMap.get("memoAdjTotAmt")));
      }

      // balRPF 계산
      balRPF = rpfPaid - rpfRev + rpfCN - rpfDN;
    }

    /*********************************************************
     * Rental Paid Amount 값 조회
     *********************************************************/
    EgovMap rentalPaidMap = commonPaymentMapper.selectBillRentalPaidAmount(params);

    if (rentalPaidMap != null && rentalPaidMap.get("rentPaid") != null) {
      rentalPaid = Double.parseDouble(String.valueOf(rentalPaidMap.get("rentPaid")));
    }

    /*********************************************************
     * Rental Reversed Amount 값 조회
     *********************************************************/
    EgovMap rentalRevMap = commonPaymentMapper.selectBillRentalRevAmount(params);

    if (rentalRevMap != null && rentalRevMap.get("rentalRev") != null) {
      rentalRev = Double.parseDouble(String.valueOf(rentalRevMap.get("rentalRev")));
    }

    // balRental 계산
    balRental = rentalPaid - rentalRev;

    /*********************************************************
     * Penalty Paid Amount 값 조회
     *********************************************************/
    EgovMap penaltyPaidMap = commonPaymentMapper.selectBillPenaltyPaidAmount(params);

    if (penaltyPaidMap != null && penaltyPaidMap.get("penaltyPaid") != null) {
      penaltyPaid = Double.parseDouble(String.valueOf(penaltyPaidMap.get("penaltyPaid")));
    }

    /*********************************************************
     * Rental Reversed Amount 값 조회
     *********************************************************/
    EgovMap penaltyRevMap = commonPaymentMapper.selectBillPenaltyRevAmount(params);

    if (penaltyRevMap != null && penaltyRevMap.get("penaltyRev") != null) {
      penaltyRev = Double.parseDouble(String.valueOf(penaltyRevMap.get("penaltyRev")));
    }

    // balPenalty 계산
    balPenalty = penaltyPaid - penaltyRev;

    /*********************************************************
     * Handling Fees Paid Amount 값 조회
     *********************************************************/
    EgovMap rhfPaidMap = commonPaymentMapper.selectBillRhfPaidAmount(params);

    if (rhfPaidMap != null && rhfPaidMap.get("rhfPaid") != null) {
      rhfPaid = Double.parseDouble(String.valueOf(rhfPaidMap.get("rhfPaid")));
    }

    /*********************************************************
     * Handling Fees Reversed Amount 값 조회
     *********************************************************/
    EgovMap rhfRevMap = commonPaymentMapper.selectBillRfhRevAmount(params);

    if (rhfRevMap != null && rhfRevMap.get("rhfRev") != null) {
      rhfRev2 = Double.parseDouble(String.valueOf(rhfRevMap.get("rhfRev")));
    }

    /*********************************************************
     * Handling Fees Adjustment CN Amount 값 조회
     *********************************************************/
    EgovMap rhfAdjCnMap = commonPaymentMapper.selectBillRhfCNAmount(params);

    if (rhfAdjCnMap != null && rhfAdjCnMap.get("memoAdjTotAmt") != null) {
      rhfCN1 = Double.parseDouble(String.valueOf(rhfAdjCnMap.get("memoAdjTotAmt")));
    }

    /*********************************************************
     * Handling Fees Adjustment Old CN Amount 값 조회
     *********************************************************/
    EgovMap rhfOldAdjCnMap = commonPaymentMapper.selectBillRhfCNOldAmount(params);

    if (rhfOldAdjCnMap != null && rhfOldAdjCnMap.get("adjOldCnAmt") != null) {
      rhfCNOld = Double.parseDouble(String.valueOf(rhfOldAdjCnMap.get("adjOldCnAmt")));
    }

    // Handling Fee 계산
    rhfCN1 = rhfCN1 - rhfCNOld;

    rhfRev = rhfRev2;
    balRHF = rhfPaid - rhfRev + rhfCN1;

    double setAmount = 0.0D;

    // Billing 정보 재정의
    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {

        setAmount = 0.0D;

        if (Integer.parseInt(String.valueOf(obj.get("billTypeId"))) == 162) { // penalty
          if (balPenalty > 0) {

            setAmount = balPenalty > Double.parseDouble(String.valueOf(obj.get("billAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("billAmt"))) : balPenalty;
            obj.put("paidAmt", setAmount);
            balPenalty = balPenalty - setAmount;
          } else {
            obj.put("paidAmt", 0);
          }
        } else if (Integer.parseInt(String.valueOf(obj.get("billTypeId"))) == 1059) { // handling
                                                                                      // fees

          if (balRHF > 0) {
            setAmount = balRHF > Double.parseDouble(String.valueOf(obj.get("billAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("billAmt"))) : balRHF;
            obj.put("paidAmt", setAmount);
            balRHF = balRHF - setAmount;
          } else {
            obj.put("paidAmt", 0);
          }
        } else if (Integer.parseInt(String.valueOf(obj.get("billTypeId"))) == 161) { // rpf

          if (balRPF > 0) {
            setAmount = balRPF > Double.parseDouble(String.valueOf(obj.get("billAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("billAmt"))) : balRPF;
            obj.put("paidAmt", setAmount);
            balRPF = balRPF - setAmount;
          } else {
            obj.put("paidAmt", 0);
          }
        } else {

          if (balRental > 0) {
            setAmount = balRental > Double.parseDouble(String.valueOf(obj.get("billAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("billAmt"))) : balRental;
            obj.put("paidAmt", setAmount);

            balRental = balRental - setAmount;
          } else {
            obj.put("paidAmt", 0);
          }
        }

        obj.put("targetAmt", Double.parseDouble(String.valueOf(obj.get("billAmt")))
            - Double.parseDouble(String.valueOf(obj.get("paidAmt"))));
      }
    }

    // 반환할 Billing 정보 정의
    List<EgovMap> returnList = new ArrayList<EgovMap>();

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        //
        if (Double.parseDouble(String.valueOf(obj.get("paidAmt"))) != Double
            .parseDouble(String.valueOf(obj.get("billAmt")))) {
          returnList.add(obj);
        }
      }
    }

    return returnList;
  }

  /*****************************************************************************
   * Non - Rental
   *
   ******************************************************************************/
  /**
   * Payment - Order Info Non - Rental 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public List
   *         <RentalOrderView> GetOutInstOrders(int orderId)
   */
  @Override
  public List<EgovMap> selectOrderInfoNonRental(Map<String, Object> params) {

    List<EgovMap> rcList = commonPaymentMapper.selectOrderInfoNonRental(params);

    Map<String, Object> newParams = null;
    Map<String, Object> billInfo = null;

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        newParams = new HashMap<String, Object>();
        newParams.put("orderId", obj.get("salesOrdId"));

        billInfo = this.getOutrightPayInfo(newParams);

        Double totalPaid = Double.parseDouble(String.valueOf(billInfo.get("paidTotal")))
            - Double.parseDouble(String.valueOf(billInfo.get("reverseAmount")));

        obj.put("lastPayment", billInfo.get("lastPayment"));
        obj.put("balance", Double.parseDouble(String.valueOf(billInfo.get("billTotal"))) - totalPaid);
        obj.put("productPrice", billInfo.get("productPrice"));
        obj.put("reverseAmount", billInfo.get("reverseAmount"));
        obj.put("totalPaid", totalPaid);
        obj.put("rpfPaid", billInfo.get("firstRf"));
      }
    }

    return rcList;
  }

  public List<EgovMap> selectHTOrderInfoNonRental(Map<String, Object> params) {

    List<EgovMap> rcList = commonPaymentMapper.selectHTOrderInfoNonRental(params);

    Map<String, Object> newParams = null;
    Map<String, Object> billInfo = null;

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        newParams = new HashMap<String, Object>();
        newParams.put("orderId", obj.get("srvOrdId"));
        billInfo = commonPaymentMapper.selectCareServicePayInfo(newParams);

        obj.put("cnvrMemId", billInfo.get("srvMemId"));
        obj.put("packageCharge", billInfo.get("packageCharge"));
        obj.put("filterCharge", billInfo.get("filterCharge"));
        obj.put("packagePaid", billInfo.get("packagePaid"));
        obj.put("filterPaid", billInfo.get("filterPaid"));
      }
    }

    return rcList;
  }

  /**
   * Payment - Order Info Non-Rental Billing 정보 조회
   *
   * @param params
   * @param model
   * @return PaymentManager.cs : public RentalPaymentInfo GetOutrightPayInfo(int
   *         orderId)
   */
  public Map<String, Object> getOutrightPayInfo(Map<String, Object> params) {

    int ledgerCnt = 0;
    int lastInstallment = 0;
    double paidTotal = 0.0D;
    double billTotal = 0.0D;
    double totalCN = 0.0D;
    double reverseAmount = 0.0D;

    String lastPayDt = "1900-01-01";
    String lastBillDt = "1900-01-01";

    /*********************************************************
     * Ledger count 조회
     *********************************************************/
    EgovMap ledgerCntMap = commonPaymentMapper.selectBillInfoLedgerCnt(params);

    /*********************************************************
     * Order 정보 조회
     *********************************************************/
    EgovMap order = commonPaymentMapper.selectOrderInfoForBills(params);

    if (ledgerCntMap != null && ledgerCntMap.get("cnt") != null) {
      ledgerCnt = Integer.parseInt(String.valueOf(ledgerCntMap.get("cnt")));
    }

    Map<String, Object> resultMap = new HashMap<String, Object>();

    if (ledgerCnt > 0) {

      /*********************************************************
       * Ledger Info 조회
       *********************************************************/
      EgovMap ledgerMap = commonPaymentMapper.selectLedgerInfo(params);

      if (ledgerMap != null) {

        if (ledgerMap.get("lastPayDt") != null) {
          lastPayDt = String.valueOf(ledgerMap.get("lastPayDt"));
        }

        if (ledgerMap.get("tradeInstNo") != null) {
          lastInstallment = Integer.parseInt(String.valueOf(ledgerMap.get("tradeInstNo")));
        }

        if (ledgerMap.get("lastBillDt") != null) {
          lastBillDt = String.valueOf(ledgerMap.get("lastBillDt"));
        }

        if (ledgerMap.get("paidTotal") != null) {
          paidTotal = Double.parseDouble(String.valueOf(ledgerMap.get("paidTotal")));
        }

        if (ledgerMap.get("billTotal") != null) {
          billTotal = Double.parseDouble(String.valueOf(ledgerMap.get("billTotal")));
        }

        if (ledgerMap.get("cnTotal") != null) {
          totalCN = Double.parseDouble(String.valueOf(ledgerMap.get("cnTotal")));
        }

        if (ledgerMap.get("revTotal") != null) {
          reverseAmount = Double.parseDouble(String.valueOf(ledgerMap.get("revTotal")));
        }
      }

      if (billTotal < Double.parseDouble(String.valueOf(order.get("totAmt")))) {
        billTotal = Double.parseDouble(String.valueOf(order.get("totAmt")));
      }

      billTotal = billTotal + totalCN;

      resultMap.put("orderId", params.get("orderId"));
      resultMap.put("lastPayment", lastPayDt);
      resultMap.put("lastInstallment", lastInstallment);
      resultMap.put("lastBillDt", lastBillDt);
      resultMap.put("paidTotal", paidTotal);
      resultMap.put("billTotal", billTotal);
      resultMap.put("rpf", order.get("totAmt"));
      resultMap.put("productPrice", order.get("totAmt"));
      resultMap.put("reverseAmount", reverseAmount);
      resultMap.put("rpfPaid", paidTotal);
      resultMap.put("firstRf", paidTotal - billTotal);
      resultMap.put("firstRfPaid", 0);
      resultMap.put("unBilledCount", 0);
      resultMap.put("unBilledAmount", 0);
      resultMap.put("balance", billTotal - (paidTotal < 0 ? (paidTotal * -1) : paidTotal));

    } else {
      resultMap.put("orderId", params.get("orderId"));
      resultMap.put("lastPayment", lastPayDt);
      resultMap.put("lastInstallment", 0);
      resultMap.put("lastBillDt", lastPayDt);
      resultMap.put("paidTotal", 0);
      resultMap.put("billTotal", order.get("totAmt"));
      resultMap.put("rpf", 0);
      resultMap.put("productPrice", order.get("totAmt"));
      resultMap.put("reverseAmount", 0);
      resultMap.put("rpfPaid", 0);
      resultMap.put("firstRf", 0);
      resultMap.put("firstRfPaid", 0);
      resultMap.put("unBilledCount", 0);
      resultMap.put("unBilledAmount", 0);
      resultMap.put("balance", order.get("totAmt"));
    }

    return resultMap;
  }

  /*****************************************************************************
   * Membership Service : FundTransfer
   *
   ******************************************************************************/
  /**
   * Payment - Order Info Membership Service 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @Override
  public Map<String, Object> selectOrderInfoSVM(Map<String, Object> params) {
    return commonPaymentMapper.selectOrderInfoSVM(params);
  }

  /*****************************************************************************
   * Rental Membership : Payment
   *
   ******************************************************************************/
  /**
   * Payment - Order Info Rental Membership 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @Override
  public List<EgovMap> selectOrderInfoSrvc(Map<String, Object> params) {

    List<EgovMap> rcList = commonPaymentMapper.selectOrderInfoSrvc(params);

    Map<String, Object> paymentInfo = null;

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        paymentInfo = this.getServiceContractPaymentInfo(obj);

        obj.put("filterCharges", paymentInfo.get("filterCharges"));
        obj.put("filterChargesPaid", paymentInfo.get("filterChargesPaid"));
        obj.put("penaltyCharges", paymentInfo.get("penaltyCharges"));
        obj.put("penaltyChargesPaid", paymentInfo.get("penaltyChargesPaid"));
        obj.put("totalPaid", paymentInfo.get("totalPaid"));
        obj.put("balance", paymentInfo.get("balance"));
        obj.put("lastPayment", paymentInfo.get("lastPayment"));
        obj.put("unBilledCount", paymentInfo.get("unBilledCount"));
        obj.put("unBillAmount", paymentInfo.get("unBillAmount"));
      }
    }

    return rcList;
  }

  /**
   * Payment - Order Info Rental Billing 정보 조회
   *
   * @param params
   * @param model
   * @return ServiceContractManager.cs : private ServiceContactBillingInfo
   *         GetServiceContractPaymentInfo(int scsID)
   */
  public Map<String, Object> getServiceContractPaymentInfo(Map<String, Object> params) {

    double filterCharge = 0.0D;
    double filterCn = 0.0D;
    double filterDn = 0.0D;
    double filterPaid = 0.0D;
    double filterReversed = 0.0D;
    double penaltyCharge = 0.0D;
    double penaltyCn = 0.0D;
    double penaltyDn = 0.0D;
    double penaltyPaid = 0.0D;
    double penaltyReversed = 0.0D;
    double totalPaid = 0.0D;
    double reversePayment = 0.0D;
    double balanceAmt = 0.0D;
    double billAmt = 0.0D;
    String lastPayDt = "1900-01-01";
    int billSchedule = 0;
    int currentSchedule = 0;
    int unbillMth = 0;
    double unbillAmt = 0.0D;
    double monthlyFee = 0.0D;

    /*********************************************************
     * Charge Amount값 계산
     *********************************************************/
    EgovMap srvcChargeMap = commonPaymentMapper.selectOrderInfoSrvcCharge(params);

    if (srvcChargeMap != null && srvcChargeMap.get("filterCharge") != null) {
      filterCharge = Double.parseDouble(String.valueOf(srvcChargeMap.get("filterCharge")));
    }

    if (srvcChargeMap != null && srvcChargeMap.get("penaltyCharge") != null) {
      penaltyCharge = Double.parseDouble(String.valueOf(srvcChargeMap.get("penaltyCharge")));
    }

    /*********************************************************
     * Adjustment CN / DN Amount값 계산
     *********************************************************/
    EgovMap srvcAdjMap = commonPaymentMapper.selectOrderInfoSrvcADJ(params);

    if (srvcAdjMap != null && srvcAdjMap.get("filterCn") != null) {
      filterCn = Double.parseDouble(String.valueOf(srvcAdjMap.get("filterCn")));
    }

    if (srvcAdjMap != null && srvcAdjMap.get("filterDn") != null) {
      filterDn = Double.parseDouble(String.valueOf(srvcAdjMap.get("filterDn")));
    }

    if (srvcAdjMap != null && srvcAdjMap.get("penaltyCn") != null) {
      penaltyCn = Double.parseDouble(String.valueOf(srvcAdjMap.get("penaltyCn")));
    }

    if (srvcAdjMap != null && srvcAdjMap.get("penaltyDn") != null) {
      penaltyDn = Double.parseDouble(String.valueOf(srvcAdjMap.get("penaltyDn")));
    }

    filterCharge = filterCharge - filterCn + filterDn;
    penaltyCharge = penaltyCharge - penaltyCn + penaltyDn;

    /*********************************************************
     * Paid Amount 값 계산
     *********************************************************/
    EgovMap srvcPaidMap = commonPaymentMapper.selectOrderInfoSrvcPaid(params);

    if (srvcPaidMap != null && srvcPaidMap.get("filterPaid") != null) {
      filterPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("filterPaid")));
    }

    if (srvcPaidMap != null && srvcPaidMap.get("penaltyPaid") != null) {
      penaltyPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("penaltyPaid")));
    }

    if (srvcPaidMap != null && srvcPaidMap.get("totalPaid") != null) {
      totalPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("totalPaid")));
    }

    if (srvcPaidMap != null && srvcPaidMap.get("lastPayDt") != null) {
      lastPayDt = String.valueOf(srvcPaidMap.get("lastPayDt"));
    }

    /*********************************************************
     * Paid Amount 값 계산
     *********************************************************/
    EgovMap srvcRevMap = commonPaymentMapper.selectOrderInfoSrvcRev(params);

    if (srvcRevMap != null && srvcRevMap.get("filterRev") != null) {
      filterReversed = Double.parseDouble(String.valueOf(srvcRevMap.get("filterRev")));
    }

    if (srvcRevMap != null && srvcRevMap.get("penaltyRev") != null) {
      penaltyReversed = Double.parseDouble(String.valueOf(srvcRevMap.get("penaltyRev")));
    }

    filterPaid = (filterPaid * -1) + filterReversed;
    penaltyPaid = (penaltyPaid * -1) + penaltyReversed;

    /*********************************************************
     * Total Paid Amount 값 계산
     *********************************************************/
    EgovMap srvcTotRevMap = commonPaymentMapper.selectOrderInfoSrvcTotalRev(params);

    if (srvcTotRevMap != null && srvcTotRevMap.get("totalRev") != null) {
      reversePayment = Double.parseDouble(String.valueOf(srvcTotRevMap.get("totalRev")));
    }
    totalPaid = (totalPaid * -1) - reversePayment;

    /*********************************************************
     * Balance Amount 값 계산
     *********************************************************/
    EgovMap srvcBalanceMap = commonPaymentMapper.selectOrderInfoSrvcBalance(params);

    if (srvcBalanceMap != null && srvcBalanceMap.get("balance") != null) {
      billAmt = Double.parseDouble(String.valueOf(srvcBalanceMap.get("balance")));
    }

    if (srvcBalanceMap != null && srvcBalanceMap.get("maxSchdulNo") != null) {
      billSchedule = Integer.parseInt(String.valueOf(srvcBalanceMap.get("maxSchdulNo")));
    }

    balanceAmt = billAmt - totalPaid;

    /*********************************************************
     * Unbill Amount 값 계산
     *********************************************************/
    EgovMap srvcUnbillMap = commonPaymentMapper.selectOrderInfoSrvcUnbill(params);

    if (srvcUnbillMap != null && srvcUnbillMap.get("currSchdulNo") != null) {
      currentSchedule = Integer.parseInt(String.valueOf(srvcUnbillMap.get("currSchdulNo")));
    }

    if (srvcUnbillMap != null && srvcUnbillMap.get("monthlyFee") != null) {
      monthlyFee = Double.parseDouble(String.valueOf(srvcUnbillMap.get("monthlyFee")));
    }

    if (currentSchedule > 0) {
      unbillMth = currentSchedule - billSchedule;

      if (unbillMth > 0) {
        unbillAmt = monthlyFee * unbillMth;
      }
    }

    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("filterCharges", filterCharge);
    resultMap.put("filterChargesPaid", filterPaid);
    resultMap.put("penaltyCharges", penaltyCharge);
    resultMap.put("penaltyChargesPaid", penaltyPaid);
    resultMap.put("totalPaid", totalPaid);
    resultMap.put("balance", balanceAmt);
    resultMap.put("lastPayment", lastPayDt);
    resultMap.put("unBilledCount", unbillMth);
    resultMap.put("unBillAmount", unbillAmt);

    return resultMap;

  }

  /**
   * Payment - Bill Info Rental Membership 조회
   *
   * @param params
   * @param model
   * @return ServiceContractManager.cs : public List
   *         <ServiceContactBillingInfo> GetServiceContractBillDetailList(int
   *         scsID, bool excludeFilterCharges, bool excludePenaltyCharges)
   */
  @Override
  @DataSource(value = DataSourceType.LONG_TIME)
  public List<EgovMap> selectBillInfoSrvc(Map<String, Object> params) {

    double balRentalPayment = 0.0D;
    double rentalPaid = 0.0D;
    double rentalReversed = 0.0D;
    double rentalCN = 0.0D;
    double rentalDN = 0.0D;

    double balFilterPayment = 0.0D;
    double filterPaid = 0.0D;
    double filterReversed = 0.0D;
    double filterCN = 0.0D;
    double filterDN = 0.0D;

    double balPenaltyPayment = 0.0D;
    double penaltyPaid = 0.0D;
    double penaltyReversed = 0.0D;
    double penaltyCN = 0.0D;
    double penaltyDN = 0.0D;

    /*********************************************************
     * Rental Paid Amount 값 계산
     *********************************************************/
    EgovMap srvcPaidMap = commonPaymentMapper.selectBillInfoSrvcPaid(params);

    if (srvcPaidMap != null && srvcPaidMap.get("rentalPaid") != null) {
      rentalPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("rentalPaid")));
    }

    /*********************************************************
     * Rental Reversed Amount 값 계산
     *********************************************************/
    EgovMap srvcRevMap = commonPaymentMapper.selectBillInfoSrvcRev(params);

    if (srvcRevMap != null && srvcRevMap.get("rentalRev") != null) {
      rentalReversed = Double.parseDouble(String.valueOf(srvcRevMap.get("rentalRev")));
    }

    /*********************************************************
     * Rental Adjustment CN/DN 값 계산
     *********************************************************/
    EgovMap srvcAdjMap = commonPaymentMapper.selectOrderInfoSrvcADJ(params);

    if (srvcAdjMap != null && srvcAdjMap.get("rentalCn") != null) {
      rentalCN = Double.parseDouble(String.valueOf(srvcAdjMap.get("rentalCn")));
    }

    if (srvcAdjMap != null && srvcAdjMap.get("rentalDn") != null) {
      rentalDN = Double.parseDouble(String.valueOf(srvcAdjMap.get("rentalDn")));
    }

    balRentalPayment = (rentalPaid * -1) + rentalReversed + rentalCN - rentalDN;

    /*********************************************************
     * Filter Amount 값 계산
     *********************************************************/
    if (!"Y".equals(params.get("excludeFilterCharges"))) {

      if (srvcPaidMap != null && srvcPaidMap.get("filterPaid") != null) {
        filterPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("filterPaid")));
      }

      if (srvcRevMap != null && srvcRevMap.get("filterRev") != null) {
        filterReversed = Double.parseDouble(String.valueOf(srvcRevMap.get("filterRev")));
      }

      if (srvcAdjMap != null && srvcAdjMap.get("filterCn") != null) {
        filterCN = Double.parseDouble(String.valueOf(srvcAdjMap.get("filterCn")));
      }

      if (srvcAdjMap != null && srvcAdjMap.get("filterDn") != null) {
        filterDN = Double.parseDouble(String.valueOf(srvcAdjMap.get("filterDn")));
      }

      balFilterPayment = (filterPaid * -1) + filterReversed + filterCN - filterDN;
    }

    /*********************************************************
     * Penalty Amount 값 계산
     *********************************************************/
    if (!"Y".equals(params.get("excludePenaltyCharges"))) {

      if (srvcPaidMap != null && srvcPaidMap.get("penaltyPaid") != null) {
        penaltyPaid = Double.parseDouble(String.valueOf(srvcPaidMap.get("penaltyPaid")));
      }

      if (srvcRevMap != null && srvcRevMap.get("penaltyRev") != null) {
        penaltyReversed = Double.parseDouble(String.valueOf(srvcRevMap.get("penaltyRev")));
      }

      if (srvcAdjMap != null && srvcAdjMap.get("penaltyCn") != null) {
        penaltyCN = Double.parseDouble(String.valueOf(srvcAdjMap.get("penaltyCn")));
      }

      if (srvcAdjMap != null && srvcAdjMap.get("penaltyDn") != null) {
        penaltyDN = Double.parseDouble(String.valueOf(srvcAdjMap.get("penaltyDn")));
      }

      balPenaltyPayment = (penaltyPaid * -1) + penaltyReversed + penaltyCN - penaltyDN;
    }

    List<EgovMap> rcList = commonPaymentMapper.selectBillInfoSrvcList(params);

    double setAmount = 0.0D;

    // Billing 정보 재정의
    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        setAmount = 0.0D;

        if (Integer.parseInt(String.valueOf(obj.get("srvLdgrTypeId"))) == 1305) { // Rental
          if (balRentalPayment > 0) {
            setAmount = balRentalPayment > Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt"))) : balRentalPayment;
            obj.put("paidTotal", setAmount);
            balRentalPayment = balRentalPayment - setAmount;
          } else {
            obj.put("paidTotal", 0);
          }
        } else if (Integer.parseInt(String.valueOf(obj.get("srvLdgrTypeId"))) == 1307) { // Filter
          if (balFilterPayment > 0) {
            setAmount = balFilterPayment > Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt"))) : balFilterPayment;
            obj.put("paidTotal", setAmount);
            balFilterPayment = balFilterPayment - setAmount;
          } else {
            obj.put("paidTotal", 0);
          }
        } else if (Integer.parseInt(String.valueOf(obj.get("srvLdgrTypeId"))) == 1306) { // Penalty
          if (balPenaltyPayment > 0) {
            setAmount = balPenaltyPayment > Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt")))
                ? Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt"))) : balPenaltyPayment;
            obj.put("paidTotal", setAmount);
            balPenaltyPayment = balPenaltyPayment - setAmount;
          } else {
            obj.put("paidTotal", 0);
          }
        }
      }
    }

    // 반환할 Billing 정보 정의
    List<EgovMap> returnList = new ArrayList<EgovMap>();

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        //
        if (Double.parseDouble(String.valueOf(obj.get("paidTotal"))) != Double
            .parseDouble(String.valueOf(obj.get("srvLdgrAmt")))) {
          obj.put("targetAmt", Double.parseDouble(String.valueOf(obj.get("srvLdgrAmt")))
              - Double.parseDouble(String.valueOf(obj.get("paidTotal"))));
          returnList.add(obj);
        }
      }
    }

    return returnList;
  }

  /**
   * Payment - Order Info Rental Payment 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  public List<EgovMap> selectOrderInfoBillPayment(Map<String, Object> params) {

    List<EgovMap> returnList = null;

    if ("1".equals(String.valueOf(params.get("billType")))) {
      returnList = commonPaymentMapper.selectOrderInfoBillPaymentAS(params);
    } else if ("2".equals(String.valueOf(params.get("billType")))) {
      returnList = commonPaymentMapper.selectOrderInfoBillPaymentHP(params);
    } else {
      returnList = commonPaymentMapper.selectOrderInfoBillPaymentPOS(params); // Add
                                                                              // Bill
                                                                              // Type
                                                                              // -
                                                                              // POS
                                                                              // -
                                                                              // TPY
                                                                              // 21/06/2018
    }

    return returnList;
  }

  /*****************************************************************************
   * Outright Membership
   ******************************************************************************/
  /**
   * Payment - Outright Membership Order 정보 조회
   *
   * @param params
   * @param model
   * @return
   *
   */
  @Override
  public List<EgovMap> selectOutSrvcOrderInfo(Map<String, Object> params) {
    // return commonPaymentMapper.selectOutSrvcOrderInfo(params);

    List<EgovMap> rcList = commonPaymentMapper.selectOutSrvcOrderInfo(params);

    Map<String, Object> paymentInfo = null;

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {

        if (obj.get("cnvrMemId") != null && Integer.parseInt(String.valueOf(obj.get("cnvrMemId"))) > 0) {
          paymentInfo = commonPaymentMapper.selectOutSrvcBillInfo(obj);

          obj.put("packageCharge", paymentInfo.get("packageCharge"));
          obj.put("filterCharge", paymentInfo.get("filterCharge"));
          obj.put("packagePaid", paymentInfo.get("packagePaid"));
          obj.put("filterPaid", paymentInfo.get("filterPaid"));
        } else {

          obj.put("packageCharge", 0);
          obj.put("filterCharge", 0);
          obj.put("packagePaid", 0);
          obj.put("filterPaid", 0);

        }
      }
    }
    return rcList;
  }

  /**
   * Payment - 처리
   *
   * @param params
   * @param model
   * @return
   *
   */
  public List<EgovMap> savePayment(Map<String, Object> paramMap, List<Object> paramList) {

    List<EgovMap> rcList = null;
    logger.debug("paramMap :" + paramMap);
    logger.debug("paramList :" + paramList);

    // 시퀀스 조회
    Integer seq = commonPaymentMapper.getPayTempSEQ();

    // payment 임시정보 등록
    paramMap.put("seq", seq);
    commonPaymentMapper.insertTmpPaymentInfo(paramMap);

    // billing 임시정보 등록
    if (paramList.size() > 0) {
      Map<String, Object> hm = null;
      for (Object map : paramList) {
        hm = (HashMap<String, Object>) map;
        hm.put("seq", seq);
        commonPaymentMapper.insertTmpBillingInfo(hm);
        logger.debug("APP TYPE : " + hm.get("appType"));
        if ("CARE_SRVC".equals(String.valueOf(hm.get("appType")))) {
          hm.put("userId", paramMap.get("userid"));
          commonPaymentMapper.updateCareSalesMStatus(hm);
          // commonPaymentMapper.processPayment(paramMap);
          // rcList =
          // commonPaymentMapper.selectProcessCSPaymentResult(paramMap);
        } else {
          // commonPaymentMapper.processPayment(paramMap);
          // rcList = commonPaymentMapper.selectProcessPaymentResult(paramMap);
        }

      }
    }

    // payment 처리 프로시저 호출
    commonPaymentMapper.processPayment(paramMap);

    // WOR 번호 조회
    return commonPaymentMapper.selectProcessPaymentResult(paramMap);
    // return rcList;

  }

  /**
   * Payment - 처리
   *
   * @param params
   * @param model
   * @return
   *
   */
  public Map<String, Object> saveNormalPayment(Map<String, Object> paramMap, List<Object> paramList, int key) {

    // 시퀀스 조회
    Integer seq = commonPaymentMapper.getPayTempSEQ();

    // payment 임시정보 등록
    paramMap.put("seq", seq);

    commonPaymentMapper.insertTmpNormalPaymentInfo(paramMap);
    Map<String, Object> procedureInfo = new HashMap<String, Object>();

    // billing 임시정보 등록
    if (paramList.size() > 0) {
      Map<String, Object> hm = null;
      for (Object map : paramList) {
        hm = (HashMap<String, Object>) map;
        hm.put("seq", seq);
        commonPaymentMapper.insertTmpBillingInfo(hm);
        logger.debug("APP TYPE : " + hm.get("appType"));
        if ("CARE_SRVC".equals(String.valueOf(hm.get("appType")))) {
          hm.put("userId", paramMap.get("userid"));
          commonPaymentMapper.updateCareSalesMStatus(hm);

        }
        procedureInfo.put("appType", hm.get("appType"));

      }
    }

    // Map<String, Object> procedureInfo = new HashMap<String, Object>();
    procedureInfo.put("seq", seq);
    procedureInfo.put("userid", paramMap.get("userid"));
    procedureInfo.put("key", key);
    procedureInfo.put("keyInPayRoute", paramMap.get("keyInPayRoute"));
    procedureInfo.put("keyInScrn", paramMap.get("keyInScrn"));

    commonPaymentMapper.processNormalPayment(procedureInfo);

    return procedureInfo;
  }

  /**
   * Payment - 등록 처리
   *
   * @param params
   * @param model
   * @return
   *
   */
  public List<EgovMap> selectProcessPaymentResult(Map<String, Object> paramMap) {
    // WOR 번호 조회
    return commonPaymentMapper.selectProcessPaymentResult(paramMap);
  }

  public List<EgovMap> selectProcessCSPaymentResult(Map<String, Object> paramMap) {
    // WOR 번호 조회
    return commonPaymentMapper.selectProcessCSPaymentResult(paramMap);
  }

  @Override
  public EgovMap checkOrderOutstanding(Map<String, Object> params) {

    int orderId = 0;
    String appTypId = "";
    String ROOT_STATE = "", isInValid = "", msg = "";

    // orderId = Integer.parseInt((String)params.get("custId"));
    orderId = CommonUtils.intNvl(Integer.parseInt(String.valueOf(params.get("salesOrdId"))));

    EgovMap RESULT = new EgovMap();

    EgovMap resultMap = this.selectSalesOrderM(orderId, 0);

    if (resultMap != null) {
      appTypId = resultMap.get("appTypeId").toString();

      EgovMap ValiRentInstNo = null;
      ValiRentInstNo = orderRegisterMapper.selectRentalInstNo(orderId);

      EgovMap OutstandingAmt = null;
      if ("1412".equals(appTypId)) {
        OutstandingAmt = orderRegisterMapper.selectOutrightPlusOutstandingAmt(orderId);
      } else {
        OutstandingAmt = orderRegisterMapper.selectOutstandingAmt(orderId);
      }

      BigDecimal rentInstNo;
      BigDecimal rentPeriod;
      String ordStus = "";
      BigDecimal valiOutStanding;
      // valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

      if ("66".equals(appTypId) || "1412".equals(appTypId)) {
        // if(Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo")))
        // != 0 || String.valueOf(ValiRentInstNo.get("rentInstNo")) != null){
        if (ValiRentInstNo != null) {
          rentInstNo = (BigDecimal) ValiRentInstNo.get("rentInstNo");
        } else {
          rentInstNo = (BigDecimal.valueOf(100));
        }
        // rentInstNo = ValiRentInstNo.get("rentInstNo") != null ?
        // Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))):
        // 100;
        rentPeriod = (BigDecimal) resultMap.get("rentalPeriod");
      } else {
        rentInstNo = BigDecimal.ZERO;
        rentPeriod = BigDecimal.ZERO;
      }

      if (OutstandingAmt != null) {
        valiOutStanding = (BigDecimal) OutstandingAmt.get("rentAmt");
        valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
      } else {
        valiOutStanding = BigDecimal.ZERO;
        valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
      }
      ordStus = resultMap.get("stusCodeId").toString();
      if ((rentInstNo.compareTo(rentPeriod) == 1 || "10".equals(ordStus))
          && (valiOutStanding.compareTo(BigDecimal.ZERO) == 0 || valiOutStanding.compareTo(BigDecimal.ZERO) == -1)) {
        msg = "Order App Type : " + (String) resultMap.get("appTypeName") + "<br/>";
        msg = msg + "Order Status : " + (String) resultMap.get("orderStatus") + "<br/>";
        msg = msg + "Rental Status : " + (String) resultMap.get("rentalStatus") + "<br/>";
        if (valiOutStanding.compareTo(BigDecimal.ZERO) == -1) {
          msg = msg + "Outstanding : RM " + "<span style='color:#ff0000;'>" + valiOutStanding + "</span>";

        } else {
          msg = msg + "Outstanding : RM " + valiOutStanding;

        }

        isInValid = "InValid";
        ROOT_STATE = "ROOT_1";
      } else {
        ROOT_STATE = "ROOT_2";
      }

      RESULT.put("ROOT_STATE", ROOT_STATE);
      RESULT.put("IS_IN_VALID", isInValid);
      RESULT.put("MSG", msg);
      RESULT.put("OLD_ORDER_ID", orderId);
    } else {
      RESULT.put("ROOT_STATE", "ROOT_3");
      RESULT.put("IS_IN_VALID", "InValid");
      RESULT.put("MSG", "Unable to get installation and outstanding amount due to selected bill ID does not contains order no.");
      RESULT.put("OLD_ORDER_ID", orderId);
    }

    return RESULT;
  }

  private EgovMap selectSalesOrderM(int ordId, int appTypeId) {
    Map<String, Object> params = new HashMap<String, Object>();

    params.put("salesOrdId", ordId);
    params.put("appTypeId", appTypeId);

    EgovMap result = orderRegisterMapper.selectSalesOrderM(params);

    return result;
  }

  @Override
  public EgovMap checkHTOrderOutstanding(Map<String, Object> params) {

    int orderId = 0;
    String appTypId = "";
    String ROOT_STATE = "", isInValid = "", msg = "";

    // orderId = Integer.parseInt((String)params.get("custId"));
    orderId = CommonUtils.intNvl(Integer.parseInt(String.valueOf(params.get("salesOrdId"))));

    EgovMap RESULT = new EgovMap();

    EgovMap resultMap = this.selectSrvOrderM(orderId, 0);

    if (resultMap != null)
      appTypId = resultMap.get("appTypeId").toString();

    EgovMap ValiRentInstNo = null;
    ValiRentInstNo = orderRegisterMapper.selectRentalInstNo(orderId);

    EgovMap OutstandingAmt = null;
    if ("1412".equals(appTypId)) {
      OutstandingAmt = orderRegisterMapper.selectOutrightPlusOutstandingAmt(orderId);
    } else {
      OutstandingAmt = orderRegisterMapper.selectOutstandingAmt(orderId);
    }

    BigDecimal rentInstNo;
    BigDecimal rentPeriod;
    String ordStus = "";
    BigDecimal valiOutStanding;
    // valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);

    if ("66".equals(appTypId) || "1412".equals(appTypId)) {
      // if(Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo")))
      // != 0 || String.valueOf(ValiRentInstNo.get("rentInstNo")) != null){
      if (ValiRentInstNo != null) {
        rentInstNo = (BigDecimal) ValiRentInstNo.get("rentInstNo");
      } else {
        rentInstNo = (BigDecimal.valueOf(100));
      }
      // rentInstNo = ValiRentInstNo.get("rentInstNo") != null ?
      // Integer.parseInt(String.valueOf(ValiRentInstNo.get("rentInstNo"))):
      // 100;
      rentPeriod = (BigDecimal) resultMap.get("rentalPeriod");
    } else {
      rentInstNo = BigDecimal.ZERO;
      rentPeriod = BigDecimal.ZERO;
    }

    if (OutstandingAmt != null) {
      valiOutStanding = (BigDecimal) OutstandingAmt.get("rentAmt");
      valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
    } else {
      valiOutStanding = BigDecimal.ZERO;
      valiOutStanding = valiOutStanding.setScale(2, BigDecimal.ROUND_HALF_UP);
    }
    ordStus = resultMap.get("stusCodeId").toString();
    if ((rentInstNo.compareTo(rentPeriod) == 1 || "10".equals(ordStus))
        && (valiOutStanding.compareTo(BigDecimal.ZERO) == 0 || valiOutStanding.compareTo(BigDecimal.ZERO) == -1)) {
      msg = "Order App Type : " + (String) resultMap.get("appTypeName") + "<br/>";
      msg = msg + "Order Status : " + (String) resultMap.get("orderStatus") + "<br/>";
      msg = msg + "Rental Status : " + (String) resultMap.get("rentalStatus") + "<br/>";
      if (valiOutStanding.compareTo(BigDecimal.ZERO) == -1) {
        msg = msg + "Outstanding : RM " + "<span style='color:#ff0000;'>" + valiOutStanding + "</span>";

      } else {
        msg = msg + "Outstanding : RM " + valiOutStanding;

      }

      isInValid = "InValid";
      ROOT_STATE = "ROOT_1";
    }

    else {
      ROOT_STATE = "ROOT_2";
    }

    RESULT.put("ROOT_STATE", ROOT_STATE);
    RESULT.put("IS_IN_VALID", isInValid);
    RESULT.put("MSG", msg);
    RESULT.put("OLD_ORDER_ID", orderId);

    return RESULT;
  }

  private EgovMap selectSrvOrderM(int ordId, int appTypeId) {
    Map<String, Object> params = new HashMap<String, Object>();

    params.put("salesOrdId", ordId);
    params.put("appTypeId", appTypeId);

    EgovMap result = htOrderRegisterMapper.selectSalesOrderM(params);

    return result;
  }

  public EgovMap checkBatchPaymentExist(Map<String, Object> params) {
    EgovMap result = commonPaymentMapper.checkBatchPaymentExist(params);
    return result;
  }

}
