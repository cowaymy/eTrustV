/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PaymentApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * 2020.2.06      MY-ONGHC    Add Add E-Notification
 * 2020.10.26	   MY-YONGJH   Update E-Notification (Email Details)
 *          </pre>
 */
@Mapper("paymentApiMapper")
public interface PaymentApiMapper {

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
   * @param params
   * @return
   */
  int insertSalesNotification(Map<String, Object> params);

  List<EgovMap> selectBankSelectBox(Map<String, Object> params);

  String getSmsTemplate(Map<String, Object> params);

  void insertMSC0015D(Map<String, Object> params);

  String getEmailTitle(Map<String, Object> params);

  //String getEmailDetails(Map<String, Object> params);

  EgovMap getEmailDetails(Map<String, Object> params); // for E-TR with HTML template

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
