package com.coway.trust.api.mobile.logistics.mystock;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MyStockListDto", description = "공통코드 Dto")
public class MyStockListDto {

	@ApiModelProperty(value = "서비스 번호(INS00000)")
	private String serviceNo;

	@ApiModelProperty(value = "부품코드 ")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "부품 s/n")
	private String partsSerialNo;

	@ApiModelProperty(value = "부품 타입(제품(61) / 필터(62) / 부품(63) / MISC(64))")
	private int partsType;

	@ApiModelProperty(value = "재고(가용재고)")
	private int stockQty;

	public static MyStockListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, MyStockListDto.class);
	}

	public String getServiceNo() {
		return serviceNo;
	}

	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
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

	public String getPartsSerialNo() {
		return partsSerialNo;
	}

	public void setPartsSerialNo(String partsSerialNo) {
		this.partsSerialNo = partsSerialNo;
	}

	public int getPartsType() {
		return partsType;
	}

	public void setPartsType(int partsType) {
		this.partsType = partsType;
	}

	public int getStockQty() {
		return stockQty;
	}

	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}

}
