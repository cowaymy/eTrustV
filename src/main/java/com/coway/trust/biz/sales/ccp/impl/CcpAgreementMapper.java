package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpAgreementMapper")
public interface CcpAgreementMapper {

	List<EgovMap> selectContactAgreementList(Map<String, Object> params);
	
	List<String> selectItemBatchNofromSalesOrdNo(Map<String, Object> params);
	
}
