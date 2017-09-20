package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpCalculateMapper")
public interface CcpCalculateMapper {

	List<EgovMap> selectDscCodeList() throws Exception;
	
	List<EgovMap> selectReasonCodeFbList() throws Exception;
	
	List<EgovMap> selectCalCcpListAjax(Map<String, Object> params) throws Exception;
	
	EgovMap getPrgId(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getOrderUnitList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> countOrderUnit(Map<String, Object> params) throws Exception;
	
	EgovMap orderUnitSelectValue(Map<String, Object> params) throws Exception;
}
