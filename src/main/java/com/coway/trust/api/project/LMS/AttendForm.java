package com.coway.trust.api.project.LMS;

import java.util.HashMap;
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
@ApiModel(value = "AttendForm", description = "AttendForm")
public class AttendForm {


	private String username;
	private String shirtSize;

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


}
