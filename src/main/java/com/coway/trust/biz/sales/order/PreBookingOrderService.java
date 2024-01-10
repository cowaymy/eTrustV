/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface PreBookingOrderService {
  public List<EgovMap> selectPreBookingOrderList(Map<String, Object> params);

	public void insertPreBooking(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO);

	EgovMap selectPreBookOrderEligibleInfo(Map<String, Object> params);

	List<EgovMap> selectPrevOrderNoList(Map<String, Object> params);

	EgovMap checkOldOrderId(Map<String, Object> params);

	public EgovMap selectPreBookingOrderInfo(Map<String, Object> params);

	public int updatePreBookOrderCancel(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	List<EgovMap> selectPreBookOrderCancelStatus(Map<String, Object> params);

	EgovMap checkPreBookSalesPerson(Map<String, Object> params);

  EgovMap checkPreBookConfigurationPerson(Map<String, Object> params);

  public EgovMap selectPreBookOrdDtlWA(Map<String, Object> params);

  public String updatePreBookOrderCustVerifyStus(Map<String, Object> params);

  EgovMap selectPreBookOrderEligibleCheck(Map<String, Object> params);

}
