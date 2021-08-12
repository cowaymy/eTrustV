package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class FilterChangeListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CD104211", example = "CD104211")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜(YYYYMMDD) 예) 20171201", example = "20171201")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜(YYYYMMDD) 예) 20171231", example = "20171231")
	private String searchToDate;

	public static Map<String, Object> createMap(FilterChangeListForm filterNotChangeListForm) {
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
