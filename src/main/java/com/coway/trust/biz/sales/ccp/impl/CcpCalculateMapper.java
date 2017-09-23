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
	
	EgovMap comboUnitSelectValue(Map<String, Object> params) throws Exception;
	
	EgovMap getScorePointByEventID(Map<String, Object> params) throws Exception;
	
	double getScoreEventTotalRental(Map<String, Object> params) throws Exception;
	
	double getScoreEventTotalRos(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getScoreEventSuspension(Map<String, Object> params) throws Exception;
	
	EgovMap rentalSchemeStatusByOrdId(Map<String, Object> params) throws Exception;
	
	EgovMap rentalInstNoByOrdId (Map<String, Object> params )throws Exception;
	
	EgovMap getScoreEventExistCust(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getCcpStusCodeList() throws Exception;
	
	List<EgovMap> getCcpRejectCodeList() throws Exception;
	
	EgovMap getCcpByCcpId(Map<String, Object> params) throws Exception; // 1
	
	List<EgovMap> getIncomeRangeList(Map<String, Object> params) throws Exception;
	
	EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception;
	
	EgovMap selectSalesManViewByOrdId(Map<String, Object> params) throws Exception;
}
