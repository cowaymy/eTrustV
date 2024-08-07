package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("OrderApiMapper")
public interface OrderApiMapper {
	
	List<EgovMap> orderProductList(Map<String, Object> params);

	List<EgovMap> orderPromotionList(Map<String, Object> params);

	EgovMap selectOrderCostCalc(Map<String, Object> params);

	List<EgovMap> selectPreOrderList(Map<String, Object> params);

	void insertPreOrder(Map<String, Object> params);
}
