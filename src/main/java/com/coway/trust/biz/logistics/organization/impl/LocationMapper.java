package com.coway.trust.biz.logistics.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("locMapper")
public interface LocationMapper {
	List<EgovMap> selectLocationList(Map<String, Object> params);
	
	List<EgovMap> selectLocationStockList(Map<String, Object> params);
	
	void updateLocationInfo(Map<String, Object> params);
	void insertLocationInfo(Map<String, Object> params);
	String locCreateSeq();
}
