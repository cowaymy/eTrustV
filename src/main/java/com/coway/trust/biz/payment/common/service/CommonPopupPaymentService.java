package com.coway.trust.biz.payment.common.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonPopupPaymentService{
	
	/**
	 * Payment - Invoice Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectCommonSearchInvoicePop(Map<String, Object> params);
    
   
  

}
