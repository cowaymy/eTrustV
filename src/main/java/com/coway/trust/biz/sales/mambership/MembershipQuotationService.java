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
public interface MembershipQuotationService {
	
	
	List<EgovMap>   quotationList(Map<String, Object> params);
	
	List<EgovMap>   newOListuotationList(Map<String, Object> params);
	
	EgovMap		newGetExpDate(Map<String, Object> params);
	
	List<EgovMap>   getSrvMemCode(Map<String, Object> params);
	
	EgovMap		mPackageInfo(Map<String, Object> params);
	
	List<EgovMap>   getPromotionCode(Map<String, Object> params);
	
	List<EgovMap>   getFilterCharge(Map<String, Object> params);
	
	
}
   