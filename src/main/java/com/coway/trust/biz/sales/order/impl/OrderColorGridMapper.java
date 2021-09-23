package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderColorGridMapper")
public interface OrderColorGridMapper {

	List<EgovMap> colorGridList(Map<String, Object> params);

	List<EgovMap> colorGridCmbProduct();

	String getMemID(Map<String, Object> params);

}
