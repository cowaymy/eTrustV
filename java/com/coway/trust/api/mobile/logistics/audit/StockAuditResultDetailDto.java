package com.coway.trust.api.mobile.logistics.audit;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockAuditResultDetailDto", description = "공통코드 Dto")
public class StockAuditResultDetailDto {

	@ApiModelProperty(value = "실사 번호")
	private String invenAdjustNo;

	@ApiModelProperty(value = "실사 item 번호")
	private int invenAdjustNoItem;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id ")
	private int partsId;

	@ApiModelProperty(value = "부품명 ")
	private String partsName;

	@ApiModelProperty(value = "시스템 재고 ")
	private int sysQty;

	@ApiModelProperty(value = "실사 수량 ")
	private int countedQty;

	@ApiModelProperty(value = "재고s/n")
	private String serialNo;

	@ApiModelProperty(value = "실사 여부 ")
	private String adjustYN;

	public static StockAuditResultDetailDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockAuditResultDetailDto.class);
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

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getAdjustYN() {
		return adjustYN;
	}

	public void setAdjustYN(String adjustYN) {
		this.adjustYN = adjustYN;
	}

}
