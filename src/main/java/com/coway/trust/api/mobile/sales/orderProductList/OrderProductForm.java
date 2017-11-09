package com.coway.trust.api.mobile.sales.orderProductList;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderProductForm", description = "공통코드 Form")
public class OrderProductForm {
	
	@ApiModelProperty(value = "salesType [default : '' 전체] 예) 66 ", example = "66, 67, 68, ")
	private String salesType;
	
	@ApiModelProperty(value = "salesSubType [default : '' 전체] 예) 2 ", example = "2")
	private String salesSubType;
	
	@ApiModelProperty(value = "searchType [default : '' 전체] 예) CODE ", example = "CODE, NAME")
	private String searchType;

	@ApiModelProperty(value = "searchKeyword [default : '' 전체] 예) CHP ", example = "CHP")
	private String searchKeyword;

	public static Map<String, Object> createMap(OrderProductForm orderProductForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("salesType", 	orderProductForm.getSalesType());
		params.put("salesSubType", 	    orderProductForm.getSalesSubType());
		params.put("searchType",    orderProductForm.getSearchType());
		params.put("searchKeyword", orderProductForm.getSearchKeyword());
		
		return params;
	}

	public String getSalesType() {
		return salesType;
	}

	public void setSalesType(String salesType) {
		this.salesType = salesType;
	}

	public String getSalesSubType() {
		return salesSubType;
	}

	public void setSalesSubType(String salesSubType) {
		this.salesSubType = salesSubType;
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

}
