package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ConfirmBankChargeService
{

	/**
   	 * Confirm Bank Charge Match - Normal KeyIn List 조회 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
	List<EgovMap> selectNorKeyInList(Map<String, Object> paramMap);
	
	/**
   	 * Confirm Bank Charge Match - Bank Statement List 조회 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);
	
	/**
	 * Confirm Bank Charge Match - Mapping 처리 
	 * @param params
	 * @param model
	 * @return
	 */	
    void saveBankChgMapping(Map<String, Object> params);
	
	
    
}
