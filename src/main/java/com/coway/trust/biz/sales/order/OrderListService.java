/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderListService {
	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	List<EgovMap> getApplicationTypeList(Map<String, Object> params);
	
	List<EgovMap> getUserCodeList();
	
	List<EgovMap> getOrgCodeList(Map<String, Object> params);
	
	List<EgovMap> getGrpCodeList(Map<String, Object> params);
}
