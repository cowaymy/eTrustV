package com.coway.trust.biz.sales.order.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderRentalMapper")
public interface OrderRentalMapper {

	EgovMap getPayTerm(Map<String, Object> params) throws Exception;
	
	EgovMap getRentPayInfo(Map<String, Object> params) throws Exception;
	
	void updatePayChannel(Map<String, Object> params) throws Exception;
}
