package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GSTZeroRateLocationService {
	//GST Zero Rate Exportation
	List<EgovMap> selectGSTExportationList(Map<String, Object> params);

	List<EgovMap> selectGSTExportDealerList(Map<String, Object> params);

	//int insertGSTExportation(List<Object> addList, Integer updUserId);

	//int updateGSTExportation(List<Object> addList, Integer updUserId);

	//int deleteGSTExportation(List<Object> addList, Integer updUserId);

	/**
	 * Insert, Update, Delete GSTExportation List
	 * @Author KR-OHK
	 * @Date 2019. 9. 10.
	 * @param addList
	 * @param udtList
	 * @param delList
	 * @param userId
	 * @return
	 */
	int saveGSTExportation(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId);

	//GST Zero Rate Location
	List<EgovMap> getStateCodeList(Map<String, Object> params);

	List<EgovMap> getSubAreaList(Map<String, Object> params);

	List<EgovMap> getZRLocationList(Map<String, Object> params);

	List<EgovMap> getPostCodeList(Map<String, Object> params);

	void saveZRLocation(Map<String, ArrayList<Object>> params, int userId);
}
