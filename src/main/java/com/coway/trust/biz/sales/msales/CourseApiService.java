package com.coway.trust.biz.sales.msales;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.sales.saveCourse.SaveCourseForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CourseApiService {

	List<EgovMap> courseList(Map<String, Object> params);

	EgovMap courseMemInfo(Map<String, Object> param);

	EgovMap memInfo(Map<String, Object> params);

	void saveCourse(SaveCourseForm saveCourseForm) throws Exception;
	
}
