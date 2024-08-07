package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderAddressApiService {

	List<EgovMap> orderAddressList(Map<String, Object> params);
	
}
