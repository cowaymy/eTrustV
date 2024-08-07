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
public interface MembershipRentalChannelService {
	
	List<EgovMap> getLoadRejectReasonList(Map<String, Object> params);
	
	int  SAL0074D_update(Map<String, Object> params);
	
	
}
   