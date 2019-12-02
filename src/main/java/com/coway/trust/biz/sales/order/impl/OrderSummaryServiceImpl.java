package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderSummaryService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderSummaryServiceImpl.java
 * @Description : Order Summary Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 02.   KR-OHK        First creation
 * </pre>
 */
@Service("orderSummaryService")
public class OrderSummaryServiceImpl implements OrderSummaryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(OrderSummaryServiceImpl.class);

	@Resource(name = "orderSummaryMapper")
	private OrderSummaryMapper orderSummaryMapper;

	@Override
	public List<EgovMap> selectOrderSummary(Map<String, Object> params) {
		return orderSummaryMapper.selectOrderSummary(params);
	}

}
