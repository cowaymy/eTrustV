package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockHolderListForm", description = "공통코드 Form")
public class logisticsStockHolderForm {


	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513",  example = "1, 2, 3")
	private String searchType;
	

	public static Map<String, Object> createMap(logisticsStockHolderForm StockHolderListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", StockHolderListForm.getSearchType());
		return params;
	}


	public String getSearchType() {
		return searchType;
	}


	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}



}
