/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.organization;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LocationService {
	List<EgovMap>selectLocationList(Map<String, Object> params);
	List<EgovMap>selectLocationStockList(Map<String, Object> params);
	
	void updateLocationInfo(Map<String, Object> params);
	void insertLocationInfo(Map<String, Object> params);
	void deleteLocationInfo(Map<String, Object> params);
}