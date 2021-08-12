package com.coway.trust.api.project.LMS;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : LMSAttendApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020. 12. 17.    MY-KAHKIT   First creation
 * </pre>
 */
@ApiModel(value = "LMSAttendApiForm", description = "LMSAttendApiForm")
public class LMSAttendApiForm {


	private List<CourseForm> courseCourse;


	public List<CourseForm> getCourseCourse() {
		return courseCourse;
	}


	public void setCourseCourse(List<CourseForm> courseCourse) {
		this.courseCourse = courseCourse;
	}





}
