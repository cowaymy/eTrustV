package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InvoiceAdjService {
    	 /**
      	 * InvoiceAdjustment List 조회
      	 * @param params
      	 * @return
      	 */
		List<EgovMap> selectInvoiceAdj(Map<String, Object> params);
      
      	/**
    	 * New InvoiceAdjustment Master 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectNewAdjMaster(Map<String, Object> params);
        
        /**
    	 * New InvoiceAdjustment Detail 조회
    	 * @param params
    	 * @return
    	 */
        List<EgovMap> selectNewAdjDetailList(Map<String, Object> params);
}
