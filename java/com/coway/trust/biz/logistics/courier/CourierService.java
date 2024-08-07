/**
 * 
 */
package com.coway.trust.biz.logistics.courier;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author 8282
 *
 */
public interface CourierService {

	List<EgovMap> selectCourierList(Map<String, Object> params);

	List<EgovMap> selectCourierDetail(Map<String, Object> params);

	void motifyCourier(Map<String, Object> params);

	void insertCourier(Map<String, Object> params);
	
	List<EgovMap> selectCourierComboList(Map<String, Object> params);

}
