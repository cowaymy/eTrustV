package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class ASRequestResultForm {
	
	private String userId;
	private String searchFromDate;
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
