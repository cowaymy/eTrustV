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

	List<EgovMap> getCcpStusCodeList2() throws Exception;

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
//EXPERIAN CHANEG
	EgovMap getResultRowForEXPERIANDisplayForCCPCalculation(Map<String, Object> params);
//EXPERIAN CHANEG
	List<EgovMap> getCcpInstallationList(Map<String, Object> params);

	EgovMap getAux(Map<String, Object> params);

	EgovMap selectCcpInfoByOrderId(Map<String, Object> params) throws Exception;

	List<EgovMap>ccpEresubmitNewConfirm(Map<String, Object> params);

	List<EgovMap>ccpEresubmitList(Map<String, Object> params) throws Exception;

	void insertCcpEresubmitNewSave(Map<String, Object> params) throws Exception;

	void insertCcpEresubmitNewSaveHist(Map<String, Object> params) throws Exception;

	void 	insertCcpEresubmitRenewSaveHist(Map<String, Object> params) throws Exception;

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

	void updateCcpEresubmitAttach(Map<String, Object> params) throws Exception;

	EgovMap selectCcpEresubmit(Map<String, Object> params) throws Exception;

	EgovMap selectCcpEresubmitView(Map<String, Object> params) throws Exception;

	List<EgovMap>selectCcpHistory(Map<String, Object> params) throws Exception;

	void updateCcpEresubmitStus(Map<String, Object> params) throws Exception;

	void updateCcpEresubmitHistStus(Map<String, Object> params) throws Exception;

	void updateCcpCalRevStus(Map<String, Object> params) throws Exception;

	void insertCcpCalRevHistStus(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCcpStusHistList(Map<String, Object> params);

	int getMemberID(Map<String, Object> params);

	String getEzyDocNo();

    EgovMap getExisitngOrderId(Map<String, Object> params) throws Exception;

    EgovMap selectOwnPurchaseInfo(Object params) throws Exception;

    List<EgovMap> selectCCPTicket(Map<String, Object> params) throws Exception;

    int ccpTicketSeq() throws Exception;

    int selectDuplicateTickets(Map<String, Object>p) throws Exception;

    void insertCCPTicket(Map<String, Object> p) throws Exception;

    void insertCCPTicketLog(Map<String, Object>p) throws Exception;

    EgovMap ccpTicketDetails(Map<String, Object> p) throws Exception;

    List<String> ccpMembers() throws Exception;

    List<EgovMap> orgDetails(Map<String, Object> p) throws Exception;

    void updateCCPTicket(Map<String, Object> p) throws Exception;

	List<EgovMap> selectTicketLogs(Map<String, Object> params) throws Exception;

	void inactiveCallLog(Map<String, Object>params) throws Exception;

	void inactiveRentalAgreement(Map<String, Object>params) throws Exception;
}
