package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpCTOSB2BMapper")
public interface CcpCTOSB2BMapper {

	
	List<EgovMap> selectCTOSB2BList(Map<String, Object> params);
	
	List<EgovMap> getCTOSDetailList(Map<String, Object> params);
	
	EgovMap getResultRowForCTOSDisplay(Map<String, Object> params);
	
}
