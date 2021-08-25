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
 * 2021. 08. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "CourseForm", description = "CourseForm")
public class CourseForm {

	private String id;
	private List<AttendForm> attendence;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public List<AttendForm> getAttendence() {
		return attendence;
	}

	public void setAttendence(List<AttendForm> attendence) {
		this.attendence = attendence;
	}



}
