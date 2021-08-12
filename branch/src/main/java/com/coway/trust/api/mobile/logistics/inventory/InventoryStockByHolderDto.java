package com.coway.trust.api.mobile.logistics.inventory;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryStockByHolderDto", description = "공통코드 Dto")
public class InventoryStockByHolderDto {

	@ApiModelProperty(value = "CT/CODY 이름")
	private String ctCodyName;

	@ApiModelProperty(value = "CT/CODY ID")
	private String ctCodyId;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 ID")
	private int partsId;

	@ApiModelProperty(value = "부품명")
	private String partsName;

	@ApiModelProperty(value = "재고")
	private int stockQty;

	@ApiModelProperty(value = "제품 s/n")
	private String serialNo;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static InventoryStockByHolderDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, InventoryStockByHolderDto.class);
	}

	public String getCtCodyName() {
		return ctCodyName;
	}

	public void setCtCodyName(String ctCodyName) {
		this.ctCodyName = ctCodyName;
	}

	public String getCtCodyId() {
		return ctCodyId;
	}

	public void setCtCodyId(String ctCodyId) {
		this.ctCodyId = ctCodyId;
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

	public int getStockQty() {
		return stockQty;
	}

	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
