package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferReqStatusListForm", description = "ReturnOnHandStockListForm")
public class StockTransferReqStatusListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100337,T010", example = "T010")
	private String userId;

	@ApiModelProperty(value = "조회시작날짜 (YYYYMMDD) 예) 20170916", example = "28092017")
	private String searchFromDate;

	@ApiModelProperty(value = "조회종료날짜 (YYYYMMDD) 예) 20170922", example = "29092017")
	private String searchToDate;

	@ApiModelProperty(value = "searchStatus 상태(requested=1 / done=2) 예) 1,2", example = "")
	private int searchStatus;

	@ApiModelProperty(value = "예) MRSL 고정값", example = "A,B,C")
	private String reqStatus;

	public static Map<String, Object> createMap(StockTransferReqStatusListForm StockTransferReqStatusListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockTransferReqStatusListForm.getUserId());
		params.put("searchFromDate", StockTransferReqStatusListForm.getSearchFromDate());
		params.put("searchToDate", StockTransferReqStatusListForm.getSearchToDate());
		params.put("searchStatus", StockTransferReqStatusListForm.getSearchStatus());
		params.put("reqStatus", StockTransferReqStatusListForm.getReqStatus());
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

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

}
