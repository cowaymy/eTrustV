package com.coway.trust.biz.sales.order.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.order.OrderRentalService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderRentalService")
public class OrderRentalServiceImpl implements OrderRentalService {

	private static final Logger logger = LoggerFactory.getLogger(OrderRentalServiceImpl.class);
	
	@Resource(name = "orderRentalMapper")
	private OrderRentalMapper orderRentalMapper;
	
	
	@Override
	public EgovMap getPayTerm(Map<String, Object> params) throws Exception {
		
		return orderRentalMapper.getPayTerm(params);
	}
	

	@Override
	public void updatePayChannel(Map<String, Object> params) throws Exception {
		
		// 1. Search
		EgovMap rentMap = null;
		rentMap = orderRentalMapper.getRentPayInfo(params); //params : OrdId
		params.put("rentPayId", rentMap.get("rentPayId"));
		
		// 2. Update
		orderRentalMapper.updatePayChannel(params); // params : 위에서 가져온 rentPayId , payTerm
		
	}
}
