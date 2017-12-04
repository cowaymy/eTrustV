package com.coway.trust.api.mobile.logistics.usedparts;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "UsedPartsListForm", description = "공통코드 Form")
public class UsedPartsListForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CD101707", example = "CD101707")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜 (YYYYMMDD) [default : '' 전체] 예) 20160307", example = "20170707")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜 (YYYYMMDD [default : '' 전체] 예) 20170714", example = "20170714")
	private String searchToDate;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) return=1, not return=2 ", example = " 1,2")
	private int searchType;

	
	public static Map<String, Object> createMap(UsedPartsListForm usedPartsListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", usedPartsListForm.getUserId());
		params.put("searchFromDate", usedPartsListForm.getSearchFromDate());
		params.put("searchToDate", usedPartsListForm.getSearchToDate());
		params.put("searchType", usedPartsListForm.getSearchType());
		return params;
	}


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


	public int getSearchType() {
		return searchType;
	}


	public void setSearchType(int searchType) {
		this.searchType = searchType;
	}

}
