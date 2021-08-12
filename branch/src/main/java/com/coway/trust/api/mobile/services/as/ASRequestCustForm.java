package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class ASRequestCustForm {



	private String userId;
	
	
	@ApiModelProperty(value = "searchType (salesOrderNo:1 / customername:2 / Nric:3)")
	private String searchType;
	
	
	@ApiModelProperty(value = "(예:1029)")
	private String searchKeyword;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getSearchKeyword() {
		return searchKeyword;
	}
	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	
	
	public static Map<String, Object> createMaps(ASRequestResultForm aSRequestResultForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;
		
		map = BeanConverter.toMap(aSRequestResultForm);
		
		return map;
}
	
}
