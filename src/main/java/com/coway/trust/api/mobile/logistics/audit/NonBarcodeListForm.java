package com.coway.trust.api.mobile.logistics.audit;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class NonBarcodeListForm {
	
	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) C450", example = "C450")
	private String userId;
	
	@ApiModelProperty(value = "실사 기준일자(YYYYMMDD) 예) 20170610", example = "20170610")
	private String adjustBaseDate;

	public static Map<String, Object> createMap(NonBarcodeListForm nonbarcodeListForm) {
		Map<String, Object> map = BeanConverter.toMap(nonbarcodeListForm);
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
