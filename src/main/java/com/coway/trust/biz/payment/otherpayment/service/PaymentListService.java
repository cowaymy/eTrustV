package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PaymentListService
{

	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectPaymentList(Map<String, Object> params);
    
    /**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);
    
    /**
	 * Payment List - Request DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    EgovMap requestDCF(Map<String, Object> params);
    
    /**
	 * Payment List - Request DCF 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */	
    List<EgovMap> selectRequestDCFList(Map<String, Object> params);
    
    /**
	 * Payment List - Reject DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
    EgovMap rejectDCF(Map<String, Object> params);
    
}
