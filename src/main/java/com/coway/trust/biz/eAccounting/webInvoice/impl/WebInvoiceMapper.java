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
	
	List<EgovMap> selectWebInvoiceAttachList(int atchFileGrpId);
	
	EgovMap selectAttachmentInfo(Map<String, Object> params);
	
	void insertWebInvoiceInfo(Map<String, Object> params);
	
	void insertWebInvoiceDetail(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
	int selectNextClmSeq();
	
}
