package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdvPaymentService
{

	/**
   	 * Advance Payment - 등록 처리 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
	List<EgovMap> saveAdvPayment(Map<String, Object> paramMap, List<Object> paramList );
    
}
