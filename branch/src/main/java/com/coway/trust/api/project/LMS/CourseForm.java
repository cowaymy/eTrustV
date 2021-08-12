package com.coway.trust.api.project.LMS;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CourseForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020. 12. 17.    MY-KAHKIT   First creation
 * </pre>
 */
@ApiModel(value = "CourseForm", description = "CourseForm")
public class CourseForm {

	private List<AttendForm> attendence;

	public List<AttendForm> getAttendence() {
		return attendence;
	}

	public void setAttendence(List<AttendForm> attendence) {
		this.attendence = attendence;
	}



}
