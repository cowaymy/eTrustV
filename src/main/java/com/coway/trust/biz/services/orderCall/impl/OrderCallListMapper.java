package com.coway.trust.biz.services.orderCall.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderCallListMapper")
public interface OrderCallListMapper {

	List<EgovMap> selectOrderCall();
	
	EgovMap getOrderCall(Map<String, Object> params);
	
	EgovMap selectCallEntry(Map<String, Object> params);
	
	void insertCallResult(Map<String, Object> params);
	
	void updateCallEntry(Map<String, Object> params);
	
	void insertInstallEntry(Map<String, Object> params);
	
	List<EgovMap> selectCallStatus();
	
	String selectMaxId(Map<String, Object> params);
}
