package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpAgreementMapper")
public interface CcpAgreementMapper {

	List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception;
	
	List<String> selectItemBatchNofromSalesOrdNo(Map<String, Object> params) throws Exception;
	
	EgovMap getOrderId(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAfterServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectBeforeServiceJsonList (Map<String, Object> params) throws Exception;
	
}
