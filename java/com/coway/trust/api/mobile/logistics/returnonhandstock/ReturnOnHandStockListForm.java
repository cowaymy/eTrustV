package com.coway.trust.api.mobile.logistics.returnonhandstock;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReturnOnHandStockListForm", description = "ReturnOnHandStockListForm")
public class ReturnOnHandStockListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T010", example = "T010")
	private String userId;

	@ApiModelProperty(value = "GI Date 조회시작날짜 (YYYYMMDD) 예) 20170916,20170920", example = "28092017")
	private String searchFromDate;

	@ApiModelProperty(value = "GR Date 조회종료날짜 (YYYYMMDD) 예) 20170921", example = "29092017")
	private String searchToDate;

	@ApiModelProperty(value = "searchStatus 상태(requested / done) 예) requested=1,done=2", example = "A,B,C")
	private int searchStatus;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) Auto=1,Manual=2,All=3", example = "1,2,3")
	private int searchType;

	@ApiModelProperty(value = "예) MROL 고정값", example = "A,B,C")
	private String reqStatus;

	public static Map<String, Object> createMap(ReturnOnHandStockListForm ReturnOnHandStockListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", ReturnOnHandStockListForm.getUserId());
		params.put("searchFromDate", ReturnOnHandStockListForm.getSearchFromDate());
		params.put("searchToDate", ReturnOnHandStockListForm.getSearchToDate());
		params.put("searchStatus", ReturnOnHandStockListForm.getSearchStatus());
		params.put("searchType", ReturnOnHandStockListForm.getSearchType());
		params.put("reqStatus", ReturnOnHandStockListForm.getReqStatus());
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

	public int getSearchStatus() {
		return searchStatus;
	}

	public void setSearchStatus(int searchStatus) {
		this.searchStatus = searchStatus;
	}

	public int getSearchType() {
		return searchType;
	}

	public void setSearchType(int searchType) {
		this.searchType = searchType;
	}

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

}
