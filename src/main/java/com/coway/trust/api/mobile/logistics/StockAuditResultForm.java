package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class StockAuditResultForm {

	private int userId;
	private String adjustBaseDate;

	public static Map<String, Object> createMap(StockAuditResultForm stockauditresultForm) {
		Map<String, Object> map = BeanConverter.toMap(stockauditresultForm);
		return map;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getAdjustBaseDate() {
		return adjustBaseDate;
	}

	public void setAdjustBaseDate(String adjustBaseDate) {
		this.adjustBaseDate = adjustBaseDate;
	}
}
