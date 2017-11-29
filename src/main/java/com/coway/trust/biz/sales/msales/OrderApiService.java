package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderApiService {

	List<EgovMap> orderProductList(Map<String, Object> params);
	
	List<EgovMap> orderPromotionList(Map<String, Object> params);

	EgovMap orderCostCalc(Map<String, Object> params);
	
	List<EgovMap> preOrderList(Map<String, Object> params);

}
