package com.coway.trust.biz.sales.customerApi.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.sales.customerApi.CustomerTierCatListApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerTierOrderListApiDto;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CustomerApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 14.    MY-ONGHC         Restructure Messy Code
 *          </pre>
 */
@Mapper("CustomerApiMapper")
public interface CustomerApiMapper {

  List<EgovMap> selectCustomerList(Map<String, Object> params);

  EgovMap selectCustomerInfo(Map<String, Object> params);

  List<EgovMap> selectCustomerOrder(Map<String, Object> params);

  List<EgovMap> selectCodeList();

  int selectNricNoCheck(Map<String, Object> param);

  int selectTelCheck(Map<String, Object> param);

  int insertCustomer(Map<String, Object> param);

  int insertCustAddress(Map<String, Object> param);

  int insertCustContact(Map<String, Object> param);

  int insertCustCareContact(Map<String, Object> param);

  int selectCustCheck(Map<String, Object> param);

  EgovMap selectCustomerTierMaster(Map<String, Object> params);

  List<CustomerTierOrderListApiDto> selectCustomerTierOrderList(Map<String, Object> params);

  List<EgovMap> selectCustomerTierOtherDet(Map<String, Object> params);

  List<EgovMap> selectCustomerTierCatgryList(Map<String, Object> params);

  int getCustId();

  int getTinId();

  int insertCustomerTin(Map<String, Object> param);
}
