package com.coway.trust.api.mobile.logistics;

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

	@ApiModelProperty(value = "접속한 유저의 Avail Qty")
	private String byUserAvailQty;

	@ApiModelProperty(value = "접속한 유저의 In-Transit Qty")
	private String byUserInTransitQty;

	@ApiModelProperty(value = "RDC의 Avail Qty")
	private String byRDCAvailQty;

	@ApiModelProperty(value = "RDC의 In-Transit Qty")
	private String byRDCInTransitQty;

	@ApiModelProperty(value = "CDC의 Avail Qty")
	private String byCDCAvailQty;

	@ApiModelProperty(value = "CDC의 In-Transit Qty")
	private String byCDCInTransitQty;

	@ApiModelProperty(value = "재고위치 Code")
	private String locationCode;

	@ApiModelProperty(value = "재고위치명")
	private String locationName;

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

	public String getByUserAvailQty() {
		return byUserAvailQty;
	}

	public void setByUserAvailQty(String byUserAvailQty) {
		this.byUserAvailQty = byUserAvailQty;
	}

	public String getByUserInTransitQty() {
		return byUserInTransitQty;
	}

	public void setByUserInTransitQty(String byUserInTransitQty) {
		this.byUserInTransitQty = byUserInTransitQty;
	}

	public String getByRDCAvailQty() {
		return byRDCAvailQty;
	}

	public void setByRDCAvailQty(String byRDCAvailQty) {
		this.byRDCAvailQty = byRDCAvailQty;
	}

	public String getByRDCInTransitQty() {
		return byRDCInTransitQty;
	}

	public void setByRDCInTransitQty(String byRDCInTransitQty) {
		this.byRDCInTransitQty = byRDCInTransitQty;
	}

	public String getByCDCAvailQty() {
		return byCDCAvailQty;
	}

	public void setByCDCAvailQty(String byCDCAvailQty) {
		this.byCDCAvailQty = byCDCAvailQty;
	}

	public String getByCDCInTransitQty() {
		return byCDCInTransitQty;
	}

	public void setByCDCInTransitQty(String byCDCInTransitQty) {
		this.byCDCInTransitQty = byCDCInTransitQty;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public String getLocationCode() {
		return locationCode;
	}

	public void setLocationCode(String locationCode) {
		this.locationCode = locationCode;
	}

}
