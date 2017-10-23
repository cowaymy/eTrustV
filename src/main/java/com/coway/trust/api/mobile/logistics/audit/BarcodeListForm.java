package com.coway.trust.api.mobile.logistics.audit;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BarcodeListForm", description = "BarcodeListForm")
public class BarcodeListForm {

	// private int userId = 1404;
	// private String adjustBaseDate = "09/09/2017";
	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) C450", example = "C450")
	private String userId;
	
	@ApiModelProperty(value = "실사 기준일자(YYYYMMDD) 예) 20170610", example = "20170610")
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
