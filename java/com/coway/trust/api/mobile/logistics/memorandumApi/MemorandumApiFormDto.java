package com.coway.trust.api.mobile.logistics.memorandumApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : MemorandumApiFormDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "MemorandumApiFormDto", description = "MemorandumApiFormDto")
public class MemorandumApiFormDto {



	public static Map<String, Object> createMap(MemorandumApiFormDto vo) {
		Map<String, Object> params = new HashMap<>();
		params.put("crtDeptId", vo.getCrtDeptId());
		params.put("crtDtFrom", vo.getCrtDtFrom());
		params.put("crtDtTo", vo.getCrtDtTo());
		params.put("selectType", vo.getSelectType());
        params.put("selectKeyword", vo.getSelectKeyword());
        params.put("userTypeId", vo.getUserTypeId());
		return params;
	}



	private String crtDeptId;
	private String crtDtFrom;
	private String crtDtTo;
    private String selectType;
    private String selectKeyword;
    private String userTypeId;



    public String getCrtDeptId() {
        return crtDeptId;
    }
    public void setCrtDeptId(String crtDeptId) {
        this.crtDeptId = crtDeptId;
    }
    public String getCrtDtFrom() {
        return crtDtFrom;
    }
    public void setCrtDtFrom(String crtDtFrom) {
        this.crtDtFrom = crtDtFrom;
    }
    public String getCrtDtTo() {
        return crtDtTo;
    }
    public void setCrtDtTo(String crtDtTo) {
        this.crtDtTo = crtDtTo;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }
    public String getSelectKeyword() {
        return selectKeyword;
    }
    public void setSelectKeyword(String selectKeyword) {
        this.selectKeyword = selectKeyword;
    }
    public String getUserTypeId() {
        return userTypeId;
    }
    public void setUserTypeId(String userTypeId) {
        this.userTypeId = userTypeId;
    }
}
