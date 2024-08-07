package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.msales.OrderCustAddrApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderCustAddrApiService")
public class OrderCustAddrApiServiceImpl extends EgovAbstractServiceImpl implements OrderCustAddrApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderCustAddrApiMapper")
	private OrderCustAddrApiMapper orderCustAddrApiMapper;
	
	@Override
	public List<EgovMap> orderCustAddressList(Map<String, Object> params) {
		return orderCustAddrApiMapper.orderCustAddressList(params);
	}
}
