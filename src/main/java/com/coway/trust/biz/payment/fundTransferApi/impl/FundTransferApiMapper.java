package com.coway.trust.biz.payment.fundTransferApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("FundTransferApiMapper")
public interface FundTransferApiMapper {



	List<EgovMap> selectReasonList();



	EgovMap selectFundTransfer(Map<String, Object> params);



	int insertPAY0296D(Map<String, Object> param);
}
