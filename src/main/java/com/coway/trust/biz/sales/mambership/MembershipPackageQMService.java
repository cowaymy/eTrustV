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
public interface MembershipPackageQMService {
	
	List<EgovMap> selectList(Map<String, Object> params);
	
	List<EgovMap> selectPopDetail(Map<String, Object> params);
	
	int  SAL0091M_update(Map<String, Object> params);
	
	List<EgovMap> selectPopUpList(Map<String, Object> params);
	
	int  SAL0092M_update(Map<String, Object> params);
	
	int  SAL0092M_insert(Map<String, Object> params);
	
	int  SAL0092M_delete(Map<String, Object> params);
	
	
	List<EgovMap> selectGroupCode(Map<String, Object> params);

	List<EgovMap> selectGroupCodeGroupby(Map<String, Object> params);
	
	EgovMap  getSAL0091M_SEQ(Map<String, Object> params);
	
	int  SAL0091M_insert(Map<String, Object> params);
	List<EgovMap> IsExistSVMPackage(Map<String, Object> params);

	
}
   