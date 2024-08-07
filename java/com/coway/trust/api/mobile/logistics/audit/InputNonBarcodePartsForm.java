package com.coway.trust.api.mobile.logistics.audit;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InputNonBarcodePartsForm", description = "InputNonBarcodePartsForm")
public class InputNonBarcodePartsForm {

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "실사 	번호")
	private String invenAdjustNo;

	@ApiModelProperty(value = "실사 item 번호")
	private int invenAdjustNoItem;

	@ApiModelProperty(value = "실사 수량")
	private int countedQty;

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

	public String getInvenAdjustNo() {
		return invenAdjustNo;
	}

	public void setInvenAdjustNo(String invenAdjustNo) {
		this.invenAdjustNo = invenAdjustNo;
	}

	public int getInvenAdjustNoItem() {
		return invenAdjustNoItem;
	}

	public void setInvenAdjustNoItem(int invenAdjustNoItem) {
		this.invenAdjustNoItem = invenAdjustNoItem;
	}

	public int getCountedQty() {
		return countedQty;
	}

	public void setCountedQty(int countedQty) {
		this.countedQty = countedQty;
	}

}
