package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.sales.registerPreOrder.RegPreOrderForm;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderApiService {

	List<EgovMap> orderProductList(Map<String, Object> params);
	
	List<EgovMap> orderPromotionList(Map<String, Object> params);

	EgovMap orderCostCalc(Map<String, Object> params);
	
	List<EgovMap> preOrderList(Map<String, Object> params);

	public void insertPreOrder(RegPreOrderForm  regPreOrderForm) throws Exception;

}
