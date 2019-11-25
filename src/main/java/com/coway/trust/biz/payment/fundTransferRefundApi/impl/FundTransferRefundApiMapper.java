package com.coway.trust.biz.payment.fundTransferRefundApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferRefundApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 10.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("FundTransferRefundApiMapper")
public interface FundTransferRefundApiMapper {



	List<EgovMap> selectFundTransferRefundList(Map<String, Object> params);
}
