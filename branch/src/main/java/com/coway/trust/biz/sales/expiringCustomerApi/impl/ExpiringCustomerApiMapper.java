package com.coway.trust.biz.sales.expiringCustomerApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ExpiringCustomerApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("ExpiringCustomerApiMapper")
public interface ExpiringCustomerApiMapper {



    List<EgovMap> selectExpiringCustomer(Map<String, Object> param);



    EgovMap selectExpiringCustomerDetail(Map<String, Object> param);



    List<EgovMap> selectExpiringCustomerDetailList(Map<String, Object> param);
}
