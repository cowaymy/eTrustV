/**
 * 
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;

import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 * 
 */
public interface MembershipRentalService {
	   
	  
	/**
	 * 
	 * @param params
	 * @return
	 */
	List<EgovMap> selectList(Map<String, Object> params);
	List<EgovMap> selectPaymentList(Map<String, Object> params);
	List<EgovMap> selectCallLogList(Map<String, Object> params);
	List<EgovMap> selectPaymentDetailList(Map<String, Object> params);
	
	EgovMap selectCcontactSalesInfo(Map<String, Object> params);
	EgovMap selectConfigInfo(Map<String, Object> params);
	EgovMap selectPatsetInfo(Map<String, Object> params, SessionVO sessionVO);
	EgovMap selectPayThirdPartyInfo(Map<String, Object> params);

	EgovMap selectPayBillingInfo(Map<String, Object> params);
	EgovMap selectPayUnbillInfo(Map<String, Object> params);
	EgovMap accServiceContractLedgers(Map<String, Object> params);
	
	EgovMap selectOrderMailingInfo(Map<String, Object> params);
	EgovMap usp_SELECT_ServiceContract_LedgerOutstanding(Map<String, Object> params);
	EgovMap usp_SELECT_ServiceContract_Ledger(Map<String, Object> params);
	EgovMap selectQuotInfoInfo(Map<String, Object> params);

	List<EgovMap> paymentViewHistory(Map<String, Object> params);
	void viewHistPaySetting(Map<String, Object> setmap);
	
	
}
   