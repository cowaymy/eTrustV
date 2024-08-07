package com.coway.trust.api.mobile.sales.addressApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : AddressApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 24.   KR-JAEMJAEM:)        First creation
 * </pre>
 */
@ApiModel(value = "AddressApiForm", description = "AddressApiForm")
public class AddressApiForm {
	public static Map<String, Object> createMap(AddressApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("state", vo.getState());
        params.put("city", vo.getCity());
        params.put("postcode", vo.getPostcode());
        params.put("area", vo.getArea());
        params.put("areaId", vo.getAreaId());
        params.put("pageSize", vo.getPageSize());
        params.put("pageNo", vo.getPageNo());
		return params;
	}

	private String state;
    private String city;
	private String postcode;
    private String area;
    private String areaId;

    private int pageSize;
    private int pageNo;

    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }
    public String getPostcode() {
        return postcode;
    }
    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getArea() {
        return area;
    }
    public void setArea(String area) {
        this.area = area;
    }
    public int getPageSize() {
        return pageSize;
    }
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    public int getPageNo() {
        return pageNo;
    }
    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }
	public String getAreaId() {
		return areaId;
	}
	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

}
