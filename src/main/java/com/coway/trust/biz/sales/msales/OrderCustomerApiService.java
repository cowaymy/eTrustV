package com.coway.trust.biz.sales.msales;

import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCustomerApiService {

	EgovMap orderCustInfo(Map<String, Object> params);
}
