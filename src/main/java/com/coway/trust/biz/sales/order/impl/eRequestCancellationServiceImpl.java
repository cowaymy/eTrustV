/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.impl.CcpCalculateMapper;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.order.eRequestCancellationService;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.sales.order.eRequestCancellationController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("eRequestCancellationService")
public class eRequestCancellationServiceImpl extends EgovAbstractServiceImpl implements eRequestCancellationService {

  private static Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);

  @Resource(name = "eRequestCancellationMapper")
  private eRequestCancellationMapper eRequestCancellationMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "orderRequestMapper")
  private OrderRequestMapper orderRequestMapper;

  @Resource(name = "ccpCalculateMapper")
  private CcpCalculateMapper ccpCalculateMapper;

  @Resource(name = "orderSuspensionMapper")
  private OrderSuspensionMapper orderSuspensionMapper;

  @Resource(name = "orderCancelMapper")
  private OrderCancelMapper orderCancelMapper;

  @Resource(name = "orderInvestMapper")
  private OrderInvestMapper orderInvestMapper;

  @Resource(name = "orderExchangeMapper")
  private OrderExchangeMapper orderExchangeMapper;

  @Override
  public List<EgovMap> selectOrderList(Map<String, Object> params) {
    return eRequestCancellationMapper.selectOrderList(params);
  }

  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {

    EgovMap orderDetail = new EgovMap();
    // Basic Info
    EgovMap basicInfo = eRequestCancellationMapper.selectBasicInfo(params);
    EgovMap logView = eRequestCancellationMapper.selectLatestOrderLogByOrderID(params);
    EgovMap agreementView = eRequestCancellationMapper.selectOrderAgreementByOrderID(params);
    EgovMap installationInfo = eRequestCancellationMapper.selectOrderInstallationInfoByOrderID(params);
    EgovMap ccpFeedbackCode = eRequestCancellationMapper.selectOrderCCPFeedbackCodeByOrderID(params);
    EgovMap ccpInfo = eRequestCancellationMapper.selectOrderCCPInfoByOrderID(params);
    EgovMap salesmanInfo = eRequestCancellationMapper.selectOrderSalesmanViewByOrderID(params);
    EgovMap codyInfo = eRequestCancellationMapper.selectOrderServiceMemberViewByOrderID(params);
    EgovMap mailingInfo = eRequestCancellationMapper.selectOrderMailingInfoByOrderID(params);
    EgovMap rentPaySetInf = null;
    EgovMap thirdPartyInfo = null;
    EgovMap grntnfo = null;
    EgovMap orderCfgInfo = eRequestCancellationMapper.selectOrderConfigInfo(params);
    EgovMap gstCertInfo = eRequestCancellationMapper.selectGSTCertInfo(params);

    String memInfo = eRequestCancellationMapper.selectMemberInfo((String) basicInfo.get("custNric"));

    if (CommonUtils.isNotEmpty(memInfo)) {
      basicInfo.put("memInfo", "(" + memInfo + ")");
    }

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode").toString())
        || SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS.equals(basicInfo.get("appTypeCode").toString())) {

      rentPaySetInf = eRequestCancellationMapper.selectOrderRentPaySetInfoByOrderID(params);

      if (rentPaySetInf != null) {

        this.loadRentPaySetInf(rentPaySetInf, sessionVO);

        if (((BigDecimal) rentPaySetInf.get("is3party")).compareTo(BigDecimal.ONE) == 0) {
          rentPaySetInf.put("is3party", "Yes");

          params.put("testparam", rentPaySetInf.get("payerCustId"));

          thirdPartyInfo = customerMapper.selectCustomerViewBasicInfo(params);
        } else {
          rentPaySetInf.put("is3Party", "No");
        }

        if ("01/01/1900".equals(rentPaySetInf.get("rentPayApplyDt"))) {
          rentPaySetInf.put("rentPayApplyDt", "-");
        }
        if ("01/01/1900".equals(rentPaySetInf.get("rentPaySubmitDt"))) {
          rentPaySetInf.put("rentPaySubmitDt", "-");
        }
        if ("01/01/1900".equals(rentPaySetInf.get("rentPayStartDt"))) {
          rentPaySetInf.put("rentPayStartDt", "-");
        }
        if ("01/01/1900".equals(rentPaySetInf.get("rentPayRejctDt"))) {
          rentPaySetInf.put("rentPayRejctDt", "-");
        }
      }

      if (Integer.toString(SalesConstants.SALES_CCP_CODEID)
          .equals(((BigDecimal) basicInfo.get("rentChkId")).toString())) {
        grntnfo = eRequestCancellationMapper.selectGuaranteeInfo(params);
        this.loadOrderGuaranteeInfo(grntnfo, installationInfo);
      }
    }

    this.loadBasicInfo(basicInfo);
    this.loadCustInfo(basicInfo);
    if (installationInfo != null)
      this.loadInstallationInfo(installationInfo);
    if (mailingInfo != null)
      this.loadMailingInfo(mailingInfo, basicInfo);
    if (orderCfgInfo != null)
      this.loadConfigInfo(orderCfgInfo);
    // if(gstCertInfo != null) this.loadGstCertInfo(gstCertInfo);

    orderDetail.put("basicInfo", basicInfo);
    orderDetail.put("logView", logView);
    orderDetail.put("agreementView", agreementView);
    orderDetail.put("installationInfo", installationInfo);
    orderDetail.put("ccpFeedbackCode", ccpFeedbackCode);
    orderDetail.put("ccpInfo", ccpInfo);
    orderDetail.put("salesmanInfo", salesmanInfo);
    orderDetail.put("codyInfo", codyInfo);
    orderDetail.put("mailingInfo", mailingInfo);
    orderDetail.put("rentPaySetInf", rentPaySetInf);
    orderDetail.put("thirdPartyInfo", thirdPartyInfo);
    orderDetail.put("orderCfgInfo", orderCfgInfo);
    orderDetail.put("gstCertInfo", gstCertInfo);

    Date salesDt = (Date) basicInfo.get("ordDt");

    DateFormat formatter = new SimpleDateFormat("yyyyMMdd");

    Date dt = formatter.parse("20180101");

    logger.debug("@#### salesDt:" + salesDt);
    logger.debug("@#### dt:" + dt);

    boolean isNew = salesDt.after(dt);

    logger.debug("@#### isBefore:" + isNew);

    orderDetail.put("isNewVer", isNew ? "Y" : "N");

    return orderDetail;
  };

  private void loadRentPaySetInf(EgovMap rentPaySetInf, SessionVO sessionVO) {

    if (!"DD".equals((String) rentPaySetInf.get("rentPayModeCode"))) {
      rentPaySetInf.put("clmDdMode", "-");
    }
    if (((BigDecimal) rentPaySetInf.get("clmLimit")).compareTo(BigDecimal.ZERO) <= 0) {
      rentPaySetInf.put("clmLimit", "-");
    }

    if (CommonUtils.isNotEmpty((String) rentPaySetInf.get("rentPayIssBankCode"))) {
      rentPaySetInf.put("rentPayIssBank",
          (String) rentPaySetInf.get("rentPayIssBankCode") + " - " + (String) rentPaySetInf.get("rentPayIssBankName"));
    } else {
      rentPaySetInf.put("rentPayIssBank", "-");
    }

    if (((BigDecimal) rentPaySetInf.get("cardTypeId")).compareTo(BigDecimal.ZERO) <= 0) {
      rentPaySetInf.put("cardType", "-");
    }

    if (CommonUtils.isNotEmpty(rentPaySetInf.get("rentPayCrcNo"))) {
      Map<String, Object> pMap = new HashMap<String, Object>();

      pMap.put("userId", sessionVO.getUserId());
      pMap.put("moduleUnitId", "252");

      EgovMap rsltMap = orderRegisterMapper.selectCheckAccessRight(pMap);

      if (rsltMap == null) {
        rentPaySetInf.put("rentPayCrcNo",
            CommonUtils.getMaskCreditCardNo(StringUtils.trim((String) rentPaySetInf.get("rentPayCrcNo")), "*", 6));
      }
    } else {
      rentPaySetInf.put("rentPayCrcNo", "-");
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayCrOwner"))) {
      rentPaySetInf.put("rentPayCrOwner", "-");
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayCrcExpr"))) {
      rentPaySetInf.put("rentPayCrcExpr", "-");
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayAccNo"))) {
      rentPaySetInf.put("rentPayAccNo", "-");
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayAccOwner"))) {
      rentPaySetInf.put("rentPayAccOwner", "-");
    }

    rentPaySetInf.put("issuNric", CommonUtils.nvl((String) rentPaySetInf.get("issuNric"), "-"));

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayApplyDt"))
        || SalesConstants.DEFAULT_DATE2.equals(rentPaySetInf.get("rentPayApplyDt"))) {
      rentPaySetInf.put("rentPayApplyDt", "-");
    } else {
      rentPaySetInf.put("rentPayApplyDt", CommonUtils.changeFormat((String) rentPaySetInf.get("rentPayApplyDt"),
          SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPaySubmitDt"))
        || SalesConstants.DEFAULT_DATE2.equals(rentPaySetInf.get("rentPaySubmitDt"))) {
      rentPaySetInf.put("rentPaySubmitDt", "-");
    } else {
      rentPaySetInf.put("rentPaySubmitDt", CommonUtils.changeFormat((String) rentPaySetInf.get("rentPaySubmitDt"),
          SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayStartDt"))
        || SalesConstants.DEFAULT_DATE2.equals(rentPaySetInf.get("rentPayStartDt"))) {
      rentPaySetInf.put("rentPayStartDt", "-");
    } else {
      rentPaySetInf.put("rentPayStartDt", CommonUtils.changeFormat((String) rentPaySetInf.get("rentPayStartDt"),
          SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    }

    if (CommonUtils.isEmpty(rentPaySetInf.get("rentPayRejctDt"))
        || SalesConstants.DEFAULT_DATE2.equals(rentPaySetInf.get("rentPayRejctDt"))) {
      rentPaySetInf.put("rentPayRejctDt", "-");
    } else {
      rentPaySetInf.put("rentPayRejctDt", CommonUtils.changeFormat((String) rentPaySetInf.get("rentPayRejctDt"),
          SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    }

    if (CommonUtils.isNotEmpty(rentPaySetInf.get("rentPayRejctCode"))) {
      rentPaySetInf.put("rentPayRejct",
          "(" + rentPaySetInf.get("rentPayRejctCode") + ") " + rentPaySetInf.get("rentPayRejctDesc"));
    } else {
      rentPaySetInf.put("rentPayRejct", "-");
    }

  }

  private void loadOrderGuaranteeInfo(EgovMap grntnfo, EgovMap installationInfo) throws ParseException {

    SimpleDateFormat format = new SimpleDateFormat(SalesConstants.DEFAULT_DATE_FORMAT3, Locale.getDefault());
    SimpleDateFormat format2 = new SimpleDateFormat(SalesConstants.DEFAULT_DATE_FORMAT1, Locale.getDefault());
    String fiDt = (String) installationInfo.get("firstInstallDt");

    String[] arrFidt = fiDt.split("/");

    Calendar c = Calendar.getInstance();

    c.set(Integer.valueOf(arrFidt[2]), Integer.valueOf(arrFidt[1]) - 1, Integer.valueOf(arrFidt[0]), 0, 0, 0);
    c.add(Calendar.MONTH, 25);

    logger.debug("!@###### Calendar.MONTH  : " + Calendar.MONTH);

    Date firstInstallDt = format2.parse(fiDt);
    Date aftDate = c.getTime();
    Date nowDate = format.parse(CommonUtils.getNowDate());
    Date defaultDate = format.parse(SalesConstants.DEFAULT_DATE3);

    logger.debug("!@##############################################################################");
    logger.debug("!@###### firstInstallDt  : " + firstInstallDt);
    logger.debug("!@###### firstInstallDt  : " + firstInstallDt);
    logger.debug("!@###### aftDate  : " + aftDate);
    logger.debug("!@###### nowDate  : " + nowDate);
    logger.debug("!@###### dflDate  := " + defaultDate);
    logger.debug("!@##############################################################################");

    if (grntnfo != null) {

      if (firstInstallDt.after(defaultDate)) {
        if (nowDate.after(aftDate)) {
          grntnfo.put("grntStatus", "Expired");
        } else {
          grntnfo.put("grntStatus", "Active");
        }
      }

      if (CommonUtils.isEmpty(grntnfo.get("memCode4"))) {
        grntnfo.put("grntHPCode", grntnfo.get("memCode4"));
        grntnfo.put("grntHPName", grntnfo.get("name4") + " (" + grntnfo.get("nric4") + ")");
      }
      if (CommonUtils.isEmpty(grntnfo.get("memCode3"))) {
        grntnfo.put("grntHMCode", grntnfo.get("memCode3"));
        grntnfo.put("grntHMName", grntnfo.get("name3") + " (" + grntnfo.get("nric3") + ")");
      }
      if (CommonUtils.isEmpty(grntnfo.get("memCode2"))) {
        grntnfo.put("grntSMCode", grntnfo.get("memCode2"));
        grntnfo.put("grntSMName", grntnfo.get("name2") + " (" + grntnfo.get("nric2") + ")");
      }
      if (CommonUtils.isEmpty(grntnfo.get("memCode"))) {
        grntnfo.put("grntGMCode", grntnfo.get("memCode"));
        grntnfo.put("grntGMName", grntnfo.get("name") + " (" + grntnfo.get("nric") + ")");
      }
    }
  }

  private void loadBasicInfo(EgovMap basicInfo) throws Exception {

    BigDecimal mthRentalFees = null;
    String installmentDuration = "-";
    String rentalStatus = "-";
    int obligationYear = 0;

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))) {
      mthRentalFees = (BigDecimal) basicInfo.get("ordMthRental");
      rentalStatus = (String) basicInfo.get("rentalStus");
    }

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))
        || SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS.equals(basicInfo.get("appTypeCode"))) {

      Date salesDt = (Date) basicInfo.get("ordDt");

      DateFormat formatter = new SimpleDateFormat("yyyyMMdd");

      Date dt = formatter.parse("20180101");

      logger.debug("@#### salesDt:" + salesDt);
      logger.debug("@#### dt:" + dt);

      boolean isNew = salesDt.after(dt);

      if (isNew) {
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("salesOrdId", basicInfo.get("ordId"));

        EgovMap rsltMap = orderRequestMapper.selectObligtPriod(map);

        if (rsltMap != null) {
          obligationYear = CommonUtils.intNvl(rsltMap.get("obligtPriod"));
        }
      } else {
        obligationYear = CommonUtils.intNvl(basicInfo.get("obligtYear"));
      }
    } else if (SalesConstants.APP_TYPE_CODE_INSTALLMENT.equals(basicInfo.get("appTypeCode"))) {

      installmentDuration = String.valueOf(basicInfo.get("instlmtPriod"));
      // installmentDuration = (String)basicInfo.get("instlmtPriod");

    }

    basicInfo.put("mthRentalFees", mthRentalFees);
    basicInfo.put("installmentDuration", installmentDuration);
    basicInfo.put("rentalStatus", rentalStatus);

    if (obligationYear == 0) {
      basicInfo.put("obligtYear", "-");
    } else {
      basicInfo.put("obligtYear", Integer.valueOf(obligationYear) + " " + " month");
    }

    if (SalesConstants.PROMO_DISC_TYPE_EQUAL == CommonUtils.intNvl(basicInfo.get("promoDiscPeriodTp"))) {
      basicInfo.put("PORMO_PERIOD_TYPE", basicInfo.get("promoDiscPeriodTpNm"));
    } else if (SalesConstants.PROMO_DISC_TYPE_EARLY == CommonUtils.intNvl(basicInfo.get("promoDiscPeriodTp"))
        || SalesConstants.PROMO_DISC_TYPE_LATE == CommonUtils.intNvl(basicInfo.get("promoDiscPeriodTp"))) {
      basicInfo.put("PORMO_PERIOD_TYPE",
          (String) basicInfo.get("promoDiscPeriodTpNm") + "(" + basicInfo.get("promoDiscPeriod") + " month)");
    } else {
      basicInfo.put("PORMO_PERIOD_TYPE", "-");
    }
  }

  private void loadCustInfo(EgovMap basicInfo) {

    if (basicInfo != null) {
      if (CommonUtils.isNotEmpty(basicInfo.get("custGender"))) {
        if ("M".equals(StringUtils.trim((String) basicInfo.get("custGender")))) {
          basicInfo.put("custGender", "Male");
        } else if ("F".equals(StringUtils.trim((String) basicInfo.get("custGender")))) {
          basicInfo.put("custGender", "Female");
        }
      }
    }

    if (CommonUtils.isEmpty(basicInfo.get("custPassportExpr"))
        || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custPassportExpr"))) {
      basicInfo.put("custPassportExpr", "-");
    }

    if (CommonUtils.isEmpty(basicInfo.get("custVisaExpr"))
        || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custVisaExpr"))) {
      basicInfo.put("custVisaExpr", "-");
    }
  }

  private void loadInstallationInfo(EgovMap installationInfo) {

    if (installationInfo != null) {
      // TODO 날짜비교 로직 추가
      if (CommonUtils.isEmpty(installationInfo.get("preferInstDt"))
          || SalesConstants.DEFAULT_DATE2.equals(installationInfo.get("preferInstDt"))) {
        installationInfo.put("preferInstDt", "-");
      } else {
        installationInfo.put("preferInstDt",
            CommonUtils.changeFormat(String.valueOf(installationInfo.get("preferInstDt")),
                SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
        /* TypeCast Exception */
        // installationInfo.put("preferInstDt",
        // CommonUtils.changeFormat((String)installationInfo.get("preferInstDt"),
        // SalesConstants.DEFAULT_DATE_FORMAT2,
        // SalesConstants.DEFAULT_DATE_FORMAT1));

      }

      if (CommonUtils.isEmpty(installationInfo.get("preferInstTm"))) {
        installationInfo.put("preferInstTm", "-");
      }

      if (CommonUtils.isEmpty(installationInfo.get("firstInstallDt"))
          || SalesConstants.DEFAULT_DATE.equals(installationInfo.get("firstInstallDt"))) {
        installationInfo.put("firstInstallDt", "-");
      } else {
        installationInfo.put("firstInstallDt",
            CommonUtils.changeFormat(String.valueOf(installationInfo.get("firstInstallDt")),
                SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
        /* TypeCast Exception */
        // installationInfo.put("firstInstallDt",
        // CommonUtils.changeFormat((String)installationInfo.get("firstInstallDt"),
        // SalesConstants.DEFAULT_DATE_FORMAT2,
        // SalesConstants.DEFAULT_DATE_FORMAT1));
      }

      if (CommonUtils.isEmpty(installationInfo.get("instCntGender"))) {
        if ("M".equals(StringUtils.trim((String) installationInfo.get("instCntGender")))) {
          installationInfo.put("instCntGender", "Male");
        } else if ("F".equals(StringUtils.trim((String) installationInfo.get("instCntGender")))) {
          installationInfo.put("instCntGender", "Female");
        }
      }

      if (CommonUtils.isEmpty(installationInfo.get("updDt"))
          || SalesConstants.DEFAULT_DATE2.equals(installationInfo.get("updDt"))) {
        installationInfo.put("updDt", "-");
      }

      String instct = StringUtils.replace((String) installationInfo.get("instct"), "<", "(");

      // instct = StringUtils.replace(instct,
      // System.getProperty("line.separator"), "<br>");

      installationInfo.put("instct", instct);
    }
  }

  private void loadMailingInfo(EgovMap mailingInfo, EgovMap basicInfo) {

    String fullAddress = "";

    if (CommonUtils.isNotEmpty(mailingInfo.get("mailAdd1"))) {
      fullAddress += mailingInfo.get("mailAdd1") + "<br />";
    }
    if (CommonUtils.isNotEmpty(mailingInfo.get("mailAdd2"))) {
      fullAddress += mailingInfo.get("mailAdd2") + "<br />";
    }
    if (CommonUtils.isNotEmpty(mailingInfo.get("mailAdd3"))) {
      fullAddress += mailingInfo.get("mailAdd3") + "<br />";
    }

    mailingInfo.put("fullAddress", fullAddress);

    if (!SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))) {
      mailingInfo.put("billGrpNo", "-");
    }

  }

  private void loadConfigInfo(EgovMap orderCfgInfo) {
    orderCfgInfo.put("configBsGen",
        ((BigDecimal) orderCfgInfo.get("configBsGen")).compareTo(BigDecimal.ONE) == 0 ? "Available" : "Unavailable");
  }

  @Override
  public List<EgovMap> selectCallLogList(Map<String, Object> params) {
    return eRequestCancellationMapper.selectCallLogList(params);
  }

  @Override
  public EgovMap checkeRequestAutoDebitDeduction(Map<String, Object> params) {

    EgovMap result = new EgovMap();

    // int ccpResult =
    // eRequestCancellationMapper.selectCcpDecisionMById(params);
    int eCashResult = eRequestCancellationMapper.selectECashDeductionItemById(params);

    /*
     * if(ccpResult > 0){ result.put("ccpStus",1); result.put("msg",
     * "CCP Result is not approve"); }
     */
    if (eCashResult > 0) {
      result.put("eCashStus", 1);
      result.put("msg", "eCash is Active");
    }

    return result;
  }

  @Override
  public EgovMap validRequestOCRStus(Map<String, Object> params) {

    EgovMap result = new EgovMap();

    int callLogResult = eRequestCancellationMapper.validRequestOCRStus(params);

    if (callLogResult > 0) {
      result.put("callLogResult", 1);
      result.put("msg", "OCR is not allowed due to Installation Status still Active");
    }

    return result;
  }

  @Override
  public ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {

    logger.info("!@###### START eRequest Cancellation ##############");

    EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
    EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);

    int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal) somMap.get("stusCodeId")));
    int appTypeId = CommonUtils.intNvl(String.valueOf((BigDecimal) somMap.get("appTypeId")));

    // GET REQUEST NUMBER
    String reqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.CANCEL_REQUEST);

    logger.info("!@#### GET NEW REQ_NO  :" + reqNo);

    int LatestOrderCallEntryID = 0;

    if (SalesConstants.STATUS_ACTIVE == stusCodeId) {
      // Active
      params.put("opt", "1");
      EgovMap callEntryMap1 = orderRequestMapper.selectCallEntry(params);

      if (callEntryMap1 != null) {
        LatestOrderCallEntryID = CommonUtils.intNvl(callEntryMap1.get("callEntryId"));
      }
    } else {
      // Complete
      EgovMap ineMap = orderRequestMapper.selectInstallEntry(params);

      if (ineMap != null) {
        LatestOrderCallEntryID = CommonUtils.intNvl(String.valueOf((BigDecimal) ineMap.get("callEntryId")));
      }
    }

    SalesReqCancelVO salesReqCancelVO = new SalesReqCancelVO();
    CallEntryVO callEntryMasterVO = new CallEntryVO();
    CallResultVO callResultVO = new CallResultVO();
    CallResultVO cancCallResultVO = new CallResultVO();

    params.put("stusCodeId", stusCodeId);
    params.put("appTypeId", appTypeId);
    params.put("callEntryId", LatestOrderCallEntryID);
    params.put("tempOrdId", params.get("salesOrdId"));
    params.put("userId", sessionVO.getUserId());

    this.preprocSalesReqCancel(salesReqCancelVO, params, sessionVO);
    this.preprocCallEntryMaster(callEntryMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
    this.preprocCallResultDetails(callResultVO, params, sessionVO);
    this.preprocCancelCallResultDetails(cancCallResultVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);

    salesReqCancelVO.setSoReqPrevCallEntryId(LatestOrderCallEntryID);
    salesReqCancelVO.setSoReqCurStkId(CommonUtils.intNvl(String.valueOf((BigDecimal) sodMap.get("itmStkId"))));
    salesReqCancelVO.setSoReqCurAmt((BigDecimal) somMap.get("totAmt"));
    salesReqCancelVO.setSoReqCurPv((BigDecimal) somMap.get("totPv"));
    salesReqCancelVO.setSoReqCurrAmt((BigDecimal) somMap.get("mthRentAmt"));
    salesReqCancelVO.setSoReqNo(reqNo);
    // if(LatestOrderCallEntryID == 0) salesReqCancelVO.setSoReqStusId(32);

    orderRequestMapper.insertSalesReqCancel(salesReqCancelVO); // SAL0020D

    // Added eCash validation - Kit - 2018/03/15
    // if(LatestOrderCallEntryID != 0){

    // PREVIOUS CALL LOG
    if (stusCodeId == SalesConstants.STATUS_ACTIVE) {
      EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);

      if (LatestOrderCallEntryID != 0) {
        cancCallResultVO.setCallEntryId(LatestOrderCallEntryID);
        cancCallResultVO.setCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal) ccleMap.get("callEntryId"))));
        orderRegisterMapper.insertCallResult(cancCallResultVO); // CCR0007D

        ccleMap.put("stusCodeId", cancCallResultVO.getCallStusId());
        ccleMap.put("resultId", cancCallResultVO.getCallResultId());
        ccleMap.put("updUserId", cancCallResultVO.getCallCrtUserId());

        orderRequestMapper.updateCallEntry2(ccleMap); // CCR0006D
      } else {
        cancCallResultVO.setCallEntryId(LatestOrderCallEntryID);
        orderRegisterMapper.insertCallResult(cancCallResultVO); // CCR0007D
      }
    }

    // CANCELLATION CALL LOG
    callEntryMasterVO.setDocId(salesReqCancelVO.getSoReqId());

    orderRegisterMapper.insertCallEntry(callEntryMasterVO); // CCR0006D

    callResultVO.setCallEntryId(callEntryMasterVO.getCallEntryId());

    orderRegisterMapper.insertCallResult(callResultVO); // CCR0007D

    Map<String, Object> tempMap = new HashMap<String, Object>();

    tempMap.put("soReqSeq", salesReqCancelVO.getSoReqId());
    tempMap.put("updCallEntryId", callResultVO.getCallEntryId());

    ccpCalculateMapper.updateOrderRequest(tempMap);

    callEntryMasterVO.setResultId(callResultVO.getCallResultId());

    orderRequestMapper.updateCallEntry(callEntryMasterVO);
    // }else{
    // params.put("updator",sessionVO.getUserId());
    // //INSERT ORDER LOG >> CANCELLATION CALL LOG
    // orderRequestMapper.updateSalesOrderLog(params);
    // //UPDATE SALESORDERM STATUS TO CANCEL
    // orderRequestMapper.updateSalesOrderMCanc(params);
    // }

    // RENTAL SCHEME
    if (appTypeId == 66) {
      EgovMap stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);

      if (stsMap != null) {
        // String stus = LatestOrderCallEntryID != 0 ? "RET" : "CAN";

        stsMap.put("stusCodeId", "RET");
        stsMap.put("isSync", SalesConstants.IS_FALSE);
        stsMap.put("salesOrdId", params.get("salesOrdId"));

        orderRequestMapper.updateRentalScheme(stsMap);
      }
    }

    // INSERT ORDER LOG >> CANCELLATION CALL LOG
    SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();

    this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
    // if(LatestOrderCallEntryID == 0 ) salesOrderLogVO.setPrgrsId(13);
    salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());

    orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);

    logger.info("!@###### END eRequest Cancellation ##############");

    Map<String, Object> saveParam = new HashMap<String, Object>();

    saveParam.put("callEntryId", callResultVO.getCallEntryId());
    saveParam.put("callStusId", "32"); // Confirm to Cancel
    saveParam.put("callFdbckId", "1649"); // C014 - OTHER
    saveParam.put("callCtId", 0);
    saveParam.put("callRem", "CANCEL & REFUND"); // Remark
    saveParam.put("callCrtUserId", sessionVO.getUserId());
    saveParam.put("callCrtUserIdDept", 0);
    saveParam.put("callHcId", 0);
    saveParam.put("callRosAmt", 0);
    saveParam.put("callSms", 0);
    saveParam.put("callSmsRem", "");
    saveParam.put("salesOrdId", params.get("salesOrdId"));

    int ccpResult = eRequestCancellationMapper.selectCcpDecisionMById(params);

    if (ccpResult > 0) {
      eRequestCancellationMapper.updateCcpStatus(params); // CCP Results

    }

    logger.info("####################### Confirm To Cancel save Start!! #####################");

    saveParam.put("userId", sessionVO.getUserId());
    EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam); // CallEntry
    saveParam.put("resultId", getResultId.get("resultId"));

    saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
    saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
    orderSuspensionMapper.insertCCR0007DSuspend(saveParam); // CallResult
    orderCancelMapper.updateCancelCCR0006D(saveParam); // CallEntry

    saveParam.put("soReqId", salesReqCancelVO.getSoReqId());
    orderCancelMapper.updReservalCancelSAL0020D(saveParam); // SalesReqCancel

    orderCancelMapper.newSearchCancelSAL0020D(saveParam);

    if (appTypeId == 66) { // RENTAL
      EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam); // RentalScheme
      saveParam.put("renSchId", getRenSchId.get("renSchId"));
      saveParam.put("rentalSchemeStusId", "CAN");
      orderCancelMapper.updateCancelSAL0071D(saveParam); // RentalScheme
    }

    orderCancelMapper.newSearchCancelSAL0001D(saveParam); // SalesOrderM
    saveParam.put("salesMstusCodeId", 10);
    orderCancelMapper.updateCancelSAL0001D(saveParam); // SalesOrderM
    saveParam.put("prgrsId", 13);
    saveParam.put("isLok", 0);
    saveParam.put("refId", 0);

    orderInvestMapper.insertSalesOrdLog(saveParam); // SalesOrderLog

    // COMBO PROMOTION
    EgovMap searchSAL0001D = orderCancelMapper.newSearchCancelSAL0001D(saveParam); // SalesOrderM

    logger.info("====================== PROMOTION COMBO CHECKING - START - ==========================");
    logger.info("= PARAM = " + searchSAL0001D.toString());

    // CHECK ORDER PROMOTION IS IT FALL ON COMBO PACKAGE PROMOTION
    // 1ST CHECK PCKAGE_BINDING_NO (SUB)
    int count = orderCancelMapper.chkSubPromo(searchSAL0001D);
    logger.info("= CHECK PCKAGE_BINDING_NO (SUB) = " + count);

    if (count > 0) {
      // CANCELLATION IS SUB COMBO PACKAGE.
      // TODO REVERT MAIN PRODUCT PROMO. CODE
      logger.info("====================== CANCELLATION IS SUB COMBO PACKAGE ==========================");

      EgovMap revCboPckage = orderCancelMapper.revSubCboPckage(searchSAL0001D);
      if (revCboPckage != null) {
        revCboPckage.put("reqStageId", "24");

        logger.info("= PARAM 2 = " + revCboPckage.toString());
        orderCancelMapper.insertSAL0254D(revCboPckage);
      }

    } else {
      // 2ND CHECK PACKAGE (MAIN)
      count = orderCancelMapper.chkMainPromo(searchSAL0001D);

      if (count > 0) {
        // CANCELLATION IS MAIN COMBO PACKAGE.
        // TODO REVERT SUB PRODUCT PROMO. CODE AND RENTAL PRICE

        logger.info("====================== CANCELLATION IS MAIN COMBO PACKAGE ==========================");

        EgovMap revCboPckage = orderCancelMapper.revMainCboPckage(searchSAL0001D);
        if (revCboPckage != null) {
          revCboPckage.put("reqStageId", "24");

          logger.info("= PARAM 2 = " + revCboPckage.toString());
          orderCancelMapper.insertSAL0254D(revCboPckage);
        }
      } else {
        // DO NOTHING (IS NOT A COMBO PACKAGE)
      }
    }
    logger.info("====================== PROMOTION COMBO CHECKING - END - ==========================");

    orderCancelMapper.updateCancelSAL0349D(saveParam); // update the table SAL0349D - DISB = 1 for Air Con Bulk promotion package

    logger.info("####################### Confirm To Cancel save END!! #####################");

    if(appTypeId == 66){
    	//rebate combo 202411 - [Enhancement] RM10 Rebate for HC Product Purchases (Combo)
    	orderCancelMapper.updateCancelSAL0424D(saveParam);
    }

    String msg = "Order Number : " + (String) somMap.get("salesOrdNo") + "<br/>Cancelled successfully.<br/>"
    // + "Request Number : " + reqNo + "<br />"
    ;

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage(msg);

    return message;
  }

  private void preprocSalesReqCancel(SalesReqCancelVO salesReqCancelVO, Map<String, Object> params,
      SessionVO sessionVO) {

    salesReqCancelVO.setSoReqId(0);
    salesReqCancelVO.setSoReqSoId(CommonUtils.intNvl((String) params.get("salesOrdId")));
    salesReqCancelVO.setSoReqStusId(SalesConstants.STATUS_ACTIVE);
    salesReqCancelVO.setSoReqCurStusId((int) params.get("stusCodeId") == 1 ? 24 : 25);
    salesReqCancelVO.setSoReqResnId(CommonUtils.intNvl((String) params.get("cmbReason")));
    salesReqCancelVO.setSoReqPrevCallEntryId(0);
    salesReqCancelVO.setSoReqCurCallEntryId(0);
    salesReqCancelVO.setSoReqCrtUserId(sessionVO.getUserId());
    salesReqCancelVO.setSoReqUpdUserId(sessionVO.getUserId());
    salesReqCancelVO.setSoReqCurStkId(0);
    salesReqCancelVO.setSoReqCurAppTypeId((int) params.get("appTypeId"));
    salesReqCancelVO.setSoReqCurAmt(BigDecimal.ZERO);
    salesReqCancelVO.setSoReqCurPv(BigDecimal.ZERO);
    salesReqCancelVO.setSoReqCurrAmt(BigDecimal.ZERO);
    salesReqCancelVO.setSoReqActualCanclDt(SalesConstants.DEFAULT_DATE);

    BigDecimal bdTotalAmount = (params.get("txtTotalAmount") == null) ? BigDecimal.ZERO
        : new BigDecimal((String) params.get("txtTotalAmount").toString().replace(",", ""));
    BigDecimal bdPenaltyCharge = (params.get("txtPenaltyCharge") == null) ? BigDecimal.ZERO
        : new BigDecimal((String) params.get("txtPenaltyCharge").toString().replace(",", ""));
    BigDecimal bdPenaltyAdj = (params.get("txtPenaltyAdj") == null) ? BigDecimal.ZERO
        : new BigDecimal((String) params.get("txtPenaltyAdj").toString().replace(",", ""));
    BigDecimal bdCurrentOutstanding = (params.get("txtCurrentOutstanding") == null) ? BigDecimal.ZERO
        : new BigDecimal((String) params.get("txtCurrentOutstanding").toString().replace(",", ""));

    logger.debug("bdTotalAmount : " + bdTotalAmount);
    logger.debug("bdPenaltyCharge : " + bdPenaltyCharge);
    logger.debug("bdPenaltyAdj : " + bdPenaltyAdj);
    logger.debug("bdCurrentOutstanding : " + bdCurrentOutstanding);

    salesReqCancelVO.setSoReqCanclTotOtstnd(bdTotalAmount);
    salesReqCancelVO.setSoReqCanclPnaltyAmt(bdPenaltyCharge);
    salesReqCancelVO.setSoReqCanclAdjAmt(bdPenaltyAdj);
    salesReqCancelVO.setSoReqCanclRentalOtstnd(bdCurrentOutstanding);

    salesReqCancelVO.setSoReqCanclObPriod(CommonUtils.intNvl((String) params.get("txtObPeriod")));
    salesReqCancelVO.setSoReqCanclUnderCoolPriod(SalesConstants.IS_FALSE);
    salesReqCancelVO.setSoReqCanclTotUsedPriod(CommonUtils.intNvl((String) params.get("txtTotalUseMth")));
    salesReqCancelVO.setSoReqNo("");
    salesReqCancelVO.setSoReqster(CommonUtils.intNvl((String) params.get("cmbRequestor")));
    salesReqCancelVO.setSoReqPreRetnDt(
        (int) params.get("stusCodeId") == 4 ? (String) params.get("dpReturnDate") : SalesConstants.DEFAULT_DATE);
    salesReqCancelVO.setSoReqRem((String) params.get("txtRemark"));

  }

  private void preprocCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO,
      String ordReqType) {

    if (SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
      callEntryVO.setCallEntryId(0);
      callEntryVO.setSalesOrdId(CommonUtils.intNvl((String) params.get("salesOrdId")));
      callEntryVO.setTypeId(CommonUtils.intNvl(SalesConstants.CALL_ENTRY_TYPE_ID));
      callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
      callEntryVO.setResultId(0);
      callEntryVO.setDocId(0);
      callEntryVO.setCrtUserId(sessionVO.getUserId());
      callEntryVO.setCallDt((String) params.get("dpCallLogDate"));
      callEntryVO.setIsWaitForCancl(SalesConstants.IS_TRUE);
      callEntryVO.setHapyCallerId(0);
      callEntryVO.setUpdUserId(sessionVO.getUserId());
      callEntryVO.setOriCallDt((String) params.get("dpCallLogDate"));
    } else if (SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
      callEntryVO.setCallEntryId(0);
      callEntryVO.setSalesOrdId(CommonUtils.intNvl((String) params.get("salesOrdId")));
      callEntryVO.setTypeId(258);
      callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
      callEntryVO.setResultId(0);
      callEntryVO.setDocId(0);
      callEntryVO.setCrtUserId(sessionVO.getUserId());
      callEntryVO.setCallDt((String) params.get("dpCallLogDate"));
      callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
      callEntryVO.setHapyCallerId(0);
      callEntryVO.setUpdUserId(sessionVO.getUserId());
      callEntryVO.setOriCallDt((String) params.get("dpCallLogDate"));
    }
  }

  private void preprocCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO) {

    callResultVO.setCallResultId(0);
    callResultVO.setCallEntryId(0);
    callResultVO.setCallStusId(SalesConstants.STATUS_ACTIVE);
    callResultVO.setCallDt((String) params.get("dpCallLogDate"));
    callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
    callResultVO.setCallFdbckId(CommonUtils.intNvl((String) params.get("cmbReason")));
    callResultVO.setCallCtId(0);
    callResultVO.setCallRem((String) params.get("txtRemark"));
    callResultVO.setCallCrtUserId(sessionVO.getUserId());
    callResultVO.setCallCrtUserIdDept(0);
    callResultVO.setCallHcId(0);
    callResultVO.setCallRosAmt(BigDecimal.ZERO);
    callResultVO.setCallSms(SalesConstants.IS_FALSE);
    callResultVO.setCallSmsRem("");

  }

  private void preprocCancelCallResultDetails(CallResultVO callResultVO, Map<String, Object> params,
      SessionVO sessionVO, String ordReqType) {

    if (SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
      callResultVO.setCallResultId(0);
      callResultVO.setCallEntryId(0);
      callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
      callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
      callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
      callResultVO.setCallFdbckId(0);
      callResultVO.setCallCtId(0);
      callResultVO.setCallRem("(Call-log cancelled - Order Cancellation Request) " + (String) params.get("txtRemark"));
      callResultVO.setCallCrtUserId(sessionVO.getUserId());
      callResultVO.setCallCrtUserIdDept(0);
      callResultVO.setCallHcId(0);
      callResultVO.setCallRosAmt(BigDecimal.ZERO);
      callResultVO.setCallSms(SalesConstants.IS_FALSE);
      callResultVO.setCallSmsRem("");
    } else if (SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
      callResultVO.setCallResultId(0);
      callResultVO.setCallEntryId(0);
      callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
      callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
      callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
      callResultVO.setCallFdbckId(0);
      callResultVO.setCallCtId(0);
      callResultVO.setCallRem("Call-log cancelled - Product Exchange Requested.");
      callResultVO.setCallCrtUserId(sessionVO.getUserId());
      callResultVO.setCallCrtUserIdDept(0);
      callResultVO.setCallHcId(0);
      callResultVO.setCallRosAmt(BigDecimal.ZERO);
      callResultVO.setCallSms(SalesConstants.IS_FALSE);
      callResultVO.setCallSmsRem("");
    }
  }

  private void preprocSalesOrderLog(SalesOrderLogVO salesOrderLogVO, Map<String, Object> params, SessionVO sessionVO,
      String ordReqType) {

    salesOrderLogVO.setLogId(0);
    salesOrderLogVO.setSalesOrdId(CommonUtils.intNvl((String) params.get("salesOrdId")));
    salesOrderLogVO.setPrgrsId(11);
    salesOrderLogVO.setRefId(0);
    salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
    salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());

    if (SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
      salesOrderLogVO.setPrgrsId(11);
    } else if (SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
      salesOrderLogVO.setPrgrsId(3);
    } else if (SalesConstants.ORDER_REQ_TYPE_CD_AEXC.equals(ordReqType)) {
      salesOrderLogVO.setPrgrsId(6);
    } else if (SalesConstants.ORDER_REQ_TYPE_CD_OTRN.equals(ordReqType)) {
      salesOrderLogVO.setPrgrsId(7);
    }
  }

  @Override
  public EgovMap cancelReqInfo(Map<String, Object> params) {

    return eRequestCancellationMapper.cancelReqInfo(params);
  }

  @Override
  public void insertReqEditOrdInfo(Map<String, Object> params) {
    eRequestCancellationMapper.insertReqEditOrdInfo(params);
  }

  @Override
  public List<EgovMap> selectRequestApprovalList(Map<String, Object> params) {
    return eRequestCancellationMapper.selectRequestApprovalList(params);
  }

  @Override
  public int saveApprCnct(Map<String, Object> params) {

    int ordUpd = 0;
    int instUpd = 0;

    int updStus = eRequestCancellationMapper.updateApprStus(params);

    if(params.get("reqStusId").equals("5") && updStus > 0){
      //ordUpd  = eRequestCancellationMapper.updSAL0001D_custCntc(params);
      instUpd  = eRequestCancellationMapper.updSAL0045D(params);
    }
    return updStus;
  }

  @Override
  public int saveApprInstAddr(Map<String, Object> params) {

    int ordUpd = 0;
    int instUpd = 0;

    int updStus = eRequestCancellationMapper.updateApprStus(params);

    if(params.get("reqStusId").equals("5") && updStus > 0){
      ordUpd  = eRequestCancellationMapper.updSAL0001D_instAddr(params);
      instUpd  = eRequestCancellationMapper.updSAL0045D(params);
    }

    return updStus;
  }

}
