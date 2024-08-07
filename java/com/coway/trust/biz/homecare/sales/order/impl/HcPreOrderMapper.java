package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreOrderMapper.java
 * @Description : Homecare Pre Order Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcPreOrderMapper")
public interface HcPreOrderMapper {

	/**
	 * Search Homecare Pre OrderList
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcPreOrderList(Map<String, Object> params);

	/**
	 * Search Homacare Pre OrderInfo
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @return
	 */
	public EgovMap selectHcPreOrderInfo(Map<String, Object> params);

	/**
	 * Update(Fail Status) - Homecare Pre Order
	 * @Author KR-SH
	 * @Date 2020. 1. 6.
	 * @param params
	 * @return
	 */
	public int updateHcPreOrderFailStatus(Map<String, Object> params);

}
