package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface WebInvoiceService {
	
	List<EgovMap> selectWebInvoiceList(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
	void insertWebInvoiceInfo(Map<String, Object> params);
	
	EgovMap selectWebInvoiceInfo(String clmNo);
	
	List<EgovMap> selectWebInvoiceItems(String clmNo);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	
	void updateWebInvoiceInfo(Map<String, Object> params);
	
	List<Object> budgetCheck(Map<String, Object> params);
	
	String selectNextAppvPrcssNo();
	
	void insertApproveManagement(Map<String, Object> params);
	
	List<EgovMap> selectApproveList(Map<String, Object> params);
	
	List<EgovMap> selectAppvLineInfo(String appvPrcssNo);
	
	List<EgovMap> selectAppvInfoAndItems(String appvPrcssNo);
	
	String getAppvPrcssStus(List<EgovMap> appvLineInfo, List<EgovMap> appvInfoAndItems);
	
	void updateApprovalInfo(Map<String, Object> params);
	
	void updateRejectionInfo(Map<String, Object> params);
	
	void updateWebInvoiceInfoTotAmt(Map<String, Object> params);
	
}
