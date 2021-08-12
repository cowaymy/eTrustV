package com.coway.trust.api.mobile.cmm.dashboard;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CommissionApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 05.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CommissionApiForm", description = "CommissionApiForm")
public class CommissionApiForm {



	public static Map<String, Object> createMap(CommissionApiForm vo){
		Map<String, Object> params = new HashMap<>();
        params.put("regId", vo.getRegId());
        params.put("userTypeId", vo.getUserTypeId());
		return params;
	}



    private String regId;
	private int userTypeId;



    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
    public int getUserTypeId() {
        return userTypeId;
    }
    public void setUserTypeId(int userTypeId) {
        this.userTypeId = userTypeId;
    }
}
