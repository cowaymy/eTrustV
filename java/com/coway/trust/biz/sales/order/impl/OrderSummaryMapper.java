package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderSummaryMapper.java
 * @Description : Order Summary Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 02.   KR-OHK        First creation
 * </pre>
 */
@Mapper("orderSummaryMapper")
public interface OrderSummaryMapper {

	List<EgovMap> selectOrderSummary(Map<String, Object> params);

}
