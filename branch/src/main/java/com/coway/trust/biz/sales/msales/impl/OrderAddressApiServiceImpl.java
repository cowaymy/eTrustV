package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.msales.OrderAddressApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderAddressApiService")
public class OrderAddressApiServiceImpl extends EgovAbstractServiceImpl implements OrderAddressApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderAddressApiMapper")
	private OrderAddressApiMapper OrderAddressApiMapper;
	
	@Override
	public List<EgovMap> orderAddressList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return OrderAddressApiMapper.orderAddressList(params);
	}
	
}
