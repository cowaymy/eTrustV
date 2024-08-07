package com.coway.trust.biz.homecare.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreOrderVO;
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
public interface HcPreOrderService {

	/**
	 * Search Homecare Pre OrderList
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcPreOrderList(Map<String, Object> params);

	/**
	 * Homecare Pre Order Register
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param orderVO
	 * @param sessionVO
	 * @throws ParseException
	 */
	public void registerHcPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) throws ParseException;

	/**
	 * Search Homacare Pre OrderInfo
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @return
	 */
	public EgovMap selectHcPreOrderInfo(Map<String, Object> params);

	/**
	 * Homecare Pre Order update
	 * @Author KR-SH
	 * @Date 2019. 11. 5.
	 * @param orderVO
	 * @param sessionVO
	 * @throws ParseException
	 */
	public int updateHcPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) throws ParseException;


	/**
	 * Homecare Pre Order Status Update
	 * @Author KR-SH
	 * @Date 2019. 11. 11.
	 * @param params
	 * @param sessionVO
	 * @throws ParseException
	 */
	public int updateHcPreOrderStatus(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

}
