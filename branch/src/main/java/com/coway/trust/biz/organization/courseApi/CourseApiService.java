package com.coway.trust.biz.organization.courseApi;

import java.util.List;

import com.coway.trust.api.mobile.organization.courseApi.CourseApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CourseApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface CourseApiService {



	List<EgovMap> selectCourse(CourseApiForm param) throws Exception;



	void saveCourse(CourseApiForm param) throws Exception;
}
