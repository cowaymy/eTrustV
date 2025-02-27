package com.coway.trust.biz.homecare.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderListService.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * 2020. 05. 20.   KR-ONGHC  Add selectProductCodeList
 *          </pre>
 */
public interface HcPreRentalListService {

  /**
   * Search Homacare OrderList
   *
   * @Author KR-SH
   * @Date 2019. 10. 24.
   * @param params
   * @return
   */
  public List<EgovMap> selectHcPreRentalList(Map<String, Object> params);

  /**
   * Search Homacare OrderInfo
   *
   * @Author KR-SH
   * @Date 2019. 10. 24.
   * @param params
   * @return
   */
  public EgovMap selectHcPreRentalInfo(Map<String, Object> params);

  /**
   * select Product Info
   *
   * @Author KR-SH
   * @Date 2020. 1. 14.
   * @param salesOrdId
   * @return
   */
  public EgovMap selectProductInfo(String salesOrdId);

  public List<EgovMap> selectProductCodeList();

  int getMemberID(Map<String, Object> params);

  EgovMap getOrgDtls(Map<String, Object> params);

  EgovMap selectOrderSimulatorViewByOrderNo(Map<String, Object> params);
}
