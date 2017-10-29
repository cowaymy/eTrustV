package com.coway.trust.api.mobile.logistics.recevie;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockReceiveListForm", description = "공통코드 Form")
public class LogStockReceiveForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100337,T010", example = "CT100337")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜 (YYYYMMDD) [default : '' 전체] 예) 20170920", example = "28092017")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜 (YYYYMMDD [default : '' 전체] 예) 20170927", example = "29092017")
	private String searchToDate;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) auto=1,manual=2,all=3", example = "auto/manual")
	private int searchType;

	@ApiModelProperty(value = "searchStatus 상태 예) In-Transit=1 / done=2", example = "A,B,C")
	private int searchStatus;

	public static Map<String, Object> createMap(LogStockReceiveForm StockReceiveListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockReceiveListForm.getUserId());
		params.put("searchFromDate", StockReceiveListForm.getSearchFromDate());
		params.put("searchToDate", StockReceiveListForm.getSearchToDate());
		params.put("searchType", StockReceiveListForm.getSearchType());
		params.put("searchStatus", StockReceiveListForm.getSearchStatus());
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

	public int getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(int searchStatus) {
		this.searchStatus = searchStatus;
	}

}
