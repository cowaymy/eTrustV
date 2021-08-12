package com.coway.trust.biz.payment.reconciliation.service;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PaymentReconciliationService
{

	/**
  	 * selectReconciliationMasterList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectReconciliationMasterList(Map<String, Object> params);
	
	/**
  	 * selectDepositView 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectDepositView(Map<String, Object> params);
	
	/**
  	 * selectDepositList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectDepositList(Map<String, Object> params);
	
	/**
  	 * updDepositItem
  	 * @param params
  	 * @return
  	 */
	boolean updDepositItem(Map<String, Object> params);
	
	/**
  	 * saveExcludeDepositItem
  	 * @param params
  	 * @return
  	 */
	boolean saveExcludeDepositItem(Map<String, Object> params);
	
	/**
  	 * selectReconciliationMasterListCount
  	 * @param params
  	 * @return
  	 */
	int selectReconciliationMasterListCount(Map<String, Object> params);
	
	
}
