package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsCodeAllDto", description = "공통코드 Dto")
public class logisticsCodeAllDto {

	@ApiModelProperty(value = "CtNmae")
	private String name;
	@ApiModelProperty(value = "CtCode ")
	private String memCode;
	@ApiModelProperty(value = "제품 보유수량")
	private int qty;
	@ApiModelProperty(value = "제품 코드")
	private String stkCode;

	public static logisticsCodeAllDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, logisticsCodeAllDto.class);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public String getStkCode() {
		return stkCode;
	}

	public void setStkCode(String stkCode) {
		this.stkCode = stkCode;
	}

}
