/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

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

}
