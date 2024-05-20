package com.coway.trust.biz.payment.selfcare.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("selfCareHostToHostMapper")
public interface SelfCareHostToHostMapper {
	List<EgovMap> getSelfCareTransactionList(Map<String,Object> params);
	List<EgovMap> getSelfCareTransactionDetails(Map<String,Object> params);
	List<EgovMap> getSelfcareBatchDetailReport(Map<String,Object> params);
}
