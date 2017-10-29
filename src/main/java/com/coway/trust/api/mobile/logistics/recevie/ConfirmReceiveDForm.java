package com.coway.trust.api.mobile.logistics.recevie;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferConfirmGiDForm", description = "StockTransferConfirmGiDForm")
public class ConfirmReceiveDForm {

	@ApiModelProperty(value = "SMO item no")
	private int smoNoItem;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "부품 sn")
	private String serialNo;

	public int getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(int smoNoItem) {
		this.smoNoItem = smoNoItem;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
