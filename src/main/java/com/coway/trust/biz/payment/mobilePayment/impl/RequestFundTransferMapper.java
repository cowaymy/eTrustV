package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestFundTransferMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("RequestFundTransferMapper")
public interface RequestFundTransferMapper {



	List<EgovMap> selectTicketStatusCode();



    int selectRequestFundTransferCount(Map<String, Object> params);



    List<EgovMap> selectRequestFundTransferList(Map<String, Object> params);



    EgovMap selectInfoPAY02052T(Map<String, Object> params);



    int insertApprovedPAY0260D(Map<String, Object> params);



    int updateApprovedPAY0296D(Map<String, Object> params);



    int updateFtStusIdPAY0252T(Map<String, Object> params);



    int updateRejectedPAY0296D(Map<String, Object> params);
}
