package com.coway.trust.api.mobile.logistics.itembank;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ItemBankResultListDto", description = "ItemBankResultListDto")
public class ItemBankResultListDto {

	@ApiModelProperty(value = "parts Code")
	private String partsCode;

	@ApiModelProperty(value = "parts Id")
	private int partsId;

	@ApiModelProperty(value = "parts Name")
	private String partsName;

	@ApiModelProperty(value = "cust Name")
	private String custName;

	@ApiModelProperty(value = "qty")
	private int qty;

	public static ItemBankResultListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ItemBankResultListDto.class);
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

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

}
