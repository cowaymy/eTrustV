package com.coway.trust.api.mobile.logistics.recevie;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ConfirmReceiveDForm", description = "ConfirmReceiveDForm")
public class ConfirmReceiveDForm {

	@ApiModelProperty(value = "SMO item no")
	private int smoNoItem;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "부품 sn")
	private String serialNo;

	@ApiModelProperty(value = "시리얼체크여부")
	private String serialChk;

	@ApiModelProperty(value = "scan Qty")
	private String scanQty;

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

	public String getSerialChk() {
		return serialChk;
	}

	public void setSerialChk(String serialChk) {
		this.serialChk = serialChk;
	}

	public String getScanQty() {
		return scanQty;
	}

	public void setScanQty(String scanQty) {
		this.scanQty = scanQty;
	}

}
