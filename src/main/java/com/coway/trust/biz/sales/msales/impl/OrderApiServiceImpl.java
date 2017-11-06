package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.msales.OrderAddressApiService;
import com.coway.trust.biz.sales.msales.OrderApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderApiService")
public class OrderApiServiceImpl extends EgovAbstractServiceImpl implements OrderApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderApiMapper")
	private OrderApiMapper orderApiMapper;
	
	@Override
	public List<EgovMap> orderProductList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderApiMapper.orderProductList(params);
	}
	
}
