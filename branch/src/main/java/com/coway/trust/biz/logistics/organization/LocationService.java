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

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LocationService {
	List<EgovMap> selectLocationList(Map<String, Object> params);

	List<EgovMap> selectLocationStockList(Map<String, Object> params);

	void updateLocationInfo(Map<String, Object> params);

	int insertLocationInfo(Map<String, Object> params);

	void deleteLocationInfo(Map<String, Object> params);

	List<EgovMap> selectLocationCodeList(Map<String, Object> params);

	int selectLocationChk(String params);

	List<EgovMap> selectLocStatusList(Map<String, Object> params);

	void updateBranchLoc(Map<String, Object> params);

}
