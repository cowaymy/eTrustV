package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class ASRequestResultForm {
	
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100695)")
	private String userId;
	@ApiModelProperty(value = "searchFromDate [default : '' 전체] 예) 20171104)")
	private String searchFromDate;
	@ApiModelProperty(value = "searchToDate [default : '' 전체] 예) 20171104)")
	private String searchToDate;


	
	
	
	public String getUserId() {
		return userId;
	}





	public void setUserId(String userId) {
		this.userId = userId;
	}





	public String getSearchFromDate() {
		return searchFromDate;
	}





	public void setSearchFromDate(String searchFromDate) {
		this.searchFromDate = searchFromDate;
	}





	public String getSearchToDate() {
		return searchToDate;
	}





	public void setSearchToDate(String searchToDate) {
		this.searchToDate = searchToDate;
	}





	public static Map<String, Object> createMaps(ASRequestResultForm aSRequestResultForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;
		
		map = BeanConverter.toMap(aSRequestResultForm);
		
		return map;
}
	
	
	
	
	

	
	
	

}
