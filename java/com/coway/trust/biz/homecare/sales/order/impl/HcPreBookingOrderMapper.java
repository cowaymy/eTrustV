package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
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

	public int insertPreBookingOrder(PreBookingOrderVO preBookingOrderVO);

	List<EgovMap> selectHcPrevOrderNoList(Map<String, Object> params);

	public EgovMap selectHcPreBookingOrderInfo(Map<String, Object> params);

	EgovMap selectPreBookOrderEligibleInfo(Map<String, Object> params);

	EgovMap selectPreBookOrderEligibleCheck(Map<String, Object> params);

	public int updateHcPreBookOrderStatus(Map<String, Object> params);

	List<EgovMap> selectPreBookOrderCancelStatus(Map<String, Object> params);

	EgovMap selectPreBookSalesPerson(Map<String, Object> params);

	EgovMap selectPreBookConfigurationPerson(Map<String, Object> params);

	String getHcPreBookSmsTemplate(Map<String, Object> params);

  EgovMap selectPreBookOrdDtlWA(Map<String, Object> params);

}
