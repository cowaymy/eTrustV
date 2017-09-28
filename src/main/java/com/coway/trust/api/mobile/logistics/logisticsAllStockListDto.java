package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsAllStockListDto", description = "공통코드 Dto")
public class logisticsAllStockListDto {

	@ApiModelProperty(value = "Filter Name")
	private String stkDesc;
	
	@ApiModelProperty(value = "Material Code")
	private String matrlNo;
	
	@ApiModelProperty(value = "Qty")
	private int qty;
	
	@ApiModelProperty(value = "No S/N")
	private String serialNo;
	

	public static logisticsAllStockListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, logisticsAllStockListDto.class);
	}


	public String getStkDesc() {
		return stkDesc;
	}


	public void setStkDesc(String stkDesc) {
		this.stkDesc = stkDesc;
	}


	public String getMatrlNo() {
		return matrlNo;
	}


	public void setMatrlNo(String matrlNo) {
		this.matrlNo = matrlNo;
	}


	public int getQty() {
		return qty;
	}


	public void setQty(int qty) {
		this.qty = qty;
	}


	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	

}
