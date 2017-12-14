package com.coway.trust.api.mobile.sales.saveCourse;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "SaveCourseForm", description = "공통코드 Form")
public class SaveCourseForm {
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100006 ", example = "CT100006")
	private String userId;
	
	@ApiModelProperty(value = "courseId [default : '' 전체] 예) 1006 ", example = "1006")
	private int courseId;
	
	@ApiModelProperty(value = "requestType [default : '1'] 예) 1 ", example = "1")
	private int requestType;
	
	public static Map<String, Object> createMap(SaveCourseForm saveCourseForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("userId", saveCourseForm.getUserId());
		params.put("courseId", saveCourseForm.getCourseId());
		params.put("requestType", saveCourseForm.getRequestType());
		
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public int getRequestType() {
		return requestType;
	}

	public void setRequestType(int requestType) {
		this.requestType = requestType;
	}

}
