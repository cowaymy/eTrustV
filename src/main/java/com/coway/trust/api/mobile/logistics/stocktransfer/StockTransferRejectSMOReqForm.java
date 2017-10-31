package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferRejectSMOReqForm", description = "StockTransferRejectSMOReqForm")
public class StockTransferRejectSMOReqForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T120", example = "T120")
	private String userId;

	@ApiModelProperty(value = "요청일(YYYYMMDD) 20171031", example = "20171031")
	private String requestDate;

	@ApiModelProperty(value = "SMO no", example = "SMO.....")
	private String smoNo;

	@ApiModelProperty(value = "GR", example = "GR")
	private String reqStatus;

	public static Map<String, Object> createMap(StockTransferRejectSMOReqForm stockTransferRejectSMOReqForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", stockTransferRejectSMOReqForm.getUserId());
		params.put("requestDate", stockTransferRejectSMOReqForm.getRequestDate());
		params.put("smoNo", stockTransferRejectSMOReqForm.getSmoNo());
		params.put("reqStatus", stockTransferRejectSMOReqForm.getReqStatus());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}

	public String getSmoNo() {
		return smoNo;
	}

	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

}
