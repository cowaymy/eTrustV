package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

public interface AdvPaymentService
{

	/**
   	 * Advance Payment - 등록 처리 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
    void saveAdvPayment(Map<String, Object> paramMap, List<Object> paramList );
    
}
