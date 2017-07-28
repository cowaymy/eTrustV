package com.coway.trust.biz.payment.autodebit.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ClaimService
{

	
	/**
	 * Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectClaimList(Map<String, Object> params);
    
    /**
     * Auto Debit - Claim Result Deactivate 처리
     * @param params
     */
    void updateDeactivate(Map<String, Object> params);
    
    /**
	 * Auto Debit - Claim 조회 
	 * @param params
	 * @return
	 */	
	EgovMap selectClaimById(Map<String, Object> params);
	
	/**Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectClaimDetailById(Map<String, Object> params); 
	
	
    
}
