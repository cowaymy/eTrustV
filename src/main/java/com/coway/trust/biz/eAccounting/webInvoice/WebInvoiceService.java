package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface WebInvoiceService {
	
	List<EgovMap> selectWebInvoiceList(Map<String, Object> params);
	
	EgovMap selectWebInvoiceInfo(String clmNo);
	
	List<EgovMap> selectWebInvoiceItems(String clmNo);
	
	List<EgovMap> selectApproveList(Map<String, Object> params);
	
	List<EgovMap> selectAppvLineInfo(String appvPrcssNo);
	
	List<EgovMap> selectAppvInfoAndItems(String appvPrcssNo);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	
	void insertWebInvoiceInfo(Map<String, Object> params);
	
	void updateWebInvoiceInfo(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	void updateApprovalInfo(Map<String, Object> params);
	
	void updateRejectionInfo(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
	String selectNextAppvPrcssNo();
	
	String selectNextIfKey();
	
	List<Object> budgetCheck(Map<String, Object> params);
	
	String getAppvPrcssStus(List<EgovMap> appvLineInfo, List<EgovMap> appvInfoAndItems);
	
	void updateWebInvoiceInfoTotAmt(Map<String, Object> params);
	
}
