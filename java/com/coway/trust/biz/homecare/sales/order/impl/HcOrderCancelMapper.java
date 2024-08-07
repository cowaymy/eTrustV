package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCancelMapper.java
 * @Description : Homecare Cancel Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcOrderCancelMapper")
public interface HcOrderCancelMapper {

	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @return list
	 */
	public List<EgovMap> hcOrderCancellationList(Map<String, Object> params);


	/**
	 * Get CallEntryId
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	public EgovMap getCallEntryId(Map<String, Object> params);

	public List<EgovMap> getPartnerMemInfo(Map<String, Object> params);

}
