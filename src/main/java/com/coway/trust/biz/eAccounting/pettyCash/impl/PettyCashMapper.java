package com.coway.trust.biz.eAccounting.pettyCash.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("pettyCashMapper")
public interface PettyCashMapper {
	
	List<EgovMap> selectPettyCashList(Map<String, Object> params);
	
	String selectUserNric(int userId);
	
	void insertCustodian(Map<String, Object> params);

}
