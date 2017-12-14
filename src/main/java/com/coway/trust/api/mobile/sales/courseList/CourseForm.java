package com.coway.trust.api.mobile.sales.courseList;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CourseForm", description = "Cource Form")
public class CourseForm {
	
	@ApiModelProperty(value = "userId 예)CD101950 ", example = "CD101950 ")
	private String userId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public static Map<String, Object> createMap(CourseForm courseForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("userId",   courseForm.getUserId());
		
		return params;
	}

	
}
