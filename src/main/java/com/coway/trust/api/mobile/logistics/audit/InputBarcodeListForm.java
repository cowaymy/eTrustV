package com.coway.trust.api.mobile.logistics.audit;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InputBarcodeListForm", description = "InputBarcodeListForm")
public class InputBarcodeListForm {

	@ApiModelProperty(value = "실사 item 번호")
	private int invenAdjustNoItem;

	@ApiModelProperty(value = "제품 Serial")
	private String serialNo;

	public int getInvenAdjustNoItem() {
		return invenAdjustNoItem;
	}

	public void setInvenAdjustNoItem(int invenAdjustNoItem) {
		this.invenAdjustNoItem = invenAdjustNoItem;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
