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
import org.springframework.stereotype.Service;

import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.ccp.impl.CcpCalculateMapper;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderDetailService")
public class OrderDetailServiceImpl extends EgovAbstractServiceImpl implements OrderDetailService {

  private static Logger logger = LoggerFactory.getLogger(OrderDetailServiceImpl.class);

  @Resource(name = "orderDetailMapper")
  private OrderDetailMapper orderDetailMapper;

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "orderRequestMapper")
  private OrderRequestMapper orderRequestMapper;

  @Resource(name = "ccpCalculateMapper")
  private CcpCalculateMapper ccpCalculateMapper;

  @Resource(name = "voucherMapper")
  private VoucherMapper voucherMapper;

  // @Autowired
  // private MessageSourceAccessor messageSourceAccessor;

  @Override
  public EgovMap selectBasicInfo(Map<String, Object> params) throws Exception {

    // Basic Info
    EgovMap basicInfo = orderDetailMapper.selectBasicInfo(params);

    return basicInfo;
  }

  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {

    EgovMap orderDetail = new EgovMap();

    // Basic Info
    EgovMap basicInfo = orderDetailMapper.selectBasicInfo(params);
    EgovMap logView = orderDetailMapper.selectLatestOrderLogByOrderID(params);
    EgovMap agreementView = orderDetailMapper.selectOrderAgreementByOrderID(params);
    EgovMap installationInfo = orderDetailMapper.selectOrderInstallationInfoByOrderID(params);
    EgovMap ccpFeedbackCode = orderDetailMapper.selectOrderCCPFeedbackCodeByOrderID(params);
    EgovMap ccpInfo = orderDetailMapper.selectOrderCCPInfoByOrderID(params);
    EgovMap salesmanInfo = orderDetailMapper.selectOrderSalesmanViewByOrderID(params);
    EgovMap codyInfo = orderDetailMapper.selectOrderServiceMemberViewByOrderID(params);
    EgovMap mailingInfo = orderDetailMapper.selectOrderMailingInfoByOrderID(params);
    EgovMap rentPaySetInf = null;
    EgovMap thirdPartyInfo = null;
    EgovMap grntnfo = null;
    EgovMap orderCfgInfo = orderDetailMapper.selectOrderConfigInfo(params);
    EgovMap gstCertInfo = orderDetailMapper.selectGSTCertInfo(params);
    EgovMap prodUsgMthInfo = orderDetailMapper.selectProductUsageMonth(params);
    EgovMap renAgrInfo = orderDetailMapper.selectRenAgrList(params);
    EgovMap mobileAutoDebitPaymentInfo = orderDetailMapper.selectMobileAutoDebitInfo(params);
	List<EgovMap> ccpTicketLogs = ccpCalculateMapper.selectTicketLogs(params);
	EgovMap seda4promo = orderDetailMapper.selectSedaPromo(params);

    params.put("viewSort", "1");
    List<EgovMap> callLog = orderDetailMapper.selectCallLogList(params);

    String memInfo = orderDetailMapper.selectMemberInfo(CommonUtils.nvl(basicInfo.get("custNric")));

    if (CommonUtils.isNotEmpty(memInfo)) {
      basicInfo.put("memInfo", "(" + memInfo + ")");
    }

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode").toString())
        || SalesConstants.APP_TYPE_CODE_TRIAL_RENTAL.equals(basicInfo.get("appTypeCode").toString())
        || SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS.equals(basicInfo.get("appTypeCode").toString())) {

      rentPaySetInf = orderDetailMapper.selectOrderRentPaySetInfoByOrderID(params);

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
        grntnfo = orderDetailMapper.selectGuaranteeInfo(params);
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

    if(basicInfo.get("voucherCode") != null
    		&& basicInfo.get("voucherCode").toString().length() > 0){
        Map<String,Object> voucherParam = new HashMap();
        voucherParam.put("voucherCode", basicInfo.get("voucherCode").toString());
        EgovMap voucherInfo = voucherMapper.getVoucherInfo(voucherParam);

        if(voucherInfo != null){
        	basicInfo.put("voucherInfo", voucherInfo);
        }
    }

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
    orderDetail.put("callLog", callLog);
    orderDetail.put("prodUsgMthInfo", prodUsgMthInfo);
    orderDetail.put("renAgrInfo", renAgrInfo);
    orderDetail.put("ccpTicketLogs", ccpTicketLogs);
    orderDetail.put("mobileAutoDebitPaymentInfo", mobileAutoDebitPaymentInfo);
    orderDetail.put("seda4promo", seda4promo);

    Date salesDt = (Date) basicInfo.get("ordDt");

    DateFormat formatter = new SimpleDateFormat("yyyyMMdd");

    Date dt = formatter.parse("20180101");

    logger.debug("@#### salesDt:" + salesDt);
    logger.debug("@#### dt:" + dt);

    boolean isNew = salesDt.after(dt);

    logger.debug("@#### isBefore:" + isNew);
    logger.debug("@#### keyInMonth:" + basicInfo);

    orderDetail.put("isNewVer", isNew ? "Y" : "N");

    return orderDetail;
  };

  private void loadGstCertInfo(EgovMap gstCertInfo) {
    gstCertInfo.put("eurcRefDt", CommonUtils.changeFormat((String) gstCertInfo.get("eurcRefDt"),
        SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
  }

  private void loadConfigInfo(EgovMap orderCfgInfo) {
    orderCfgInfo.put("configBsGen",
        ((BigDecimal) orderCfgInfo.get("configBsGen")).compareTo(BigDecimal.ONE) == 0 ? "Available" : "Unavailable");
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

    // Added for eMandate Paperless-phase 2, Hui Ding, 2023-09-06
    if (!CommonUtils.isEmpty(rentPaySetInf.get("ddPaperless"))
    		&& !CommonUtils.isEmpty(rentPaySetInf.get("rentPayModeCode")) && rentPaySetInf.get("rentPayModeCode").toString().equalsIgnoreCase("DD")){
    	rentPaySetInf.put("ddPaperless", "Yes");
    } else {
    	rentPaySetInf.put("ddPaperless", "-");
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

    if (!SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))
    	&& !SalesConstants.APP_TYPE_CODE_TRIAL_RENTAL.equals(basicInfo.get("appTypeCode"))) {
      mailingInfo.put("billGrpNo", "-");
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

  private void loadBasicInfo(EgovMap basicInfo) throws Exception {

    BigDecimal mthRentalFees = null;
    String installmentDuration = "-";
    String rentalStatus = "-";
    int obligationYear = 0;

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))
    || SalesConstants.APP_TYPE_CODE_TRIAL_RENTAL.equals(basicInfo.get("appTypeCode"))) {
      mthRentalFees = (BigDecimal) basicInfo.get("ordMthRental");
    }

    if (SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode"))
        || SalesConstants.APP_TYPE_CODE_TRIAL_RENTAL.equals(basicInfo.get("appTypeCode"))
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

      rentalStatus = (String) basicInfo.get("rentalStus");

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

  private String convert12Tm(String TM) {
    String HH = "", MI = "", cvtTM = "";

    if (CommonUtils.isNotEmpty(TM)) {
      HH = CommonUtils.left(TM, 2);
      MI = TM.substring(3, 5);

      if (Integer.parseInt(HH) > 12) {
        cvtTM = String.valueOf(Integer.parseInt(HH) - 12) + ":" + String.valueOf(MI) + " PM";
      } else {
        cvtTM = HH + ":" + String.valueOf(MI) + " AM";
      }
    }
    return cvtTM;
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
        // installationInfo.put("preferInstDt", CommonUtils.changeFormat((String)installationInfo.get("preferInstDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));

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
        // installationInfo.put("firstInstallDt", CommonUtils.changeFormat((String)installationInfo.get("firstInstallDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
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

      // instct = StringUtils.replace(instct, System.getProperty("line.separator"), "<br>");

      installationInfo.put("instct", instct);
    }
  }

  @Override
  public List<EgovMap> selectSameRentalGrpOrderList(Map<String, Object> params) {
    return orderDetailMapper.selectOrderSameRentalGroupOrderList(params);
  }

  @Override
  public List<EgovMap> selectMembershipInfoList(Map<String, Object> params) {
    return orderDetailMapper.selectMembershipInfoList(params);
  }

  @Override
  public List<EgovMap> selectDocumentList(Map<String, Object> params) {
    return orderDetailMapper.selectDocumentList(params);
  }

  @Override
  public List<EgovMap> selectCallLogList(Map<String, Object> params) {
    return orderDetailMapper.selectCallLogList(params);
  }

  @Override
  public List<EgovMap> selectPaymentMasterList(Map<String, Object> params) {
    return orderDetailMapper.selectPaymentMasterList(params);
  }

  @Override
  public List<EgovMap> selectAutoDebitList(Map<String, Object> params) {
    return orderDetailMapper.selectAutoDebitList(params);
  }

  @Override
  public List<EgovMap> selectEcashList(Map<String, Object> params) {
    return orderDetailMapper.selectEcashList(params);
  }

  @Override
  public List<EgovMap> selectDiscountList(Map<String, Object> params) {
    return orderDetailMapper.selectDiscountList(params);
  }

  @Override
  public List<EgovMap> selectLast6MonthTransList(Map<String, Object> params) {
    return orderDetailMapper.selectLast6MonthTransList(params);
  }

  @Override
  public List<EgovMap> selectLast6MonthTransListNew(Map<String, Object> params) {
    return orderDetailMapper.selectLast6MonthTransListNew(params);
  }

  @Override
  public EgovMap selectGSTCertInfo(Map<String, Object> params) {
    return orderDetailMapper.selectGSTCertInfo(params);
  }

  @Override
  public EgovMap selectCurrentBSResultByBSNo(Map<String, Object> params) {
    return orderDetailMapper.selectCurrentBSResultByBSNo(params);
  }

  @Override
  public List<EgovMap> selectASInfoList(Map<String, Object> params) {
    return orderDetailMapper.selectASInfoList(params);
  }

  @Override
  public List<EgovMap> getInstImg(Map<String, Object> params) {
    return orderDetailMapper.getInstImg(params);
  }

  @Override
  public List<EgovMap> getInstImgByInst(Map<String, Object> params) {
    return orderDetailMapper.getInstImgByInst(params);
  }

  @Override
  public List<EgovMap> getHsImg(Map<String, Object> params) {
    return orderDetailMapper.getHsImg(params);
  }

  @Override
  public List<EgovMap> selectGSTRebateList(Map<String, Object> params) {
    return orderDetailMapper.selectGSTRebateList(params);
  }

  @Override
  public List<EgovMap> getInstAsPSIData(Map<String, Object> params) {
    return orderDetailMapper.getInstAsPSIData(params);
  }

  @Override
  public List<EgovMap> selectMCORemarkList(Map<String, Object> params) {
    return orderDetailMapper.selectMCORemarkList(params);
  }

  @Override
  public List<EgovMap> selectFmcoEvoucherList(Map<String, Object> params) {
    return orderDetailMapper.selectFmcoEvoucherList(params);
  }

    @Override
    public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params) {
        return orderDetailMapper.selectOrderSalesmanViewByOrderID(params);
    }

    @Override
    public EgovMap selectOrderInstallationInfoByOrderID(Map<String, Object> params) {
        return orderDetailMapper.selectOrderInstallationInfoByOrderID(params);
    }

  @Override
  public List<EgovMap> selectPvRebateList(Map<String, Object> params) {
    return orderDetailMapper.selectPvRebateList(params);
  }

  @Override
  public List<EgovMap> getHsAppntDateInfo(Map<String, Object> params) {
    return orderDetailMapper.getHsAppntDateInfo(params);
  }

  @Override
  public List<EgovMap> selectComboRebateList(Map<String, Object> params) {
    return orderDetailMapper.selectComboRebateList(params);
  }

  @Override
  public List<EgovMap> selectMixAndMatchList(Map<String, Object> params) {
	  return orderDetailMapper.selectMixAndMatchList(params);
  }
}
