package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderCancelService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderCancelService")
public class OrderCancelServiceImpl  extends EgovAbstractServiceImpl implements OrderCancelService{

	private static final Logger logger = LoggerFactory.getLogger(OrderCancelServiceImpl.class);
	
	@Resource(name = "orderCancelMapper")
	private OrderCancelMapper orderCancelMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderCancellationList(Map<String, Object> params) {
		return orderCancelMapper.orderCancellationList(params);
	}
	
	
	/**
	 * DSC BRANCH
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> dscBranch(Map<String, Object> params) {
		return orderCancelMapper.dscBranch(params);
	}
	
	
	@Override
	public EgovMap cancelReqInfo(Map<String, Object> params) {
		
		return orderCancelMapper.cancelReqInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> cancelLogTransctionList(Map<String, Object> params) {
		return orderCancelMapper.cancelLogTransctionList(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> productReturnTransctionList(Map<String, Object> params) {
		return orderCancelMapper.productReturnTransctionList(params);
	}
	
	
	@Override
	public EgovMap ctAssignmentInfo(Map<String, Object> params) {
		
		return orderCancelMapper.ctAssignmentInfo(params);
	}
	
	
	/**
	 * Assign CT  - New Cancellation Log Result
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> selectAssignCT(Map<String, Object> params) {
		return orderCancelMapper.selectAssignCT(params);
	}
	
	
	/**
	 * Assign CT  - New Cancellation Log Result
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> selectFeedback(Map<String, Object> params) {
		return orderCancelMapper.selectFeedback(params);
	}
}
