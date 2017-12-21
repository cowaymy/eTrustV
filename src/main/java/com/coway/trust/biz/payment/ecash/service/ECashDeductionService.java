package com.coway.trust.biz.payment.ecash.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ECashDeductionService
{
	/**
	 * E-Cash - List
	 * @param params
	 * @return
	 */
    List<EgovMap> selectECashDeductList(Map<String, Object> params);

	/**
	 * E-Cash Sub - List
	 * @param params
	 * @return
	 */
    List<EgovMap> selectECashDeductSubList(Map<String, Object> params);

	/**
     * E-Cash - Create new claim
     * @param params
     */
    Map<String, Object> createECashDeduction(Map<String, Object> param);

    /**
     * E-Cash - eCash Deactivate 처리
     * @param params
     */
    void deactivateECashDeductionStatus(Map<String, Object> params);

    /**
     * E Cash - eCash Result Item Update
     * @param params
     */
    void updateECashDeductionResultItem(Map<String, Object> eCashMap, List<Object> resultItemList );

    /**
     * E Cash - eCash Result Update
     * @param params
     */
    void updateECashDeductionResult(Map<String, Object> eCashMap);

}
