package com.coway.trust.api.mobile.logistics.audit;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InputBarcodeListForm", description = "InputBarcodeListForm")
public class InputBarcodeListForm {

	@ApiModelProperty(value = "제품 Serial")
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
