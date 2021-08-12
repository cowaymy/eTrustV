package com.coway.trust.api.mobile.logistics.inventory;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsAllStockListDto", description = "공통코드 Dto")
public class InventoryAllListDto {

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품명")
	private String partsName;

	@ApiModelProperty(value = "재고")
	private int stockQty;

	@ApiModelProperty(value = "제품 s/n")
	private String serialNo;

	@ApiModelProperty(value = "재고위치 Code")
	private String locationCode;

	@ApiModelProperty(value = "재고위치명")
	private String locationName;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "브런치 코드")
	private int branchCode;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	@ApiModelProperty(value = "Holder 별 재고존재유무(Y/N)")
	private String byHolderYN;

	public static InventoryAllListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, InventoryAllListDto.class);
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
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

	public String getLocationCode() {
		return locationCode;
	}

	public void setLocationCode(String locationCode) {
		this.locationCode = locationCode;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public int getBranchCode() {
		return branchCode;
	}

	public void setBranchCode(int branchCode) {
		this.branchCode = branchCode;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

	public String getByHolderYN() {
		return byHolderYN;
	}

	public void setByHolderYN(String byHolderYN) {
		this.byHolderYN = byHolderYN;
	}

}
