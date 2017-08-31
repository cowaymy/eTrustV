package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GSTZeroRateLocationService {
	//GST Zero Rate Exportation
	List<EgovMap> selectGSTExportationList(Map<String, Object> params);
	
	//GST Zero Rate Location
	List<EgovMap> getStateCodeList(Map<String, Object> params);

	List<EgovMap> getSubAreaList(Map<String, Object> params);

	List<EgovMap> getZRLocationList(Map<String, Object> params);

	List<EgovMap> getPostCodeList(Map<String, Object> params);

	void saveZRLocation(Map<String, ArrayList<Object>> params, int userId);
}
