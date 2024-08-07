package com.coway.trust.api.mobile.services.as;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "SyncIhrApiForm", description = "공통코드 Form")
public class SyncIhrApiForm {


	public static Map<String, Object> createMap(SyncIhrApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("whLocId", vo.getWhLocId());
		params.put("regId", vo.getRegId());
		params.put("salesOrderNo", vo.getSalesOrderNo());
		return params;
	}


	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100583 ", example = "1, 2, 3")
	private String userId;
	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201705", example = "1, 2, 3")
	private String requestDate;

	private String regId;
	private int WhLocId;
	private String salesOrderNo ;


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

	public String getRegId() {
		return regId;
	}

	public void setRegId(String regId) {
		this.regId = regId;
	}

	public int getWhLocId() {
		return WhLocId;
	}

	public void setWhLocId(int whLocId) {
		WhLocId = whLocId;
	}

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

}
