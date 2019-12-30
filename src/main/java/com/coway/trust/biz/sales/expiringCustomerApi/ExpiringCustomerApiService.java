package com.coway.trust.biz.sales.expiringCustomerApi;

import java.util.List;

import com.coway.trust.api.mobile.sales.expiringCustomerApi.ExpiringCustomerApiDto;
import com.coway.trust.api.mobile.sales.expiringCustomerApi.ExpiringCustomerApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ExpiringCustomerApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface ExpiringCustomerApiService {



    List<EgovMap> selectExpiringCustomer(ExpiringCustomerApiForm param) throws Exception;



    ExpiringCustomerApiDto selectExpiringCustomerDetail(ExpiringCustomerApiForm param) throws Exception;
}
