package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "BarcodeListForm", description = "BarcodeListForm")
public class BarcodeListForm {

	// private int userId = 1404;
	// private String adjustBaseDate = "09/09/2017";

	private String userId;
	private String adjustBaseDate;

	public static Map<String, Object> createMap(BarcodeListForm barcodeListForm) {
		Map<String, Object> map = BeanConverter.toMap(barcodeListForm);
		return map;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAdjustBaseDate() {
		return adjustBaseDate;
	}

	public void setAdjustBaseDate(String adjustBaseDate) {
		this.adjustBaseDate = adjustBaseDate;
	}

}
