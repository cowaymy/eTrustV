package com.coway.trust.biz.payment.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.payment.payment.PaymentForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.payment.service.PaymentApiService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PaymentApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * 2020. 2. 6.     MY-ONGHC   Add E-Notification
 * 2020. 4. 9.     MY_ONGHC  Amend insertSalesNotification to Add Customer Name
 * 2020. 5. 29.   MY_ONGHC   Amend sendEmail function
 * 2020. 10. 26.  MY_YONGJH Amend sendEmail function to use Email Template Type
 *          </pre>
 */
@Service("paymentApiService")
public class PaymentApiServiceImpl extends EgovAbstractServiceImpl implements PaymentApiService {

  @Resource(name = "paymentApiMapper")
  private PaymentApiMapper paymentApiMapper;

  @Resource(name = "commonPaymentMapper")
  private CommonPaymentMapper commonPaymentMapper;

  @Autowired
  private LoginMapper loginMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Value("${autodebit.email.receiver}")
  private String emailReceiver;

  @Value("${billing.type.confirm.url}")
  private String billingTypeConfirmUrl;

  // 티켓 서비스
  @Resource(name = "mobileAppTicketApiCommonService")
  private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

  private static final Logger logger = LoggerFactory.getLogger(PaymentApiServiceImpl.class);

  /**
   * selectPaymentList
   *
   * @Author KR-HAN
   * @Date 2019. 9. 30.
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectPaymentList(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectPaymentList(params);
  }

  /**
   * selectPaymentDetailList
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#selectPaymentDetailList(java.util.Map)
   */
  @Override
  public List<EgovMap> selectPaymentDetailList(Map<String, Object> params) {

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

    System.out.println("++++ rcList.toString() ::" + rcList.toString());

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

        System.out.println("++++ ::" + Integer.parseInt(String.valueOf(obj.get("billTypeId"))));

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

          System.out.println("++++ balRPF ::" + balRPF);

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

    System.out.println("++++ rcList.size() ::" + rcList.size());

    if (rcList != null && rcList.size() > 0) {
      for (EgovMap obj : rcList) {
        //
        System.out.println("++++ paidAmt ::" + Double.parseDouble(String.valueOf(obj.get("paidAmt"))));
        System.out.println("++++ billAmt ::" + Double.parseDouble(String.valueOf(obj.get("billAmt"))));
        if (Double.parseDouble(String.valueOf(obj.get("paidAmt"))) != Double
            .parseDouble(String.valueOf(obj.get("billAmt")))) {
          returnList.add(obj);
        }
      }
    }

    System.out.println("++++ returnList.toString() ::" + returnList.toString());

    return returnList;
  }

  /**
   * selectMegaDealByOrderId
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#selectMegaDealByOrderId(java.util.Map)
   */
  @Override
  public EgovMap selectMegaDealByOrderId(Map<String, Object> params) {

    return commonPaymentMapper.selectMegaDealByOrderId(params);
  }

  /**
   * selectBillInfoRental
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#selectBillInfoRental(java.util.Map)
   */
  @Override
  public EgovMap selectBillInfoRental(Map<String, Object> params) {

    return paymentApiMapper.selectBillInfoRental(params);
  }

  /**
   * selectSalesNotificationInfo
   *
   * @Author KR-HAN
   * @Date 2019. 10. 15.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#selectSalesNotificationInfo(java.util.Map)
   */
  @Override
  public EgovMap selectSalesNotificationInfo(Map<String, Object> params) {

    return paymentApiMapper.selectSalesNotificationInfo(params);
  }

  /**
   * insertSalesNotification
   *
   * @Author KR-HAN
   * @Date 2019. 10. 15.
   * @param paymentForm
   * @return
   * @throws Exception
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#insertSalesNotification(com.coway.trust.api.mobile.payment.payment.PaymentForm)
   */
  @Override
  public int insertSalesNotification(PaymentForm paymentForm) throws Exception {

    logger.debug("============================================ ");
    logger.debug("= PAYMENT FORM = " + paymentForm.toString());
    logger.debug("============================================ ");

    int rtn = 0;

    Map<String, Object> params = PaymentForm.createMap(paymentForm);

    params.put("_USER_ID", paymentForm.getUserId());

    LoginVO loginVO = loginMapper.selectLoginInfoById(params);

    // Ticket 저장
    List<Map<String, Object>> arrParams = new ArrayList<Map<String, Object>>();
    Map<String, Object> sParams = new HashMap<String, Object>();

    sParams.put("salesOrdNo", params.get("salesOrdNo"));
    sParams.put("ticketTypeId", "5677"); // Mobile Payment Key-in
    sParams.put("ticketStusId", "1");
    sParams.put("userId", paymentForm.getUserId());

    arrParams.add(sParams);

    int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);

    // GET CUSTOMER NAME
    String custNm = mobileAppTicketApiCommonService.getCustNm(sParams);

    // 저장
    params.put("signImg", params.get("signData"));
    params.put("payStusId", '1');
    params.put("mobTicketNo", mobTicketNo);
    params.put("crtUserId", loginVO.getUserId());
    params.put("updUserId", loginVO.getUserId());
    params.put("custNm", custNm);

    rtn = paymentApiMapper.insertSalesNotification(params);

    // ONGHC - START
    // SMS
    this.sendSms(params);
    // EMAIL

    try {
    	this.sendEmail(params);
    } catch (Exception e) {
    	logger.error("EMAIL SENDING PROCESS ENCOUNTERED ERROR: " + e.getMessage());
    }

    return rtn;
  }

  /**
   * selectBankSelectBox
   *
   * @Author KR-HAN
   * @Date 2019. 10. 24.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.PaymentApiService#selectBankSelectBox(java.util.Map)
   */
  @Override
  public List<EgovMap> selectBankSelectBox(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectBankSelectBox(params);
  }

  @Override
  public List<EgovMap> selectCardModeBox(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectCardModeBox(params);
  }

  @Override
  public List<EgovMap> selectMerchantBankOn2708(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectMerchantBankOn2708(params);
  }

  @Override
  public List<EgovMap> selectMerchantBankOn2709(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectMerchantBankOn2709(params);
  }

  @Override
  public List<EgovMap> selectMerchantBankOn2710(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectMerchantBankOn2710(params);
  }

  @Override
  public List<EgovMap> selectMerchantBankOn2711(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectMerchantBankOn2711(params);
  }

  @Override
  public List<EgovMap> selectMerchantBankOn2712(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectMerchantBankOn2712(params);
  }

  @Override
  public List<EgovMap> selectIssueBankOn2710(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectIssueBankOn2710(params);
  }

  @Override
  public List<EgovMap> selectIssueBankOn2712(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectIssueBankOn2712(params);
  }

  @Override
  public List<EgovMap> selectIssueBankOnDefault(Map<String, Object> params) {

    Map<String, Object> sParams = new HashMap<String, Object>();

    return paymentApiMapper.selectIssueBankOnDefault(params);
  }

  @Override
  public void sendSms(Map<String, Object> params) {
    SmsVO sms = new SmsVO(Integer.parseInt(params.get("crtUserId").toString()), 975);
    String smsTemplate = paymentApiMapper.getSmsTemplate(params);
    String smsNo = "";

    params.put("smsTemplate", smsTemplate);

    if (!"".equals(CommonUtils.nvl(params.get("sms1")))) {
      smsNo = CommonUtils.nvl(params.get("sms1"));
    }

    if (!"".equals(CommonUtils.nvl(params.get("sms2")))) {
      if (!"".equals(CommonUtils.nvl(smsNo))) {
        smsNo += "|!|" + CommonUtils.nvl(params.get("sms2"));
      } else {
        smsNo = CommonUtils.nvl(params.get("sms2"));
      }
    }

    if (!"".equals(CommonUtils.nvl(smsNo))) {
      sms.setMessage(CommonUtils.nvl(smsTemplate));
      sms.setMobiles(CommonUtils.nvl(smsNo));
      sms.setRemark("SMS E-TR TICKET VIA MOBILE APPS");
      sms.setRefNo(CommonUtils.nvl(params.get("mobTicketNo")));
      SmsResult smsResult = adaptorService.sendSMS(sms);
      logger.debug(" smsResult : {}", smsResult.toString());

      // INSERT MSC0015D
      //String[] mobileArray = CommonUtils.getDelimiterValues(smsNo);
      //if (mobileArray.length > 0) {
      //  for (int i = 0; i < mobileArray.length; i++) {
      //     Map<String, Object> logs = new HashMap<String, Object>();

      //     logs.put("smsTemplate", CommonUtils.nvl(params.get("smsTemplate")));
      //     logs.put("mobileNo", CommonUtils.nvl(mobileArray[i]));
      //     logs.put("salesOrdNo", CommonUtils.nvl(params.get("salesOrdNo")));
      //     logs.put("crtUserId", CommonUtils.nvl(params.get("crtUserId")));

      //     paymentApiMapper.insertMSC0015D(logs);
      //  }
      //}
    }
  }

  @SuppressWarnings("unchecked")
  @Override
  public void sendEmail(Map<String, Object> params) {
    EmailVO email = new EmailVO();
    String emailTitle = paymentApiMapper.getEmailTitle(params);

    //String emailDetails = paymentApiMapper.getEmailDetails(params);

    Map<String, Object> additionalParams = (Map<String, Object>) paymentApiMapper.getEmailDetails(params);
    params.putAll(additionalParams);


    //String emailNo = "";
    List<String> emailNo = new ArrayList<String>();

    if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
      //emailNo = CommonUtils.nvl(params.get("email1"));
      emailNo.add(CommonUtils.nvl(params.get("email1")));
    }

    if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
      //if (!"".equals(CommonUtils.nvl(emailNo))) {
        //emailNo += "|!|" + CommonUtils.nvl(params.get("email2"));
        //emailNo.add(CommonUtils.nvl(params.get("email2")));
      //} else {
        //emailNo = CommonUtils.nvl(params.get("email2"));
        //emailNo.add(CommonUtils.nvl(params.get("email2")));
      //}
      emailNo.add(CommonUtils.nvl(params.get("email2")));
    }

    email.setTo(emailNo);
    email.setHtml(true);
    email.setSubject(emailTitle);
    //email.setText(emailDetails);
    email.setHasInlineImage(true);

    boolean isResult = false;

    //isResult = adaptorService.sendEmail(email, false);
    isResult = adaptorService.sendEmail(email, false, EmailTemplateType.E_TEMPORARY_RECEIPT, params);
  }
}
