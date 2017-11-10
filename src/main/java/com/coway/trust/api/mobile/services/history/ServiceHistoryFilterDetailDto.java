package com.coway.trust.api.mobile.services.history;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "ServiceHistoryFilterDetailDto", description = "ServiceHistoryFilterDetailDto")
public class ServiceHistoryFilterDetailDto {

	private String filterCode;
	private String filterName;
	private String lastChangeDate;
	private String filterPeriod;
	private String nextChangeDate;
	private String changeQty;
	
	public String getFilterCode() {
		return filterCode;
	}
	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}
	public String getFilterName() {
		return filterName;
	}
	public void setFilterName(String filterName) {
		this.filterName = filterName;
	}
	public String getLastChangeDate() {
		return lastChangeDate;
	}
	public void setLastChangeDate(String lastChangeDate) {
		this.lastChangeDate = lastChangeDate;
	}
	public String getFilterPeriod() {
		return filterPeriod;
	}
	public void setFilterPeriod(String filterPeriod) {
		this.filterPeriod = filterPeriod;
	}
	public String getNextChangeDate() {
		return nextChangeDate;
	}
	public void setNextChangeDate(String nextChangeDate) {
		this.nextChangeDate = nextChangeDate;
	}
	public String getChangeQty() {
		return changeQty;
	}
	public void setChangeQty(String changeQty) {
		this.changeQty = changeQty;
	}

	
	public static ServiceHistoryFilterDetailDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ServiceHistoryFilterDetailDto.class);
	}
	
	
}
