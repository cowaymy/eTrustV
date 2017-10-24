package com.coway.trust.api.mobile.logistics.itembank;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ItemBankItemListDto", description = "ItemBankItemListDto")
public class ItemBankItemListDto {

	@ApiModelProperty(value = "item Code")
	private int itemCode;

	@ApiModelProperty(value = "item Name")
	private String itemName;

	public static ItemBankItemListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ItemBankItemListDto.class);
	}

	public int getItemCode() {
		return itemCode;
	}

	public void setItemCode(int itemCode) {
		this.itemCode = itemCode;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

}
