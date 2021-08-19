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


	private List<CourseForm> courseCode;


	public List<CourseForm> getCourseCode() {
		return courseCode;
	}


	public void setCourseCode(List<CourseForm> courseCode) {
		this.courseCode = courseCode;
	}





}
