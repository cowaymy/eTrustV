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

	//private String id;
	//private List<AttendForm> attendence;

	private String username;
	private String shirtSize;
	private String action;
	private String courseCode;

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getShirtSize() {
		return shirtSize;
	}
	public void setShirtSize(String shirtSize) {
		this.shirtSize = shirtSize;
	}

	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public String getCourseCode() {
		return courseCode;
	}
	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}

}
