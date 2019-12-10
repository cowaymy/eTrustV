package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderExchangeMapper.java
 * @Description : Homecare Order Exchange Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcOrderExchangeMapper")
public interface HcOrderExchangeMapper {

	/**
	 * Homecare Order Exchange List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 31.
	 * @param params
	 * @return
	 */
	public List<EgovMap> hcOrderExchangeList(Map<String, Object> params);

}
