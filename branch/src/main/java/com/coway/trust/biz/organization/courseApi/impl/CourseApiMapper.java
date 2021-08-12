package com.coway.trust.biz.organization.courseApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CourseApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("CourseApiMapper")
public interface CourseApiMapper {



	List<EgovMap>selectCourse(Map<String, Object> params);



	int insertCourse(Map<String, Object> params);



	int updateCourse(Map<String, Object> params);



	int deleteCourse(Map<String, Object> params);
}
