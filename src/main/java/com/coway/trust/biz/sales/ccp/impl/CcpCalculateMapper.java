package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpCalculateMapper")
public interface CcpCalculateMapper {

	List<EgovMap> getRegionCodeList(Map<String, Object> params) throws Exception;
	
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
	
	EgovMap countCallEntry(Map<String, Object> params) throws Exception;
	
	void updateCcpDecision(Map<String, Object> params )throws Exception;
	
	List<EgovMap> getCcpDecisionList (Map<String, Object> params) throws Exception; 
	
	void updateCcpDecisionStatus(EgovMap params) throws Exception;
	
	void insertCcpDecision(Map<String, Object> params) throws Exception;
	
	void updateOrdStus(Map<String, Object> params) throws Exception;
	
	EgovMap getCancelOrd(Map<String, Object> params) throws Exception; 
	
	EgovMap getAccRentLedgerAmt(Map<String, Object> params) throws Exception; 
	
	EgovMap getAccTradeLedgerAmt(Map<String, Object> params) throws Exception;
	
	EgovMap getCancelItm(Map<String, Object> params) throws Exception;
	
	void insertOrderCancel(Map<String, Object> params) throws Exception;
	
	String crtSeqSAL0020D() throws Exception; 
	
	void insertCallEntry(Map<String, Object> params) throws Exception;
	
	String crtSeqCCR0006D() throws Exception;
	
	String crtSeqCCR0007D() throws Exception;
	
	String crtSeqSAL0009D() throws Exception;
	
	void insertCallResult(Map<String, Object> params) throws Exception;
	
	void updateCallEntryId(Map<String, Object> params) throws Exception;
	
	void updateOrderRequest(Map<String, Object> params) throws Exception;
	
	void insertLog(Map<String, Object>params) throws Exception;
	
	EgovMap chkECash(Map<String, Object> params);
	
	EgovMap getResultRowForCTOSDisplayForCCPCalculation(Map<String, Object> params);
	
	List<EgovMap> getCcpInstallationList(Map<String, Object> params);
}
