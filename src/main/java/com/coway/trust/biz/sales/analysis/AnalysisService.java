package com.coway.trust.biz.sales.analysis;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AnalysisService {

	EgovMap maintanceSession();

	List<EgovMap> selectPltvProductCodeList(Map<String, Object> params);

	List<EgovMap> selectPltvProductCategoryList(Map<String, Object> params);

	String selectMaxAccYm();
}
