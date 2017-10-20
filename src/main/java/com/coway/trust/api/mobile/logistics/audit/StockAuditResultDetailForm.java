package com.coway.trust.api.mobile.logistics.audit;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockAuditResultDetailForm", description = "StockAuditResultDetailForm")
public class StockAuditResultDetailForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T010", example = "CT100337")
	private String userId;

	@ApiModelProperty(value = "실사 기준월(YYYYMM) 예) 201709", example = "201709")
	private String adjustBaseMonth;

	@ApiModelProperty(value = "invenAdjustNo 예) AD0000000001,AD0000000002", example = "AD0000000001")
	private String invenAdjustNo;

	
	public static Map<String, Object> createMap(StockAuditResultDetailForm StockAuditResultDetailForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockAuditResultDetailForm.getUserId());
		params.put("adjustBaseMonth", StockAuditResultDetailForm.getAdjustBaseMonth());
		params.put("invenAdjustNo", StockAuditResultDetailForm.getInvenAdjustNo());

		return params;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getAdjustBaseMonth() {
		return adjustBaseMonth;
	}


	public void setAdjustBaseMonth(String adjustBaseMonth) {
		this.adjustBaseMonth = adjustBaseMonth;
	}


	public String getInvenAdjustNo() {
		return invenAdjustNo;
	}


	public void setInvenAdjustNo(String invenAdjustNo) {
		this.invenAdjustNo = invenAdjustNo;
	}

}
