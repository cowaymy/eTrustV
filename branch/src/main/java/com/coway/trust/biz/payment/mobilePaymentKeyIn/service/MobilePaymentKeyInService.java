package com.coway.trust.biz.payment.mobilePaymentKeyIn.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobilePaymentKeyInService.java
 * @Description : MobilePaymentKeyInService
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * 2020. 07. 06.   ONGHC         Add selectMemDetails
 *          </pre>
 */
public interface MobilePaymentKeyInService {

  /**
   * selectMobilePaymentKeyInList
   *
   * @Author KR-HAN
   * @Date 2019. 11. 21.
   * @param params
   * @return
   */
  List<EgovMap> selectMobilePaymentKeyInList(Map<String, Object> params);

  /**
   * saveMobilePaymentKeyInReject
   *
   * @Author KR-HAN
   * @Date 2019. 11. 21.
   * @param params
   * @return
   * @throws Exception
   */
  int saveMobilePaymentKeyInReject(Map<String, Object> params) throws Exception;

  /**
   * saveMobilePaymentKeyInCard
   *
   * @Author KR-HAN
   * @Date 2019. 11. 21.
   * @param params
   * @param userId
   * @return
   */
  List<EgovMap> saveMobilePaymentKeyInCard(Map<String, Object> params, String userId);

  /**
   * saveMobilePaymentKeyInNormalPayment
   *
   * @Author KR-HAN
   * @Date 2019. 11. 21.
   * @param params
   * @param userId
   * @return
   */
  Map<String, Object> saveMobilePaymentKeyInNormalPayment(Map<String, Object> params, String userId);

  EgovMap selectMemDetails(SessionVO sessionVO);

}
