package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("confirmBankChargeMapper")
public interface ConfirmBankChargeMapper {

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
	 * Confirm Bank Charge Match - Mapping 처리 : Group Payment Mapping처리 
	 * @param params
	 * @param model
	 * @return
	 */	
	void mappingBankChgGroupPayment(Map<String, Object> params);
	
	/**
	 * Confirm Bank Charge Match - Mapping 처리 : Bank Statement Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */	
	void mappingBankStatementBankChg(Map<String, Object> params);
	
	/**
	 * 
	 * @param params
	 * @param model
	 * @return
	 */	
	void insertConfBankChargeIF(Map<String, Object> params);
	
	
}
