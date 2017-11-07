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
public interface MembershipRCService {
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCancellationList(Map<String, Object> params);	
	List<EgovMap> selectReasonList(Map<String, Object> params);	
	List<EgovMap> selectBranchList(Map<String, Object> params);
	EgovMap selectCancellationInfo(Map<String, Object> params);	
	
}
  