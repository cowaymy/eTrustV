package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreOrderMapper.java
 * @Description : Homecare Pre Order Mapper
 *
 */
@Mapper("hcPreBookingOrderMapper")
public interface HcPreBookingOrderMapper {

	 // Search Homecare Pre OrderList
	public List<EgovMap> selectHcPreBookingOrderList(Map<String, Object> params);

	/*	// Search Homacare Pre OrderInfo
	public EgovMap selectHcPreBookingOrderInfo(Map<String, Object> params);

	 // Update(Fail Status) - Homecare Pre Order
	public int updateHcPreBookingOrderFailStatus(Map<String, Object> params);

	*/

}
