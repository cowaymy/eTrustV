package com.coway.trust.api.mobile.logistics;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LogStockPartsReceiveDto", description = "공통코드 Dto")
public class LogStockPartsReceiveDto {

	@ApiModelProperty(value = "SMO item no")
	private String smoNoItem;
	
	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	
	@ApiModelProperty(value = "부품명")
	private String partsName;
	
	@ApiModelProperty(value = "요청수량")
	private String requestQty;
	
	@ApiModelProperty(value = "부품 sn")
	private String serialNo;
	
	@ApiModelProperty(value = "선택 수량")
	private String selectQty;
	

	
	
	public static LogStockPartsReceiveDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, LogStockPartsReceiveDto.class);
	}




	public String getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(String smoNoItem) {
		this.smoNoItem = smoNoItem;
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

	public String getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(String requestQty) {
		this.requestQty = requestQty;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSelectQty() {
		return selectQty;
	}

	public void setSelectQty(String selectQty) {
		this.selectQty = selectQty;
	}


	
		

}
