package com.coway.trust.biz.payment.requestRefundApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("RequestRefundApiMapper")
public interface RequestRefundApiMapper {



    List<EgovMap> selectCancelReasonList();



    List<EgovMap> selectCustomerIssueBankList();



    int insertPAY0298D(Map<String, Object> param);
}
