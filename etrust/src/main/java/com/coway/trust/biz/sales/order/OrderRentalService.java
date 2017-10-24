package com.coway.trust.biz.sales.order;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderRentalService {

	EgovMap getPayTerm(Map<String, Object> params) throws Exception;
	
	void updatePayChannel(Map<String, Object> params) throws Exception;
}
