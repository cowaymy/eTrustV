/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipRentalQuotationService;
import com.coway.trust.biz.sales.order.impl.OrderInvestMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipRentalQuotationService")
public class MembershipRentalQuotationServiceImpl extends EgovAbstractServiceImpl
    implements MembershipRentalQuotationService {

  private static final Logger logger = LoggerFactory.getLogger(MembershipRentalQuotationServiceImpl.class);

  @Resource(name = "membershipRentalQuotationMapper")
  private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

  @Resource(name = "membershipQuotationMapper")
  private MembershipQuotationMapper membershipQuotationMapper;

  @Resource(name = "orderInvestMapper")
  private OrderInvestMapper orderInvestMapper;

  @Override
  public List<EgovMap> quotationList(Map<String, Object> params) {
    return membershipRentalQuotationMapper.quotationList(params);
  }

  @Override
  public List<EgovMap> selCheckExpService(Map<String, Object> params) {
    return membershipRentalQuotationMapper.selCheckExpService(params);
  }

  @Override
  public List<EgovMap> newConfirm(Map<String, Object> params) {
    return membershipRentalQuotationMapper.newConfirm(params);
  }

  @Override
  public List<EgovMap> newOListuotationList(Map<String, Object> params) {
    return membershipRentalQuotationMapper.newOListuotationList(params);
  }

  @Override
  public EgovMap newGetExpDate(Map<String, Object> params) {
    return membershipRentalQuotationMapper.newGetExpDate(params);
  }

  @Override
  public List<EgovMap> getSrvMemCode(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getSrvMemCode(params);
  }

  @Override
  public EgovMap mPackageInfo(Map<String, Object> params) {

    String zeroRatYn = "Y";
    String eurCertYn = "Y";

    params.put("srvSalesOrderId", params.get("SALES_ORD_ID"));

    logger.debug(
        "zeroRat ==========================>>  " + membershipRentalQuotationMapper.selectGSTZeroRateLocation(params));
    logger.debug(
        "EURCert ==========================>>  " + membershipRentalQuotationMapper.selectGSTEURCertificate(params));

    int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
    if (zeroRat > 0) {
      zeroRatYn = "N";
    }

    int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);
    if (EURCert > 0) {
      eurCertYn = "N";
    }

    EgovMap result = membershipRentalQuotationMapper.mPackageInfo(params);

    if (result == null) {
      result = new EgovMap();
    }

    logger.debug("zeroRat ==========================>>  " + zeroRatYn);
    logger.debug("EURCert ==========================>>  " + eurCertYn);

    result.put("zeroRatYn", zeroRatYn);
    result.put("eurCertYn", eurCertYn);

    // return membershipRentalQuotationMapper.mPackageInfo(params);
    return result;

  }

  @Override
  public List<EgovMap> getPromotionCode(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getPromotionCode(params);
  }

  @Override
  public List<EgovMap> getFilterChargeList(Map<String, Object> params) {
    // return membershipRentalQuotationMapper.getFilterChargeList(params);

    membershipQuotationMapper.getFilterCharge(params);
    return (List<EgovMap>) params.get("p1");
  }

  @Override
  public double getFilterChargeListSum(Map<String, Object> params) {

    membershipQuotationMapper.getFilterCharge(params);

    List<EgovMap> list = (List<EgovMap>) params.get("p1");

    int sum = 0;

    logger.debug("zeroRat ==========================>>  " + params.get("zeroRatYn"));
    logger.debug("eurCertYn ==========================>>  " + params.get("eurCertYn"));

    for (EgovMap result : list) {

      double prc = Math.floor(Double.parseDouble(result.get("prc").toString()));

      logger.debug("PRC ==========================>>  " + prc);

      if ("N".equals(params.get("zeroRatYn")) || "N".equals(params.get("eurCertYn"))) {

        // sum += Math.floor((double)(prc * 100 / 106 )); -- without GST 6%
        // edited by TPY 01/06/2018
        sum += Math.floor((double) (prc));

        logger.debug("SUM 111 :: ==========================>>  " + sum);
      } else {
        sum += prc;

        logger.debug("SUM 222 :: ==========================>>  " + sum);
      }

    }

    return sum; // membershipQuotationMapper.getFilterChargeListSum(params);

    /*
     * membershipQuotationMapper.getFilterCharge(params); return (List<EgovMap>)
     * params.get("p1");
     */

  }

  @Override
  public EgovMap getFilterCharge(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getFilterCharge(params);
    // return (EgovMap) params.get("p1");
  }

  @Override
  public EgovMap getFilterPromotionAmt(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getFilterPromotionAmt(params);
  }

  @Override
  public List<EgovMap> getFilterPromotionCode(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getFilterPromotionCode(params);
  }

  @Override
  public List<EgovMap> getPromoPricePercent(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getPromoPricePercent(params);
  }

  @Override
  public List<EgovMap> getOrderCurrentBillMonth(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getOrderCurrentBillMonth(params);
  }

  @Override
  public EgovMap getOderOutsInfo(Map<String, Object> params) {
    membershipRentalQuotationMapper.getOderOutsInfo(params);

    return (EgovMap) params.get("p1");
  }

  @Override
  public EgovMap insertQuotationInfo(Map<String, Object> params) {

    EgovMap trnMap = new EgovMap();

    String taxCode = "";
    params.put("srvSalesOrderId", params.get("qotatOrdId"));
    int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
    if (zeroRat > 0) {
      taxCode = "39";
    }

    int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);
    if (EURCert > 0) {
      taxCode = "28";
    }

    EgovMap docMap = membershipRentalQuotationMapper.getSAL0083D_DocNo(params);
    EgovMap seqMap = membershipRentalQuotationMapper.getSAL0083D_SEQ(params);

    logger.debug("seqMap =============>" + seqMap.toString());
    logger.debug("docMap =============>" + docMap.toString());

    String SAL0083D_SEQ = String.valueOf(seqMap.get("seq"));
    String docNo = String.valueOf(docMap.get("docno"));

    if ("".equals(SAL0083D_SEQ)) {
      throw new ApplicationException(AppConstants.FAIL, "can't  get SAL0083D_SEQ !!");
    }

    logger.debug("params : {}", params.toString());
    logger.debug("SAL0083D_SEQ =============>");
    logger.debug("SAL0083D_SEQ : {}", SAL0083D_SEQ);
    logger.debug("docNo : {}", docNo);

    params.put("qotatId", SAL0083D_SEQ);
    params.put("qotatRefNo", docNo);

    // 1. insert
    membershipRentalQuotationMapper.insertQuotationInfo(params);

    String isFilter = (String) params.get("isFilterChange");

    logger.debug("isFilterCharge =============>" + (String) params.get("isFilterChange"));
    logger.debug("isFilter =============>" + isFilter);

    if ("true".equals(isFilter)) {

      // 2. get getMembershipFilterChargeList 프로시져 호출
      // 3. 프로시져 result foreach

      params.put("ORD_ID", params.get("qotatOrdId"));
      params.put("PROMO_ID", params.get("qotatFilPromoId"));

      membershipRentalQuotationMapper.getFilterCharge(params);

      logger.debug("map =============>" + params.toString());

      ArrayList list = (ArrayList) params.get("p1");
      EgovMap eFilterMap = null;

      if (list.size() > 0) {
        for (int a = 0; a < list.size(); a++) {

          eFilterMap = new EgovMap();
          Map rMap = (Map) list.get(a);

          eFilterMap.put("qotatId", SAL0083D_SEQ);
          eFilterMap.put("qotatItmStkId", rMap.get("filterId"));
          eFilterMap.put("qotatItmExpDt", rMap.get("lastChngDt"));
          eFilterMap.put("qotatItmChrg", Math.floor(Double.parseDouble(rMap.get("prc").toString())));

          logger.debug("aaaaaaa =============>" + Math.floor(Double.parseDouble(rMap.get("prc").toString())));

          if ("39".equals(taxCode) || "28".equals(taxCode)) {

            double chargePrice = Math.floor(Double.parseDouble(rMap.get("prc").toString()));
            // double amt =Math.floor((float)(chargePrice * 100 / 106 )); --
            // without GST 6% edited by TPY 01/06/2018
            double amt = Math.floor((float) (chargePrice));

            logger.debug("bbbbbbbb =============>" + chargePrice);

            eFilterMap.put("qotatItmAmt", amt);
            eFilterMap.put("qotatItmGstRate", "0");
            eFilterMap.put("qotatItmGstTaxCodeId", "39");
            eFilterMap.put("qotatItmTxs", "0");

          } else {

            double chargePrice = Math.floor(Double.parseDouble(rMap.get("prc").toString()));
            // double itemAmount =
            // Math.floor(Double.parseDouble(rMap.get("prc").toString()));
            // double amt =Math.floor((float)(chargePrice * 100 / 106
            // )*100)/100; -- without GST 6% edited by TPY 01/06/2018
            double amt = Math.floor((float) (chargePrice));

            logger.debug("cccccccc =============>" + chargePrice);

            eFilterMap.put("qotatItmAmt", chargePrice);
            eFilterMap.put("qotatItmChrg", amt);
            eFilterMap.put("qotatItmTxs", (chargePrice - amt));
            // eFilterMap.put("qotatItmGstRate", "6"); -- without GST 6% edited
            // by TPY 01/06/2018
            eFilterMap.put("qotatItmGstRate", "0");
            eFilterMap.put("qotatItmGstTaxCodeId", "32");
          }

          membershipRentalQuotationMapper.insertSrvMembershipQuot_Filter(eFilterMap);
        }
      }
    }

    trnMap.put("qotatId", SAL0083D_SEQ);
    trnMap.put("qotatRefNo", docNo);

    return trnMap;
  }

  @Override
  public EgovMap getMembershipFilterChargeList(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getMembershipFilterChargeList(params);
  }

  @Override
  public void insertSrvMembershipQuot_Filter(Map<String, Object> params) {
    membershipRentalQuotationMapper.insertSrvMembershipQuot_Filter(params);
  }

  @Override
  public EgovMap getSAL0083D_SEQ(Map<String, Object> params) {
    return membershipRentalQuotationMapper.getSAL0083D_SEQ(params);
  }

  @Override
  public List<EgovMap> mActiveQuoOrder(Map<String, Object> params) {
    return membershipRentalQuotationMapper.mActiveQuoOrder(params);
  }

  @Override
  public List<EgovMap> selectSrchMembershipQuotationPop(Map<String, Object> params) {
    return membershipRentalQuotationMapper.selectSrchMembershipQuotationPop(params);
  }

  @Override
  public EgovMap cnvrToSalesPackageInfo(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesPackageInfo(params);
  }

  @Override
  public EgovMap cnvrToSalesOrderInfo(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesOrderInfo(params);
  }

  @Override
  public EgovMap cnvrToSalesThrdParty(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesThrdParty(params);
  }

  @Override
  public EgovMap cnvrToSalesAddrInfo(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesAddrInfo(params);
  }

  @Override
  public EgovMap cnvrToSalesCntcInfo(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesCntcInfo(params);
  }

  @Override
  public List<EgovMap> cnvrToSalesfilterChgList(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesfilterChgList(params);
  }

  @Override
  public EgovMap cnvrToSalesOrderInfo2nd(Map<String, Object> params) {
    return membershipRentalQuotationMapper.cnvrToSalesOrderInfo2nd(params);
  }

  @Override
  public EgovMap insertCnvrToSale(Map<String, Object> params) {

    EgovMap trnMap = new EgovMap();

    Map<String, Object> saveParam = new HashMap<String, Object>();
    saveParam.put("userId", params.get("userId"));

    saveParam.put("docNoId", 140);
    String getDocId = orderInvestMapper.getDocNo(saveParam);
    int getSrvCntrctIdSeq = membershipRentalQuotationMapper.getSrvCntrctIdSeq();
    int getCntrctIdSeq = membershipRentalQuotationMapper.getCntrctIdSeq();
    saveParam.put("getSrvCntrctIdSeq", getSrvCntrctIdSeq);
    saveParam.put("getCntrctIdSeq", getCntrctIdSeq);

    saveParam.put("srvCntrctRefNo", getDocId);
    saveParam.put("srvCntrctQuotId", params.get("srvCntrctQuotId"));
    saveParam.put("srvCntrctOrdId", params.get("hiddenOrdId"));
    saveParam.put("srvCntrctStusId", 1);
    saveParam.put("srvCntrctPckgId", params.get("hiddenQotatPckgId"));
    saveParam.put("srvCntrctRem", "");
    saveParam.put("srvCntrctNetMonth", 0);
    saveParam.put("srvCntrctNetYear", 0);
    saveParam.put("srvCntrctRental", params.get("rentalAmt"));
    saveParam.put("srvCntrctExpFilter", params.get("filterAmt"));
    saveParam.put("srvCntrctBrnchId", params.get("branchId"));
    saveParam.put("srvCntrctSalesman", params.get("qotatSalesmanId"));
    saveParam.put("srvCntrcPromoId", params.get("qotatPacPromoId"));
    membershipRentalQuotationMapper.insertSrvContract(saveParam);

    saveParam.put("cntrctRentalStus", "ACT");
    saveParam.put("cntrctRem", "");
    membershipRentalQuotationMapper.insertSrvContractSub(saveParam);

    int serviceCntractQotatCnt = membershipRentalQuotationMapper.serviceCntractQotatCnt(saveParam);
    if (serviceCntractQotatCnt > 0) {
      saveParam.put("qotatStusId", 4);
      membershipRentalQuotationMapper.updateSAL0083D(saveParam);
    }

    // ONGHC - REMOVE FROM BACKEND AND MOVE TO SP.
    /* Map<String, Object> saveSchdule = new HashMap<String, Object>();
    // int getSrvPaySchdulIdSeq =
    // membershipRentalQuotationMapper.getSrvPaySchdulIdSeq();

    Calendar oCalendar = Calendar.getInstance();
    Date curdate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

    int yyyy = oCalendar.get(oCalendar.YEAR);
    int k = 1;
    int mm = oCalendar.get(oCalendar.MONTH) + 1;
    for (int i = 0; i < 24; i++) {

      saveSchdule.put("srvPayCntrctId", getSrvCntrctIdSeq);
      saveSchdule.put("srvPaySchdulOrdId", params.get("hiddenOrdId"));
      saveSchdule.put("srvPaySchdulNo", i + 1);

      saveSchdule.put("srvPaySchdulTypeId", 0);
      saveSchdule.put("srvPaySchdulAmt", params.get("rentalAmt"));
      saveSchdule.put("srvPaySchdulStusId", 1);
      saveSchdule.put("srvPaySchdulRem", " ");

      if (mm > 12) {
        // oCalendar.set(oCalendar.YEAR , oCalendar.get(oCalendar.YEAR)+k);

        if (mm % 12 == 1) {
          yyyy++;
        }
      }

      int realMm = 0;
      if (mm % 12 == 0) {
        realMm = 12;
      } else {
        realMm = mm % 12;
      }

      saveSchdule.put("srvPaySchdulMonth", realMm);
      saveSchdule.put("srvPaySchdulYear", yyyy);
      mm++;
      membershipRentalQuotationMapper.insertSrvPaySchdul(saveSchdule);
    } */

    EgovMap cnvrToSalesSrvConfigur = membershipRentalQuotationMapper.cnvrToSalesSrvConfigur(saveParam);
    saveParam.put("qotatStusId", 4);
    saveParam.put("srvConfigId", cnvrToSalesSrvConfigur.get("srvConfigId"));
    membershipRentalQuotationMapper.updateSAL0083D(saveParam);

    int getSrvPrdIdSeq = membershipRentalQuotationMapper.getSrvPrdIdSeq();

    saveParam.put("getSrvPrdIdSeq", getSrvPrdIdSeq);
    // saveParam.put("srvConfigId", getSrvPrdIdSeq); 위에
    saveParam.put("srvMbrshId", 0);
    saveParam.put("srvPrdStartDt", SalesConstants.DEFAULT_DATE2);
    saveParam.put("srvPrdExprDt", SalesConstants.DEFAULT_DATE2);
    saveParam.put("srcPrdDur", 2);
    saveParam.put("srcPrdStusId", 1);
    saveParam.put("srcPrdRem", " ");
    saveParam.put("srvPrdCntrctId", getSrvCntrctIdSeq);
    membershipRentalQuotationMapper.insertSrvConfigPeriod(saveParam);

    saveParam.put("cnfmOrdId", params.get("hiddenOrdId"));
    saveParam.put("cnfmCntrctId", getSrvCntrctIdSeq);
    saveParam.put("cnfmCustTypeId", 0);
    saveParam.put("cnfmTypeId", 0);
    saveParam.put("cnfmStusId", 1);
    saveParam.put("cnfmFdbckId", 0);
    saveParam.put("cnfmRem", " ");
    saveParam.put("cnfmPncRem", " ");
    membershipRentalQuotationMapper.insertSrvCntrctConfirm(saveParam);

    saveParam.put("poOrdId", params.get("hiddenOrdId"));
    saveParam.put("poRefNo", params.get("poNo") != null ? params.get("poNo") : "");
    saveParam.put("poStartInstlmt", 1);
    saveParam.put("poEndInstlmt", 24);
    saveParam.put("poRem", "Default Purchase Order");
    saveParam.put("poStusId", 1);
    saveParam.put("poCntrctId", getSrvCntrctIdSeq);
    membershipRentalQuotationMapper.insertAccInvoicePo(saveParam);

    int rentMode = Integer.parseInt((String) params.get("cmbRentPaymode")); // recall,
                                                                            // calcel,
                                                                            // reversal
                                                                            // cancel
    int chkBoxThrdParty = Integer.parseInt((String) params.get("chkBoxThrdParty")); // recall,
                                                                                    // calcel,
                                                                                    // reversal
                                                                                    // cancel

    saveParam.put("srvCntrctOrdId", params.get("hiddenOrdId"));
    saveParam.put("modeId", rentMode);
    saveParam.put("custCrcId", rentMode == 131 ? params.get("hiddenRentPayCRCId") : 0);
    saveParam.put("bankId",
        rentMode == 131 ? params.get("hiddenRentPayCRCBankId") : rentMode == 132 ? params.get("hiddenAccBankId") : 0);
    saveParam.put("custAccId", rentMode == 132 ? params.get("hiddenRentPayBankAccID") : 0);
    saveParam.put("ddSubmitDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("ddStartDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("ddRejctDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("stusCodeId", 1);
    saveParam.put("is3rdParty", chkBoxThrdParty);
    saveParam.put("custId", chkBoxThrdParty == 1 ? params.get("hiddenThrdPartyId") : params.get("thrdPartyId"));
    saveParam.put("editTypeId", 0);
    saveParam.put("nricOld", params.get("rentPayIc") != null ? params.get("rentPayIc") : " ");
    saveParam.put("failResnId", 0);
    saveParam.put("issuNric", (params.get("rentPayIc").toString() != null && params.get("rentPayIc").toString() != "") ?  params.get("rentPayIc").toString()
                                       : (params.get("thrdPartyNric").toString() != null && params.get("thrdPartyNric") != "") ? params.get("thrdPartyNric")
                                       : (params.get("hiddenNRIC").toString() != null && params.get("hiddenNRIC") != "") ? params.get("hiddenNRIC").toString()
                                           : " - ");
    saveParam.put("aeonCnvr", 0);
    saveParam.put("rem", "");
    saveParam.put("lastApplyUser", 1);
    saveParam.put("payTrm", 0);
    saveParam.put("svcCntrctId", getSrvCntrctIdSeq);
    membershipRentalQuotationMapper.insertRentPaySet(saveParam);

    String AdtPayMode = "REG";
    int IssueBankID = 0;
    String BankAccName = "";
    String BankAccNo = "";

    if (rentMode == 130) {
      AdtPayMode = "REG";
    } else if (rentMode == 131) {
      AdtPayMode = "CRC";
      IssueBankID = Integer.parseInt((String) params.get("hiddenRentPayCRCBankId"));
      BankAccName = (String) params.get("rentPayCRCName");
      BankAccNo = (String) params.get("hiddenRentPayEncryptCRCNoId");
    } else if (rentMode == 132) {
      AdtPayMode = "DD";
      IssueBankID = Integer.parseInt((String) params.get("hiddenRentPayBankAccID"));
      BankAccName = (String) params.get("accName");
      BankAccNo = (String) params.get("rentPayBankAccNo");
    } else if (rentMode == 133) {
      AdtPayMode = "AEON";
    } else if (rentMode == 134) {
      AdtPayMode = "FPX";
    }
    saveParam.put("accClSrvCntrctId", getSrvCntrctIdSeq);
    saveParam.put("accClBillClmAmt", params.get("rentalAmt"));
    saveParam.put("accClClmAmt", params.get("rentalAmt"));
    saveParam.put("accClPromo", 0);
    saveParam.put("accClBankCode", 0);//////////////////
    saveParam.put("accClBankAccNo", BankAccNo);
    saveParam.put("accDecBankAccNo", "");
    saveParam.put("accClReqstMCode", "");
    saveParam.put("accClSubmitDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("accClAppvDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("accClRejctDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("accClStusId", "ACT");
    saveParam.put("accClPromoChkId", 0);
    saveParam.put("accClPromoStartDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("accClRejctId", "");
    saveParam.put("accClAccTName", BankAccName);
    saveParam.put("accClAccNric", params.get("rentPayIc") != null ? params.get("rentPayIc")
        : chkBoxThrdParty == 1 ? params.get("hiddenThrdPartyId") : params.get("thrdPartyId"));
    saveParam.put("accClSplClmAmt", 0);
    saveParam.put("accClSoNo", params.get("hiddenOrdNo"));
    saveParam.put("accClUserName", params.get("userName"));
    saveParam.put("accClPayMode", AdtPayMode);
    saveParam.put("accClPayModeId", rentMode);
    saveParam.put("accClBankId", IssueBankID);
    saveParam.put("accClClmLimit", 0);
    saveParam.put("accClBillDt", 5);
    membershipRentalQuotationMapper.insertAccClaimAdt(saveParam);

    saveParam.put("qotatCrtUserId", params.get("qotatCrtUserId"));
    membershipRentalQuotationMapper.spInstRscRentalBill(saveParam);
    return trnMap;
  }

  @Override
  public void updateStus(Map<String, Object> params) {

    params.put("qotatStusId", 8);
    membershipRentalQuotationMapper.updateSAL0083D(params);
  }

}
