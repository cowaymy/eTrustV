package com.coway.trust.biz.payment.ecash.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ECashService
{


	/**
	 * E-Cash - List
	 * @param params
	 * @return
	 */
    List<EgovMap> selectECashList(Map<String, Object> params);

	/**
     * E-Cash - Create new claim
     * @param params
     */
    Map<String, Object> createECashDeduction(Map<String, Object> param);

//    /**
//     * Auto Debit - Claim Result Deactivate 처리
//     * @param params
//     */
//    void updateDeactivate(Map<String, Object> params);
//
//    /**
//	 * Auto Debit - Claim 조회
//	 * @param params
//	 * @return
//	 */
//	EgovMap selectClaimById(Map<String, Object> params);
//
//	/**Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
//	 * @param params
//	 * @return
//	 */
//	List<EgovMap> selectClaimDetailById(Map<String, Object> params);
//
//
//    /**
//     * Auto Debit - Claim Result Update
//     * @param params
//     */
//    void updateClaimResultItem(Map<String, Object> claimMap, List<Object> resultItemList );
//
//    /**
//     * Auto Debit - Claim Result Update LIVE
//     * @param params
//     */
//    void updateClaimResultLive(Map<String, Object> claimMap);
//
//    /**
//     * Auto Debit - Claim Result Update NEXT DAY
//     * @param params
//     */
//    void updateClaimResultNextDay(Map<String, Object> claimMap);
//
//    /**
//     * Auto Debit - Claim Fail Deduction SMS 상세 리스트 조회
//     * @param params
//     */
//    List<EgovMap> selectFailClaimDetailList(Map<String, Object> param);
//
//    /**
//     * Auto Debit - Fail Deduction SMS 재발송 처리
//     * @param params
//     */
//    void sendFaileDeduction(Map<String, Object> params);

}
