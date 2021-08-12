package com.coway.trust.biz.sales.msales;

import java.util.Map;

import com.coway.trust.api.mobile.sales.registerCustomer.RegCustomerForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCustomerApiService {

	EgovMap orderCustInfo(Map<String, Object> params);
	
	public void insertCustomer(RegCustomerForm regCustomerForm);
}
