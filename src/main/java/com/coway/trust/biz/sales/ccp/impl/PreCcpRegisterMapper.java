package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preCcpRegisterMapper")
public interface PreCcpRegisterMapper {

	int insertPreCcpSubmission(Map<String, Object> params);

	EgovMap getExistCustomer(Map<String, Object> params);

//	List<EgovMap> selectPreCcpStatus();
//
//	List<EgovMap> searchPreCcpRegisterList(Map<String, Object> params);

	List<EgovMap> searchOrderSummaryList(Map<String, Object> params);

}