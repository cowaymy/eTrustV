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
        params.put("loginMemId", vo.getLoginMemId());
        params.put("selectMemId", vo.getSelectMemId());
        params.put("selectMemUpId", vo.getSelectMemUpId());
        params.put("selectMemLvl", vo.getSelectMemLvl());
		return params;
	}



	private int memType;
	private int memLvl;
	private int memId;
	private int loginMemId;
    private int selectMemId;
    private int selectMemUpId;
    private int selectMemLvl;


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


    public int getLoginMemId() {
        return loginMemId;
    }


    public void setLoginMemId(int loginMemId) {
        this.loginMemId = loginMemId;
    }


    public int getSelectMemId() {
        return selectMemId;
    }


    public void setSelectMemId(int selectMemId) {
        this.selectMemId = selectMemId;
    }


    public int getSelectMemUpId() {
        return selectMemUpId;
    }


    public void setSelectMemUpId(int selectMemUpId) {
        this.selectMemUpId = selectMemUpId;
    }


    public int getSelectMemLvl() {
        return selectMemLvl;
    }


    public void setSelectMemLvl(int selectMemLvl) {
        this.selectMemLvl = selectMemLvl;
    }

}
