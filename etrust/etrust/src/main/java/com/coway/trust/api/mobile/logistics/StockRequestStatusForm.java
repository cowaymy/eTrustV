package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class StockRequestStatusForm {

	String userId;
	String searchFromDate;
	String searchToDate;
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
