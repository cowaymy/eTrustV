package com.coway.trust.api.mobile.logistics.inventory;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MyStockListForm", description = "공통코드 Form")
public class InventoryOnHandStockForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100561", example = "CT100561")
	private String userId;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) PartsCode=1,PartsName=2,All=3, NoSerial=4 ", example = " 1,2,3,4")
	private int searchType;

	@ApiModelProperty(value = "Input Keyword [default : '' 전체] 예) AN,DO,AP/3300513,3300514,3302950", example = "AP")
	private String searchKeyword;

	public static Map<String, Object> createMap(InventoryOnHandStockForm inventoryOnHandStockForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", inventoryOnHandStockForm.getUserId());
		params.put("searchType", inventoryOnHandStockForm.getSearchType());
		params.put("searchKeyword", inventoryOnHandStockForm.getSearchKeyword());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getSearchType() {
		return searchType;
	}

	public void setSearchType(int searchType) {
		this.searchType = searchType;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

}
