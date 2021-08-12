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
public interface MembershipPackageMService {
	
	List<EgovMap> selectList(Map<String, Object> params);
	
	List<EgovMap> selectPopDetail(Map<String, Object> params);

	int  SAL0081D_insert(Map<String, Object> params);

	int  SAL0081D_update(Map<String, Object> params);
	
	List<EgovMap> selectPopUpList(Map<String, Object> params);
	
	int  SAL0082D_update(Map<String, Object> params);
	
	int  SAL0082D_insert(Map<String, Object> params);
	
	int  SAL0082D_delete(Map<String, Object> params);
	
	
	List<EgovMap> selectGroupCode(Map<String, Object> params);

	List<EgovMap> selectGroupCodeGroupby(Map<String, Object> params);
	
	List<EgovMap> IsExistSVMPackage(Map<String, Object> params);
	EgovMap  getSAL0081D_SEQ(Map<String, Object> params);

	List<EgovMap> selectFilterList(Map<String, Object> params);

	int saveFilterInfo(Map<String, Object> params);

	String selectStkCode(Map<String, Object> params);	
}
   