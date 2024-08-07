package com.coway.trust.biz.sales.customerApi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.api.mobile.sales.customerApi.CustomerApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CustomerApiService.java
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
public interface CustomerApiService {

  List<EgovMap> selectCustomerList(CustomerApiForm param) throws Exception;

  EgovMap selectCustomerInfo(CustomerApiForm param) throws Exception;

  List<EgovMap> selectCustomerOrder(CustomerApiForm param) throws Exception;

  CustomerApiDto selectCodeList() throws Exception;

  CustomerApiForm saveCustomer(CustomerApiForm param) throws Exception;

  Map<String, Object> selectCustomerTierPoint(HttpServletRequest request,CustomerApiForm param) throws Exception;
}
