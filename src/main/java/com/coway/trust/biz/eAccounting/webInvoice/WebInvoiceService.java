package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface WebInvoiceService {
	
	List<EgovMap> selectWebInvoiceList(Map<String, Object> params);
	
	EgovMap selectWebInvoiceInfo(String clmNo);
	
	List<EgovMap> selectWebInvoiceItems(String clmNo);
	
	List<EgovMap> selectWebInvoiceAttachList(int atchFileGrpId);
	
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	
	void insertWebInvoiceInfo(Map<String, Object> params);
	
	void insertWebInvoiceDetail(Map<String, Object> params);
	
	void updateWebInvoiceInfo(Map<String, Object> params);
	
	void updateWebInvoiceDetail(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
	int selectNextClmSeq();
	
}
