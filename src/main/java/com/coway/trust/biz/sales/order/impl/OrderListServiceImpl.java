/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderListService")
public class OrderListServiceImpl extends EgovAbstractServiceImpl implements OrderListService {

//	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "orderListMapper")
	private OrderListMapper orderListMapper;
	
	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return orderListMapper.selectOrderList(params);
	}
}
