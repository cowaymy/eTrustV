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
 * 2021. 08. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "LMSAttendApiForm", description = "LMSAttendApiForm")
public class LMSAttendApiForm {


	private List<CourseForm> assignCourse;

	public List<CourseForm> getAssignCourse() {
		return assignCourse;
	}


	public void setAssignCourse(List<CourseForm> assignCourse) {
		this.assignCourse = assignCourse;
	}
}
