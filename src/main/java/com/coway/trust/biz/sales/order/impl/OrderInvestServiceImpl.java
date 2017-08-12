package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderInvestService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderInvestService")
public class OrderInvestServiceImpl extends EgovAbstractServiceImpl implements OrderInvestService{

	private static final Logger logger = LoggerFactory.getLogger(OrderInvestServiceImpl.class);
	
	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderInvestList(Map<String, Object> params) {
		return orderInvestMapper.orderInvestigationList(params);
	}
}
