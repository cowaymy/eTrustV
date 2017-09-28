package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsCodeAllDto", description = "공통코드 Dto")
public class logStockHolderDto {

	@ApiModelProperty(value = "CT Code")
	private String memCode;
	
	@ApiModelProperty(value = "CT Name")
	private String name;
	
	@ApiModelProperty(value = "Parts Name")
	private String stkDesc;
	
	@ApiModelProperty(value = "Parts Code")
	private String bomCompnt;
	
	@ApiModelProperty(value = "Qty")
	private int qty;
	
	@ApiModelProperty(value = "No S/N")
	private String serialNo;
	

	public static logStockHolderDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, logStockHolderDto.class);
	}


	public String getMemCode() {
		return memCode;
	}


	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getStkDesc() {
		return stkDesc;
	}


	public void setStkDesc(String stkDesc) {
		this.stkDesc = stkDesc;
	}


	public String getBomCompnt() {
		return bomCompnt;
	}


	public void setBomCompnt(String bomCompnt) {
		this.bomCompnt = bomCompnt;
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
