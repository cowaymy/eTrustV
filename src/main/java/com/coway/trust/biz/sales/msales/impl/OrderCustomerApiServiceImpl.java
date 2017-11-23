package com.coway.trust.biz.sales.msales.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.msales.OrderCustomerApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderCustomerApiService")
public class OrderCustomerApiServiceImpl extends EgovAbstractServiceImpl implements OrderCustomerApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderCustomerApiMapper")
	private OrderCustomerApiMapper orderCustomerApiMapper;
	
	@Override
	public EgovMap orderCustomerInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderCustomerApiMapper.orderCustomerInfo(params);
	}
}
