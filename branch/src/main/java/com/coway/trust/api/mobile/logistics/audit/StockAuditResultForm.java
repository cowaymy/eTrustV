package com.coway.trust.api.mobile.logistics.audit;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class StockAuditResultForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T010", example = "T010")
	private String userId;
	@ApiModelProperty(value = "실사 기준월(YYYYMM) 예) 201710", example = "201710")
	private String adjustBaseMonth;

	public static Map<String, Object> createMap(StockAuditResultForm stockauditresultForm) {
		Map<String, Object> map = BeanConverter.toMap(stockauditresultForm);
		return map;
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

}
