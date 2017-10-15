package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class StockRequestStatusForm {
	@ApiModelProperty(value = "조회할 CT/CODY ID [default : '' 전체] 예) CT100337 ", example = "CT100337")
	String userId;
	@ApiModelProperty(value = "조회할 CT/CODY ID [default : '' 전체] 예) 01/01/2017 ", example = "")
	String searchFromDate;
	@ApiModelProperty(value = "조회할 CT/CODY ID [default : '' 전체] 예) 01/10/2017, ", example = "CD100205,CT100070")
	String searchToDate;
	@ApiModelProperty(value = "조회할 CT/CODY ID [default : '' 전체] 예) requested / done, ", example = "requested / done")
	String searchStatus;

	public static Map<String, Object> createMap(StockRequestStatusForm stockRequestStatusForm) {
		Map<String, Object> map = BeanConverter.toMap(stockRequestStatusForm);
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

	public String getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
	}

}
