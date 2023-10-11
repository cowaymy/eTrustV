/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface PreBookingOrderService {

/*	List<EgovMap> selectPreBookingOrderList(Map<String, Object> params);

	int selectExistSofNo(Map<String, Object> params);

	void insertPreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO);

	EgovMap selectPreBookingOrderInfo(Map<String, Object> params);

	void updatePreBookingOrder(PreBookingOrderVO preBookingOrderVO, SessionVO sessionVO);

	void updatePreBookingOrderStatus(PreBookingOrderListVO preBookingOrderListVO, SessionVO sessionVO);

	void updatePreBookingOrderFailStatus(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> selectPreBookingOrderFailStatus(Map<String, Object> params);

	int selectExistingMember(Map<String, Object> params);

	List<EgovMap> getAttachList(Map<String, Object> params);

	int selRcdTms(Map<String, Object> params);

	int selPreBookingOrdId(Map<String, Object> params);

	EgovMap checkOldOrderIdEKeyIn(Map<String, Object> params);

	EgovMap checkOldOrderIdICareEKeyIn(Map<String, Object> params);*/

	EgovMap checkExtradeSchedule();

}
