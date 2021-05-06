package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.sales.order.HcOrderListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderListServiceImpl.java
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
@Service("hcOrderListService")
public class HcOrderListServiceImpl extends EgovAbstractServiceImpl implements HcOrderListService {

  @Resource(name = "hcOrderListMapper")
  private HcOrderListMapper hcOrderListMapper;

  /**
   * Search Homacare OrderList
   *
   * @Author KR-SH
   * @Date 2019. 10. 24.
   * @param params
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectHcOrderList(java.util.Map)
   */
  @Override
  public List<EgovMap> selectHcOrderList(Map<String, Object> params) {
    return hcOrderListMapper.selectHcOrderList(params);
  }

  /**
   * Search Homacare OrderInfo
   *
   * @Author KR-SH
   * @Date 2019. 10. 25.
   * @param params
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectHcOrderInfo(java.util.Map)
   */
  @Override
  public EgovMap selectHcOrderInfo(Map<String, Object> params) {
    return hcOrderListMapper.selectHcOrderInfo(params);
  }

  /**
   * select Product Info
   *
   * @Author KR-SH
   * @Date 2020. 1. 14.
   * @param salesOrdId
   * @return
   * @see com.coway.trust.biz.homecare.sales.order.HcOrderListService#selectProductInfo(java.lang.String)
   */
  @Override
  public EgovMap selectProductInfo(String salesOrdId) {
    return hcOrderListMapper.selectProductInfo(salesOrdId);
  }

  @Override
  public List<EgovMap> selectProductCodeList() {
    return hcOrderListMapper.selectProductCodeList();
  }

  @Override
  public int getMemberID(Map<String, Object> params) {
      return hcOrderListMapper.getMemberID(params);
  }

  @Override
  public EgovMap getOrgDtls(Map<String, Object> params) {
      return hcOrderListMapper.getOrgDtls(params);
  }
}
