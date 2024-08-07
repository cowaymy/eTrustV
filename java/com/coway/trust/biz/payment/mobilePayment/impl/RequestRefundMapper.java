package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("RequestRefundMapper")
public interface RequestRefundMapper {



	List<EgovMap> selectTicketStatusCode();



    int selectRequestFundTransferCount(Map<String, Object> params);



    List<EgovMap> selectRequestRefundList(Map<String, Object> params);



    int updateApprovedPAY0298D(Map<String, Object> params);



    int updateRejectedPAY0298D(Map<String, Object> params);
}
