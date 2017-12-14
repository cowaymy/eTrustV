package com.coway.trust.biz.sales.msales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CourseApiMapper")
public interface CourseApiMapper {

	List<EgovMap> courseList(Map<String, Object> params);

	EgovMap courseMemInfo(Map<String, Object> param);

	EgovMap memInfo(Map<String, Object> params);
	
	void registerCourse(Map<String, Object> params);
	
	void cancelCourse(Map<String, Object> params);
}
