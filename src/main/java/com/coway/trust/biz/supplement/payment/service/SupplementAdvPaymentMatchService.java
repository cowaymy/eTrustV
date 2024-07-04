package com.coway.trust.biz.supplement.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementAdvPaymentMatchService
{

	/**
   	 * Advance Payment Match - Advance KeyIn List
   	 */
	List<EgovMap> selectAdvKeyInList(Map<String, Object> paramMap);

	/**
   	 * Advance Payment Match - Bank Statement List
   	 */
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

	/**
	 * Advance Payment Matching - Mapping
	 */
    void saveAdvPaymentMapping(Map<String, Object> params);

    /**
	 * Advance Payment Matching - Debtor
	 * @param params
	 * @param model
	 * @return
	 */
    void saveAdvPaymentDebtor(Map<String, Object> params);

    List<EgovMap> getAccountList(Map<String, Object> params);

    List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

    List<EgovMap> selectAdvKeyInReport(Map<String, Object> params);
}
