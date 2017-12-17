package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class UserFilterListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CD104211", example = "CD104211")
	private String userId;

	@ApiModelProperty(value = "112450    예)    ", example = "112450")
	private String partsCode;

	@ApiModelProperty(value = "901  예)     ", example = "901")
	private int partsId;

	@ApiModelProperty(value = "조회시작날짜(YYYYMMDD) 예) 20171201", example = "20171201")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜(YYYYMMDD) 예) 20171231", example = "20171231")
	private String searchToDate;

	public static Map<String, Object> createMap(UserFilterListForm filterNotChangeListForm) {
		Map<String, Object> map = BeanConverter.toMap(filterNotChangeListForm);
		return map;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
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
