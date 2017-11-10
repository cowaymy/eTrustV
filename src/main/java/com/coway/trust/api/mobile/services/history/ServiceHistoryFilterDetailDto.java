package com.coway.trust.api.mobile.services.history;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "ServiceHistoryFilterDetailDto", description = "ServiceHistoryFilterDetailDto")
public class ServiceHistoryFilterDetailDto {

	private int filterCode;
	private String filterName;
	private String lastChangeDate;
	private int filterPeriod;
	private String nextChangeDate;
	private int changeQty;
	
	public int getFilterCode() {
		return filterCode;
	}
	public void setFilterCode(int filterCode) {
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
	public int getFilterPeriod() {
		return filterPeriod;
	}
	public void setFilterPeriod(int filterPeriod) {
		this.filterPeriod = filterPeriod;
	}
	public String getNextChangeDate() {
		return nextChangeDate;
	}
	public void setNextChangeDate(String nextChangeDate) {
		this.nextChangeDate = nextChangeDate;
	}
	public int getChangeQty() {
		return changeQty;
	}
	public void setChangeQty(int changeQty) {
		this.changeQty = changeQty;
	}

	
	public static ServiceHistoryFilterDetailDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ServiceHistoryFilterDetailDto.class);
	}
	
	
}
