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
public interface MembershipConvSaleService {
	
	int SAL0095D_insert(Map<String, Object> params);
	
	EgovMap  getHasBill(Map<String, Object> params);
	
	
}
   