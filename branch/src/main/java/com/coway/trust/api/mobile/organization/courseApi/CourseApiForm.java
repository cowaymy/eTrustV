package com.coway.trust.api.mobile.organization.courseApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : CourseApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CourseApiForm", description = "CourseApiForm")
public class CourseApiForm {



	public static Map<String, Object> createMap(CourseApiForm param){
		Map<String, Object> params = new HashMap<>();
		params.put("userId", param.getUserId());
		params.put("coursId", param.getCoursId());
		params.put("coursStatus", param.getCoursStatus());
		return params;
	}



	private String userId;
	private String coursId;
	private String coursStatus;



	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCoursId() {
		return coursId;
	}
	public void setCoursId(String coursId) {
		this.coursId = coursId;
	}

	public String getCoursStatus() {
		return coursStatus;
	}
	public void setCoursStatus(String coursStatus) {
		this.coursStatus = coursStatus;
	}
}
