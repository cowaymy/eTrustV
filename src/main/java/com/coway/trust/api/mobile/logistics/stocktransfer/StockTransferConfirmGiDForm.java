package com.coway.trust.api.mobile.logistics.stocktransfer;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferConfirmGiDForm", description = "StockTransferConfirmGiDForm")
public class StockTransferConfirmGiDForm {

	@ApiModelProperty(value = "SMO item no")
	private int smoNoItem;
	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	@ApiModelProperty(value = "부품 id")
	private int partsId;
	@ApiModelProperty(value = "부품 sn")
	private String serialNo;
	@ApiModelProperty(value = "요청수량")
	private int requestQty;
	@ApiModelProperty(value = "부품 이름")
	private String partsName;

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

	public int getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(int requestQty) {
		this.requestQty = requestQty;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

}
