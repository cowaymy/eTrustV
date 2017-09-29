package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface WebInvoiceService {
	
	List<EgovMap> selectSampleList(Map<String, Object> params);
	
	void insertWebInvoiceByMap(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTextCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
}
