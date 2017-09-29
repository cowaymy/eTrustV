package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("webInvoiceMapper")
public interface WebInvoiceMapper {
	
	List<EgovMap> selectWebInvoiceByParamsList(Map<String, Object> params);
	
	void insertWebInvoiceByMap(Map<String, Object> params);
	
	List<EgovMap> selectSupplier(Map<String, Object> params);
	
	List<EgovMap> selectCostCenter(Map<String, Object> params);
	
	List<EgovMap> selectTextCodeWebInvoiceFlag();
	
	String selectNextClmNo();
	
}
