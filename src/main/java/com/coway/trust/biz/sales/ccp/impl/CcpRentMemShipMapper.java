package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpRentMemShipMapper")
public interface CcpRentMemShipMapper {

	List<EgovMap> getBranchCodeList() throws Exception;
	
	List<EgovMap> getReasonCodeList() throws Exception;
	
	List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception;
}
