package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class NonBarcodeListForm {

	private int userId;
	private String adjustBaseDate;

	public static Map<String, Object> createMap(NonBarcodeListForm nonbarcodeListForm) {
		Map<String, Object> map = BeanConverter.toMap(nonbarcodeListForm);
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
