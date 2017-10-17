package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockReceiveListForm", description = "공통코드 Form")
public class LogStockReceiveForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100337,T010", example = "CT100337")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜 (YYYYMMDD) [default : '' 전체] 예) 20170820", example = "28092017")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜 (YYYYMMDD [default : '' 전체] 예) 20170827", example = "29092017")
	private String searchToDate;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) auto,manual,all", example = "auto/manual")
	private String searchType;
	
	@ApiModelProperty(value = "searchStatus 상태상태    (In-Transit / done) 예) transit/done", example = "A,B,C")
	private String searchStatus;

	public static Map<String, Object> createMap(LogStockReceiveForm StockReceiveListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockReceiveListForm.getUserId());
		params.put("searchFromDate", StockReceiveListForm.getSearchFromDate());
		params.put("searchToDate", StockReceiveListForm.getSearchToDate());
		params.put("searchType", StockReceiveListForm.getSearchType());
		params.put("searchStatus", StockReceiveListForm.getSearchStatus());
		return params;
	}

	public String getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(String searchStatus) {
		this.searchStatus = searchStatus;
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

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

}
