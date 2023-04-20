package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdvPaymentMatchService
{

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
	 * Advance Payment Matching - Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */
    void saveAdvPaymentMapping(Map<String, Object> params);

    /**
	 * Advance Payment Matching - Reverse 처리
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap requestDCFWithAppv(Map<String, Object> params);

    /**
	 * Advance Payment Matching - Debtor 처리
	 * @param params
	 * @param model
	 * @return
	 */
    void saveAdvPaymentDebtor(Map<String, Object> params);

    List<EgovMap> selectJompayMatchList(Map<String, Object> params);

    EgovMap  saveJompayPaymentMapping(Map<String, Object> params);

  List<EgovMap> selectAdvanceMatchList(Map<String, Object> params);

  EgovMap saveAdvancePaymentMapping(Map<String, Object> params);


}
