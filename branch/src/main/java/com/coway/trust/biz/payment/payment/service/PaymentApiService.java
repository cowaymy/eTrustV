package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.payment.payment.PaymentForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PaymentApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * 2020.2.6.       MY-ONGHC   Add E-Notification
 *          </pre>
 */
public interface PaymentApiService {

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 9. 30.
   * @param params
   * @return
   */
  List<EgovMap> selectPaymentList(Map<String, Object> params);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   */
  List<EgovMap> selectPaymentDetailList(Map<String, Object> params);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   */
  EgovMap selectMegaDealByOrderId(Map<String, Object> params);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 14.
   * @param params
   * @return
   */
  EgovMap selectBillInfoRental(Map<String, Object> params);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 15.
   * @param params
   * @return
   */
  EgovMap selectSalesNotificationInfo(Map<String, Object> params);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 15.
   * @param paymentForm
   * @return
   */
  int insertSalesNotification(PaymentForm paymentForm) throws Exception;

  List<EgovMap> selectBankSelectBox(Map<String, Object> params);

  void sendSms(Map<String, Object> params);

  void sendEmail(Map<String, Object> params);

  List<EgovMap> selectCardModeBox(Map<String, Object> params);

  List<EgovMap> selectMerchantBankOn2708(Map<String, Object> params);

  List<EgovMap> selectMerchantBankOn2709(Map<String, Object> params);

  List<EgovMap> selectMerchantBankOn2710(Map<String, Object> params);

  List<EgovMap> selectMerchantBankOn2711(Map<String, Object> params);

  List<EgovMap> selectMerchantBankOn2712(Map<String, Object> params);

  List<EgovMap> selectIssueBankOn2710(Map<String, Object> params);

  List<EgovMap> selectIssueBankOn2712(Map<String, Object> params);

  List<EgovMap> selectIssueBankOnDefault(Map<String, Object> params);

}
