package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GSTZeroRateLocationService {
	List<EgovMap> getStateCodeList(Map<String, Object> params);

	List<EgovMap> getSubAreaList(Map<String, Object> params);

	List<EgovMap> getZRLocationList(Map<String, Object> params);
}
