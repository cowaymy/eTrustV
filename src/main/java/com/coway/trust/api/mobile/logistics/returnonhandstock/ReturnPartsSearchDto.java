package com.coway.trust.api.mobile.logistics.returnonhandstock;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReturnPartsSearchDto", description = "공통코드 Dto")
public class ReturnPartsSearchDto {

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "부품명")
	private String partsName;

	@ApiModelProperty(value = "재고")
	private int stockQty;

	@ApiModelProperty(value = "제품 s/n")
	private String serialNo;

	@ApiModelProperty(value = "제품 등급")
	private String stockGrade;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	@ApiModelProperty(value = "제품 등급")
	private String stkCatgry;

	public static ReturnPartsSearchDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ReturnPartsSearchDto.class);
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

	public String getStockGrade() {
		return stockGrade;
	}

	public void setStockGrade(String stockGrade) {
		this.stockGrade = stockGrade;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

	public String getStkCatgry() {
		return stkCatgry;
	}

	public void setStkCatgry(String stkCatgry) {
		this.stkCatgry = stkCatgry;
	}

}
