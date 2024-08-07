package com.coway.trust.biz.sales.msales.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("OrderCustomerApiMapper")
public interface OrderCustomerApiMapper {

	EgovMap orderCustInfo(Map<String, Object> params);
	
	int custIdSeq();
	
	void insertCustomer(Map<String, Object> params);
	
	void insertContactInfo(Map<String, Object> params);
	
	void insertCareContactInfo(Map<String, Object> params);
}
