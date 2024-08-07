package com.coway.trust.api.mobile.logistics.recevie;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LogStockPartsReceiveDto", description = "공통코드 Dto")
public class LogStockPartsReceiveDto {

	@ApiModelProperty(value = "SMO item no")
	private int smoNoItem;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "부품명")
	private String partsName;

	@ApiModelProperty(value = "요청수량")
	private int requestQty;

	@ApiModelProperty(value = "부품 sn")
	private String serialNo;

	@ApiModelProperty(value = "시리얼 체크 여부")
	private String serialChk;

	public static LogStockPartsReceiveDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, LogStockPartsReceiveDto.class);
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public int getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(int smoNoItem) {
		this.smoNoItem = smoNoItem;
	}

	public int getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(int requestQty) {
		this.requestQty = requestQty;
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

}
