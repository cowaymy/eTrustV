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
@ApiModel(value = "ResultForm", description = "ResultForm")
public class ResultForm {


	private String username;
	private String courseCode;
	private String trainingResult;
	private String cdpPoint;
	private String attendDay;
	private String supplementInd;

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getCourseCode() {
		return courseCode;
	}
	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}
	public String getTrainingResult() {
		return trainingResult;
	}
	public void setTrainingResult(String trainingResult) {
		this.trainingResult = trainingResult;
	}
	public String getCdpPoint() {
		return cdpPoint;
	}
	public void setCdpPoint(String cdpPoint) {
		this.cdpPoint = cdpPoint;
	}
	public String getAttendDay() {
		return attendDay;
	}
	public void setAttendDay(String attendDay) {
		this.attendDay = attendDay;
	}
	public String getSupplementInd() {
		return supplementInd;
	}
	public void setSupplementInd(String supplementInd) {
		this.supplementInd = supplementInd;
	}

}
