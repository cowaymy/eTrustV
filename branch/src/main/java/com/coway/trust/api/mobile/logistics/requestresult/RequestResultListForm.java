package com.coway.trust.api.mobile.logistics.requestresult;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RequestResultListForm", description = "RequestResultListForm")
public class RequestResultListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CD102101", example = "CD102101")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜 (YYYYMMDD) 예) 20170820", example = "28092017")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜 (YYYYMMDD) 예) 20170827", example = "29092017")
	private String searchToDate;

	@ApiModelProperty(value = "searchStatus 상태(requested / done) 예) requested=1,done=2", example = "A,B,C")
	private int searchStatus;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) Auto=1,Manual=2,All=3", example = "1,2,3")
	private int searchType;

	@ApiModelProperty(value = "예) MRRL 고정값", example = "MRRL")
	private String reqStatus;

	public static Map<String, Object> createMap(RequestResultListForm RequestResultListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", RequestResultListForm.getUserId());
		params.put("searchFromDate", RequestResultListForm.getSearchFromDate());
		params.put("searchToDate", RequestResultListForm.getSearchToDate());
		params.put("searchStatus", RequestResultListForm.getSearchStatus());
		params.put("searchType", RequestResultListForm.getSearchType());
		params.put("reqStatus", RequestResultListForm.getReqStatus());
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
