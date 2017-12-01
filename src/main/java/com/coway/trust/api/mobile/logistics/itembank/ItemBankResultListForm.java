package com.coway.trust.api.mobile.logistics.itembank;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ItemBankLocationListForm", description = "ItemBankLocationListForm")
public class ItemBankResultListForm {

	@ApiModelProperty(value = "사용자 ID 예) C180", example = "1,2,3")
	private String userId;

	@ApiModelProperty(value = "검색 type (all / partCode / partName) [default : '' 전체] 예)PartsCode=1,PartsName=2,All=3  ", example = "1, 2, 3")
	private int searchType;

	@ApiModelProperty(value = "CT100528", example = "1, 2, 3")
	private String searchLocation;

	@ApiModelProperty(value = "검색 type (Kiosk Item=1345/Merchandise Item=1346 / Uniform=1347/Misc Item=1348/Finance Item=1349/Item Bank=1249/Product Display=1426/HR Item=1350) [default : '' 전체] 예)", example = "1, 2, 3")
	private int searchItem;

	@ApiModelProperty(value = "검색어 (all 일 경우에만 빈값으로 처리 예정) [default : '' 전체] 예) ", example = "1, 2, 3")
	private String searchKeyword;

	public static Map<String, Object> createMap(ItemBankResultListForm itemBankResultListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", itemBankResultListForm.getUserId());
		params.put("searchType", itemBankResultListForm.getSearchType());
		params.put("searchLocation", itemBankResultListForm.getSearchLocation());
		params.put("searchItem", itemBankResultListForm.getSearchItem());
		params.put("searchKeyword", itemBankResultListForm.getSearchKeyword());

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

	public String getSearchLocation() {
		return searchLocation;
	}

	public void setSearchLocation(String searchLocation) {
		this.searchLocation = searchLocation;
	}

	public int getSearchItem() {
		return searchItem;
	}

	public void setSearchItem(int searchItem) {
		this.searchItem = searchItem;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

}
