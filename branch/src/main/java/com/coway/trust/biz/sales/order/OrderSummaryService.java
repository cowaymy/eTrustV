package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrderSummaryService.java
 * @Description : Order Summary Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 02.   KR-OHK        First creation
 * </pre>
 */
public interface OrderSummaryService {

	List<EgovMap> selectOrderSummary(Map<String, Object> params);

}
