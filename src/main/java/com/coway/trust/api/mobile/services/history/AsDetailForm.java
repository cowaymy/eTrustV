package com.coway.trust.api.mobile.services.history;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;



@ApiModel(value = "AsDetailForm", description = "공통코드 Form")
public class AsDetailForm {

	@ApiModelProperty(value = "salesOrderNo [default : '' 전체] 예) 1209382", example = "1, 2, 3")
	private String salesOrderNo;

	@ApiModelProperty(value = "userId [default : '' 전체] 예) 1209382", example = "1, 2, 3")
	private String userId;


	public static Map<String, Object> createMap(AsDetailForm vo) {
		Map<String, Object> params = new HashMap<>();
		params.put("salesOrderNo", vo.getSalesOrderNo());
		params.put("userId", vo.getUserId());
		return params;
	}


	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
