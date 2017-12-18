package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("advPaymentMatchMapper")
public interface AdvPaymentMatchMapper {

	/**
   	 * Advance Payment Match - Advance KeyIn List 조회 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
	List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);
	
	/**
   	 * Advance Payment Match - Bank Statement List 조회 
   	 * @param params
   	 * @param model
   	 * @return
   	 * 
   	 */
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);
	
	/**
	 * Advance Payment Matching - Mapping 처리 : Group Payment Mapping처리 
	 * @param params
	 * @param model
	 * @return
	 */	
	void mappingAdvGroupPayment(Map<String, Object> params);
	
	/**
	 * Advance Payment Matching - Mapping 처리 : Bank Statement Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */	
	void mappingBankStatementAdv(Map<String, Object> params);
	
	
	
}
