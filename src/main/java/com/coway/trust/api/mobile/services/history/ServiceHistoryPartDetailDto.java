package com.coway.trust.api.mobile.services.history;


import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "ServiceHistoryPartDetailDto", description = "ServiceHistoryPartDetailDto")
public class ServiceHistoryPartDetailDto {

	private String partCode;
	private String partName;
	private String changeQty;
	
	public String getPartCode() {
		return partCode;
	}
	public void setPartCode(String partCode) {
		this.partCode = partCode;
	}
	public String getPartName() {
		return partName;
	}
	public void setPartName(String partName) {
		this.partName = partName;
	}
	public String getChangeQty() {
		return changeQty;
	}
	public void setChangeQty(String changeQty) {
		this.changeQty = changeQty;
	}

	public static ServiceHistoryPartDetailDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ServiceHistoryPartDetailDto.class);
	}
	
}
