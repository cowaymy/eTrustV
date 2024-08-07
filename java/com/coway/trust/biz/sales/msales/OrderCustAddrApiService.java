package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCustAddrApiService {

	List<EgovMap> orderCustAddressList(Map<String, Object> params);
	
}
