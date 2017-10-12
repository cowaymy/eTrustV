package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BatchPaymentOutService
{

	
	/**
	 * Batch Payment List(Internal Staff)조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectBatchPaymentOutList(Map<String, Object> params);
    
    /**
	 * saveBatchPaymentOutUpload
	 * @param params
	 * @return
	 */
    int saveBatchPaymentOutUpload(Map<String, Object> master, List<Map<String, Object>> detailList);
    
    

}
