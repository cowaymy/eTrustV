package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class FilterNotChangeListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CD100876", example = "CD100876")
	private String userId;

	@ApiModelProperty(value = "실사 기준일자(YYYYMMDD) 예) 20140411", example = "20140411")
	private String searchFromDate;

	@ApiModelProperty(value = "실사 기준일자(YYYYMMDD) 예) 20140417", example = "20140417")
	private String searchToDate;

	public static Map<String, Object> createMap(FilterNotChangeListForm filterNotChangeListForm) {
		Map<String, Object> map = BeanConverter.toMap(filterNotChangeListForm);
		return map;
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

}
