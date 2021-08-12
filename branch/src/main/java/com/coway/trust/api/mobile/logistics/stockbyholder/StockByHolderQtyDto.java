package com.coway.trust.api.mobile.logistics.stockbyholder;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderQtyDto", description = "공통코드 Dto")
public class StockByHolderQtyDto {

	@ApiModelProperty(value = "위치")
	private String locationType;

	@ApiModelProperty(value = "가용 재고")
	private int availQty;

	@ApiModelProperty(value = "이동중 재고")
	private int intransitQty;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static StockByHolderQtyDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockByHolderQtyDto.class);
	}

	public String getLocationType() {
		return locationType;
	}

	public void setLocationType(String locationType) {
		this.locationType = locationType;
	}

	public int getAvailQty() {
		return availQty;
	}

	public void setAvailQty(int availQty) {
		this.availQty = availQty;
	}

	public int getIntransitQty() {
		return intransitQty;
	}

	public void setIntransitQty(int intransitQty) {
		this.intransitQty = intransitQty;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
