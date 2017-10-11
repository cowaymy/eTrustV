package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryStockByHolderForm", description = "공통코드 Form")
public class InventoryStockByHolderForm {

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513", example = "1, 2, 3")
	private String searchType;
									
	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513", example = "1, 2, 3")
	private String searchKeyword;

	public static Map<String, Object> createMap(InventoryStockByHolderForm InventoryStockByHolderForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", InventoryStockByHolderForm.getSearchType());
		return params;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

}
