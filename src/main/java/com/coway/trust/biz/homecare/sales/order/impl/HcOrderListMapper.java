package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderListMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcOrderListMapper")
public interface HcOrderListMapper {

	/**
	 * Search Homacare OrderList
	 * @Author KR-SH
	 * @Date 2019. 10. 18.
	 * @param params
	 * @return list
	 */
	public List<EgovMap> selectHcOrderList(Map<String, Object> params);

	/**
	 * Search Homacare OrderInfo
	 * @Author KR-SH
	 * @Date 2019. 10. 25.
	 * @param params
	 * @return
	 */
	public EgovMap selectHcOrderInfo(Map<String, Object> params);

}
