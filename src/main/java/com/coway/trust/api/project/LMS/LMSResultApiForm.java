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
@ApiModel(value = "LMSResultApiForm", description = "LMSResultApiForm")
public class LMSResultApiForm {


	private List<ResultForm> userResult;

	public List<ResultForm> getUserResult() {
		return userResult;
	}

	public void setUserResult(List<ResultForm> userResult) {
		this.userResult = userResult;
	}



}
