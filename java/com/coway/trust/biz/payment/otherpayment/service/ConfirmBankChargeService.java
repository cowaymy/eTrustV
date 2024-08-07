package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

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
	 * Confirm Bank Charge Confirm 처리
	 * @param params
	 * @param model
	 * @return
	 */	
    void saveBankChgConfirm(List<Object> paramList, SessionVO sessionVO);
	
	
    
}
