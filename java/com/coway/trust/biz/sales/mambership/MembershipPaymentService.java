/**
 * 
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;



import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
public interface MembershipPaymentService {
	
	
	List<EgovMap>   selPaymentConfig(Map<String, Object> params);
	
	List<EgovMap> paymentLastMembership(Map<String, Object> params);
	
	List<EgovMap> paymentInsAddress(Map<String, Object> params);
	
	EgovMap   paymentCharges(Map<String, Object> params);
	
	List<EgovMap> paymentCollecterList(Map<String, Object> params);

	List<EgovMap> paymentColleConfirm(Map<String, Object> params);
	
	List<EgovMap> paymentGetAccountCode(Map<String, Object> params);
	
	
}
   