package com.coway.trust.api.mobile.logistics.audit;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "NonBarcodeListDto", description = "NonBarcodeListDto")
public class NonBarcodeDListDto {

	@ApiModelProperty(value = "실사 item 번호")
	private int invenAdjustNoItem;
	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	@ApiModelProperty(value = "부품 id")
	private int partsId;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "시스템 재고")
	private int sysQty;
	@ApiModelProperty(value = "실사 수량")
	private int countedQty;
	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static NonBarcodeDListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, NonBarcodeDListDto.class);
	}

	public int getInvenAdjustNoItem() {
		return invenAdjustNoItem;
	}

	public void setInvenAdjustNoItem(int invenAdjustNoItem) {
		this.invenAdjustNoItem = invenAdjustNoItem;
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

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public int getSysQty() {
		return sysQty;
	}

	public void setSysQty(int sysQty) {
		this.sysQty = sysQty;
	}

	public int getCountedQty() {
		return countedQty;
	}

	public void setCountedQty(int countedQty) {
		this.countedQty = countedQty;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
