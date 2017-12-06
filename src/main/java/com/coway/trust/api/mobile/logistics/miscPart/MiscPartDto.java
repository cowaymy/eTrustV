package com.coway.trust.api.mobile.logistics.miscPart;

import java.text.DecimalFormat;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "UsedPartsDto", description = "UsedPartsDto")
public class MiscPartDto {

	@ApiModelProperty(value = "부품코드")
	String partsCode;

	@ApiModelProperty(value = "부품id(stk_id)")
	int partsId;

	@ApiModelProperty(value = "부품명")
	String partsName;

	@ApiModelProperty(value = "부품 가격")
	int salesPrice;

	@ApiModelProperty(value = "부품 type")
	int partType; // no standard data


	public static MiscPartDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, MiscPartDto.class);
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


	public int getSalesPrice() {
		return salesPrice;
	}


	public void setSalesPrice(int salesPrice) {
		this.salesPrice = salesPrice;
	}


	public int getPartType() {
		return partType;
	}


	public void setPartType(int partType) {
		this.partType = partType;
	}

	
}
