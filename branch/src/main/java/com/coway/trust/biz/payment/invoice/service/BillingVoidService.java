package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BillingVoidService {
    	 
		/**
      	 * selectStatementView 조회
      	 * @param params
      	 * @return
      	 */
		EgovMap selectStatementView(Map<String, Object> params);
		
		/**
      	 * selectInvoiceDetailList 조회
      	 * @param params
      	 * @return
      	 */
		List<EgovMap> selectInvoiceDetailList(Map<String, Object> params);
		
		/**
      	 * saveInvoiceVoidResult (SP_INST_VOID_INVC_STATE)
      	 * @param params
      	 * @return
      	 */
		void saveInvoiceVoidResult(Map<String, Object> params);
		
}
