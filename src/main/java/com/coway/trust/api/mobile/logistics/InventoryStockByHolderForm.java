package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryStockByHolderForm", description = "공통코드 Form")
public class InventoryStockByHolderForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100069", example = "1, 2, 3")
	private String userId;
	
	@ApiModelProperty(value = "검색 type (all / partCode / partName) [default : '' 전체] 예) 1=Parts Code ,2=Parts Name, 3= ALL ", example = "1, 2, 3")
	private String searchType;
									
	@ApiModelProperty(value = "검색어 (all 일 경우에만 빈값으로 처리 예정) [default : '' 전체] 예) 3300513,3001499 ,3105547,AN,DO,AP", example = "1, 2, 3")
	private String searchKeyword;

	public static Map<String, Object> createMap(InventoryStockByHolderForm InventoryStockByHolderForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", InventoryStockByHolderForm.getUserId());
		params.put("searchType", InventoryStockByHolderForm.getSearchType());
		params.put("searchKeyword", InventoryStockByHolderForm.getSearchKeyword());
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
