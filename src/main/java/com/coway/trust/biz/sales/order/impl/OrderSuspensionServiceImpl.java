package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderSuspensionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderSuspensionService")
public class OrderSuspensionServiceImpl extends EgovAbstractServiceImpl implements OrderSuspensionService{
	
	private static final Logger logger = LoggerFactory.getLogger(OrderSuspensionServiceImpl.class);

	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderSuspensionList(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspensionList(params);
	}
	
	
	/**
	 * Suspension Information.
	 * 
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	@Override
	public EgovMap orderSuspendInfo(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspendInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> suspendInchargePerson(Map<String, Object> params) {
		return orderSuspensionMapper.suspendInchargePerson(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> suspendCallResult(Map<String, Object> params) {
		return orderSuspensionMapper.suspendCallResult(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> callResultLog(Map<String, Object> params) {
		return orderSuspensionMapper.callResultLog(params);
	}
	
}
