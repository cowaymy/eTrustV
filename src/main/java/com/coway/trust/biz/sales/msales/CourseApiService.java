package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CourseApiService {

	List<EgovMap> courseList(Map<String, Object> params);

	EgovMap courseMemInfo(Map<String, Object> param);

	EgovMap memInfo(Map<String, Object> params);
	
}
