package com.coway.trust.api.mobile.logistics.returnonhandstock;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReturnPartsSearchForm", description = "공통코드 Form")
public class ReturnPartsSearchForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100554,CT100555,CT100591", example = "1, 2")
	private String userId;

	@ApiModelProperty(value = " 검색 type (all / partCode / partName) [default : '' 전체] 예) PartsCode=1,PartsName=2,All=3 ", example = "1, 2,3")
	private int searchType;

	@ApiModelProperty(value = "검색어 (all 일 경우에만 빈값으로 처리 예정) [default '' 전체] 예) partCode=620002,111765,111358B partName=AP", example = "1, 2")
	private String searchKeyword;

	public static Map<String, Object> createMap(ReturnPartsSearchForm ReturnPartsSearchForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", ReturnPartsSearchForm.getUserId());
		params.put("searchType", ReturnPartsSearchForm.getSearchType());
		params.put("searchKeyword", ReturnPartsSearchForm.getSearchKeyword());
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
