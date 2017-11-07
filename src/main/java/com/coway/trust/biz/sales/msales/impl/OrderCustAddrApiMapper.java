package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("OrderCustAddrApiMapper")
public interface OrderCustAddrApiMapper {

	List<EgovMap> orderCustAddressList(Map<String, Object> params);
	
}
