package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderListMapper.java
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
@Mapper("hcTrialRentalListMapper")
public interface HcTrialRentalListMapper {

  /**
   * Search Homacare OrderList
   *
   * @Author KR-SH
   * @Date 2019. 10. 18.
   * @param params
   * @return list
   */
  public List<EgovMap> selectHcTrialRentalList(Map<String, Object> params);

  /**
   * Search Homacare OrderInfo
   *
   * @Author KR-SH
   * @Date 2019. 10. 25.
   * @param params
   * @return
   */
  public EgovMap selectHcTrialRentalInfo(Map<String, Object> params);

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

  EgovMap hcSelectOrderSimulatorViewByOrderNo(Map<String, Object> params);

  EgovMap getTrialRentalBasicInfo(Map<String, Object> params);

  List<EgovMap> selectTrialRentalConvertServicePackageList(Map<String, Object> params);

  int updateSAL0001D(SalesOrderMVO salesOrderMVO);

  int updateSAL0225D(SalesOrderMVO salesOrderMVO);

  int updateSAL0002D(SalesOrderDVO salesOrderDVO);

  int updateSAL0003D(SalesOrderContractVO salesOrderContractVO);

  int insertSAL0095D(Map<String, Object> params);

  int insertSAL0088D(Map<String, Object> params);

  int insertSAL0070D(Map<String, Object> params);

  int getTrialRentalConvertHistorySeq();

  int checkActiveTrialRentalConvertHistory(Map<String, Object> params);

  int insertTrialRentalConvertHistory(Map<String, Object> params);

  int updateTrialRentalConvertHistory(Map<String, Object> params);

  int updateOldTrialRentalConvertHistory(Map<String, Object> params);

  Map<String, Object> createTrialBillCN(Map<String, Object> param);
}
