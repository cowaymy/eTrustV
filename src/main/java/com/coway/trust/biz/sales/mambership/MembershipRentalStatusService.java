/**
 * 
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
public interface MembershipRentalStatusService {
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCnvrList(Map<String, Object> params);
	
	List<EgovMap> selectCnvrDetailList(Map<String, Object> params);
	
	EgovMap selectCnvrDetail(Map<String, Object> params);
	
	int selectCnvrDetailCount(Map<String, Object> params);
	
	
	
}
  