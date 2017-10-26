package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("OrderAddressApiMapper")
public interface OrderAddressApiMapper {
	
	List<EgovMap> orderAddressList(Map<String, Object> params);

}
