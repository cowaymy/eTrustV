package com.coway.trust.api.mobile.logistics.stocktransfer;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferConfirmGiDForm", description = "StockTransferConfirmGiDForm")
public class StockTransferConfirmGiDForm {

	@ApiModelProperty(value = "부품 sn")
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
