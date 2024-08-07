/**
 *
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface PreOrderService {

	List<EgovMap> selectPreOrderList(Map<String, Object> params);

	int selectExistSofNo(Map<String, Object> params);

	void insertPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO);

	EgovMap selectPreOrderInfo(Map<String, Object> params);

	void updatePreOrder(PreOrderVO preOrderVO, SessionVO sessionVO);

	void updatePreOrderStatus(PreOrderListVO preOrderListVO, SessionVO sessionVO);

	void updatePreOrderFailStatus(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> selectPreOrderFailStatus(Map<String, Object> params);

	int selectExistingMember(Map<String, Object> params);

	List<EgovMap> getAttachList(Map<String, Object> params);

	int selRcdTms(Map<String, Object> params);

	int selPreOrdId(Map<String, Object> params);

	EgovMap checkOldOrderIdEKeyIn(Map<String, Object> params);

	EgovMap checkOldOrderIdICareEKeyIn(Map<String, Object> params);

	EgovMap checkExtradeSchedule() ;

}
