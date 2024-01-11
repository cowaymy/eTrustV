package com.coway.trust.biz.homecare.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcPreOrderService.java
 * @Description : Homecare Pre Order Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 18.   KR-SH        First creation
 * </pre>
 */
public interface HcPreBookingOrderService {


 // Search Homecare Pre Booking Order List
	public List<EgovMap> selectHcPreBookingOrderList(Map<String, Object> params);

	 // Homecare Pre Booking Order Register
	public void registerHcPreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO) throws ParseException;

	List<EgovMap> selectHcPrevOrderNoList(Map<String, Object> params);

	EgovMap checkOldOrderId(Map<String, Object> params);

	public EgovMap selectHcPreBookingOrderInfo(Map<String, Object> params);

	EgovMap selectPreBookOrderEligibleInfo(Map<String, Object> params);

	EgovMap selectPreBookOrderEligibleCheck(Map<String, Object> params);

	public int updateHcPreBookOrderCancel(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	List<EgovMap> selectPreBookOrderCancelStatus(Map<String, Object> params);

	EgovMap checkPreBookSalesPerson(Map<String, Object> params);

	EgovMap checkPreBookConfigurationPerson(Map<String, Object> params);

	public EgovMap selectPreBookOrdDtlWA(Map<String, Object> params);

}
