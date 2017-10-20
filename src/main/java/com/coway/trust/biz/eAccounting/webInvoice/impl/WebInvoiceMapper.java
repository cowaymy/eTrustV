package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("webInvoiceMapper")
public interface WebInvoiceMapper {
	
	List<EgovMap> selectWebInvoiceList(Map<String, Object> params);
	
	EgovMap selectWebInvoiceInfo(String clmNo);
	
	List<EgovMap> selectWebInvoiceItems(String clmNo);
	
	List<EgovMap> selectApproveList(Map<String, Object> params);
	
	List<EgovMap> selectAppvLineInfo(String appvPrcssNo);
	
	List<EgovMap> selectAppvInfoAndItems(String appvPrcssNo);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	
	void insertWebInvoiceInfo(Map<String, Object> params);
	
	void insertWebInvoiceDetail(Map<String, Object> params);
	
	void updateWebInvoiceInfo(Map<String, Object> params);
	
	void updateWebInvoiceDetail(Map<String, Object> params);
	
	void deleteWebInvoiceDetail(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	void insertApproveLineDetail(Map<String, Object> params);
	
	void insertApproveItems(Map<String, Object> params);
	
	void updateAppvPrcssNo(Map<String, Object> params);
	
	void updateAppvInfo(Map<String, Object> params);
	
	void updateAppvLine(Map<String, Object> params);
	
	void updateLastAppvLine(Map<String, Object> params);
	
	void insertEccInterface(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
	int selectNextClmSeq(String clmNo);
	
	String selectNextAppvPrcssNo();
	
	int selectNextAppvItmSeq(String appvPrcssNo);
	
	int selectAppvLineCnt(String appvPrcssNo);
	
	int selectAppvLinePrcssCnt(String appvPrcssNo);
	
	String selectNextIfKey();
	
	int selectNextSeq(String ifKey);
	
	String budgetCheck(Map<String, Object> params);
	
}
