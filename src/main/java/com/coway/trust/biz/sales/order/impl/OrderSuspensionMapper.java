package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderSuspensionMapper")
public interface OrderSuspensionMapper {

	List<EgovMap> orderSuspensionList(Map<String, Object> params);
	
	EgovMap orderSuspendInfo(Map<String, Object> params);
	
	List<EgovMap> suspendInchargePerson(Map<String, Object> params);
	
	List<EgovMap> suspendCallResult(Map<String, Object> params);
	
	List<EgovMap> callResultLog(Map<String, Object> params);
	
}
