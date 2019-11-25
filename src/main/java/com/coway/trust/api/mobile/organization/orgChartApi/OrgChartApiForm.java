package com.coway.trust.api.mobile.organization.orgChartApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : OrgChartApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "OrgChartApiForm", description = "OrgChartApiForm")
public class OrgChartApiForm {



	public static Map<String, Object> createMap(OrgChartApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memType", vo.getMemType());
		params.put("memLvl", vo.getMemLvl());
		params.put("memId", vo.getMemId());
		return params;
	}



	private int memType;
	private int memLvl;
	private int memId;



	public int getMemType() {
		return memType;
	}


	public void setMemType(int memType) {
		this.memType = memType;
	}


	public int getMemLvl() {
		return memLvl;
	}


	public void setMemLvl(int memLvl) {
		this.memLvl = memLvl;
	}


	public int getMemId() {
		return memId;
	}


	public void setMemId(int memId) {
		this.memId = memId;
	}
}
