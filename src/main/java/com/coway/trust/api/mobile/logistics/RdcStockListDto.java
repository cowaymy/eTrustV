package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsCodeAllDto", description = "공통코드 Dto")
public class RdcStockListDto {

	@ApiModelProperty(value = "CtNmae")
	private String whLocDesc;
	@ApiModelProperty(value = "Available Qty")
	private int availableQty;
	@ApiModelProperty(value = "RDC/CDC")
	private String codeName;


	public static RdcStockListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RdcStockListDto.class);
	}


	public String getWhLocDesc() {
		return whLocDesc;
	}


	public void setWhLocDesc(String whLocDesc) {
		this.whLocDesc = whLocDesc;
	}

	public int getAvailableQty() {
		return availableQty;
	}


	public void setAvailableQty(int availableQty) {
		this.availableQty = availableQty;
	}


	public String getCodeName() {
		return codeName;
	}


	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}

	

}
